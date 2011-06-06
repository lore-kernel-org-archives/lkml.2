Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1FFMRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:17:15 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:59464 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab1FFMRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:17:13 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 6 Jun 2011 20:22:19 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <arnd@arndb.de>, <olof@lixom.net>,
        <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>
Subject: Re: [PATCH v4 0/2] Move plat-mxc gpio driver into drivers/gpio
Message-ID: <20110606122219.GC21204@S2100-06.ap.freescale.net>
References: <1307290075-7062-1-git-send-email-shawn.guo@linaro.org>
 <20110606085051.GA23771@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110606085051.GA23771@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 10:50:51AM +0200, Sascha Hauer wrote:
> On Mon, Jun 06, 2011 at 12:07:53AM +0800, Shawn Guo wrote:
> > The patch set moves plat-mxc gpio driver into drivers/gpio, and
> > migrates mach-imx and mach-mx5 to the new driver.
> > 
> > Changes since v3:
> >  * Reorganize the patch set per Grant's comments
> > 
> > Shawn Guo (2):
> >       gpio/mxc: Move Freescale MXC gpio driver to drivers/gpio
> >       gpio/mxc: Change gpio-mxc into an upstanding gpio driver
> > 
> >  arch/arm/plat-mxc/include/mach/common.h            |   12 +-
> >  arch/arm/plat-mxc/include/mach/devices-common.h    |    2 +
> >  arch/arm/plat-mxc/include/mach/gpio.h              |   27 ---
> >  drivers/gpio/Kconfig                               |    4 +
> >  drivers/gpio/Makefile                              |    1 +
> >  .../arm/plat-mxc/gpio.c => drivers/gpio/gpio-mxc.c |  217 +++++++++++++-------
> 
> While at renaming I'd prefer naming this file gpio-imx.c. We currently
> have inconsistent naming between mxc vs. imx and I'd like to get rid
> of the former.
> 
It's not just a file name.  The "mxc" is embedded in the variable
and function name all over the driver.  I would currently keep it as
it is for the reasons below.

 * The driver was moved out from plat-mxc, so naturally the name
   gpio-mxc is picked.

 * Changing name to gpio-imx would require replace all "mxc" with
   "imx" all over the file, IMO.  This makes the diff of the patch
   look complex.

 * i.MX23 and i.MX28 are also part of imx family, but architecture
   name "imx" does not cover it.  Taking "mxs" as the architecture name 
   for i.MX23 and i.MX28, "mxc" stands well what it stands right now.

I would start renaming the driver with another patch, probably when
I see mach-mx5 start getting merged into mach-imx and plat-mxc renamed
to plat-imx.

-- 
Regards,
Shawn

