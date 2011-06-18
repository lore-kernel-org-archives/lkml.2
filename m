Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1FRQWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 12:22:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65221 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1FRQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 12:22:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
Date: Sat, 18 Jun 2011 18:21:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, patches@linaro.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jason Liu <jason.hui@linaro.org>, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org> <1308410354-21387-2-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1308410354-21387-2-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106181821.46574.arnd@arndb.de>
X-Provags-ID: V02:K0:FKE6X+nBQjHjAHLHVRUsZzuDX6zbXxpC7i1+W98cu7E
 yS9RaHCzCraummEOnhvhyFi+aOAEVdVPhmErCSoQel4ZV6FXn0
 MWVw9ebhTKMhzDCq2uXuGKwqrJDV4e78bxRzcLmdqcqKnkFTEI
 flzUHE8SgcPIFk4R1fMIYrR8qFUfC7/edFdAh37zf9xUyrSG/a
 IWY5S4uLZO3sbpbv1Igng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 17:19:12 Shawn Guo wrote:
>
> +Required properties:
> +- compatible : should be "fsl,<soc>-uart", "fsl,imx-uart"
> +- reg : address and length of the register set for the device
> +- interrupts : should contain uart interrupt
> +- id : should be the port ID defined by soc
> +
> +Optional properties:
> +- fsl,has-rts-cts : indicate it has rts-cts
> +- fsl,irda-mode : support irda mode
> +
> +Example:
> +
> +uart@73fbc000 {
> +	compatible = "fsl,imx51-uart", "fsl,imx-uart";
> +	reg = <0x73fbc000 0x4000>;
> +	interrupts = <31>;
> +	id = <1>;
> +	fsl,has-rts-cts;
> +};

Should this also support the "clock-frequency" property that 8250-style
serial ports support [1]?

For the flow-control properties, should we name that more generic? The
same property certainly makes sense for other serial-ports if it does
here. OTOH, I'm not sure it's actually reliable, because it also depends
on whether the other side of the connection and the cable support hw flow
control.


	Arnd

[1] http://playground.sun.com/1275/bindings/devices/html/serial-1_0d.html#HDR9
