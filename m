Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2BTGWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:22:15 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40416 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2BTGWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:22:13 -0500
Date: Mon, 20 Feb 2012 11:38:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkenisto@us.ibm.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        oleg@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        Benjamin Herrenschmidt <benh@au1.ibm.com>,
        Josh Stone <jistone@redhat.com>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/uprobes] uprobes/core: Clean up,  refactor and
 improve the code
Message-ID: <20120220060825.GA22680@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <tip-ewbwhb8o6navvllsauu7k07p@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <tip-ewbwhb8o6navvllsauu7k07p@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022006-3270-0000-0000-0000042A09F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
>  - remove unnecessary volatile

volatiles were added because of warnings thrown by gcc-4.6. Please see
below.

> 
>  - restructure comment blocks to make them more uniform and
>    more readable in general
> 

...

> diff --git a/arch/Kconfig b/arch/Kconfig
> index 284f589..cca5b54 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -66,13 +66,19 @@ config OPTPROBES
>  	depends on !PREEMPT
> 
>  config UPROBES
> -	bool "User-space probes (EXPERIMENTAL)"
> +	bool "Transparent user-space probes (EXPERIMENTAL)"
>  	depends on ARCH_SUPPORTS_UPROBES
>  	default n
>  	help
> -	  Uprobes enables kernel subsystems to establish probepoints
> -	  in user applications and execute handler functions when
> -	  the probepoints are hit.
> +	  Uprobes is the user-space counterpart to kprobes: they
> +	  enable instrumentation applications (such as 'perf probe')
> +	  to establish unintrusive probes in user-space binaries and
> +	  libraries, by executing handler functions when the probes
> +	  are hit by user-space applications.
> +
> +	  ( These probes come in the form of single-byte breakpoints,

One nit: In some architectures like powerpc, the breakpoints arent
single-byte.

> +	    managed by the kernel and kept transparent to the probed
> +	    application. )
> 
>  	  If in doubt, say "N".
> 
> 
>  #ifdef CONFIG_X86_64
> -static volatile u32 good_insns_64[256 / 32] = {
> +static u32 good_insns_64[256 / 32] = {

The volatiles were added to arch/x86/kernel/kprobes.c because of commit
7115e3fcf45 and 315eb8a2a1b. The volatiles are required because gcc 4.6
gave a warning about the asm operand for test_bit.  So the same were
added to arch/x86/kernel/uprobes.c.

-- 
Thanks and Regards
Srikar

