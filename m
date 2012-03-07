Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030862Ab2CGWnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:43:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41791 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965219Ab2CGWm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:42:58 -0500
Message-ID: <4F57E46F.6050505@wwwdotorg.org>
Date: Wed, 07 Mar 2012 15:42:55 -0700
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
Subject: Re: [PATCH 4/4] ARM: u300: configure some pins as an example
References: <1331071547-25109-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1331071547-25109-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 03:05 PM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> To show how the pin configuration is used on the U300, let's
> include some configs for two GPIO pins.

> -/* Pinmux settings */
> +static unsigned long g0d_conf[] = {
> +	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 0),
> +};
> +
> +static unsigned long g1d_conf[] = {
> +	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 0),
> +};
> +
> +static unsigned long g0i_conf[] = {
> +	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 0),
> +};
> +
> +static unsigned long g1i_conf[] = {
> +	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 0),
> +};

Those are all the same, so you could just point all the mapping tables
at the same config param array.

> +
> +/* Pin control settings */
>  static struct pinctrl_map __initdata u300_pinmux_map[] = {
>  	/* anonymous maps for chip power and EMIFs */
>  	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "power"),
> @@ -1615,6 +1632,11 @@ static struct pinctrl_map __initdata u300_pinmux_map[] = {
>  	PIN_MAP_MUX_GROUP_DEFAULT("mmci",  "pinctrl-u300", NULL, "mmc0"),
>  	PIN_MAP_MUX_GROUP_DEFAULT("pl022", "pinctrl-u300", NULL, "spi0"),
>  	PIN_MAP_MUX_GROUP_DEFAULT("uart0", "pinctrl-u300", NULL, "uart0"),
> +	/* some pin configurations */
> +	PIN_MAP_CONFIGS_PIN_DEFAULT("mmci", "pinctrl-u300", "GPIO0", g0d_conf),
> +	PIN_MAP_CONFIGS_PIN_DEFAULT("mmci", "pinctrl-u300", "GPIO1", g1d_conf),
> +	PIN_MAP_CONFIGS_PIN("mmci", "idle", "pinctrl-u300", "GPIO0", g0i_conf),
> +	PIN_MAP_CONFIGS_PIN("mmci", "idle", "pinctrl-u300", "GPIO1", g1i_conf),
>  };

I'd assume though that the default and idle state should have different
pin configurations?

(and if this was stacked on top of your other patch, you could use
PINCTRL_STATE_IDLE instead of "idle" for the last two entries)
