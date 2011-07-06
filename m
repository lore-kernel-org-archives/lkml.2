Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1GFFhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:37:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49783 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab1GFFhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:37:04 -0400
Date: Tue, 5 Jul 2011 23:37:00 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Erik Gilling <konkers@android.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ARM: tegra: gpio: Use engineering names in DT compatible
 property
Message-ID: <20110706053700.GC9978@ponder.secretlab.ca>
References: <1309896918-22496-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309896918-22496-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 02:15:18PM -0600, Stephen Warren wrote:
> Engineering names are more stable than marketing names. Hence, use them
> for Device Tree compatible properties instead.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Grant, This patch is physically against devicetree/arm, but also makes
> sense to apply to devicetree/test. This patch will cause conflicts
> somewhere, given you previously posted a patch to move gpio.c into
> drivers/gpio.

Applied to gpio/next, Thanks!

g.

> 
>  .../devicetree/bindings/gpio/gpio_nvidia.txt       |    2 +-
>  arch/arm/mach-tegra/gpio.c                         |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt b/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
> index afb3ff3..64aac39 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
> @@ -1,7 +1,7 @@
>  NVIDIA Tegra 2 GPIO controller
>  
>  Required properties:
> -- compatible : "nvidia,tegra250-gpio"
> +- compatible : "nvidia,tegra20-gpio"
>  - #gpio-cells : Should be two. The first cell is the pin number and the
>    second cell is used to specify optional parameters (currently unused).
>  - gpio-controller : Marks the device node as a GPIO controller.
> diff --git a/arch/arm/mach-tegra/gpio.c b/arch/arm/mach-tegra/gpio.c
> index 13afb88..747eb40 100644
> --- a/arch/arm/mach-tegra/gpio.c
> +++ b/arch/arm/mach-tegra/gpio.c
> @@ -347,7 +347,7 @@ static int __init tegra_gpio_init(void)
>  	 * driver is converted into a platform_device
>  	 */
>  	tegra_gpio_chip.of_node = of_find_compatible_node(NULL, NULL,
> -						"nvidia,tegra250-gpio");
> +						"nvidia,tegra20-gpio");
>  #endif /* CONFIG_OF_GPIO */
>  
>  	gpiochip_add(&tegra_gpio_chip);
> -- 
> 1.7.0.4
> 
