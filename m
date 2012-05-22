Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab2EVGxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:53:14 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65182 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2EVGxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:53:12 -0400
MIME-Version: 1.0
In-Reply-To: <4fbb2ac4.63de440a.589d.78cc@mx.google.com>
References: <4fbb2ac4.63de440a.589d.78cc@mx.google.com>
Date: Tue, 22 May 2012 15:53:11 +0900
X-Google-Sender-Auth: _R85LbcUjmfSjqaGmCu2QWgV_uU
Message-ID: <CAH9JG2Xq-4J9Vn6d6cxcMNsZ5Y2LLJG9vrVQWEyPHhNd08ek9g@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] regulator: Add initial suport for max77686
From: Kyungmin Park <kmpark@infradead.org>
To: yadi.brar01@gmail.com, "jonghwa3.lee" <jonghwa3.lee@samsung.com>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

BTW, do you know that you're reviewing the same device driver patch
from different person?
One from Mr. Lee and another from Yadwinder.

I wonder how to handle it finally. which one is choose?

Thank you,
Kyungmin Park

On 5/22/12, yadi.brar01@gmail.com <yadi.brar01@gmail.com> wrote:
> From: Yadwinder Singh Brar <yadi.brar@samsung.com>
>
> This patch series adds support for max77686 which is a multifunction device
> which includes regulator (pmic), rtc and charger sub-blocks within it. The
> support for mfd driver and regulator driver are added by this patch series.
> This
> patch series also includes device tree and irqdomain support for mfd and
> regulator portions.
>
> Implemented the required modification, stated in the recieved review
> comments.
> changes since v1:
> -added regmap support.
> -implemented .get_voltage_sel, .set_voltage_sel and .set_voltage_time_sel
> after
>  removing .get_voltage and .set_voltage in regulator driver.
> -used of_regulator_match() for parsing DT.
> -added Documentation for Devive Tree binding.
>
> changes since v2:
> -converted to use regulator_get_voltage_sel_regmap,
>  regulator_set_voltage_sel_regmap, regulator_enable_regmap,
>  regulator_disable_regmap, regulator_is_enabled_regmap.
>
> This patch series is based on mark_regulator/for-next and has been tested
> on
> GAIA board.
>
> Yadwinder Singh Brar (2):
>   mfd: Add support for MAX77686.
>   regulator: Add support for MAX77686.
>
>  Documentation/devicetree/bindings/mfd/max77686.txt |   61 +++
>  drivers/mfd/Kconfig                                |   21 +
>  drivers/mfd/Makefile                               |    1 +
>  drivers/mfd/max77686-irq.c                         |  255 +++++++++++++
>  drivers/mfd/max77686.c                             |  322 ++++++++++++++++
>  drivers/regulator/Kconfig                          |    9 +
>  drivers/regulator/Makefile                         |    1 +
>  drivers/regulator/max77686.c                       |  389
> ++++++++++++++++++++
>  include/linux/mfd/max77686-private.h               |  282 ++++++++++++++
>  include/linux/mfd/max77686.h                       |  100 +++++
>  10 files changed, 1441 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max77686.txt
>  create mode 100644 drivers/mfd/max77686-irq.c
>  create mode 100644 drivers/mfd/max77686.c
>  create mode 100644 drivers/regulator/max77686.c
>  create mode 100644 include/linux/mfd/max77686-private.h
>  create mode 100644 include/linux/mfd/max77686.h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
