Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab1FFIr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:47:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47631 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab1FFIr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:47:26 -0400
Date: Mon, 6 Jun 2011 10:47:20 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Shawn Guo <shawn.guo@linaro.org>, arnd@arndb.de, patches@linaro.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] gpio/mxc: Change gpio-mxc into an upstanding gpio
 driver
Message-ID: <20110606084720.GZ23771@pengutronix.de>
References: <1307290075-7062-1-git-send-email-shawn.guo@linaro.org>
 <1307290075-7062-3-git-send-email-shawn.guo@linaro.org>
 <20110606075241.GD10410@ponder.secretlab.ca>
 <20110606081205.GC32632@pengutronix.de>
 <BANLkTinY44trVnt-XXaH85Vsj46put6N1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinY44trVnt-XXaH85Vsj46put6N1Q@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:43:01 up 11 days,  1:44, 30 users,  load average: 1.35, 0.67,
 0.79
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 02:18:29AM -0600, Grant Likely wrote:
> On Mon, Jun 6, 2011 at 2:12 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Mon, Jun 06, 2011 at 01:52:41AM -0600, Grant Likely wrote:
> >> On Mon, Jun 06, 2011 at 12:07:55AM +0800, Shawn Guo wrote:
> >> > The patch makes necessary changes on gpio-mxc as below to turn it
> >> > into an upstanding gpio driver.
> >> >
> >> >  * Add a list to save all mx2 ports references, so that
> >> >    mx2_gpio_irq_handler can walk through all interrupt status
> >> >    registers
> >> >
> >> >  * Use readl/writel to replace mach-specific accessors
> >> >    __raw_readl/__raw_writel
> >> >
> >> >  * Change mxc_gpio_init into mxc_gpio_probe function
> >> >
> >> >  * Move "struct mxc_gpio_port" into gpio-mxc.c, as it needs not to
> >> >    be public at all, and also make some other cleanup on
> >> >    plat-mxc/include/mach/gpio.h at the same time
> >> >
> >> > And the patch then migrates mach-imx and mach-mx5 to the updated
> >> > driver by adding corresponding platform devices.
> >> >
> >> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> >> > Acked-by: Olof Johansson <olof@lixom.net>
> >>
> >> Applied, thanks.
> >
> > I'm not completely happy with this patch going through your tree. It
> > does massive changes to arch/arm/mach-*mx*, so expect merge conflicts
> > here.
> 
> There are also massive changes going on in drivers/gpio.  The solution
> here is to probably put these changes into a new dedicated branch
> based on Linus' tree, we both agree not to rebase that branch, and
> both of us merge the branch into our trees.

That can work. I just checked that atm there are no conflicts between my
branch and Shawns patches. Can you set up such a branch? Otherwise I can
just keep an eye on conflicts and we set up such a branch once a real
conflict arises.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
