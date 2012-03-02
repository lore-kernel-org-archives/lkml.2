Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab2CBFOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:14:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16960 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2CBFOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:14:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Mar 2012 21:14:14 -0800
Message-ID: <4F505723.9000103@nvidia.com>
Date: Fri, 2 Mar 2012 14:14:11 +0900
From: Jin Park <jinyoungp@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: Add a pointer to aat2870_data in struct aat2870_regulator
References: <1330651724.6247.3.camel@phoenix>
In-Reply-To: <1330651724.6247.3.camel@phoenix>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jin Park <jinyoungp@nvidia.com>

On 2012-03-02 오전 10:28, Axel Lin wrote:
> The reason we add *pdev in struct aat2870_regulator is to use it
> to get a pointer to struct aat2870_data.
> Save a pointer to struct aat2870_data instead of pdev in struct
> aat2870_regulator, this change makes the intention more clear.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/regulator/aat2870-regulator.c |   14 +++++++-------
>   1 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
> index 685ad43..9ed5c5d 100644
> --- a/drivers/regulator/aat2870-regulator.c
> +++ b/drivers/regulator/aat2870-regulator.c
> @@ -31,7 +31,7 @@
>   #include<linux/mfd/aat2870.h>
>
>   struct aat2870_regulator {
> -	struct platform_device *pdev;
> +	struct aat2870_data *aat2870;
>   	struct regulator_desc desc;
>
>   	const int *voltages; /* uV */
> @@ -60,7 +60,7 @@ static int aat2870_ldo_set_voltage_sel(struct regulator_dev *rdev,
>   				       unsigned selector)
>   {
>   	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
> -	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
> +	struct aat2870_data *aat2870 = ri->aat2870;
>
>   	return aat2870->update(aat2870, ri->voltage_addr, ri->voltage_mask,
>   			       selector<<  ri->voltage_shift);
> @@ -69,7 +69,7 @@ static int aat2870_ldo_set_voltage_sel(struct regulator_dev *rdev,
>   static int aat2870_ldo_get_voltage_sel(struct regulator_dev *rdev)
>   {
>   	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
> -	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
> +	struct aat2870_data *aat2870 = ri->aat2870;
>   	u8 val;
>   	int ret;
>
> @@ -83,7 +83,7 @@ static int aat2870_ldo_get_voltage_sel(struct regulator_dev *rdev)
>   static int aat2870_ldo_enable(struct regulator_dev *rdev)
>   {
>   	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
> -	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
> +	struct aat2870_data *aat2870 = ri->aat2870;
>
>   	return aat2870->update(aat2870, ri->enable_addr, ri->enable_mask,
>   			       ri->enable_mask);
> @@ -92,7 +92,7 @@ static int aat2870_ldo_enable(struct regulator_dev *rdev)
>   static int aat2870_ldo_disable(struct regulator_dev *rdev)
>   {
>   	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
> -	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
> +	struct aat2870_data *aat2870 = ri->aat2870;
>
>   	return aat2870->update(aat2870, ri->enable_addr, ri->enable_mask, 0);
>   }
> @@ -100,7 +100,7 @@ static int aat2870_ldo_disable(struct regulator_dev *rdev)
>   static int aat2870_ldo_is_enabled(struct regulator_dev *rdev)
>   {
>   	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
> -	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
> +	struct aat2870_data *aat2870 = ri->aat2870;
>   	u8 val;
>   	int ret;
>
> @@ -185,7 +185,7 @@ static int aat2870_regulator_probe(struct platform_device *pdev)
>   		dev_err(&pdev->dev, "Invalid device ID, %d\n", pdev->id);
>   		return -EINVAL;
>   	}
> -	ri->pdev = pdev;
> +	ri->aat2870 = dev_get_drvdata(pdev->dev.parent);
>
>   	rdev = regulator_register(&ri->desc,&pdev->dev,
>   				  pdev->dev.platform_data, ri, NULL);
