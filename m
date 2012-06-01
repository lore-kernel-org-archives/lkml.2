Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab2FAARi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 20:17:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40201 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932484Ab2FAARh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 20:17:37 -0400
Message-ID: <1338509855.9151.2.camel@joe2Laptop>
Subject: Re: [PATCH] regmap: Fix the size calculation for
 map->format.buf_size
From: Joe Perches <joe@perches.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        marc@cpdesign.com.au, philippe.retornaz@epfl.ch,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Date: Thu, 31 May 2012 17:17:35 -0700
In-Reply-To: <1338509430-24416-1-git-send-email-festevam@gmail.com>
References: <1338509430-24416-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 21:10 -0300, Fabio Estevam wrote:
> the total size should be calculated by summing up the number of bits of
> each element and using a DIV_ROUND_UP to return the number of bytes.
[]
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
[]
> @@ -246,11 +246,11 @@ struct regmap *regmap_init(struct device *dev,
>  		map->lock = regmap_lock_mutex;
>  		map->unlock = regmap_unlock_mutex;
>  	}
> -	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
>  	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
>  	map->format.pad_bytes = config->pad_bits / 8;
>  	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
> -	map->format.buf_size += map->format.pad_bytes;
> +	map->format.buf_size = DIV_ROUND_UP(config->reg_bits +
> +			config->val_bits + config->pad_bits, 8);
>  	map->reg_shift = config->pad_bits % 8;

s/8/BITS_PER_BYTE/ ?


