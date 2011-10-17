Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1JQDXC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 23:23:02 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59749 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1JQDXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 23:23:00 -0400
Date: Mon, 17 Oct 2011 04:22:32 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Message-ID: <20111017032232.GA4816@srcf.ucam.org>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
 <20111014154348.ae6267aa.akpm@linux-foundation.org>
 <20111015112006.GA10173@tango.0pointer.de>
 <1318705910.2664.5.camel@laptop>
 <20111017013921.GA30035@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017013921.GA30035@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 03:39:21AM +0200, Lennart Poettering wrote:
> On Sat, 15.10.11 21:11, Peter Zijlstra (peterz@infradead.org) wrote:
> > I would argue this is an excellent reason not to merge this. This really
> > is in the camp of lets paper over shitty userspace instead of fix it.
> > 
> > Such a scheme takes away the immediate need to fix crap and therefore
> > crap will not get fixed. Why not focus on creating tools (I think
> > powertop really already does everything you need) and track down WTF
> > apps are firing so many timers when the screen if off.
> 
> Well, maybe that works in fantasy land. In real life however there's
> stuff like closed source crap, and all kinds of other things you cannot
> fix. In a world where everybody wants "apps" (i.e. 3rd party code
> running with limited privileges) your chance to fix every bit of code is
> gone.

I agree. We can't assume perfect software, and I don't think *requiring* 
the duplication of this functionality in every single session 
application is sensible. We want to be able to shut down timer based 
code when the session is idle. We could do this by exposing the slack in 
/proc. We could do this by modifying every piece of code to listen for 
session idle events and (independently) enact session-wide policy. Or we 
could just accept that it's a problem that maps onto what people are 
already using cgroups for and implement it in the same way.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
