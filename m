Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3ABU3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:29:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59500 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3ABU3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:29:53 -0500
Message-ID: <50E498BD.7070104@wwwdotorg.org>
Date: Wed, 02 Jan 2013 13:29:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] pinctrl/nomadik: add device tree support
References: <1355992535-5383-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1355992535-5383-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 01:35 AM, Linus Walleij wrote:
> From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> 
> This implements pin multiplexing and pin configuration for
> the Nomadik pin controller using the device tree.

> diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt

> +Required properties:
> +- compatible: "stericsson,nmk_pinctrl"

- rather than _ is more typically used, but not a big deal.

> +mux function to select on those pin(s)/group(s), and various pin configuration
> +parameters, such as inputn output, pull up, pull down...

s/n/,/ ?

> +Example board file extract:
> +
> +	pinctrl {
> +		compatible = "stericsson,nmk_pinctrl";
> +		reg = <0x80157000 0x2000>;
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&uart0_default_mode>;
...
> +	uart@80120000 {
> +		compatible = "arm,pl011", "arm,primecell";
> +		reg = <0x80120000 0x1000>;
> +		interrupts = <0 11 0x4>;
> +
> +		pinctrl-names = "default","sleep";
> +		pinctrl-0 = <&uart0_default_mux>, <&uart0_default_mode>;
> +		pinctrl-1 = <&uart0_sleep_mode>;
> +	};

Both pinctrl and uart@80120000 are going to try and claim/use the
content of &uart0_default_mode in that example, which I don't think will
work.

> +

There's a blank line at the end of the file.

> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c

> +int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,

> +	unsigned reserve = 1;
...> +	ret = of_property_read_string(np, "ste,function", &function);
> +	if (ret < 0)
> +		reserve = 0;

It might be a little simpler to say:

reserve = 0;
...
	ret = of_property_read_string(np, "ste,function", &function);
	if (ret >= 0)
		reserve = 1;

but not a big deal I suppose.

Aside from that,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
