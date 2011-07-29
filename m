Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1G2ESh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 00:18:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61785 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1G2ESg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 00:18:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110729014247.692715109@goodmis.org>
References: <20110729014215.328710900@goodmis.org>
	<20110729014247.692715109@goodmis.org>
Date: Fri, 29 Jul 2011 00:18:34 -0400
Message-ID: <CAMzpN2jAKphUcp2eFfyVtn+ut+=oRqr40G3tTbDMziEg+TEuhw@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86: Do not differentiate between x86_64 and i386
 with init_per_cpu
From: Brian Gerst <brgerst@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though 32-bit doesn't currently use these macros, please keep the
current define, since only 64-bit SMP is special in this regard.
64-bit SMP uses a zero-based percpu segment, which requires the linker
fixup for statically initialized percpu pointers.  This fixup isn't
needed on 32-bit SMP (or UP).

--
Brian Gerst

On Thu, Jul 28, 2011 at 9:42 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> There's nothing different between the way x86_64 and x86_32
> treate init_per_cpu.
>
> Although only x86_64 uses INIT_PER_CPU_VAR() in the head.S file,
> there is still no reason to keep the macro x86_64 only.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/include/asm/percpu.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
> index a0a9779..ab86813 100644
> --- a/arch/x86/include/asm/percpu.h
> +++ b/arch/x86/include/asm/percpu.h
> @@ -33,7 +33,7 @@
>  #define PER_CPU_VAR(var)       var
>  #endif /* SMP */
>
> -#ifdef CONFIG_X86_64_SMP
> +#ifdef CONFIG_SMP
>  #define INIT_PER_CPU_VAR(var)  init_per_cpu__##var
>  #else
>  #define INIT_PER_CPU_VAR(var)  var
> @@ -77,7 +77,7 @@
>  #define DECLARE_INIT_PER_CPU(var) \
>        extern typeof(var) init_per_cpu_var(var)
>
> -#ifdef CONFIG_X86_64_SMP
> +#ifdef CONFIG_SMP
>  #define init_per_cpu_var(var)  init_per_cpu__##var
>  #else
>  #define init_per_cpu_var(var)  var
> --
> 1.7.5.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
