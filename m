Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2EYM1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:27:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37555 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2EYM1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:27:35 -0400
MIME-Version: 1.0
In-Reply-To: <1337919230-8296-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1337919230-8296-1-git-send-email-jonghwa3.lee@samsung.com>
Date: Fri, 25 May 2012 17:57:35 +0530
Message-ID: <CAKew6eXsf5UKe4t5m3MAuU1OUSZcUPBoSRUCjyR-gKRmDC8MOw@mail.gmail.com>
Subject: Re: [PATCH v4] regulator: MAX77686: Add Maxim 77686 regulator driver
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwa,

> +
> +       if (pdata)
> +               max77686->opmode_data = pdata->opmode_data;

I think this is unused(unwanted) now.

> +
> +       for (i = 0; i < MAX77686_REGULATORS; i++) {
> +               if (pdata)
> +                       init_data[pdata->regulators[i].id] =
> +                                                pdata->regulators[i].initdata;

I  think we can directly use  pdata->regulators[i].initdata instead of
init_data[i].
In case if pdata is not their we can use same instance of
init_data(default)  for all regulators.

> +
> +               config.init_data = init_data[i];
> +               rdev[i] = regulator_register(&regulators[i], &config);
> +

> +
> +       for (i = 0; i < 8; i++) {
> +               if (pdata->buck2_voltage[i] > 0)
> +                       ret = regulator_map_voltage_linear(
> +                                       rdev[MAX77686_LDOS+1],
> +                                       pdata->buck2_voltage[i],
> +                                       pdata->buck2_voltage[i]
> +                                       + MAX77686_DVS_UVSTEP);
> +               /* 1.1V as default for safety */
> +               if (pdata->buck2_voltage[i] <= 0 || ret < 0)
> +                       max77686->buck2_vol[i] = 0x28;
> +               else
> +                       max77686->buck2_vol[i] = ret;
> +               regmap_write(max77686->iodev->regmap,
> +                        MAX77686_REG_BUCK2DVS1 + i, max77686->buck2_vol[i]);
> +
> +               if (pdata->buck3_voltage[i] > 0)
> +                       ret = regulator_map_voltage_linear(
> +                                       rdev[MAX77686_LDOS+1],
> +                                       pdata->buck3_voltage[i],
> +                                       pdata->buck3_voltage[i]
> +                                       + MAX77686_DVS_UVSTEP);
> +               /* 1.1V as default for safety */
> +               if (pdata->buck3_voltage[i] <= 0 || ret < 0)
> +                       max77686->buck3_vol[i] = 0x28;
> +               else
> +                       max77686->buck3_vol[i] = ret;
> +               regmap_write(max77686->iodev->regmap,
> +                        MAX77686_REG_BUCK3DVS1 + i, max77686->buck3_vol[i]);
> +
> +               if (pdata->buck4_voltage[i] > 0)
> +                       ret = regulator_map_voltage_linear(
> +                                       rdev[MAX77686_LDOS+1],
> +                                       pdata->buck4_voltage[i],
> +                                       pdata->buck4_voltage[i]
> +                                       + MAX77686_DVS_UVSTEP);
> +               /* 1.1V as default for safety */
> +               if (pdata->buck4_voltage[i] <= 0 || ret < 0)
> +                       max77686->buck4_vol[i] = 0x28;
> +               else
> +                       max77686->buck4_vol[i] = ret;
> +               regmap_write(max77686->iodev->regmap,
> +                        MAX77686_REG_BUCK4DVS1 + i, max77686->buck4_vol[i]);
> +       }

Why do we need to initialize the 8 voltage registers of BUCK2/3/4  ?


Regards,
Yadwinder.
