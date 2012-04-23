Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2DWG43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:56:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38915 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2DWG42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:56:28 -0400
Date: Mon, 23 Apr 2012 08:56:23 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Rob Lee <rob.lee@linaro.org>, Amit Kucheria <amit.kucheria@linaro.org>,
        kernel@pengutronix.de, linaro-dev@lists.linaro.org, patches@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
Message-ID: <20120423065623.GA3852@pengutronix.de>
References: <CAMXH7KH41kWMPu_dEpetZc8OUD3C0-mtxGbXX0Vqd4EODPWJUg@mail.gmail.com>
 <20120417174213.GD3852@pengutronix.de>
 <CAMXH7KFYA24sPUcwgKfwVLNPA0jWQ-QG02y+SfPNnAqdiv0+gg@mail.gmail.com>
 <CAMXH7KGgSmvfqUTC1bufBz0QXbt01dHsPo1cbRA9jLj9mGmfjg@mail.gmail.com>
 <20120419064308.GH3852@pengutronix.de>
 <20120420020816.GH22219@S2101-09.ap.freescale.net>
 <CAMXH7KE2RtdNy3G61guZb2uWy3rn267Z3eEVEgN5e==tHHsiuA@mail.gmail.com>
 <20120423051813.GM26306@S2101-09.ap.freescale.net>
 <20120423062739.GX3852@pengutronix.de>
 <20120423065259.GR26306@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423065259.GR26306@S2101-09.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:54:37 up 162 days, 14:41, 41 users,  load average: 0.09, 0.06,
 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 02:53:01PM +0800, Shawn Guo wrote:
> On Mon, Apr 23, 2012 at 08:27:39AM +0200, Sascha Hauer wrote:
> > On Mon, Apr 23, 2012 at 01:18:21PM +0800, Shawn Guo wrote:
> > > On Sun, Apr 22, 2012 at 11:44:39PM -0500, Rob Lee wrote:
> > > > >> I don't think we need a cpu_is_imx6q(), but having some i.MX6 specific
> > > > >> hook at device_initcall time can't be too wrong. Shawn?
> > > > >>
> > > > > Yep, it works for me.
> > > > >
> > > > Sascha, Shawn, thanks for the response.
> > > > 
> > > > Since device_initcall isn't platform specific, it seems I would still
> > > > need a cpu_is_imx6q() function or similiar functionality from a device
> > > > tree call.  Or do you have something else in mind that I'm not seeing?
> > > > 
> > > I guess Sascha is asking for something like the following.
> > > 
> > > static int __init imx_device_init(void)
> > > {
> > > 	imx5_device_init();
> > > 	imx6_device_init();
> > > }
> > > device_initcall(imx_device_init)
> > > 
> > > static int __init imx6_device_init(void)
> > > {
> > > 	/*
> > > 	 * do whatever needs to get done in device_initcall time
> > > 	 */
> > > }
> > 
> > The problem is more how we can detect that we are actually running a
> > i.MX6 SoC. We could directly ask the devicetree in an initcall or we
> > could introduce a cpu_is_mx6() just like we have a macro for all other
> > i.MX SoCs.
> > 
> Oops, my reply was a brain-dead one.  Hmm, then it seems that we have
> to introduce cpu_is_mx6() which I tried hard to avoid.  I do not have
> a preference between defining a macro and asking device tree.

Since we already have a place in early setup code in which we know that
we are running on an i.MX6 I suggest for the sake of the symmetry of the
universe that we introduce a cpu_is_mx6.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
