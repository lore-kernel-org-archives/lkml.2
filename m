Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab1FRS1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 14:27:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56051 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1FRS1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 14:27:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] net/fec: add device tree support
Date: Sat, 18 Jun 2011 20:27:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, patches@linaro.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jason Liu <jason.hui@linaro.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org> <1308410354-21387-3-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1308410354-21387-3-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182027.22974.arnd@arndb.de>
X-Provags-ID: V02:K0:D7h03f8Es+J7TtG1HvMp5Uvcg7pZXOEBclgAm1YvorL
 1bDc1EvIPxqUiyKufWgAAAdi1dRvt9lpPqky8HDsoVqhepUEbJ
 bEXlCtsgDIdJEBhc3tK3CiOGG+SRAP7TypddYShV35qtBIdVWB
 WeXMk8C3hyrghHKiAM/uEtEjN7QYvK8P8xkzphDlBFwuuboarz
 F+TGN860A9Bna8A48cpPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 17:19:13 Shawn Guo wrote:
> diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
> new file mode 100644
> index 0000000..705111d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
> @@ -0,0 +1,14 @@
> +* Freescale Fast Ethernet Controller (FEC)
> +
> +Required properties:
> +- compatible : should be "fsl,<soc>-fec", "fsl,fec"
> +- reg : address and length of the register set for the device
> +- interrupts : should contain fec interrupt
> +
> +Example:
> +
> +fec@83fec000 {
> +	compatible = "fsl,imx51-fec", "fsl,fec";
> +	reg = <0x83fec000 0x4000>;
> +	interrupts = <87>;
> +};

How about also adding device_type="network" as required here, so you
inherit the attributes like "local-mac-address".

I would also suggest adding a call to of_get_mac_address() so you
can read the address out of the device tree when it is not configured
in hardware. Today, the driver relies on a module parameter or
platform_data on hardware with a mac address set.

The other information that is currently encoded in platform_data
is the phy mode. How about adding a property that enables RMII mode
when present?

	Arnd
