Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1JJJBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:01:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35976 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839Ab1JJJBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:01:21 -0400
Date: Mon, 10 Oct 2011 10:01:17 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Warn on raw I/O as well as bulk reads that
	bypass cache
Message-ID: <20111010090117.GB2563@opensource.wolfsonmicro.com>
References: <1318167534-16479-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318167534-16479-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 09, 2011 at 02:38:54PM +0100, Mark Brown wrote:
> As with the bulk reads we really should be able to make these play
> nicely with the cache but warn for now.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/base/regmap/regmap.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index d786ddc..85bffdd 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -377,6 +377,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
>  {
>  	int ret;
>  
> +	WARN_ON(map->cache_type != REGCACHE_NONE);
> +
>  	mutex_lock(&map->lock);
>  
>  	ret = _regmap_raw_write(map, reg, val, val_len);
> @@ -481,6 +483,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
>  {
>  	int ret;
>  
> +	WARN_ON(map->cache_type != REGCACHE_NONE);
> +
>  	mutex_lock(&map->lock);
>  
>  	ret = _regmap_raw_read(map, reg, val, val_len);
> -- 
> 1.7.6.3

All of them look good.

Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
