Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab1LGDqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:46:11 -0500
Received: from 20.mo1.mail-out.ovh.net ([188.165.45.168]:51517 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755627Ab1LGDqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:46:09 -0500
Date: Wed, 7 Dec 2011 04:42:00 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: achew@nvidia.com
Cc: grant.likely@secretlab.ca, olof@lixom.net, swarren@nvidia.com,
        dwillemsen@nvidia.com, rklein@nvidia.com, mogantyv@nvidia.com,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH 1/3 v4] usb: tegra20-ehci: Add devicetree support.
Message-ID: <20111207034200.GG32515@game.jcrosoft.org>
References: <1311283067-18952-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311283067-18952-1-git-send-email-achew@nvidia.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16241669107048819473
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredvnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucffohhmrghinhepne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredvnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucffohhmrghinhepne
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:17 Thu 21 Jul     , achew@nvidia.com wrote:
> From: Andrew Chew <achew@nvidia.com>
> 
> Add code to try to get platform data information (register base, irq,
> modes, various tuning parameters) from device tree, if not present in board
> files.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> ---
> Applied Olof Johansson's comments:
> - Use direct assignment when copying default config structs.
> - Use __devinitdata for static default config structs.
> - Don't compile the default config structs if CONFIG_OF is disabled, to avoid
>   a warning.
> 
>  .../devicetree/bindings/usb/tegra20-ehci.txt       |   27 +++
>  drivers/usb/host/ehci-tegra.c                      |  189 ++++++++++++++++++++
>  2 files changed, 216 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/tegra20-ehci.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/tegra20-ehci.txt b/Documentation/devicetree/bindings/usb/tegra20-ehci.txt
> new file mode 100644
> index 0000000..315ea6e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/tegra20-ehci.txt
> @@ -0,0 +1,27 @@
> +NVIDIA Tegra20 SOC USB controllers
> +
> +The device node for a USB controller that is part of a Tegra20
> +SOC is as described in the document "Open Firmware Recommended
> +Practice: Universal Serial Bus" with the following modifications
> +and additions:
> +
> +Required properties:
> + - compatible: Should be "nvidia,tegra20-ehci".
> + - phy-type: Should be one of "utmi" or "ulpi".  Defaults to utmi.
> + - dr-mode: Should be one of "peripheral", "host", or "otg".  Defaults to host.
> + - power-down-on-bus-suspend: For host mode only.  If present, then
> +   the USB phy will power down when the host is suspended.
> +
> +Required properties for phy-type = "utmi".  These values are derived from
> +characterization by system engineering.
> + - nvidia,hssync-start-delay: Defaults to 9.
> + - nvidia,idle-wait-delay: Defaults to 17.
> + - nvidia,elastic-limit: Defaults to 16.
> + - nvidia,term-range-adj: Defaults to 6.
> + - nvidia,xcvr-setup: Defaults to 9.
> + - nvidia,xcvr-lsfslew: Defaults to 2.
> + - nvidia,xcvr-lsrslew: Defaults to 2.
> +
> +Required properties for phy-type = "ulpi":
> + - reset-gpio: The GPIO used to drive reset.  Defaults to 169.
> + - clk: Defaults to "cdev2".
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 02b2bfd..d7295eb 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -21,10 +21,34 @@
>  #include <linux/platform_data/tegra_usb.h>
>  #include <linux/irq.h>
>  #include <linux/usb/otg.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +
>  #include <mach/usb_phy.h>
>  
>  #define TEGRA_USB_DMA_ALIGN 32
>  
> +static u64 tegra_ehci_dmamask = DMA_BIT_MASK(TEGRA_USB_DMA_ALIGN);
I really does not like this
as the dmamask is supposed to be device specific

before we put it in the soc codewhich alow to have it generic

this need to be manage a DT level
	dmamask = <32>

or
	dmamask = <0xffffffff>

Best Regards,
J.
