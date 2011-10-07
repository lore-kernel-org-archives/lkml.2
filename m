Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954Ab1JGJXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:23:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59380 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759641Ab1JGJXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:23:44 -0400
Message-ID: <4E8EC517.2050006@linaro.org>
Date: Fri, 07 Oct 2011 17:23:35 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Icedove/3.1.13
MIME-Version: 1.0
To: ashish.jangam@kpitcummins.com
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
Subject: Re: [Patch 5/11] Regulator: DA9052 regulator support v3
References: <1309948610.4168.12.camel@L-0532.kpit.com>
In-Reply-To: <1309948610.4168.12.camel@L-0532.kpit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011年07月06日 18:36), ashishj3 wrote:
> +static int __devinit da9052_regulator_probe(struct platform_device *pdev)
> +{
> +	struct da9052_regulator *regulator;
> +	struct da9052 *da9052;
> +	struct da9052_pdata *pdata;
> +	int ret;
> +
> +	regulator = kzalloc(sizeof(struct da9052_regulator), GFP_KERNEL);
> +	if (!regulator)
> +		return -ENOMEM;
> +
> +	da9052 = dev_get_drvdata(pdev->dev.parent);
> +	pdata = da9052->dev->platform_data;
> +
> +	regulator->info = find_regulator_info(pdev->id);
> +	if (regulator->info == NULL) {
> +		dev_err(&pdev->dev, "invalid regulator ID specified\n");
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	regulator->rdev = regulator_register(&regulator->info->reg_desc,
> +					     &pdev->dev,
> +					     pdata->regulators[pdev->id],
> +					     regulator);
> +	if (IS_ERR(regulator->rdev)) {
> +		dev_err(&pdev->dev, "failed to register regulator %s\n",
> +			regulator->info->reg_desc.name);
> +		ret = PTR_ERR(regulator->rdev);
> +		goto err;
> +	}
> +
> +	platform_set_drvdata(pdev, regulator);
> +
> +	return 0;
> +err:
> +	kfree(regulator);
> +	return ret;
> +}

Hi Ashish,

It seems to me that in this function, regulator->da9052 isn't initialized.

Regards,
Paul
