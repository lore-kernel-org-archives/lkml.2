Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2LQVgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:36:10 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53749 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2LQVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:36:07 -0500
Message-ID: <50CF9043.8030308@wwwdotorg.org>
Date: Mon, 17 Dec 2012 14:36:03 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
CC: alan@linux.intel.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] serial: tegra: add serial driver
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 05:10 AM, Laxman Dewangan wrote:
> Nvidia's Tegra has multiple uart controller which supports:
> - APB dma based controller fifo read/write.
> - End Of Data interrupt in incoming data to know whether end
>   of frame achieve or not.
> - Hw controlled RTS and CTS flow control to reduce SW overhead.

> diff --git a/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt b/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt

> +NVIDIA Tegra20/Tegra30 high speed (dma based) UART controller driver.
> +
> +Required properties:
> +- compatible : should be "nvidia,tegra20-hsuart", "nvidia,tegra30-hsuart".

One question that isn't addressed here is:

Tegra has 5 UARTs. All of them can use the existing 8250.c by specifying
compatible = "nvidia,tegra20-uart". However, the 8250.c driver doesn't
support the DMA features of this driver. This driver is an alternate
driver for the same HW that allows DMA to be used with it, etc.

Since DT is supposed to describe the HW, modifying the DT to change the
compatible value in order to select a different driver in Linux doesn't
seem correct, or is it? Is there any kind of precedent for how to select
different drivers for the same HW at run-time? I'd wondered about using
the sysfs bind/unbind "methods" from user-space as the driver selection
mechanism...
