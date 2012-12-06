Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423588Ab2LFOqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:46:36 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:42277 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423553Ab2LFOqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:46:35 -0500
Date: Thu, 6 Dec 2012 15:46:31 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org, Hans-Peter Nilsson <hp@axis.com>
Subject: Re: [PATCH -resend] cris: Use "int" for ssize_t to match size_t
Message-ID: <20121206144631.GZ14172@axis.com>
References: <1354617596-2457-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354617596-2457-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 11:39:56AM +0100, Geert Uytterhoeven wrote:
> On cris-linux-gcc, __SIZE_TYPE__ expands to "unsigned int", as
> gcc-4.6.3-nolibc/cris-linux/lib/gcc/cris-linux/4.6.3/plugin/include/config/cris/linux.h
> has
> 
>     #define SIZE_TYPE "unsigned int"
> 
> Hence __kernel_size_t is also "unsigned int".  But __kernel_ssize_t is
> "long", which has a different base type, causing compiler warnings like:
> 
>     fs/quota/quota_tree.c:372:4: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]
> 
> To fix this, __kernel_ssize_t should be changed to "int". Hence cris can
> just use the generic 32-bit versions from include/asm-generic/posix_types.h
> for all size-related types.

Yup, I agree, thanks!

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mikael Starvik <starvik@axis.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
> Cc: linux-cris-kernel@axis.com
> ---
>  arch/cris/include/asm/posix_types.h |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/cris/include/asm/posix_types.h b/arch/cris/include/asm/posix_types.h
> index ce4e517..0f22e6a 100644
> --- a/arch/cris/include/asm/posix_types.h
> +++ b/arch/cris/include/asm/posix_types.h
> @@ -22,11 +22,6 @@ typedef unsigned short	__kernel_uid_t;
>  typedef unsigned short	__kernel_gid_t;
>  #define __kernel_uid_t __kernel_uid_t
>  
> -typedef __SIZE_TYPE__	__kernel_size_t;
> -typedef long		__kernel_ssize_t;
> -typedef int		__kernel_ptrdiff_t;
> -#define __kernel_size_t __kernel_size_t
> -
>  typedef unsigned short	__kernel_old_dev_t;
>  #define __kernel_old_dev_t __kernel_old_dev_t
>  
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
