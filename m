Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0LIImz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:42:55 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:52146 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0LIImy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:42:54 -0500
Subject: Re: [PATCH] AVR32: Fix sys_execve breakage
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: svens@stackframe.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1291883201-7903-2-git-send-email-svens@stackframe.org>
References: <1291874601.2794.5.camel@hcegtvedt>
	 <1291883201-7903-2-git-send-email-svens@stackframe.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Thu, 09 Dec 2010 09:42:48 +0100
Message-ID: <1291884168.18008.4.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2010 08:42:50.0281 (UTC) FILETIME=[0FD98190:01CB977D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 09:26 +0100, svens@stackframe.org wrote: 
> From: Sven Schnelle <svens@stackframe.org>
> 
> Signed-off-by: Sven Schnelle <svens@stackframe.org>
> ---
>  arch/avr32/include/asm/syscalls.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/avr32/include/asm/syscalls.h b/arch/avr32/include/asm/syscalls.h
> index ab608b7..1440368 100644
> --- a/arch/avr32/include/asm/syscalls.h
> +++ b/arch/avr32/include/asm/syscalls.h
> @@ -21,8 +21,10 @@ asmlinkage int sys_clone(unsigned long, unsigned long,
>  			 unsigned long, unsigned long,
>  			 struct pt_regs *);
>  asmlinkage int sys_vfork(struct pt_regs *);
> -asmlinkage int sys_execve(const char __user *, char __user *__user *,
> -			  char __user *__user *, struct pt_regs *);
> +asmlinkage int sys_execve(const char __user *ufilename,
> +			  const char __user *const __user *uargv,
> +			  const char __user *const __user *uenvp,
> +			  struct pt_regs *regs);
>  
>  /* kernel/signal.c */
>  asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,

Also discussed at https://lkml.org/lkml/2010/12/8/401 Sorry for not
letting you know in my first reply.

I am thinking something in the order of

>From 8e2bf82870c3324d7151493d5557244fb178dbce Mon Sep 17 00:00:00 2001
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Date: Thu, 9 Dec 2010 09:00:01 +0100
Subject: [PATCH] avr32: use syscall prototypes from asm-generic instead of arch

This patch removes the redundant syscalls prototypes in the architecture
specific syscalls.h header file. These were identical with the ones in
asm-generic/syscalls.h.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 arch/avr32/include/asm/syscalls.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/avr32/include/asm/syscalls.h b/arch/avr32/include/asm/syscalls.h
index 1440368..730a461 100644
--- a/arch/avr32/include/asm/syscalls.h
+++ b/arch/avr32/include/asm/syscalls.h
@@ -16,20 +16,9 @@
 #include <linux/signal.h>
 
 /* kernel/process.c */
-asmlinkage int sys_fork(struct pt_regs *);
 asmlinkage int sys_clone(unsigned long, unsigned long,
 			 unsigned long, unsigned long,
 			 struct pt_regs *);
-asmlinkage int sys_vfork(struct pt_regs *);
-asmlinkage int sys_execve(const char __user *ufilename,
-			  const char __user *const __user *uargv,
-			  const char __user *const __user *uenvp,
-			  struct pt_regs *regs);
-
-/* kernel/signal.c */
-asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
-			       struct pt_regs *);
-asmlinkage int sys_rt_sigreturn(struct pt_regs *);
 
 /* mm/cache.c */
 asmlinkage int sys_cacheflush(int, void __user *, size_t);
-- 
1.7.1

-- 
Hans-Christian Egtvedt

