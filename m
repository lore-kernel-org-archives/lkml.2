Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1HHGj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 02:39:26 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:56747 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195Ab1HHGjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 02:39:22 -0400
Message-ID: <4E3F8422.8000303@metafoo.de>
Date: Mon, 08 Aug 2011 08:37:22 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Convert pcf50633 to use new register map API
References: <1312780458-3018-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1312780458-3018-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  /* Read a block of up to 32 regs  */
>  int pcf50633_read_block(struct pcf50633 *pcf, u8 reg,
>  					int nr_regs, u8 *data)
>  {
> -	int ret;
> -
> -	mutex_lock(&pcf->lock);
> -	ret = __pcf50633_read(pcf, reg, nr_regs, data);
> -	mutex_unlock(&pcf->lock);
> -
> -	return ret;
> +	return regmap_raw_read(pcf->regmap, reg, data, nr_regs);
>  }
>  EXPORT_SYMBOL_GPL(pcf50633_read_block);
>  
> @@ -71,21 +42,22 @@ int pcf50633_write_block(struct pcf50633 *pcf , u8 reg,
>  {
>  	int ret;
>  
> -	mutex_lock(&pcf->lock);
> -	ret = __pcf50633_write(pcf, reg, nr_regs, data);
> -	mutex_unlock(&pcf->lock);
> +	ret = regmap_raw_write(pcf->regmap, reg, data, nr_regs);
> +	if (ret != 0)
> +		return ret;
>  
> -	return ret;
> +	return nr_regs;
>  }
>  EXPORT_SYMBOL_GPL(pcf50633_write_block);

We need to return the number of read regs in case of success for read_block
too. (Actually we only need this for read_block, but I guess it is nice to be
consistent here)

- Lars
