Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2JSIfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:35:34 -0400
Received: from ra.se.axis.com ([195.60.68.13]:48126 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296Ab2JSIfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:35:30 -0400
Date: Fri, 19 Oct 2012 10:35:24 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: starvik@axis.com, yongjun_wei@trendmicro.com.cn,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRIS: locking: fix the return value of
 arch_read_trylock()
Message-ID: <20121019083524.GH29793@axis.com>
References: <CAPgLHd9enojK7tbCxWKyHnzgnSYZUGqAiAgevn6uamrw_3t4Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9enojK7tbCxWKyHnzgnSYZUGqAiAgevn6uamrw_3t4Mg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 10:54:27PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> arch_write_trylock() should return 'ret' instead of always
> return 1.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)

I've taken this into the CRIS-tree, thanks!

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  arch/cris/include/arch-v32/arch/spinlock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/cris/include/arch-v32/arch/spinlock.h b/arch/cris/include/arch-v32/arch/spinlock.h
> index f171a66..f132755 100644
> --- a/arch/cris/include/arch-v32/arch/spinlock.h
> +++ b/arch/cris/include/arch-v32/arch/spinlock.h
> @@ -118,7 +118,7 @@ static  inline int arch_write_trylock(arch_rwlock_t *rw)
>  		ret = 1;
>  	}
>  	arch_spin_unlock(&rw->slock);
> -	return 1;
> +	return ret;
>  }
>  
>  #define _raw_read_lock_flags(lock, flags) _raw_read_lock(lock)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
