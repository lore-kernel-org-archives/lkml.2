Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab2HIHKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:10:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45034 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2HIHKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:10:12 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/7] regulator: lp872x: set_current_limit should select
 the maximum current in specific range
Thread-Topic: [PATCH 6/7] regulator: lp872x: set_current_limit should select
 the maximum current in specific range
Thread-Index: AQHNdWCDOuenCkTYt02jtiHG2XJikJdRDuvg
Date: Thu, 9 Aug 2012 07:10:00 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EEBC28@DBDE02.ent.ti.com>
References: <1344428238.3199.1.camel@phoenix>
 <1344428555.3199.6.camel@phoenix>
In-Reply-To: <1344428555.3199.6.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q797AJke025459

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Wednesday, August 08, 2012 9:23 PM
> To: Mark Brown
> Cc: Kim, Milo; Girdwood, Liam; linux-kernel@vger.kernel.org
> Subject: [PATCH 6/7] regulator: lp872x: set_current_limit should select
> the maximum current in specific range
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/lp872x.c |   18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
> index 212c38e..6199d0f 100644
> --- a/drivers/regulator/lp872x.c
> +++ b/drivers/regulator/lp872x.c
> @@ -374,8 +374,8 @@ static int lp8725_buck_set_current_limit(struct
> regulator_dev *rdev,
>  {
>  	struct lp872x *lp = rdev_get_drvdata(rdev);
>  	enum lp872x_regulator_id buck = rdev_get_id(rdev);
> -	int i, max = ARRAY_SIZE(lp8725_buck_uA);
> -	u8 addr, val;
> +	int i;
> +	u8 addr;
> 
>  	switch (buck) {
>  	case LP8725_ID_BUCK1:
> @@ -388,17 +388,15 @@ static int lp8725_buck_set_current_limit(struct
> regulator_dev *rdev,
>  		return -EINVAL;
>  	}
> 
> -	for (i = 0 ; i < max ; i++)
> +	for (i = ARRAY_SIZE(lp8725_buck_uA) - 1 ; i >= 0; i--) {
>  		if (lp8725_buck_uA[i] >= min_uA &&
>  			lp8725_buck_uA[i] <= max_uA)
> -			break;
> -
> -	if (i == max)
> -		return -EINVAL;
> -
> -	val = i << LP8725_BUCK_CL_S;
> +			return lp872x_update_bits(lp, addr,
> +						  LP8725_BUCK_CL_M,
> +						  i << LP8725_BUCK_CL_S);
> +	}
> 
> -	return lp872x_update_bits(lp, addr, LP8725_BUCK_CL_M, val);
> +	return -EINVAL;
>  }
> 
>  static int lp8725_buck_get_current_limit(struct regulator_dev *rdev)
> --
> 1.7.9.5
> 
> 

It looks a semantic patch rather than operation issue.
Could you let me know why we need this patch in more details ?
Thank you, all the time !

Best Regards,
Milo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
