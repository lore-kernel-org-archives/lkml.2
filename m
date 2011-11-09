Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1KIMOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:14:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37028 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab1KIMOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:14:08 -0500
Date: Wed, 9 Nov 2011 12:14:06 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: Support some more block operations on
	cached devices
Message-ID: <20111109121406.GA32212@opensource.wolfsonmicro.com>
References: <1320773846-28635-1-git-send-email-lars@metafoo.de> <1320773846-28635-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320773846-28635-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:37:26PM +0100, Lars-Peter Clausen wrote:
> Commit 10a08d9f ("regmap: Support some block operations on cached devices")
> allowed raw read operations without throwing a warning when using caches if
> all registers are volatile. This patch does the same for raw write operations.
> 
> This is for example useful when loading a firmware in a predefined volatile
> region on a chip where we otherwise want registers to be cached.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/base/regmap/regmap.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 4016b00..a471083 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -387,9 +387,11 @@ EXPORT_SYMBOL_GPL(regmap_write);
>  int regmap_raw_write(struct regmap *map, unsigned int reg,
>  		     const void *val, size_t val_len)
>  {
> +	size_t val_count = val_len / map->format.val_bytes;
>  	int ret;
>  
> -	WARN_ON(map->cache_type != REGCACHE_NONE);
> +	WARN_ON(!regmap_volatile_range(map, reg, val_count) &&
> +		map->cache_type != REGCACHE_NONE);
>  
>  	mutex_lock(&map->lock);
>  
> -- 
> 1.7.7

Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
