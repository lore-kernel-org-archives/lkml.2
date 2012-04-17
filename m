Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2DQMaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 08:30:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38769 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab2DQMaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 08:30:18 -0400
Date: Tue, 17 Apr 2012 14:30:06 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        Dong Aisheng <dongas86@gmail.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120417123006.GC3852@pengutronix.de>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
 <20120414134814.GA3852@pengutronix.de>
 <CAA+hA=T0FAfuGKcW0vAKO+OWyFdM-6vQqVo53xKf8y28m7gPOQ@mail.gmail.com>
 <20120415141736.GG24997@S2101-09.ap.freescale.net>
 <20120416034713.GB17173@shlinux2.ap.freescale.net>
 <20120416034646.GI24997@S2101-09.ap.freescale.net>
 <20120417095722.GF17173@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417095722.GF17173@shlinux2.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:22:31 up 156 days, 20:09, 94 users,  load average: 0.05, 0.33,
 0.29
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 05:57:23PM +0800, Dong Aisheng wrote:
> Sascha & Shawn,
> 
> Just let you know:
> After changes the pinctrl table may look like:
> (i also removed fsl,* config properties since it was introduced for better
> readability before, but after dtc macro support is available, it could also
> be removed. So i removed now. Then the using is much similar as iomux-v3).
> 
> iomuxc@020e0000 {
>         compatible = "fsl,imx6q-iomuxc";
>         reg = <0x020e0000 0x4000>;
> 
>         /* shared pinctrl settings */
>         uart4 {
>                 pinctrl_uart4_1: uart4grp-1 {
>                         fsl,pins = <58 61>;
>                         fsl,configs = <0x12407>

Why do we have a hex value for the config now? This should be
independent on how we describe the mux settings.

Also I think a single fsl,configs entry for a pin group is not
enough, what for example with I2C where the data line needs a pullup
whereas the clock line does not?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
