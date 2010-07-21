Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab0GUVKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:10:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39000 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758710Ab0GUVKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:10:31 -0400
Message-ID: <4C476236.1020302@zytor.com>
Date: Wed, 21 Jul 2010 14:10:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86, xsave: introduce xstate enable functions
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com> <1279731838-1522-3-git-send-email-robert.richter@amd.com>
In-Reply-To: <1279731838-1522-3-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 10:03 AM, Robert Richter wrote:
> The patch renames xsave_cntxt_init() and __xsave_init() into
> xstate_enable_boot_cpu() and xstate_enable() as this names are more
> meaningful.
> 
> It also removes the duplicate xcr setup for the boot cpu.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

> -static void __cpuinit xsave_cntxt_init(void)
> +static void __cpuinit xstate_enable_boot_cpu(void)
>  {
>  	unsigned int eax, ebx, ecx, edx;
>  
> @@ -443,7 +438,8 @@ static void __cpuinit xsave_cntxt_init(void)
>  	 * Support only the state known to OS.
>  	 */
>  	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
> -	__xsave_init();
> +
> +	xstate_enable(pcntxt_mask);
>  
>  	/*
>  	 * Recompute the context size for enabled features

This one should be __init rather than __cpuinit, right?  As written, I get:


WARNING: vmlinux.o(.cpuinit.text+0x824): Section mismatch in reference
from the function xstate_enable_boot_cpu() to the function
.init.text:__alloc_bootmem()
The function __cpuinit xstate_enable_boot_cpu() references
a function __init __alloc_bootmem().
If __alloc_bootmem is only used by xstate_enable_boot_cpu then
annotate __alloc_bootmem with a matching annotation.

[No need to resend the patch, but if either Suresh or Robert could ACK
this change I'd appreciate it.]


	-hpa
