Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab1KNPoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 10:44:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53328 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000Ab1KNPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 10:44:14 -0500
Date: Mon, 14 Nov 2011 15:44:11 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] regmap: return ERR_PTR instead of NULL in
	regmap_init
Message-ID: <20111114154411.GA12690@opensource.wolfsonmicro.com>
References: <1321263619-25891-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321263619-25891-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 10:40:15AM +0100, Lars-Peter Clausen wrote:
> The regmap_init documentation states that it will either return a pointer to a
> valid regmap structure or a ERR_PTR in case of an error. Currently it returns a
> NULL pointer in case no bus or no config was given. Since NULL is not a
> ERR_PTR a caller might assume that it is a pointer to a valid regmap structure,
> so return a ERR_PTR(-EINVAL) instead.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/base/regmap/regmap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index b08df85..b84ebf9 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -139,7 +139,7 @@ struct regmap *regmap_init(struct device *dev,
>  	int ret = -EINVAL;
>  
>  	if (!bus || !config)
> -		return NULL;
> +		goto err;
>  
>  	map = kzalloc(sizeof(*map), GFP_KERNEL);
>  	if (map == NULL) {
> -- 
> 1.7.7.1
> 
> 

Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
