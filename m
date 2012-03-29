Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab2C2Whr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:37:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63269 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760155Ab2C2Whm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:37:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6664"; a="177137864"
Message-ID: <4F74E435.9030101@codeaurora.org>
Date: Thu, 29 Mar 2012 15:37:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: MyungJoo Ham <myungjoo.ham@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, NeilBrown <neilb@suse.de>,
        gregkh@linuxfoundation.org, Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@gmail.com,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldmFn?= <arve@android.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mike Lockwood <lockwood@android.com>
Subject: Re: [PATCH v6 2/5] Extcon: support generic GPIO extcon driver
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com> <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com> <1330344939-18394-3-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1330344939-18394-3-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/12 04:15, MyungJoo Ham wrote
> +static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
> +{
> +	struct gpio_extcon_data *extcon_data =
> +	    (struct gpio_extcon_data *)dev_id;

Casting from void is unnecessary.

> +
> +static int gpio_extcon_probe(struct platform_device *pdev)

__devinit?

> +{
> +	struct gpio_extcon_platform_data *pdata = pdev->dev.platform_data;
> +	struct gpio_extcon_data *extcon_data;
> +	int ret = 0;
[snip]
> +	return ret;
> +}
> +
> +static int gpio_extcon_remove(struct platform_device *pdev)

__devexit?
> +{
> +	struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
[snip]
> +static struct platform_driver gpio_extcon = {
> +	.probe		= gpio_extcon_probe,
> +	.remove		= gpio_extcon_remove,

__devexit_p()?
> +	.driver		= {
> +		.name	= "extcon-gpio",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(gpio_extcon);
> +
> +MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
> +MODULE_DESCRIPTION("GPIO extcon driver");
> +MODULE_LICENSE("GPL");
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

