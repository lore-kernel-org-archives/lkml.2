Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2JHFkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:40:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9867 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2JHFkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:40:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 07 Oct 2012 22:40:45 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Laxman Dewangan <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Oct 2012 11:10:40 +0530
Subject: RE: [PATCH 3/5] mfd: tps65090: remove unused member of struct
 tps65090
Thread-Topic: [PATCH 3/5] mfd: tps65090: remove unused member of struct
 tps65090
Thread-Index: Ac2kpD0s0jECywPVRs+77YM0eKrXcAAcso8w
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF8AF38A@BGMAIL02.nvidia.com>
References: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
 <1349623340-21807-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1349623340-21807-4-git-send-email-ldewangan@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Laxman Dewangan
> Sent: Sunday, October 07, 2012 8:52 PM
> To: sameo@linux.intel.com
> Cc: linux-kernel@vger.kernel.org; Venu Byravarasu; Laxman Dewangan
> Subject: [PATCH 3/5] mfd: tps65090: remove unused member of struct
> tps65090
> 
> Remove unused member from tps65090 data structure as

Remove unused members 

> these are not used.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/mfd/tps65090.c       |    6 +-----
>  include/linux/mfd/tps65090.h |   11 -----------
>  2 files changed, 1 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
> index f95f7f6..3cfc9dc 100644
> --- a/drivers/mfd/tps65090.c
> +++ b/drivers/mfd/tps65090.c
> @@ -269,12 +269,9 @@ static int __devinit tps65090_i2c_probe(struct
> i2c_client *client,
>  		return -ENOMEM;
>  	}
> 
> -	tps65090->client = client;
>  	tps65090->dev = &client->dev;
>  	i2c_set_clientdata(client, tps65090);
> 
> -	mutex_init(&tps65090->lock);
> -
>  	if (client->irq) {
>  		ret = tps65090_irq_init(tps65090, client->irq, pdata-
> >irq_base);
>  		if (ret) {
> @@ -284,8 +281,7 @@ static int __devinit tps65090_i2c_probe(struct
> i2c_client *client,
>  		}
>  	}
> 
> -	tps65090->rmap = devm_regmap_init_i2c(tps65090->client,
> -					      &tps65090_regmap_config);
> +	tps65090->rmap = devm_regmap_init_i2c(client,
> &tps65090_regmap_config);

Indentation missing.
 

>  	if (IS_ERR(tps65090->rmap)) {
>  		ret = PTR_ERR(tps65090->rmap);
>  		dev_err(&client->dev, "regmap_init failed with err: %d\n",
> ret);
> diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
> index 6bc31d8..6c57622 100644
> --- a/include/linux/mfd/tps65090.h
> +++ b/include/linux/mfd/tps65090.h
> @@ -25,26 +25,15 @@
>  #include <linux/irq.h>
> 
>  struct tps65090 {
> -	struct mutex		lock;
>  	struct device		*dev;
> -	struct i2c_client	*client;
>  	struct regmap		*rmap;
>  	struct irq_chip		irq_chip;
>  	struct mutex		irq_lock;
>  	int			irq_base;
> -	unsigned int		id;
> -};
> -
> -struct tps65090_subdev_info {
> -	int		id;
> -	const char	*name;
> -	void		*platform_data;
>  };
> 
>  struct tps65090_platform_data {
>  	int irq_base;
> -	int num_subdevs;
> -	struct tps65090_subdev_info *subdevs;
>  };
> 
>  /*
> --
> 1.7.1.1

