Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab1CRRTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:19:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139Ab1CRRTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:19:48 -0400
Date: Fri, 18 Mar 2011 13:19:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        jwjstone@fastmail.fm, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] watchdog, nmi:  Allow hardlockup to panic by
 default
Message-ID: <20110318171932.GH2743@redhat.com>
References: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
 <20110317185013.7c8be1e0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317185013.7c8be1e0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 06:50:13PM -0700, Andrew Morton wrote:
> On Mon,  7 Mar 2011 16:37:39 -0500 Don Zickus <dzickus@redhat.com> wrote:
> 
> > Add a Kconfig option to allow users to set the hardlockup to panic
> > by default.  Also add in a 'nmi_watchdog=nopanic' to override this.
> > 
> 
> Changelog forgot to tell us "why".

Yeah, sorry about that.

When a cpu is considered stuck, instead of limping along and just printing
a warning, it is sometimes preferred to just panic, let kdump capture the
vmcore and reboot.  This gets the machine back into a stable state quickly
while saving the info that got it into a stuck state to begin with.


> 
> >  			Format: [state][,regs][,debounce][,die]
> >  
> >  	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
> > -			Format: [panic,][num]
> > +			Format: [panic,][nopanic,][num]
> 
> It would be better to support panic=[0|1], if that can be simply done
> in a back-compatible fashion.

I am open to the idea, just can't figure the best way to implement that in
a backwards compatible way.

Personally I was wondering if there were situations where you would _not_
want it to panic.  If the cpu is stuck spinning after 60 seconds, the odds
of it freeing itself is low and you are probably stuck rebooting anyway.


> 
> >  static int __init hardlockup_panic_setup(char *str)
> >  {
> >  	if (!strncmp(str, "panic", 5))
> >  		hardlockup_panic = 1;
> > +	else if (!strncmp(str, "nopanic", 5))
> 
> s/5/7/

doh.

I can send a refreshed patch with the above changes.

Cheers,
Don
