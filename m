Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab1LIQyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:54:01 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17988 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1LIQyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:54:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 09 Dec 2011 08:53:48 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Date: Fri, 9 Dec 2011 08:53:48 -0800
Subject: RE: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32
 SoCs
Thread-Topic: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32
 SoCs
Thread-Index: Acy2L5p9Mpu7IjSzSgS0F9div4YllgAYtvDA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17518604CA@HQMAIL01.nvidia.com>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
 <20111209010147.GH7913@S2100-06.ap.freescale.net>
 <4EE18403.30604@nvidia.com>
 <20111209043220.GJ7913@S2100-06.ap.freescale.net>
 <4EE192DC.3080209@nvidia.com>
 <20111209051413.GK7913@S2100-06.ap.freescale.net>
In-Reply-To: <20111209051413.GK7913@S2100-06.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Guo wrote at Thursday, December 08, 2011 10:14 PM:
> On Thu, Dec 08, 2011 at 09:47:24PM -0700, Stephen Warren wrote:
...
> > I'm not familiar with imx. For my education, which of the following is true:
> >
> 
> It's the case b).
> 
> > a)
> >
> > * UART TX signal can muxed onto 1 of 16 pins
> > * UART RX signal can muxed onto 1 of 16 pins
> >
> > In this case, you'd just list say "UART A TX" as a legal function for
> > each of those 16 pins. Yes, that's a lot of places, but still do-able.
> >
> > (16 possible positions would be a lot, but I suppose it is possible in HW)
> >
> > b)
> >
> > * UART TX signal can muxed onto 1 of 4 pins
> > * UART RX signal can muxed onto 1 of 4 pins
> > * So, there are 16 (4*4) combinations of these two settings
> >
> > In this case, you'd just list say "UART A TX" for the 4 pins, and "UART
> > A RX" for the other 4 pins. The 16 combinations don't come into play at
> > all; the board-specific mapping table would pick 1 single combination,
> > and represent this as:
> >
> > pin X: function = UART A TX
> > pin Y: function = UART A RX
> 
> We really do not expect per pin function mapping but per block function
> mapping.  That said, the UART driver is going to tell pinctrl subsystem
> "I'm UARTA, please set all my pins up for me".

That's fine; UART A can operate that way with pinctrl used as intended.

The way the pinctrl subsystem is defined is:

The SoC-specific pinctrl driver exposes the per-pin available functions.

The board-specific mapping table selects the function to use for each pin,
based on the board's requirements.

Any other way isn't fully consistent with the way pinctrl works. If we
do see a need for just a single per-board table rather than a separate
per-SoC table, and a per-board mapping table, we should rethink the
pinctrl subsystem...

> > Either way though, whether you put the data into tables in the driver or
> > in the SoC .dtsi file (included by each board's .dts file), the pinctrl
> 
> We are not going to list that into SoC .dtsi file.
> 
> > driver's table really should list all possible options, and the pinctrl
> > mapping table should select just one; that's kinda the whole point of
> > the tables. If you try to put just the used subset into device tree, you
> > won't be able to put it into the .dtsi file since it'll be
> > board-specific, and you'll end up forcing board .dts authors to recreate
> 
> That's what we are going to do.
> 
> > that driver's complete configuration table every time, which seems like
> > a lot of wasted work.

I re-iterate that point...

-- 
nvpublic

