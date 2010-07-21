Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab0GUVVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:21:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:59571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757693Ab0GUVU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:20:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,240,1278313200"; 
   d="scan'208";a="537621887"
Subject: Re: [PATCH 2/7] x86, xsave: introduce xstate enable functions
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C476236.1020302@zytor.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
	 <1279731838-1522-3-git-send-email-robert.richter@amd.com>
	 <4C476236.1020302@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 21 Jul 2010 14:20:25 -0700
Message-Id: <1279747225.2812.37.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 14:10 -0700, H. Peter Anvin wrote:
> On 07/21/2010 10:03 AM, Robert Richter wrote:
> > The patch renames xsave_cntxt_init() and __xsave_init() into
> > xstate_enable_boot_cpu() and xstate_enable() as this names are more
> > meaningful.
> > 
> > It also removes the duplicate xcr setup for the boot cpu.
> > 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> > -static void __cpuinit xsave_cntxt_init(void)
> > +static void __cpuinit xstate_enable_boot_cpu(void)
> >  {
> >  	unsigned int eax, ebx, ecx, edx;
> >  
> > @@ -443,7 +438,8 @@ static void __cpuinit xsave_cntxt_init(void)
> >  	 * Support only the state known to OS.
> >  	 */
> >  	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
> > -	__xsave_init();
> > +
> > +	xstate_enable(pcntxt_mask);
> >  
> >  	/*
> >  	 * Recompute the context size for enabled features
> 
> This one should be __init rather than __cpuinit, right?  As written, I get:
> 
> 
> WARNING: vmlinux.o(.cpuinit.text+0x824): Section mismatch in reference
> from the function xstate_enable_boot_cpu() to the function
> .init.text:__alloc_bootmem()
> The function __cpuinit xstate_enable_boot_cpu() references
> a function __init __alloc_bootmem().
> If __alloc_bootmem is only used by xstate_enable_boot_cpu then
> annotate __alloc_bootmem with a matching annotation.
> 
> [No need to resend the patch, but if either Suresh or Robert could ACK
> this change I'd appreciate it.]

Yes, it should be __init.

thanks,
suresh

