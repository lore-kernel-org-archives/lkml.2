Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab1DNGsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:48:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45787 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1DNGsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:48:32 -0400
Message-ID: <4DA698BA.6020506@monstr.eu>
Date: Thu, 14 Apr 2011 08:48:26 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] ftrace: Build without frame pointers on Microblaze
References: <1301908812-8119-1-git-send-email-monstr@monstr.eu> <1301908812-8119-2-git-send-email-monstr@monstr.eu>
In-Reply-To: <1301908812-8119-2-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, [cc: Steven and Frederic]

can you please add this patch to your tree?

Thanks,
Michal

Michal Simek wrote:
> Microblaze doesn't need/support FRAME_POINTERS in order to have a working
> function tracer.
> 
> The patch remove Kconfig warning.
> 
> Warning log:
> warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP &&
> FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct
> dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 ||
> SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 61d7d59..2ad39e5 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -141,7 +141,7 @@ if FTRACE
>  config FUNCTION_TRACER
>  	bool "Kernel Function Tracer"
>  	depends on HAVE_FUNCTION_TRACER
> -	select FRAME_POINTER if !ARM_UNWIND && !S390
> +	select FRAME_POINTER if !ARM_UNWIND && !S390 && !MICROBLAZE
>  	select KALLSYMS
>  	select GENERIC_TRACER
>  	select CONTEXT_SWITCH_TRACER


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
