Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1AFNpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:45:09 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:53743 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547Ab1AFNpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:45:08 -0500
Subject: Re: [patch] mtd: pxa3xx_nand: NULL dereference in pxa3xx_nand_probe
From: Sven Neumann <s.neumann@raumfeld.com>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, Daniel Mack <daniel@caiaq.de>,
        leiwen@marvell.com, haojian.zhuang@marvell.com,
        David.Woodhouse@intel.com, eric.y.miao@gmail.com,
        Artem.Bityutskiy@nokia.com
In-Reply-To: <20110106124525.GA1717@bicker>
References: <1294227801.3996.62.camel@sven>  <20110106124525.GA1717@bicker>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Thu, 06 Jan 2011 14:45:01 +0100
Message-ID: <1294321502.2218.5.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1294321508;57c44bd7;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, 2011-01-06 at 15:45 +0300, Dan Carpenter wrote:

> Could you test this patch?  I don't have an arm so I can't compile this.

Yes, this change fixes the boot problem for me. Thanks for the quick
help.

> This was introduced in 18c81b1828f8 "mtd: pxa3xx_nand: remove the flash
> info in driver structure"
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Tested-by: Sven Neumann <s.neumann@raumfeld.com>

> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index 17f8518..ea2c288 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -885,6 +885,7 @@ static int pxa3xx_nand_detect_config(struct pxa3xx_nand_info *info)
>  	/* set info fields needed to __readid */
>  	info->read_id_bytes = (info->page_size == 2048) ? 4 : 2;
>  	info->reg_ndcr = ndcr;
> +	info->cmdset = &default_cmdset;
>  
>  	if (__readid(info, &id))
>  		return -ENODEV;
> @@ -915,7 +916,6 @@ static int pxa3xx_nand_detect_config(struct pxa3xx_nand_info *info)
>  
>  	info->ndtr0cs0 = nand_readl(info, NDTR0CS0);
>  	info->ndtr1cs0 = nand_readl(info, NDTR1CS0);
> -	info->cmdset = &default_cmdset;
>  
>  	return 0;
>  }
> 


