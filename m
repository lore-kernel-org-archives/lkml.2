Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1LIAtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:49:00 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:16255
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752880Ab1LIAs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:48:58 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 9 Dec 2011 09:01:48 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Message-ID: <20111209010147.GH7913@S2100-06.ap.freescale.net>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 03:14:40PM -0800, Stephen Warren wrote:
> Presumably, the set of pins, groups, and functions is determined by the
> SoC HW. Platform data is usually board-specific rather than SoC specific.
> You have two choices here: You could either parse this data from device
> tree as Arnd suggested (and I think as the TI OMAP pinctrl driver will),
> or do what I've done in the Tegra pinctrl driver, and simply put each
> SoC's data into the driver and select which one to use based on the DT
> compatible flag; I didn't see the point of putting data in to the DT that
> was identical for every board using a given SoC.
> 
I'm not sure about tegra, but for imx, it's very difficult to enumerate
all these data and list them in pinctrl driver.  Sascha gave a few
examples when we discussed about it in another thread.  The TX and RX
pin of UART has 4 options each.  SD could possibly have 1, 4, and 8
data lines.  Display interface could have 16, 24, 32 data lines, etc.
All these options are chosen by board design for given soc pinmux
design.  So putting this data into device tree makes sense for imx too.

-- 
Regards,
Shawn

