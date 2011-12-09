Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1LIDoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 22:44:24 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1768 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1LIDoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 22:44:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 08 Dec 2011 19:44:07 -0800
Message-ID: <4EE18403.30604@nvidia.com>
Date: Thu, 08 Dec 2011 20:44:03 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32
 SoCs
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de> <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com> <20111209010147.GH7913@S2100-06.ap.freescale.net>
In-Reply-To: <20111209010147.GH7913@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 06:01 PM, Shawn Guo wrote:
> On Thu, Dec 08, 2011 at 03:14:40PM -0800, Stephen Warren wrote:
>> Presumably, the set of pins, groups, and functions is determined by the
>> SoC HW. Platform data is usually board-specific rather than SoC specific.
>> You have two choices here: You could either parse this data from device
>> tree as Arnd suggested (and I think as the TI OMAP pinctrl driver will),
>> or do what I've done in the Tegra pinctrl driver, and simply put each
>> SoC's data into the driver and select which one to use based on the DT
>> compatible flag; I didn't see the point of putting data in to the DT that
>> was identical for every board using a given SoC.
>>
> I'm not sure about tegra, but for imx, it's very difficult to enumerate
> all these data and list them in pinctrl driver.  Sascha gave a few
> examples when we discussed about it in another thread.  The TX and RX
> pin of UART has 4 options each.  SD could possibly have 1, 4, and 8
> data lines.  Display interface could have 16, 24, 32 data lines, etc.
> All these options are chosen by board design for given soc pinmux
> design.  So putting this data into device tree makes sense for imx too.

The pinctrl driver should simply represent the raw options that the HW
supports on each individual pin. This table should be readily enumerable
(it's probably already in the SoC's datasheet), and of non-exponential
size. In this table, considerations such as display bus width do not
come into play; you just note that a certain 32 pins could support the
display function.

The board-specific selection of which function to use for each pin/group
(which is where the actual selection of e.g. 16/24/32-bit display bus
comes in) is provided by the board-specific mapping table, which I agree
makes perfect sense to put into device tree, since it's potentially
highly variable.

-- 
nvpublic
