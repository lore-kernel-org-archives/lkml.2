Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab1LLK47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:56:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35659 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1LLK44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:56:56 -0500
Date: Mon, 12 Dec 2011 11:56:50 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
Message-ID: <20111212105650.GA5798@glitch>
Mail-Followup-To: Linus Walleij <linus.walleij@stericsson.com>,
	linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Dong Aisheng <dong.aisheng@linaro.org>,
	Rajendra Nayak <rajendra.nayak@linaro.org>,
	Haojian Zhuang <haojian.zhuang@marvell.com>,
	Linus Walleij <linus.walleij@linaro.org>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 09, 2011 at 12:57:37PM +0100, Linus Walleij wrote:
> 
> This add per-pin and per-group pin config interfaces for biasing,
> driving and other such electronic properties. The details of passed
> configurations are passed in an opaque unsigned long which may be
> dereferences to integer types, structs or lists on either side
> of the configuration interface.

[...]

> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
> index f17fac4..4ad5043 100644
> --- a/include/linux/pinctrl/pinctrl.h
> +++ b/include/linux/pinctrl/pinctrl.h
> @@ -21,6 +21,7 @@
>  
>  struct pinctrl_dev;
>  struct pinmux_ops;
> +struct pinconf_ops;
>  struct gpio_chip;
>  
>  /**
> @@ -97,7 +98,9 @@ struct pinctrl_ops {
>   *	but may be equal to npins if you have no holes in the pin range.
>   * @pctlops: pin control operation vtable, to support global concepts like
>   *	grouping of pins, this is optional.
> - * @pmxops: pinmux operation vtable, if you support pinmuxing in your driver
> + * @pmxops: pinmux operations vtable, if you support pinmuxing in your driver
> + * @confops: pin config operations vtable, if you support pin configuration in
> + *	your driver
>   * @owner: module providing the pin controller, used for refcounting
>   */
>  struct pinctrl_desc {
> @@ -107,6 +110,7 @@ struct pinctrl_desc {
>  	unsigned int maxpin;
>  	struct pinctrl_ops *pctlops;
>  	struct pinmux_ops *pmxops;
> +	struct pinconf_ops *confops;
>  	struct module *owner;
>  };
>  
> @@ -123,9 +127,7 @@ extern const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev);
>  extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
>  #else
>  
> -struct pinctrl_dev;

this introduces a warning in case CONFIG_PINCTRL is not enabled.

> -
> -/* Sufficiently stupid default function when pinctrl is not in use */
> +/* Sufficiently stupid default functions when pinctrl is not in use */
>  static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
>  {
>  	return pin >= 0;

cheers,
Domenico
