Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab1JJIlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:41:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50363 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab1JJIl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:41:29 -0400
Date: Mon, 10 Oct 2011 09:41:26 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] regmap: Allow caches for devices with no defaults
Message-ID: <20111010084126.GA2563@opensource.wolfsonmicro.com>
References: <1318167876-17801-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1318167876-17801-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318167876-17801-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 09, 2011 at 02:44:36PM +0100, Mark Brown wrote:
> We only really need the defaults in order to cut down the number of
> registers we sync and to satisfy reads while the device is powered off
> but not all devices are going to need to do that (always on devices like
> PMICs being the prime example) so don't require those devices to supply
> a default.  Instead only try to fall back to hardware defaults if the
> driver told us to.
> 
> Devices using LZO won't be able to instantiate with this, that will require
> some updates in the LZO code to handle this case.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/base/regmap/regcache.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
> index 67c7703..666f6f5 100644
> --- a/drivers/base/regmap/regcache.c
> +++ b/drivers/base/regmap/regcache.c
> @@ -120,7 +120,7 @@ int regcache_init(struct regmap *map)
>  		if (!tmp_buf)
>  			return -ENOMEM;
>  		map->reg_defaults = tmp_buf;
> -	} else {
> +	} else if (map->num_reg_defaults_raw) {
>  		/* Some devices such as PMICs don't have cache defaults,
>  		 * we cope with this by reading back the HW registers and
>  		 * crafting the cache defaults by hand.
> -- 
> 1.7.6.3

We could probably then also remove the first check in
regcache_hw_init() I guess.

The one:

if (!map->num_reg_defaults_raw)
	return -EINVAL;

Thanks,
Dimitris
