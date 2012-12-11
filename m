Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2LKHQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:16:57 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45834 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2LKHQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:16:55 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-a1-50c6dde554df
Message-id: <50C6DDDC.7070208@samsung.com>
Date: Tue, 11 Dec 2012 08:16:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: lp3971: Convert to get_voltage_sel
References: <1355140012.6601.1.camel@phoenix>
In-reply-to: <1355140012.6601.1.camel@phoenix>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4Nd2nd48FGGxcr2JxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyNr+4w1hwRKqi/+A+tgbGp6JdjJwcEgImEldftTFD2GISF+6t
	Z+ti5OIQEljKKDFl3TEWCGcJk8TSSTvAqngFtCSuLD7GCmKzCKhKNJ9sZQSx2QQMJbredrGB
	2KICvhLTfl1jgqgXlPgx+R4LiC0ioCSx6v5lMJtZoEDizf037CC2sICbxNHWx2DzhQR0JXY0
	fgbr5RTQkzg4fz1UvZnEo5Z1zBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tTS4oTkrP
	NdQrTswtLs1L10vOz93ECAnBLzsYFx+zOsQowMGoxMOroXUsQIg1say4MvcQowQHs5IIb2ku
	UIg3JbGyKrUoP76oNCe1+BAjEwenVANj/OSJK6J5FBfEcHry8UTXTf7plf/IRiRV+pVBfMi1
	F+m3NVLu/U7ke5sn+X/FYyZhjVubmHf/M93PmzvB8UaHdqds8EGf4COz2Nk8mBxadewnLy1N
	3vqhdca6h2LPZ269Lv59Ra7eUxl369JjSmFTL0xvmN37WOfPK/14jklO7Ir3kkK5175TYinO
	SDTUYi4qTgQAZq8onx8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/10/2012 12:46 PM, Axel Lin wrote:
> regulator_list_voltage_table() returns -EINVAL if selector >= n_voltages.
> Thus we don't need to check if reg is greater than BUCK_TARGET_VOL_MAX_IDX in
> lp3971_dcdc_get_voltage_sel.
>
> BUCK_TARGET_VOL_MIN_IDX and BUCK_TARGET_VOL_MAX_IDX are not used, remove them.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/regulator/lp3971.c |   22 ++++++----------------
>   1 file changed, 6 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
> index 5f68ff1..9cb2c0f 100644
> --- a/drivers/regulator/lp3971.c
> +++ b/drivers/regulator/lp3971.c
> @@ -73,8 +73,6 @@ static const unsigned int buck_voltage_map[] = {
>   };
>
>   #define BUCK_TARGET_VOL_MASK 0x3f
> -#define BUCK_TARGET_VOL_MIN_IDX 0x01
> -#define BUCK_TARGET_VOL_MAX_IDX 0x19
>
>   #define LP3971_BUCK_RAMP_REG(x)	(buck_base_addr[x]+2)
>
> @@ -140,7 +138,7 @@ static int lp3971_ldo_disable(struct regulator_dev *dev)
>   	return lp3971_set_bits(lp3971, LP3971_LDO_ENABLE_REG, mask, 0);
>   }
>
> -static int lp3971_ldo_get_voltage(struct regulator_dev *dev)
> +static int lp3971_ldo_get_voltage_sel(struct regulator_dev *dev)
>   {
>   	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
>   	int ldo = rdev_get_id(dev) - LP3971_LDO1;
> @@ -149,7 +147,7 @@ static int lp3971_ldo_get_voltage(struct regulator_dev *dev)
>   	reg = lp3971_reg_read(lp3971, LP3971_LDO_VOL_CONTR_REG(ldo));
>   	val = (reg >> LDO_VOL_CONTR_SHIFT(ldo)) & LDO_VOL_CONTR_MASK;
>
> -	return dev->desc->volt_table[val];
> +	return val;
>   }
>
>   static int lp3971_ldo_set_voltage_sel(struct regulator_dev *dev,
> @@ -168,7 +166,7 @@ static struct regulator_ops lp3971_ldo_ops = {
>   	.is_enabled = lp3971_ldo_is_enabled,
>   	.enable = lp3971_ldo_enable,
>   	.disable = lp3971_ldo_disable,
> -	.get_voltage = lp3971_ldo_get_voltage,
> +	.get_voltage_sel = lp3971_ldo_get_voltage_sel,
>   	.set_voltage_sel = lp3971_ldo_set_voltage_sel,
>   };
>
> @@ -201,24 +199,16 @@ static int lp3971_dcdc_disable(struct regulator_dev *dev)
>   	return lp3971_set_bits(lp3971, LP3971_BUCK_VOL_ENABLE_REG, mask, 0);
>   }
>
> -static int lp3971_dcdc_get_voltage(struct regulator_dev *dev)
> +static int lp3971_dcdc_get_voltage_sel(struct regulator_dev *dev)
>   {
>   	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
>   	int buck = rdev_get_id(dev) - LP3971_DCDC1;
>   	u16 reg;
> -	int val;
>
>   	reg = lp3971_reg_read(lp3971, LP3971_BUCK_TARGET_VOL1_REG(buck));
>   	reg &= BUCK_TARGET_VOL_MASK;
>
> -	if (reg <= BUCK_TARGET_VOL_MAX_IDX)
> -		val = buck_voltage_map[reg];
> -	else {
> -		val = 0;
> -		dev_warn(&dev->dev, "chip reported incorrect voltage value.\n");
> -	}
> -
> -	return val;
> +	return reg;
>   }
>
>   static int lp3971_dcdc_set_voltage_sel(struct regulator_dev *dev,
> @@ -249,7 +239,7 @@ static struct regulator_ops lp3971_dcdc_ops = {
>   	.is_enabled = lp3971_dcdc_is_enabled,
>   	.enable = lp3971_dcdc_enable,
>   	.disable = lp3971_dcdc_disable,
> -	.get_voltage = lp3971_dcdc_get_voltage,
> +	.get_voltage_sel = lp3971_dcdc_get_voltage_sel,
>   	.set_voltage_sel = lp3971_dcdc_set_voltage_sel,
>   };
>
>


Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

