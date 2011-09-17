Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1IQOf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 10:35:58 -0400
Received: from mail-wy0-f170.google.com ([74.125.82.170]:49114 "EHLO
	mail-wy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab1IQOf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 10:35:57 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Sep 2011 10:35:56 EDT
Subject: Re: [PATCH] sys_poll: Fix negative timeout values for x86 userland
 on x86_64 kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1316262630.5814.9.camel@localhost.localdomain>
References: <1316262630.5814.9.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Sep 2011 16:29:18 +0200
Message-ID: <1316269758.31335.0.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 17 septembre 2011 à 14:30 +0200, Thomas Meyer a écrit :
> sizeof(int/long) differs on x86 and x86_64, so provide a compat_sys_poll().
> 

Please provide a more descriptive Changelog, since this is a stable
candidate patch.



> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>  arch/x86/ia32/ia32entry.S |    2 +-
>  fs/compat.c               |    6 ++++++
>  include/linux/compat.h    |    2 ++
>  3 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 54edb207..30f4116 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -671,7 +671,7 @@ ia32_sys_call_table:
>  	.quad sys_getresuid16	/* 165 */
>  	.quad sys32_vm86_warning	/* vm86 */ 
>  	.quad quiet_ni_syscall	/* query_module */
> -	.quad sys_poll
> +	.quad compat_sys_poll
>  	.quad quiet_ni_syscall /* old nfsservctl */
>  	.quad sys_setresgid16	/* 170 */
>  	.quad sys_getresgid16
> diff --git a/fs/compat.c b/fs/compat.c
> index 58b1da4..f176fda 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -1621,6 +1621,12 @@ asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
>  				 sigsetsize);
>  }
>  
> +asmlinkage long compat_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
> +				int timeout)
> +{
> +	return sys_poll(ufds, nfds, timeout);
> +}
> +
>  asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
>  	unsigned int nfds, struct compat_timespec __user *tsp,
>  	const compat_sigset_t __user *sigmask, compat_size_t sigsetsize)
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index c6e7523..3bfb30a 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -433,6 +433,8 @@ asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
>  				    compat_ulong_t __user *exp,
>  				    struct compat_timespec __user *tsp,
>  				    void __user *sig);
> +asmlinkage long compat_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
> +				int timeout);
>  asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
>  				 unsigned int nfds,
>  				 struct compat_timespec __user *tsp,


