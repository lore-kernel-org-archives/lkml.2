Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab2HPSpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:45:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60247 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab2HPSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:45:34 -0400
Message-ID: <502D3FCA.6030708@wwwdotorg.org>
Date: Thu, 16 Aug 2012 12:45:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 3/3] tegra: add pwm backlight device tree nodes
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com> <1345097337-24170-4-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1345097337-24170-4-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 12:08 AM, Alexandre Courbot wrote:

> +++ b/arch/arm/boot/dts/tegra20-ventana.dts

> +	backlight_reg: fixedregulator@176 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "backlight_regulator";
> +		regulator-min-microvolt = <1800000>;
> +		regulator-max-microvolt = <1800000>;
> +		gpio = <&gpio 176 0>;
> +		startup-delay-us = <0>;
> +		enable-active-high;
> +		regulator-boot-off;
> +	};

Rather than add that as a separate node at the top-level, I think just
add another sub-node to the "regulators" node. Oh, in fact it's already
there in next-20120816; you just need to add a label.

> +++ b/arch/arm/boot/dts/tegra20.dtsi

> -	pwm {
> +	pwm: pwm {
>  		compatible = "nvidia,tegra20-pwm";
>  		reg = <0x7000a000 0x100>;

It's pretty trivial I know, but I'd almost be tempted to make that a
separate patch so that it could be cherry-picked somewhere without a
tegra20-ventana.dts. But, perhaps that's silly.
