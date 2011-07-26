Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab1GZI5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:57:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57076 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1GZI5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:57:37 -0400
Date: Tue, 26 Jul 2011 09:57:25 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: Document ARM's user_debug parameter
Message-ID: <20110726085721.GB2075@arm.com>
References: <1311556514-24728-1-git-send-email-sboyd@codeaurora.org>
 <20110725142924.85de25dd.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725142924.85de25dd.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 02:29:24PM -0700, Randy Dunlap wrote:
> On Sun, 24 Jul 2011 18:15:14 -0700 Stephen Boyd wrote:
> 
> > Usually kernel parameters are documented in kernel-parameters.txt
> > but user_debug is only documented in the Kconfig. Document the
> > option and point to the Kconfig help text for more info.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > Cc: Russell King <linux@arm.linux.org.uk>
> 
> Is this a superset of 'print_fatal_signals'?
> 
> Applied, thanks.
> 
> > ---
> >  Documentation/kernel-parameters.txt |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index aa47be7..8186adc 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2612,6 +2612,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  					medium is write-protected).
> >  			Example: quirks=0419:aaf5:rl,0421:0433:rc
> >  
> > +	user_debug=	[KNL,ARM]
> > +			Format: <int>
> > +			See arch/arm/Kconfig.debug help text.
> > +				 1 - undefined instruction events
> > +				 2 - system calls

linux$ git grep UDBG_SYSCALL -- arch/arm/
include/asm/system.h:#define UDBG_SYSCALL       (1 << 1)
kernel/traps.c: if (user_debug & UDBG_SYSCALL) {
kernel/traps.c: if (user_debug & UDBG_SYSCALL) {

Looking at kernel/traps.c, it looks like only undefined or obsolete
syscalls are logged.  It could be worth clarifying this in the wording,
both here and in arch/arm/Kconfig.debug.

Cheers
---Dave

> > +				 4 - invalid data aborts
> > +				 8 - SIGSEGV faults
> > +				16 - SIGBUS faults
> > +			Example: user_debug=31
> > +
> >  	userpte=
> >  			[X86] Flags controlling user PTE allocations.
> >  
> > -- 
> > Sent by an employee of the Qualcomm Innovation Center, Inc.
> > The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
