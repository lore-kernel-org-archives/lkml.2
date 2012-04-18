Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2DRHHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:07:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42519 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2DRHHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:07:30 -0400
Date: Wed, 18 Apr 2012 09:07:21 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <kernel@pengutronix.de>, shawn.guo@linaro.org
Subject: Re: [PATCH 1/4] clk: select CLKDEV_LOOKUP for COMMON_CLK
Message-ID: <20120418070721.GL3852@pengutronix.de>
References: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
 <1334003101-17274-2-git-send-email-robherring2@gmail.com>
 <CAJOA=zMPqiH2fQJ5JWJ=COnju7Cmur6J2ATYUTcx41C4WMjFQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJOA=zMPqiH2fQJ5JWJ=COnju7Cmur6J2ATYUTcx41C4WMjFQQ@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:05:40 up 157 days, 14:52, 26 users,  load average: 0.24, 0.19,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 03:13:49PM -0700, Turquette, Mike wrote:
> On Mon, Apr 9, 2012 at 1:24 PM, Rob Herring <robherring2@gmail.com> wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> >
> > Using the common clock infrastructure without the common clkdev code makes
> > little sense, so select CLKDEV_LOOKUP for COMMON_CLK.
> >
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > ---
> >  drivers/clk/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> > index 165e1fe..f05a60d 100644
> > --- a/drivers/clk/Kconfig
> > +++ b/drivers/clk/Kconfig
> > @@ -12,6 +12,7 @@ config HAVE_MACH_CLKDEV
> >  config COMMON_CLK
> >        bool
> >        select HAVE_CLK_PREPARE
> > +       select CLKDEV_LOOKUP
> >        ---help---
> >          The common clock framework is a single definition of struct
> >          clk, useful across many platforms, as well as an
> 
> Hi Rob,
> 
> I agree that the common clk framework is not particularly useful
> without clkdev.  However the core code has no dependency on clkdev.
> Why not just select it from an arch Kconfig, or even make it a
> dependency based on your own platform clock data/code?

Selecting it from COMMON_CLK means that the compiler/linker will point
everybody trying to implement it without CLKDEV into the right
direction.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
