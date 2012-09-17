Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2IQRDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:03:25 -0400
Received: from antcom.de ([188.40.178.216]:55676 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab2IQRDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:03:23 -0400
Message-ID: <505757D8.8090405@antcom.de>
Date: Mon, 17 Sep 2012 19:03:20 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 09/19] ARM: ux500: Enable SSP (SPI) for HREF when booting
 Device Tree
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <1347016499-29354-10-git-send-email-lee.jones@linaro.org> <CACRpkdaC_enpxUFNM_wteAQWKER_naUNUH-s1pJtiGzVFSV+og@mail.gmail.com>
In-Reply-To: <CACRpkdaC_enpxUFNM_wteAQWKER_naUNUH-s1pJtiGzVFSV+og@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 09/10/2012 01:11 PM, Linus Walleij wrote:
> +SPI slave nodes must be children of the SPI master node and can
> +contain the following properties.
> +
> +- pl022,interface : interface type:
> +       0: SPI
> +       1: Texas Instruments Synchronous Serial Frame Format
> +       2: Microwire (Half Duplex)
> +- pl022,com-mode : polling, interrupt or dma
> +- pl022,rx-level-trig : Rx FIFO watermark level
> +- pl022,tx-level-trig : Tx FIFO watermark level
> +- pl022,ctrl-len : Microwire interface: Control length
> +- pl022,wait-state : Microwire interface: Wait state
> +- pl022,duplex : Microwire interface: Full/Half duplex
> 
> Currently this is defined as auxdata in board-mop500.c
> but notanly cs-gpios (num chipselects) should come from
> device tree instead.
> 
> It appears Roland has written his bindings such that DT
> data augments platform data (yes, I am also getting crazy
> about this prioritization, mea culpa for ACKing this without
> proper discussion) so it appears that you could actually
> use AUXDATA and some stuff in the DT at the same
> time.

Sorry for the incompleteness of the devicetree conversion. I'm sending a
patch (separately) that makes it possible to specify everything via
devicetree, so you can choose between dt and platform data.

Except in case of callback specification (dma_filter()), you need to
provide platform data.

Interestingly, when I removed the actual platform data from the board
file, I noticed that I still needed to specify a device name (like
dev:ssp0) to make it work. But this seems to be expected according to
the documentation of OF_DEV_AUXDATA(). Are there any plans or ideas how
to fix this?

When we have sorted out this driver change (please check the new pl022
specific dt property names!), I will provide patches for arm-soc to
actually use this new interface via dts files.

Thanks in advance,

Roland
