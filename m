Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3AGQ6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:58:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36482 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3AGQ6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:58:19 -0500
Message-ID: <50EAFEA7.90201@wwwdotorg.org>
Date: Mon, 07 Jan 2013 09:58:15 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, praithatha@nvidia.com,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: tegra114: add pinctrl driver for NVIDIA's
 Tegra114 SoC
References: <1357387375-25919-1-git-send-email-ldewangan@nvidia.com> <1357387375-25919-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357387375-25919-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 05:02 AM, Laxman Dewangan wrote:
> From: Pritesh Raithatha <praithatha@nvidia.com>
> 
> This adds a driver for the Tegra114 pinmux, and required
> parameterization data for Tegra114.
> 
> The driver uses the common Tegra pincontrol driver utility
> functions to implement the majority of the driver.
> 
> This driver is not compatible with the earlier NVIDIA's SoCs,
> hence add new compatibile as "nvidia,tegra114-pinmux".
> 
> Originally written by Pritesh.
> ldewangan: cleanup the patches, remove non-require tables.

> +static struct platform_driver tegra114_pinctrl_driver = {
> +	.driver = {
> +		.name = "tegra114-pinctrl",
> +		.owner = THIS_MODULE,
> +		.of_match_table = tegra114_pinctrl_of_match,
> +	},
> +	.probe = tegra114_pinctrl_probe,
> +	.remove = tegra_pinctrl_remove,
> +};

> +
> +static int __init tegra114_pinctrl_init(void)
> +{
> +	return platform_driver_register(&tegra114_pinctrl_driver);
> +}
> +arch_initcall(tegra114_pinctrl_init);
> +
> +static void __exit tegra114_pinctrl_exit(void)
> +{
> +	platform_driver_unregister(&tegra114_pinctrl_driver);
> +}
> +module_exit(tegra114_pinctrl_exit);

I believe that last chunk should be
module_platform_driver(tegra114_pinctrl_driver), since now that
everything is instantiated purely from DT, I don't believe there's any
probe ordering advantage to be gained from using arch_initcall() rather
than module_init().

Aside from that, the series,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

I didn't check the content of all the tables, but the structure looks good!
