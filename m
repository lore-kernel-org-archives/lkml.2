Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2IJLLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:11:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58471 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab2IJLLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:11:12 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-10-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-10-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 04:11:10 -0700
Message-ID: <CACRpkdaC_enpxUFNM_wteAQWKER_naUNUH-s1pJtiGzVFSV+og@mail.gmail.com>
Subject: Re: [PATCH 09/19] ARM: ux500: Enable SSP (SPI) for HREF when booting
 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Roland Stigge <stigge@antcom.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we add a new SSP node to the HREF's Device Tree file which
> activates the generic one found in the .dtsi file. This will
> allow probing of the SSP driver when Device Tree is enabled.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

We have to look closer at this.

There are merged PL022 DT bindings (by Roland Stigge)
nowadays, see commit 6d3952a7dfa80919842bbe01ac7f693d40a1eb84
in linux-next:

 Optional properties:
+- num-cs : total number of chipselects
 - cs-gpios : should specify GPIOs used for chipselects.
   The gpios will be referred to as reg = <index> in the SPI child nodes.
   If unspecified, a single SPI device without a chip select can be used.

+SPI slave nodes must be children of the SPI master node and can
+contain the following properties.
+
+- pl022,interface : interface type:
+       0: SPI
+       1: Texas Instruments Synchronous Serial Frame Format
+       2: Microwire (Half Duplex)
+- pl022,com-mode : polling, interrupt or dma
+- pl022,rx-level-trig : Rx FIFO watermark level
+- pl022,tx-level-trig : Tx FIFO watermark level
+- pl022,ctrl-len : Microwire interface: Control length
+- pl022,wait-state : Microwire interface: Wait state
+- pl022,duplex : Microwire interface: Full/Half duplex

Currently this is defined as auxdata in board-mop500.c
but notanly cs-gpios (num chipselects) should come from
device tree instead.

It appears Roland has written his bindings such that DT
data augments platform data (yes, I am also getting crazy
about this prioritization, mea culpa for ACKing this without
proper discussion) so it appears that you could actually
use AUXDATA and some stuff in the DT at the same
time.

Or you could keep it like this and only have AUXDATA
as it stands, I just want a discussion about what is the right
thing to do before we commit to anything.

Yours,
Linus Walleij
