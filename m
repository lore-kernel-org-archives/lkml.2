Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1GSVv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:51:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35000 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1GSVvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:51:25 -0400
Date: Tue, 19 Jul 2011 15:51:20 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] regmap: Add SPI bus support
Message-ID: <20110719215120.GS6848@ponder.secretlab.ca>
References: <20110718100444.GD423@opensource.wolfsonmicro.com>
 <1310983663-6404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310983663-6404-3-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310983663-6404-3-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 07:07:42PM +0900, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Liam Girdwood <lrg@ti.com>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>

One comment below, but otherwise:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

on the whole series.
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index e509bac..c549632 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -61,6 +61,9 @@ struct regmap *regmap_init(struct device *dev,
>  			   const struct regmap_config *config);
>  struct regmap *regmap_init_i2c(struct device *dev,
>  			       const struct regmap_config *config);
> +struct regmap *regmap_init_spi(struct device *dev,
> +			       const struct regmap_config *config);
> +

regmap_init_i2c/spi should take an i2c_client and spi_device pointer
respectively so it can be type checked.

>  void regmap_exit(struct regmap *map);
>  int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
>  int regmap_raw_write(struct regmap *map, unsigned int reg,
> -- 
> 1.7.5.4
> 
