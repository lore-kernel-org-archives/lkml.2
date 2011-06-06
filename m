Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab1FFIMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:12:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35179 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab1FFIMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:12:12 -0400
Date: Mon, 6 Jun 2011 10:12:05 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Shawn Guo <shawn.guo@linaro.org>, arnd@arndb.de, patches@linaro.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] gpio/mxc: Change gpio-mxc into an upstanding gpio
 driver
Message-ID: <20110606081205.GC32632@pengutronix.de>
References: <1307290075-7062-1-git-send-email-shawn.guo@linaro.org>
 <1307290075-7062-3-git-send-email-shawn.guo@linaro.org>
 <20110606075241.GD10410@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606075241.GD10410@ponder.secretlab.ca>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:07:13 up 11 days,  1:08, 19 users,  load average: 7.38, 5.55,
 3.45
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 01:52:41AM -0600, Grant Likely wrote:
> On Mon, Jun 06, 2011 at 12:07:55AM +0800, Shawn Guo wrote:
> > The patch makes necessary changes on gpio-mxc as below to turn it
> > into an upstanding gpio driver.
> > 
> >  * Add a list to save all mx2 ports references, so that
> >    mx2_gpio_irq_handler can walk through all interrupt status
> >    registers
> > 
> >  * Use readl/writel to replace mach-specific accessors
> >    __raw_readl/__raw_writel
> > 
> >  * Change mxc_gpio_init into mxc_gpio_probe function
> > 
> >  * Move "struct mxc_gpio_port" into gpio-mxc.c, as it needs not to
> >    be public at all, and also make some other cleanup on
> >    plat-mxc/include/mach/gpio.h at the same time
> > 
> > And the patch then migrates mach-imx and mach-mx5 to the updated
> > driver by adding corresponding platform devices.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > Acked-by: Olof Johansson <olof@lixom.net>
> 
> Applied, thanks.

I'm not completely happy with this patch going through your tree. It
does massive changes to arch/arm/mach-*mx*, so expect merge conflicts
here.

Sascha

> 
> g.
> 
> > ---
> >  arch/arm/mach-imx/mach-apf9328.c                |    2 +
> >  arch/arm/mach-imx/mach-armadillo5x0.c           |    2 +
> >  arch/arm/mach-imx/mach-bug.c                    |    2 +
> >  arch/arm/mach-imx/mach-cpuimx27.c               |    2 +
> >  arch/arm/mach-imx/mach-cpuimx35.c               |    2 +
> >  arch/arm/mach-imx/mach-eukrea_cpuimx25.c        |    2 +
> >  arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |    2 +
> >  arch/arm/mach-imx/mach-imx27ipcam.c             |    2 +
> >  arch/arm/mach-imx/mach-imx27lite.c              |    2 +
> >  arch/arm/mach-imx/mach-kzm_arm11_01.c           |    2 +
> >  arch/arm/mach-imx/mach-mx1ads.c                 |    2 +
> >  arch/arm/mach-imx/mach-mx21ads.c                |    2 +
> >  arch/arm/mach-imx/mach-mx25_3ds.c               |    2 +
> >  arch/arm/mach-imx/mach-mx27_3ds.c               |    2 +
> >  arch/arm/mach-imx/mach-mx27ads.c                |    2 +
> >  arch/arm/mach-imx/mach-mx31_3ds.c               |    2 +
> >  arch/arm/mach-imx/mach-mx31ads.c                |    2 +
> >  arch/arm/mach-imx/mach-mx31lilly.c              |    2 +
> >  arch/arm/mach-imx/mach-mx31lite.c               |    2 +
> >  arch/arm/mach-imx/mach-mx31moboard.c            |    2 +
> >  arch/arm/mach-imx/mach-mx35_3ds.c               |    2 +
> >  arch/arm/mach-imx/mach-mxt_td60.c               |    2 +
> >  arch/arm/mach-imx/mach-pca100.c                 |    2 +
> >  arch/arm/mach-imx/mach-pcm037.c                 |    2 +
> >  arch/arm/mach-imx/mach-pcm038.c                 |    2 +
> >  arch/arm/mach-imx/mach-pcm043.c                 |    2 +
> >  arch/arm/mach-imx/mach-qong.c                   |    2 +
> >  arch/arm/mach-imx/mach-scb9328.c                |    2 +
> >  arch/arm/mach-imx/mach-vpr200.c                 |    2 +
> >  arch/arm/mach-imx/mm-imx1.c                     |   17 +-
> >  arch/arm/mach-imx/mm-imx21.c                    |   21 +--
> >  arch/arm/mach-imx/mm-imx25.c                    |   16 +-
> >  arch/arm/mach-imx/mm-imx27.c                    |   21 +--
> >  arch/arm/mach-imx/mm-imx31.c                    |   15 +-
> >  arch/arm/mach-imx/mm-imx35.c                    |   15 +-
> >  arch/arm/mach-mx5/board-cpuimx51.c              |    2 +
> >  arch/arm/mach-mx5/board-cpuimx51sd.c            |    2 +
> >  arch/arm/mach-mx5/board-mx50_rdp.c              |    2 +
> >  arch/arm/mach-mx5/board-mx51_3ds.c              |    2 +
> >  arch/arm/mach-mx5/board-mx51_babbage.c          |    2 +
> >  arch/arm/mach-mx5/board-mx51_efikamx.c          |    2 +
> >  arch/arm/mach-mx5/board-mx51_efikasb.c          |    2 +
> >  arch/arm/mach-mx5/board-mx53_evk.c              |    2 +
> >  arch/arm/mach-mx5/board-mx53_loco.c             |    2 +
> >  arch/arm/mach-mx5/board-mx53_smd.c              |    2 +
> >  arch/arm/mach-mx5/devices.c                     |   64 -------
> >  arch/arm/mach-mx5/mm-mx50.c                     |   21 +--
> >  arch/arm/mach-mx5/mm.c                          |   25 ++-
> >  arch/arm/plat-mxc/devices.c                     |   11 ++
> >  arch/arm/plat-mxc/devices/Makefile              |    1 +
> >  arch/arm/plat-mxc/devices/platform-gpio-mxc.c   |   32 ++++
> >  arch/arm/plat-mxc/include/mach/common.h         |   12 ++-
> >  arch/arm/plat-mxc/include/mach/devices-common.h |    2 +
> >  arch/arm/plat-mxc/include/mach/gpio.h           |   27 ---
> >  drivers/gpio/gpio-mxc.c                         |  217 +++++++++++++++--------
> >  55 files changed, 358 insertions(+), 237 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/devices/platform-gpio-mxc.c
> > 
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
