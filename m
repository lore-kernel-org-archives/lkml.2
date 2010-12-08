Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab0LHE1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:27:35 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52205 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0LHE1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:27:34 -0500
Subject: Re: [PATCH] Move the scope of the FD_SET, FD_CLR, FD_SETSIZE,
 FD_ISSET, and FD_SERO to the linux/posix_types.h scope and out of the
 linux/time.h scope.
From: john stultz <johnstul@us.ibm.com>
To: ckhardin@gmail.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1291775384-7570-1-git-send-email-ckhardin@gmail.com>
References: <1291775384-7570-1-git-send-email-ckhardin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 20:27:30 -0800
Message-ID: <1291782450.2325.41.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 18:29 -0800, ckhardin@gmail.com wrote:
> From: Charles Hardin <chardin@erebus.dhcp.2wire.com>
> 
> This is a change to address a conflict in a time utility library that
> was using the kernel version of timespec and picked up the FD_SET macros
> and which caused a redefinition compiler error
> 
> Signed-off-by: Charles Hardin <ckhardin@gmail.com>

No objection here, but I'm not sure if I'm the best to review this, as
I'm not as familiar with the users of FD_*.

thanks
-john


> ---
>  include/linux/posix_types.h |   12 ++++++++++++
>  include/linux/time.h        |    8 --------
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/posix_types.h b/include/linux/posix_types.h
> index f04c98c..c49ce52 100644
> --- a/include/linux/posix_types.h
> +++ b/include/linux/posix_types.h
> @@ -33,6 +33,18 @@
>  #undef __FDMASK
>  #define	__FDMASK(d)	(1UL << ((d) % __NFDBITS))
> 
> +#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
> +
> +#define NFDBITS			__NFDBITS
> +
> +#define FD_SETSIZE		__FD_SETSIZE
> +#define FD_SET(fd,fdsetp)	__FD_SET(fd,fdsetp)
> +#define FD_CLR(fd,fdsetp)	__FD_CLR(fd,fdsetp)
> +#define FD_ISSET(fd,fdsetp)	__FD_ISSET(fd,fdsetp)
> +#define FD_ZERO(fdsetp)		__FD_ZERO(fdsetp)
> +
> +#endif /* not kernel and not glibc */
> +
>  typedef struct {
>  	unsigned long fds_bits [__FDSET_LONGS];
>  } __kernel_fd_set;
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 9f15ac7..6e612a4 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -254,14 +254,6 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
>  }
>  #endif /* __KERNEL__ */
> 
> -#define NFDBITS			__NFDBITS
> -
> -#define FD_SETSIZE		__FD_SETSIZE
> -#define FD_SET(fd,fdsetp)	__FD_SET(fd,fdsetp)
> -#define FD_CLR(fd,fdsetp)	__FD_CLR(fd,fdsetp)
> -#define FD_ISSET(fd,fdsetp)	__FD_ISSET(fd,fdsetp)
> -#define FD_ZERO(fdsetp)		__FD_ZERO(fdsetp)
> -
>  /*
>   * Names of the interval timers, and structure
>   * defining a timer setting:


