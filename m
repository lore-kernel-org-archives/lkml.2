Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1JYEuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 00:50:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10266 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1JYEuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 00:50:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 24 Oct 2011 21:49:59 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 24 Oct 2011 21:49:55 -0700
Subject: RE: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Topic: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Index: AcyRX2ZaScvGiJtuQKSyiP5wrZ2EQABcVqbg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B4180@HQMAIL01.nvidia.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
 <20111020023140.GC32007@S2100-06.ap.freescale.net>
 <CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
 <20111020131042.GH32007@S2100-06.ap.freescale.net>
 <CACRpkdYah+MSPCcHKhD+Wh11u2V3XR_3T8aCFxKpL0Znh+gh9g@mail.gmail.com>
 <20111023085113.GC1401@S2100-06.ap.freescale.net>
In-Reply-To: <20111023085113.GC1401@S2100-06.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Guo wrote at Sunday, October 23, 2011 2:51 AM:
...
> To me, pin_config() and its parameters should be invisible to client
> drivers.  For amba-pl011 example, do you think any of those SoCs will
> need multiple sets of uart pin configurations to switch for different
> working modes?  If that's case, the individual SoC pinctrl driver
> should be responsible for mapping particular pin configuration to
> specific pl011 working mode.  Otherwise, the amba-pl011 can simply
> call pinmux_enable(...) to have both mux and cfg set up.

I agree.

Somebody at the ARM workshop yesterday (and I'm sorry, I forget who; I'm
missing too much sleep) pointed out another very good reason:

If there's some IP block that's used in a bunch of SoCs, and each SoC has
different sets of params (or values) that can be set, the IP block driver
shouldn't know about each SoC, and set those values; instead, the board
should be telling the pinmux system exactly what parameters to set, and
the IP block driver should simply be telling pinmux "set up the pins".

Now, I suppose that this could also be done by providing all the params
and values to the driver through platform data, however:

a) The driver is already calling pinctrl to set up the muxing in an
abstract way (mapping table hides the details); I'd like to see pin
config work in the same way.

b) If this were implemented through platform data in each driver, then
every driver's DT binding and probe code will need to define the format
of this data and parse it at probe time. Instead, if this is all in some
table handled by the pinctrl system, it's defined once, and parse once,
which seems a lot simpler.

-- 
nvpublic

