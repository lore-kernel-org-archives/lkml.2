Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0HRUpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:45:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171Ab0HRUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:45:31 -0400
Date: Wed, 18 Aug 2010 13:44:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: tony.luck@gmail.com, torvalds@linux-foundation.org,
        xiyou.wangcong@gmail.com, ralf@linux-mips.org,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the declaration of sys_execve() in
 asm-generic/syscalls.h
Message-Id: <20100818134416.50403573.akpm@linux-foundation.org>
In-Reply-To: <20100818175533.22912.89002.stgit@warthog.procyon.org.uk>
References: <20100818175533.22912.89002.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 18:55:33 +0100
David Howells <dhowells@redhat.com> wrote:

> Fix the declaration of sys_execve() in asm-generic/syscalls.h to have various
> consts applied to its pointers.
> 

crappy changelog :(

> ---
> 
>  include/asm-generic/syscalls.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/syscalls.h b/include/asm-generic/syscalls.h
> index df84e3b..d89dec8 100644
> --- a/include/asm-generic/syscalls.h
> +++ b/include/asm-generic/syscalls.h
> @@ -23,8 +23,10 @@ asmlinkage long sys_vfork(struct pt_regs *regs);
>  #endif
>  
>  #ifndef sys_execve
> -asmlinkage long sys_execve(char __user *filename, char __user * __user *argv,
> -			char __user * __user *envp, struct pt_regs *regs);
> +asmlinkage long sys_execve(const char __user *filename,
> +			   const char __user *const __user *argv,
> +			   const char __user *const __user *envp,
> +			   struct pt_regs *regs);
>  #endif
>  
>  #ifndef sys_mmap2

Is this recent breakage?

In what way does the problem exhibit itself?

If we know these things we can then work out if the patch is needed in
2.6.36 and -stable.

