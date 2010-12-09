Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0LIIRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:17:08 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:49100 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab0LIIRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:17:07 -0500
Subject: Re: [PATCH] avr32: Fix build failure conflicting types for
 'sys_execve'
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
In-Reply-To: <1291850373-6955-1-git-send-email-peterhuewe@gmx.de>
References: <1291850373-6955-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Thu, 09 Dec 2010 08:54:04 +0100
Message-ID: <1291881244.2794.87.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2010 07:54:06.0787 (UTC) FILETIME=[414FB930:01CB9776]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 00:19 +0100, Peter Huewe wrote: 
> This patch fixes a build failure[1] for the avr32 architecture which seems
> to be introduced by commit d7627467b7a8
> "Make do_execve() take a const filename pointer"
> 
> The commit changes the definition in arch/avr32/kernel/process.c but
> forgot to change it here.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Thanks for the heads-up.

> ---
> This build failure exists in linus' tree - added stable@kernel.org to the cc list
> 
> KernelVersion: linux-next-20101208
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/3607003/
> 
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

Actually, I think it would be just as good to move to using the
syscalls.h in asm-generic. Let me prepare a patch or two for that. I can
try to push it through my, now hopefully working, arch tree.

-- 
Hans-Christian Egtvedt

