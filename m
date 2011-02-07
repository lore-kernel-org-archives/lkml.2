Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1BGJsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 04:48:53 -0500
Received: from shutemov.name ([188.40.19.243]:38403 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab1BGJsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 04:48:52 -0500
Date: Mon, 7 Feb 2011 11:48:51 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
Message-ID: <20110207094851.GA11712@shutemov.name>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
 <1296679656-31163-3-git-send-email-kirill@shutemov.name>
 <20110203054616.GT16432@count0.beaverton.ibm.com>
 <20110203094138.GD1083@shutemov.name>
 <20110206024951.GB16432@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110206024951.GB16432@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 06:49:51PM -0800, Matt Helsley wrote:
> On Thu, Feb 03, 2011 at 11:41:38AM +0200, Kirill A. Shutemov wrote:
> > On Wed, Feb 02, 2011 at 09:46:16PM -0800, Matt Helsley wrote:
> > > On Wed, Feb 02, 2011 at 10:47:36PM +0200, Kirill A. Shutsemov wrote:
> > > > From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> <snip>
> 
> > > > diff --git a/kernel/cgroup_timer_slack.c b/kernel/cgroup_timer_slack.c
> > > > new file mode 100644
> > > > index 0000000..a343a50
> > > > --- /dev/null
> > > > +++ b/kernel/cgroup_timer_slack.c
> 
> <snip>
> 
> > > > +static int tslack_write_set_slack_ns(struct cgroup *cgroup, struct cftype *cft,
> > > > +		u64 val)
> > > > +{
> > > > +	struct timer_slack_cgroup *tslack_cgroup;
> > > > +	struct cgroup_iter it;
> > > > +	struct task_struct *task;
> > > > +
> > > > +	tslack_cgroup = cgroup_to_tslack_cgroup(cgroup);
> > > > +	if (!val || val < tslack_cgroup->min_slack_ns ||
> > > 
> > > Why is a val of 0 disallowed? I know having slack is good, but for
> > > an administrator or tool that doesn't care about number of wakeups
> > > and cares more about wringing out performance a slack of
> > > 0 seems acceptable. Is this just here to be consistent with the
> > > values passed in via prctl?
> > 
> > Yes, it's to consistent with the prctl(). I don't think that it's good
> > idea to allow to set timer_slack outside of range prctl() allows. It may
> > lead to interface abuse.
> 
> Hmm, I was just thinking that 0 timer slack might be useful. But I
> suppose you could just as easily set it to 1 and nobody would notice.

I've rechecked once again. it lookes cleaner to allow 0 as timer slack
value.
I allowed it in version 4 of the patchset.


-- 
 Kirill A. Shutemov
