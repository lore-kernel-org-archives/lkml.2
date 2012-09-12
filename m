Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2ILJFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:05:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41808 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2ILJFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:05:35 -0400
Date: Wed, 12 Sep 2012 11:04:58 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 5/7] pwm: i.MX: add devicetree support
Message-ID: <20120912090458.GN6180@pengutronix.de>
References: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
 <1347267577-3296-6-git-send-email-s.hauer@pengutronix.de>
 <20120911144043.GA3824@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120911144043.GA3824@avionic-0098.mockup.avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:02:40 up 81 days, 14 min, 58 users,  load average: 0.87, 3.31,
 2.48
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 04:40:43PM +0200, Thierry Reding wrote:
> On Mon, Sep 10, 2012 at 10:59:35AM +0200, Sascha Hauer wrote:
> > From: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> > At the same time remove platform based support. No user for
> > this driver has made it into mainline so far, so all we break
> > is out of tree stuff.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> > Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
> [...]
> 
> I was just doing some build tests on the series and noticed that it
> fails with this:
> 
> 	  CC [M]  drivers/pwm/pwm-imx.o
> 	/home/thierry.reding/src/kernel/linux-pwm.git/drivers/pwm/pwm-imx.c: In function 'imx_pwm_config_v2':
> 	/home/thierry.reding/src/kernel/linux-pwm.git/drivers/pwm/pwm-imx.c:140:2: error: implicit declaration of function 'cpu_is_mx25' [-Werror=implicit-function-declaration]
> 
> This breaks bisection in the middle of the series. It seems to be
> related to this change.
> 
> > diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> > index a1e799e..b4e0ad3 100644
> > --- a/drivers/pwm/pwm-imx.c
> > +++ b/drivers/pwm/pwm-imx.c
> > @@ -16,8 +16,7 @@
> >  #include <linux/clk.h>
> >  #include <linux/io.h>
> >  #include <linux/pwm.h>
> > -#include <mach/hardware.h>
> 
> This probably needs to be postponed to the next patch, until the final
> reference to cpu_is_mx25() is removed.

Oops, you are right. I updated the tag accordingly, and did a full
compile test over this series, so please pull again:


The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.pengutronix.de/git/imx/linux-2.6.git tags/imx-pwm-oftree

for you to fetch changes up to a1d38ca9e249e670aa9f608e1cc7491fb4ca45af:

  pwm: i.MX: fix clock lookup (2012-09-12 11:00:55 +0200)

----------------------------------------------------------------
Cleanup i.MX PWM driver and add devicetree support

----------------------------------------------------------------
Philipp Zabel (2):
      pwm: i.MX: add devicetree support
      pwm: i.MX: fix clock lookup

Sascha Hauer (5):
      pwm: i.MX: factor out SoC specific functions
      pwm: i.MX: remove unnecessary if in pwm_[en|dis]able
      pwm: i.MX: add functions to enable/disable pwm.
      pwm: i.MX: Use module_platform_driver
      pwm: i.MX: use per clock unconditionally

 Documentation/devicetree/bindings/pwm/imx-pwm.txt |   17 ++
 drivers/pwm/pwm-imx.c                             |  278 ++++++++++++++-------
 2 files changed, 199 insertions(+), 96 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/imx-pwm.txt

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
