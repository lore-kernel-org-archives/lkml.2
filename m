Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2BXDX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:23:59 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:17595 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2BXDX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:23:58 -0500
X-SpamScore: -1
X-BigFish: VS-1(z4256lz1432N98dKa706lzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 24 Feb 2012 11:31:07 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] pinctrl: Re-order struct pinctrl_map
Message-ID: <20120224033106.GB25789@shlinux2.ap.freescale.net>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
 <1330041880-12406-2-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1330041880-12406-2-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 05:04:39PM -0700, Stephen Warren wrote:
> The lookup key in struct pinctrl_map is (.dev_name, .name). Re-order the
> struct definition to put the lookup key fields first, and the result
> values afterwards. To me at least, this slightly better reflects the
> lookup process.
> 

Not only better reflects the llokup process, i think the map name meaning
is a litlle different as before since it represents states now rather than
a map name, right?
And a map entry becomes a specific device's map entry, here the device
becomes the main entity, so it's reasonable to me to put it in the first.

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

> Update the documentation in a similar fashion.
> 
> Note: PIN_MAP*() macros aren't updated; I plan to update this once later
> when enhancing the mapping table format to support pin config to reduce
> churn.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  Documentation/pinctrl.txt       |   24 ++++++++++++------------
>  include/linux/pinctrl/machine.h |   10 +++++-----
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index 8bf46bc..6fe3232 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -781,19 +781,19 @@ spi on the second function mapping:
>  
>  static const struct pinctrl_map __initdata mapping[] = {
>  	{
> +		.dev_name = "foo-spi.0",
>  		.ctrl_dev_name = "pinctrl-foo",
>  		.function = "spi0",
> -		.dev_name = "foo-spi.0",
>  	},
>  	{
> +		.dev_name = "foo-i2c.0",
>  		.ctrl_dev_name = "pinctrl-foo",
>  		.function = "i2c0",
> -		.dev_name = "foo-i2c.0",
>  	},
>  	{
> +		.dev_name = "foo-mmc.0",
>  		.ctrl_dev_name = "pinctrl-foo",
>  		.function = "mmc0",
> -		.dev_name = "foo-mmc.0",
>  	},
>  };
>  
> @@ -826,18 +826,18 @@ As it is possible to map a function to different groups of pins an optional
>  
>  ...
>  {
> +	.dev_name = "foo-spi.0",
>  	.name = "spi0-pos-A",
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "spi0",
>  	.group = "spi0_0_grp",
> -	.dev_name = "foo-spi.0",
>  },
>  {
> +	.dev_name = "foo-spi.0",
>  	.name = "spi0-pos-B",
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "spi0",
>  	.group = "spi0_1_grp",
> -	.dev_name = "foo-spi.0",
>  },
>  ...
>  
> @@ -852,45 +852,45 @@ case), we define a mapping like this:
>  
>  ...
>  {
> +	.dev_name = "foo-mmc.0",
>  	.name = "2bit"
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "mmc0",
>  	.group = "mmc0_1_grp",
> -	.dev_name = "foo-mmc.0",
>  },
>  {
> +	.dev_name = "foo-mmc.0",
>  	.name = "4bit"
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "mmc0",
>  	.group = "mmc0_1_grp",
> -	.dev_name = "foo-mmc.0",
>  },
>  {
> +	.dev_name = "foo-mmc.0",
>  	.name = "4bit"
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "mmc0",
>  	.group = "mmc0_2_grp",
> -	.dev_name = "foo-mmc.0",
>  },
>  {
> +	.dev_name = "foo-mmc.0",
>  	.name = "8bit"
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.group = "mmc0_1_grp",
> -	.dev_name = "foo-mmc.0",
>  },
>  {
> +	.dev_name = "foo-mmc.0",
>  	.name = "8bit"
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "mmc0",
>  	.group = "mmc0_2_grp",
> -	.dev_name = "foo-mmc.0",
>  },
>  {
> +	.dev_name = "foo-mmc.0",
>  	.name = "8bit"
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "mmc0",
>  	.group = "mmc0_3_grp",
> -	.dev_name = "foo-mmc.0",
>  },
>  ...
>  
> @@ -988,10 +988,10 @@ This is enabled by simply setting the .dev_name field in the map to the name
>  of the pin controller itself, like this:
>  
>  {
> +	.dev_name = "pinctrl-foo",
>  	.name = PINCTRL_STATE_DEFAULT,
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "power_func",
> -	.dev_name = "pinctrl-foo",
>  },
>  
>  Since it may be common to request the core to hog a few always-applicable
> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> index 4743f84..20e9735 100644
> --- a/include/linux/pinctrl/machine.h
> +++ b/include/linux/pinctrl/machine.h
> @@ -16,6 +16,10 @@
>  
>  /**
>   * struct pinctrl_map - boards/machines shall provide this map for devices
> + * @dev_name: the name of the device using this specific mapping, the name
> + *	must be the same as in your struct device*. If this name is set to the
> + *	same name as the pin controllers own dev_name(), the map entry will be
> + *	hogged by the driver itself upon registration
>   * @name: the name of this specific map entry for the particular machine.
>   *	This is the second parameter passed to pinmux_get() when you want
>   *	to have several mappings to the same device
> @@ -27,17 +31,13 @@
>   * @group: sometimes a function can map to different pin groups, so this
>   *	selects a certain specific pin group to activate for the function, if
>   *	left as NULL, the first applicable group will be used
> - * @dev_name: the name of the device using this specific mapping, the name
> - *	must be the same as in your struct device*. If this name is set to the
> - *	same name as the pin controllers own dev_name(), the map entry will be
> - *	hogged by the driver itself upon registration
>   */
>  struct pinctrl_map {
> +	const char *dev_name;
>  	const char *name;
>  	const char *ctrl_dev_name;
>  	const char *function;
>  	const char *group;
> -	const char *dev_name;
>  };
>  
>  /*
> -- 
> 1.7.0.4
> 
> 

