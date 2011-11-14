Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab1KNPpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 10:45:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53338 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582Ab1KNPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 10:45:38 -0500
Date: Mon, 14 Nov 2011 15:45:36 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] regmap: Do not call regcache_exit from
	regcache_lzo_init error path
Message-ID: <20111114154536.GB12690@opensource.wolfsonmicro.com>
References: <1321263619-25891-1-git-send-email-lars@metafoo.de> <1321263619-25891-5-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321263619-25891-5-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 10:40:19AM +0100, Lars-Peter Clausen wrote:
> Calling regcache_exit from regcache_lzo_init is a layering violation and
> might cause double frees. In case of an error only free those structures which
> have been allocated in this function.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/base/regmap/regcache-lzo.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
> index 226ffc1..b7d1614 100644
> --- a/drivers/base/regmap/regcache-lzo.c
> +++ b/drivers/base/regmap/regcache-lzo.c
> @@ -15,6 +15,8 @@
>  
>  #include "internal.h"
>  
> +static int regcache_lzo_exit(struct regmap *map);
> +
>  struct regcache_lzo_ctx {
>  	void *wmem;
>  	void *dst;
> @@ -193,7 +195,7 @@ static int regcache_lzo_init(struct regmap *map)
>  
>  	return 0;
>  err:
> -	regcache_exit(map);
> +	regcache_lzo_exit(map);
>  	return ret;
>  }
>  
> -- 
> 1.7.7.1
> 
> 

All of them look good.

Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
