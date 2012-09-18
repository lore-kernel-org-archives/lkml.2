Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab2IRNNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:13:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab2IRNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:13:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] spi/pl022: Devicetree support w/o platform data
Date: Tue, 18 Sep 2012 13:13:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
References: <1347972540-29667-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1347972540-29667-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209181313.30880.arnd@arndb.de>
X-Provags-ID: V02:K0:MPx+yUsvKLQGTz2oojwGnN81IOIg5itlEkm0d7NTNZR
 iJDtIQtiIM3WH/fUJGsfn2EWQxNkmgdOsZEreWcrP/RifuBNEt
 MJ2LLIv6B+OwJCnnSkqOsDQIjMlY+ykhIP6cO4xNUYUzGM1aNT
 IIfwq54FsHAl26iatAQlijd4PxvbM3pEENLtLoybAMMDK+jDvg
 Tg52RYHv6Sj2+VBoHCXzgE74pqeJDKdIDtcM9pyHOb0hJRoLV0
 5EcYu0Z5tytWCFqEtd4wt3XctFYOEq2oZ/lxN77jQ8NXNTmExs
 ooe5D+meaZ9ppMo7eUzjgg/fzaab7qUsGn0zvC7aCH+O8F/Yzu
 XBnql8y0XUepJwa/sjiw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Roland Stigge wrote:
> --- linux-2.6.orig/Documentation/devicetree/bindings/spi/spi_pl022.txt
> +++ linux-2.6/Documentation/devicetree/bindings/spi/spi_pl022.txt
> @@ -10,6 +10,15 @@ Optional properties:
>  - cs-gpios : should specify GPIOs used for chipselects.
>    The gpios will be referred to as reg = <index> in the SPI child nodes.
>    If unspecified, a single SPI device without a chip select can be used.
> +- pl022,bus-id : Bus ID (0, 1, ...)

I don't understand why we need the bus-id here. My understanding is that
this is a linux-specific number that should not be necessary when all
devices are described in the device tree rather than through spi_board_info.

Can't you just set master->bus_num to -1 when using the DT for probing?

> +- pl022,enable-dma : enables DMA driven transfers (boolean)

Similar thing here: Can't you just set the enable_dma flag when
a dma channel is provided in the device tree and unset it otherwise?

It also seems a bit pointless to enable DMA mode when you don't provide
a way to specify the channel at the same time.

	Arnd
