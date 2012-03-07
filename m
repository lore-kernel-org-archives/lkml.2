Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236Ab2CGWkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:40:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34264 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964875Ab2CGWkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:40:22 -0500
Message-ID: <4F57E3D2.40405@wwwdotorg.org>
Date: Wed, 07 Mar 2012 15:40:18 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/4] pinctrl: support pinconfig on the U300
References: <1331071533-24789-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1331071533-24789-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 03:05 PM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This adds pin configuration support for the U300 driver pair,
> we can now read out the biasing and drive mode in debugfs and
> configure it using the new configuration API.

> +int u300_pin_config_set(struct pinctrl_dev *pctldev,
> +			unsigned pin,
> +			unsigned long config)
> +{
> +	struct pinctrl_gpio_range *range = u300_match_gpio_range(pin);
> +	int ret;
> +
> +	if (!range)
> +		return -EINVAL;
> +
> +	/* Note: none of these configurations take any argument */
> +	ret = u300_gpio_config_set(range->gc,
> +				   (pin - range->pin_base + range->base),
> +				   to_config_param(config));

I'm a little confused here; the documentation for most of the
PIN_CONFIG_* parameters that this function is passed does explicitly
document that there is an associated argument value. For example,
IN_CONFIG_BIAS_PULL_UP is coupled with the pull up resistance in Ohms.
Shouldn't this code extract the argument and validate that it's a
supported value for the HW?
