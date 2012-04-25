Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab2DYF2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 01:28:46 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15126 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2DYF2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 01:28:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 24 Apr 2012 22:28:44 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 25 Apr 2012 10:58:38 +0530
Subject: RE: [PATCH] mfd: tps65090: Return proper error if regmap_init_i2c
 fails
Thread-Topic: [PATCH] mfd: tps65090: Return proper error if regmap_init_i2c
 fails
Thread-Index: Ac0igws+cZXxKYnJSRezm+AzWCpDsQAIMHBQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD76B0EFB@BGMAIL02.nvidia.com>
References: <1335317436.24039.2.camel@phoenix>
In-Reply-To: <1335317436.24039.2.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3P5Sprn004104

Thanks for the patch.
Acked by: Venu Byravarasu<vbyravarasu@nvidia.com>

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Wednesday, April 25, 2012 7:01 AM
> To: linux-kernel@vger.kernel.org
> Cc: Samuel Ortiz; Venu Byravarasu
> Subject: [PATCH] mfd: tps65090: Return proper error if regmap_init_i2c fails
> 
> Return proper error instead of 0 if regmap_init_i2c fails.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/tps65090.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
> index 47f802b..da821d9 100644
> --- a/drivers/mfd/tps65090.c
> +++ b/drivers/mfd/tps65090.c
> @@ -286,10 +286,10 @@ static int __devinit tps65090_i2c_probe(struct
> i2c_client *client,
>  	tps65090->rmap = regmap_init_i2c(tps65090->client,
>  		&tps65090_regmap_config);
>  	if (IS_ERR(tps65090->rmap)) {
> -		dev_err(&client->dev, "regmap_init failed with err: %ld\n",
> -			PTR_ERR(tps65090->rmap));
> +		ret = PTR_ERR(tps65090->rmap);
> +		dev_err(&client->dev, "regmap_init failed with err: %d\n", ret);
>  		goto err_irq_exit;
> -	};
> +	}
> 
>  	ret = mfd_add_devices(tps65090->dev, -1, tps65090s,
>  		ARRAY_SIZE(tps65090s), NULL, 0);
> --
> 1.7.5.4
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
