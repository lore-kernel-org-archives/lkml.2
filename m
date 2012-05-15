Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965845Ab2EOQdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:33:21 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62803 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965661Ab2EOQdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:33:18 -0400
Date: Tue, 15 May 2012 12:33:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jonathan Nieder <jrnieder@gmail.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [34-longterm 074/179] xen: Use IRQF_FORCE_RESUME
Message-ID: <20120515163316.GC17760@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
 <1337048075-6132-75-git-send-email-paul.gortmaker@windriver.com>
 <20120515050221.GA4292@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120515050221.GA4292@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [34-longterm 074/179] xen: Use IRQF_FORCE_RESUME] On 15/05/2012 (Tue 00:02) Jonathan Nieder wrote:

> Hi Paul,
> 
> Paul Gortmaker wrote:
> 
> > From: Thomas Gleixner <tglx@linutronix.de>
> [...]
> >     If you see a problem with using this for longterm, please comment.
> [...]
> > commit 676dc3cf5bc36a9e129a3ad8fe3bd7b2ebf20f5d upstream.
> >
> > Mark the IRQF_NO_SUSPEND interrupts IRQF_FORCE_RESUME and remove the extra
> > walk through the interrupt descriptors.
> 
> This produces resume failures and migration failures in Xen guests[1].
> 
> Commit 9bab0b7fbace (genirq: Add IRQF_RESUME_EARLY and resume such
> IRQs earlier, 2011-11-09) is needed on top to avoid regressions.
> 
> Hope that helps,
> Jonathan
> 
> [1] http://thread.gmane.org/gmane.linux.kernel/1198673

Hi Jonathan,

I'd considered this patch, but then saw Greg used it on 2.6.32
and reverted it one release later:

-------------------
commit 758d61b4a76e6ad4224780771edbc6d3a0c29b16
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Tue Nov 8 15:40:42 2011 -0800

    Revert "genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier"
    
    This reverts commit 0f12a6ad9fa3a03f2bcee36c9cb704821e244c40.
    
    It causes too many build errors and needs to be done properly.
    
    Reported-by: Jiri Slaby <jslaby@suse.cz>
    Reported-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
    Cc: Ian Campbell <ian.campbell@citrix.com>
 [...]
-------------

What I didn't realize was that it got re-added as a v2 again in:

-------------
commit 5e87d8ee34e32fda720f3a4e4055f570b09230d6
Author: Ian Campbell <ian.campbell@citrix.com>
Date:   Wed Nov 9 08:53:09 2011 +0000

    genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier
    
[...]

    Back ported to 2.6.32 (which lacks syscore support) by calling the relavant
    resume function directly from sysdev_resume).
    
    v2: Fixed non-x86 build errors.
-----------

I'll make sure the v2 ends up in the 34 queue.

Thanks again,
Paul.

