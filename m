Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2DQShA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:37:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58671 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab2DQSg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:36:58 -0400
Message-ID: <4F8DB83D.8000208@zytor.com>
Date: Tue, 17 Apr 2012 11:36:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        ming.m.lin@intel.com, rjw@sisk.pl, x86@kernel.org
Subject: Re: [PATCH 2/2] x86/acpi: Call acpi_enter_sleep_state via an asmlinkage
 C function from assembler.
References: <1334687359-9970-1-git-send-email-konrad.wilk@oracle.com> <1334687359-9970-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1334687359-9970-3-git-send-email-konrad.wilk@oracle.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 11:29 AM, Konrad Rzeszutek Wilk wrote:
> diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
> index 13ab720..d3a18a4 100644
> --- a/arch/x86/kernel/acpi/wakeup_32.S
> +++ b/arch/x86/kernel/acpi/wakeup_32.S
> @@ -74,8 +74,7 @@ restore_registers:
>  ENTRY(do_suspend_lowlevel)
>  	call	save_processor_state
>  	call	save_registers
> -	pushl	$3
> -	call	acpi_enter_sleep_state
> +	call	acpi_enter_s3
>  	addl	$4, %esp
>  

You need to drop the %esp adjustment here.

>  #	In case of S3 failure, we'll emerge here.  Jump
> diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
> index 8ea5164..fea733d 100644
> --- a/arch/x86/kernel/acpi/wakeup_64.S
> +++ b/arch/x86/kernel/acpi/wakeup_64.S
> @@ -71,9 +71,8 @@ ENTRY(do_suspend_lowlevel)
>  	movq	%rsi, saved_rsi
>  
>  	addq	$8, %rsp
> -	movl	$3, %edi
>  	xorl	%eax, %eax
> -	call	acpi_enter_sleep_state
> +	call	acpi_enter_s3
>  	/* in case something went wrong, restore the machine status and go on */

You can presumably remove the xorl here ... setting %eax to zero
immediately before calling a non-varadic C function is meaningless.

	-hpa

