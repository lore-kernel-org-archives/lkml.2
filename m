Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2DOOp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 10:45:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46727 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab2DOOp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 10:45:57 -0400
Date: Sun, 15 Apr 2012 16:45:49 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Dong Aisheng <dongas86@gmail.com>, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120415144549.GJ3852@pengutronix.de>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
 <20120414134814.GA3852@pengutronix.de>
 <CAA+hA=T0FAfuGKcW0vAKO+OWyFdM-6vQqVo53xKf8y28m7gPOQ@mail.gmail.com>
 <20120415141736.GG24997@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120415141736.GG24997@S2101-09.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:44:40 up 154 days, 22:31, 15 users,  load average: 0.01, 0.02,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 10:17:43PM +0800, Shawn Guo wrote:
> On Sun, Apr 15, 2012 at 11:49:04AM +0800, Dong Aisheng wrote:
> ...
> > My plan is:
> > 1) not all combinations, just define frequently used ones since
> > it's hard to define all combinations groups for per based IMX.
> > (maybe we can try to add a fix-up function which can do minor changes
> > based on available ones, then user does not need to write a new group
> > caused by only a small change.
> > what do you think?)
> > 
> > 2)  When dt supports macro, will try convert string to integer macro.
> > Then it maybe:
> > fsl,pins = <MX6Q_PAD_SD4_CMD 0
> >                 MX6Q_PAD_SD4_CLK 0
> >                 MX6Q_PAD_SD4_DAT0 1
> >                 .................>,
> > Why i did not start pin id with a raw integer is because it's less
> > meaning to user and
> > not easy to read in dts file.
> > 
> We may want to use integer from the beginning to reduce the churn on
> driver later.
> 
> I'm thinking about documenting the definition we used to have in
> iomux-mx*.h in the binding document and assign id to each of them
> in order.
> 
> pinmux						id
> ------						--
> MX6Q_PAD_SD2_DAT1__USDHC2_DAT1			0
> MX6Q_PAD_SD2_DAT1__ECSPI5_SS0			1
> MX6Q_PAD_SD2_DAT1__WEIM_WEIM_CS_2		2
> ...
> 
> The ordering between the list and imx6q_pin_regs[] array need to match.
> 
> By looking at the binding document, we can just put pinmux-id into
> property "fsl,pins" (maybe rename it to "fsl,pinmux-ids") to get the
> desired pinmux settings.  With doing so, we can gain the following.
> 
> 1) The pinmux-id can be used as index to locate the entry in array
>    imx6q_pin_regs[], so that the slow string lookup can be avoid.
> 
> 2) Property "fsl,mux" can be dropped, as it's been encoded in
>    imx6q_pin_regs[] entry.
> 
> 3) Converting the existing board files to device tree will be much
>    easier.  We only need to find the pinmux-id of those existing
>    definitions and put them in "fsl, pinmux-ids".
> 
> 4) When DTC support macro, we can simply move the pinmux-id list from
>    binding document into dts file.  No driver change is needed at all.
> 
> Thoughts?

I like it. I think it will feel much more natural to use.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
