Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1BNXjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:39:45 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38166 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1BNXjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:39:43 -0500
Date: Mon, 14 Feb 2011 15:39:36 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v6 3/3] cgroups: introduce timer slack controller
Message-ID: <20110214233936.GQ16432@count0.beaverton.ibm.com>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name>
 <1297688787-3592-4-git-send-email-kirill@shutemov.name>
 <alpine.LFD.2.00.1102141432440.26192@localhost6.localdomain6>
 <20110214151914.GA4210@shutemov.name>
 <alpine.LFD.2.00.1102141753240.26192@localhost6.localdomain6>
 <20110214223939.GA6230@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214223939.GA6230@shutemov.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 12:39:39AM +0200, Kirill A. Shutemov wrote:
> On Mon, Feb 14, 2011 at 06:01:06PM +0100, Thomas Gleixner wrote:
> > B1;2401;0cOn Mon, 14 Feb 2011, Kirill A. Shutemov wrote:
> > 
> > > On Mon, Feb 14, 2011 at 03:00:03PM +0100, Thomas Gleixner wrote:
> > > > On Mon, 14 Feb 2011, Kirill A. Shutsemov wrote:
> > > > > From: Kirill A. Shutemov <kirill@shutemov.name>

<snip>

> > > > > +	list_for_each_entry(cur, &cgroup->children, sibling) {
> > > > > +		child = cgroup_to_tslack_cgroup(cur);
> > > > > +		if (type == TIMER_SLACK_MIN && val > child->min_slack_ns)
> > > > > +			return -EBUSY;
> > > > 
> > > >   I thought the whole point is to propagate values through the group.
> > > 
> > > I think silent change here is wrong. cpuset returns -EBUSY in similar
> > > case.
> > 
> > And how is cpuset relevant for this ? Not at all. This is about

I agree with Thomas here -- cpusets aren't relevant.

> > timer_slack and we better have a well defined scheme for all of this
> > and not some cobbled together thing with tons of exceptions and corner
> > cases. Of course undocumented as far the code goes.
> 
> I don't like silent cascade changes. Userspace can implement it if

It need not be totally silent. memcg has a "use_hierarchy" flag file.
Alternately, you could punt for now and disable hierarchy somewhat like
blkio does.

> needed. -EBUSY is appropriate.

Hmm, I haven't thought about that method of cascading enough. The important
question to consider is how will the parent cgroup be constrained if the
owner/group of the children is different and thus disallows userspace from
implementing this cascade. I suppose it's consistent with the owner/group
ids but it hardly seems consistent with the "spirit" of using cgroups to
enable things like containers.

Cheers,
	-Matt Helsley
