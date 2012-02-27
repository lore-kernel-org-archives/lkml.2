Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2B0NhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 08:37:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16700 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2B0NhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 08:37:12 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=cHesF316CzwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=UOuEXLYGAAAA:8 a=zvjADMBuTgUBdnGZuMAA:9 a=PUjeQqilurYA:10 a=KDHgVdQ1CmEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330349831.25686.188.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: don't select FRAME_POINTER on PPC
From: Steven Rostedt <rostedt@goodmis.org>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: holger.brunck@keymile.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 27 Feb 2012 08:37:11 -0500
In-Reply-To: <1330330101-8618-1-git-send-email-gerlando.falauto@keymile.com>
References: <1330330101-8618-1-git-send-email-gerlando.falauto@keymile.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 09:08 +0100, Gerlando Falauto wrote:
> On PowerPC, FUNCTION_TRACER selects FRAME_POINTER, even
> though the architecture does not support it.
> 
> This causes the following warning:
> warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)
> 
> So remove the warning by adding the extra condition
> "if !PPC" to FUNCTION_TRACER for FRAME_POINTER selection

I'll queue it up for 3.4, if that's fine with you.

Thanks,

-- Steve

> 
> Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
> ---
>  kernel/trace/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 2ad39e5..fbdec2e 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -141,7 +141,7 @@ if FTRACE
>  config FUNCTION_TRACER
>  	bool "Kernel Function Tracer"
>  	depends on HAVE_FUNCTION_TRACER
> -	select FRAME_POINTER if !ARM_UNWIND && !S390 && !MICROBLAZE
> +	select FRAME_POINTER if !ARM_UNWIND && !PPC && !S390 && !MICROBLAZE
>  	select KALLSYMS
>  	select GENERIC_TRACER
>  	select CONTEXT_SWITCH_TRACER


