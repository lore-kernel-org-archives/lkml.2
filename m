Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2H1WyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:54:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35178 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab2H1WyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:54:03 -0400
Message-ID: <503D4C08.8040605@wwwdotorg.org>
Date: Tue, 28 Aug 2012 15:54:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@linaro.org, kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sameo@linux.intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, richard.zhao@freescale.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3 1/7] mfd: add syscon driver based on regmap
References: <1346145005-17961-1-git-send-email-b29396@freescale.com> <1346145005-17961-2-git-send-email-b29396@freescale.com>
In-Reply-To: <1346145005-17961-2-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 02:09 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Add regmap based syscon driver.
> This is usually used for access misc bits in registers which does not belong
> to a specific module, for example, IMX IOMUXC GPR and ANATOP.
> With this driver, client can use generic regmap API to access registers
> which are registered into syscon.

> diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt

> +* System Controller Registers R/W driver

I think the binding document could use some information about what a
"syscon" actually is, especially since the compatible value is something
generic like "syscon" rather than something with a vendor-specific
prefix. How about:

A system controller node represents a register region containing a set
of miscellaneous registers. The registers are not cohesive enough to
represent as any specific type of device. The typical use-case is for
some other node's driver, or platform-specific code, to acquire a
reference to the syscon node (e.g. by phandle, node path, or search
using a specific compatible value), interrogate the node (or associated
OS driver) to determine the location of the registers, and access the
registers directly.

> +Required properties:
> +- compatible: Should contain "syscon".
> +- reg: the register range can be access from syscon
> +
> +Examples:
> +gpr: iomuxc-gpr@020e0000 {
> +	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
> +	reg = <0x020e0000 0x38>;
> +};

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig

> +config MFD_SYSCON
> +        bool "System Controller Register R/W Based on Regmap"
> +        select REGMAP_MMIO
> +        help
> +          Select this option to enable accessing system control registers
> +	  via regmap.

I think the indentation is off there.

> +static int __devinit syscon_probe(struct platform_device *pdev)
...
> +	regcache_cache_only(syscon->regmap, false);

Isn't that the default?

Aside from that, I don't have any particular comments on this series, so
please consider it,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
