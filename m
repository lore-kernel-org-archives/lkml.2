Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2DYFUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 01:20:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14465 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2DYFUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 01:20:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 24 Apr 2012 22:20:48 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 25 Apr 2012 10:50:45 +0530
Subject: RE: [PATCH 3/5] mfd: tps65090: Convert to devm_regmap_init_i2c()
Thread-Topic: [PATCH 3/5] mfd: tps65090: Convert to devm_regmap_init_i2c()
Thread-Index: Ac0ih9Vu2d8y0s03QdWIIEenKuZi1wAGxtvQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD76B0EF0@BGMAIL02.nvidia.com>
References: <1335319315.30909.2.camel@phoenix>
 <1335319498.30909.6.camel@phoenix>
In-Reply-To: <1335319498.30909.6.camel@phoenix>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3P5LVbs004077

Thanks for the patch.
Acked by: Venu Byravarasu<vbyravarasu@nvidia.com>


> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Wednesday, April 25, 2012 7:35 AM
> To: linux-kernel@vger.kernel.org
> Cc: Samuel Ortiz; Venu Byravarasu
> Subject: [PATCH 3/5] mfd: tps65090: Convert to devm_regmap_init_i2c()
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/tps65090.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
> index da821d9..3e12bba 100644
> --- a/drivers/mfd/tps65090.c
> +++ b/drivers/mfd/tps65090.c
> @@ -283,8 +283,8 @@ static int __devinit tps65090_i2c_probe(struct
> i2c_client *client,
>  		}
>  	}
> 
> -	tps65090->rmap = regmap_init_i2c(tps65090->client,
> -		&tps65090_regmap_config);
> +	tps65090->rmap = devm_regmap_init_i2c(tps65090->client,
> +					      &tps65090_regmap_config);
>  	if (IS_ERR(tps65090->rmap)) {
>  		ret = PTR_ERR(tps65090->rmap);
>  		dev_err(&client->dev, "regmap_init failed with err: %d\n", ret);
> @@ -296,14 +296,11 @@ static int __devinit tps65090_i2c_probe(struct
> i2c_client *client,
>  	if (ret) {
>  		dev_err(&client->dev, "add mfd devices failed with err: %d\n",
>  			ret);
> -		goto err_regmap_exit;
> +		goto err_irq_exit;
>  	}
> 
>  	return 0;
> 
> -err_regmap_exit:
> -	regmap_exit(tps65090->rmap);
> -
>  err_irq_exit:
>  	if (client->irq)
>  		free_irq(client->irq, tps65090);
> @@ -316,7 +313,6 @@ static int __devexit tps65090_i2c_remove(struct
> i2c_client *client)
>  	struct tps65090 *tps65090 = i2c_get_clientdata(client);
> 
>  	mfd_remove_devices(tps65090->dev);
> -	regmap_exit(tps65090->rmap);
>  	if (client->irq)
>  		free_irq(client->irq, tps65090);
> 
> --
> 1.7.5.4
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
