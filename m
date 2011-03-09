Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1CIWlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:41:50 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:38199 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1CIWlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:41:49 -0500
Message-ID: <4D780221.1030209@free.fr>
Date: Wed, 09 Mar 2011 23:41:37 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com, rjw@sisk.pl
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/trampoline] x86, trampoline: Use the unified trampoline
 setup for ACPI wakeup
References: <4D5DFBE4.7090104@intel.com> <tip-d1ee433539ea5963a8f946f3428b335d1c5fdb20@git.kernel.org>
In-Reply-To: <tip-d1ee433539ea5963a8f946f3428b335d1c5fdb20@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

tip-bot for H. Peter Anvin a écrit :
> Commit-ID:  d1ee433539ea5963a8f946f3428b335d1c5fdb20
> Gitweb:     http://git.kernel.org/tip/d1ee433539ea5963a8f946f3428b335d1c5fdb20
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Mon, 14 Feb 2011 15:42:46 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 17 Feb 2011 21:05:06 -0800
> 
> diff --git a/arch/x86/kernel/acpi/wakeup_rm.S b/arch/x86/kernel/acpi/wakeup_rm.S
> index 6ff3b57..6ce81ee 100644
> --- a/arch/x86/kernel/acpi/wakeup_rm.S
> +++ b/arch/x86/kernel/acpi/wakeup_rm.S
> @@ -2,9 +2,11 @@
>   * Wrapper script for the realmode binary as a transport object
>   * before copying to low memory.
>   */
> -	.section ".rodata","a"
> -	.globl	wakeup_code_start, wakeup_code_end
> -wakeup_code_start:
> +#include <asm/page_types.h>
> +
> +	.section ".x86_trampoline","a"
> +	.balign PAGE_SIZE
> +	.globl	acpi_wakeup_code
> +acpi_wakeup_code:
>  	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
> -wakeup_code_end:
>  	.size	wakeup_code_start, .-wakeup_code_start
It doesn't build for me, Shouldn't you change this to 
.size	acpi_wakeup_code, .-acpi_wakeup_code ?


Matthieu
