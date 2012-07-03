Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab2GCHqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:46:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59046 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab2GCHqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:46:01 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH v2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
Thread-Topic: [PATCH v2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
Thread-Index: AQHNWOw3Ezi6miyYEUWUzbZ3Rn+VZ5cXLYnQ
Date: Tue, 3 Jul 2012 07:45:52 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9E8E74@DBDE01.ent.ti.com>
References: <1341299973.4669.4.camel@phoenix>
In-Reply-To: <1341299973.4669.4.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q637k7Sr014362

Hi Axel,

Thanks for the patch

Acked-by: AnilKumar Ch <anilkumar@ti.com>

On Tue, Jul 03, 2012 at 12:49:33, Axel Lin wrote:
> It is ok to request voltage with min_uV < tps->info[rid]->min_uV and
> max_uV > tps->info[rid]->max_uV.
> 
> The equation we used in uv_to_vsel() does not allow
> min_uV < tps->info[rid]->min_uV, otherwise it returns negative selector.
> So we need to set min_uV = tps->info[rid]->min_uV if
> min_uV < tps->info[rid]->min_uV.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/tps65217-regulator.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
> index 0a3df5b..f7d0495 100644
> --- a/drivers/regulator/tps65217-regulator.c
> +++ b/drivers/regulator/tps65217-regulator.c
> @@ -206,10 +206,10 @@ static int tps65217_pmic_map_voltage(struct regulator_dev *dev,
>  	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
>  		return -EINVAL;
>  
> -	if (min_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
> -		return -EINVAL;
> +	if (min_uV < tps->info[rid]->min_uV)
> +		min_uV = tps->info[rid]->min_uV;
>  
> -	if (max_uV < tps->info[rid]->min_uV || max_uV > tps->info[rid]->max_uV)
> +	if (max_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
>  		return -EINVAL;
>  
>  	ret = tps->info[rid]->uv_to_vsel(min_uV, &sel);
> -- 
> 1.7.9.5
> 
> 
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
