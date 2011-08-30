Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1H3Fgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:36:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:50233 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1H3Fgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:36:49 -0400
Subject: Re: [PATCH v9 11/13] powerpc: select HAVE_SECCOMP_FILTER and
 provide seccomp_execve
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        djm@mindrot.org, segoon@openwall.com, kees.cook@canonical.com,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        fweisbec@gmail.com, tglx@linutronix.de, scarybeasts@gmail.com,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1308875813-20122-11-git-send-email-wad@chromium.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
	 <1308875813-20122-11-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 15:28:03 +1000
Message-ID: <1314682083.2488.73.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 19:36 -0500, Will Drewry wrote:
> Facilitate the use of CONFIG_SECCOMP_FILTER by wrapping compatibility
> system call numbering for execve and selecting HAVE_SECCOMP_FILTER.
> 
> v9: rebase on to bccaeafd7c117acee36e90d37c7e05c19be9e7bf
> 
> Signed-off-by: Will Drewry <wad@chromium.org>

Seen these around for a while ... :-)

I don't see a harm in the patches per-se tho I haven't reviewed the
actual seccomp filter stuff and it's good (or bad) behaviour on ppc.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.

> ---
>  arch/powerpc/Kconfig               |    1 +
>  arch/powerpc/include/asm/seccomp.h |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 2729c66..030d392 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -129,6 +129,7 @@ config PPC
>  	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
>  	select HAVE_GENERIC_HARDIRQS
>  	select HAVE_SPARSE_IRQ
> +	select HAVE_SECCOMP_FILTER
>  	select IRQ_PER_CPU
>  	select GENERIC_IRQ_SHOW
>  	select GENERIC_IRQ_SHOW_LEVEL
> diff --git a/arch/powerpc/include/asm/seccomp.h b/arch/powerpc/include/asm/seccomp.h
> index 00c1d91..3cb9cc1 100644
> --- a/arch/powerpc/include/asm/seccomp.h
> +++ b/arch/powerpc/include/asm/seccomp.h
> @@ -7,10 +7,12 @@
>  #define __NR_seccomp_write __NR_write
>  #define __NR_seccomp_exit __NR_exit
>  #define __NR_seccomp_sigreturn __NR_rt_sigreturn
> +#define __NR_seccomp_execve __NR_execve
>  
>  #define __NR_seccomp_read_32 __NR_read
>  #define __NR_seccomp_write_32 __NR_write
>  #define __NR_seccomp_exit_32 __NR_exit
>  #define __NR_seccomp_sigreturn_32 __NR_sigreturn
> +#define __NR_seccomp_execve_32 __NR_execve
>  
>  #endif	/* _ASM_POWERPC_SECCOMP_H */


