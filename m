Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1LGJHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:07:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49484 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1LGJHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:07:40 -0500
Date: Wed, 7 Dec 2011 10:07:34 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Ryan Mallon <rmallon@gmail.com>,
        Bill Gatliff <bgat@billgatliff.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Message-ID: <20111207090734.GN27267@pengutronix.de>
References: <201106301441.24493.arnd@arndb.de>
 <4E11994B.7070103@gmail.com>
 <20110704124318.GI6069@pengutronix.de>
 <201107041607.10265.arnd@arndb.de>
 <20111207085339.GA7970@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207085339.GA7970@avionic-0098.mockup.avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:00:50 up 24 days, 16:47, 47 users,  load average: 0.16, 0.38,
 0.62
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 09:53:39AM +0100, Thierry Reding wrote:
> * Arnd Bergmann wrote:
> > On Monday 04 July 2011, Sascha Hauer wrote:
> > > On Mon, Jul 04, 2011 at 08:43:23PM +1000, Ryan Mallon wrote:
> > >
> > > > The fine-grained control api could be added now. pwm_config could be
> > > > left as is for the time being (the new api could be a wrapper around it
> > > > to start with). Polarity control and interrupt handling apis could also
> > > > be defined without affecting the drivers which don't need to implement
> > > > them. Multiple channels and the sleeping/non-sleeping api are the more
> > > > difficult ones, but at least having some sort of indication about how
> > > > these plan to be solved would be useful.
> > > 
> > > Again, why should we add these *now*? It only raises the chance that
> > > there's more discussion.
> > 
> > My impression is that there are a lot of things that could easily be
> > done to improve the state of PWM drivers, but I don't care about the
> > order in which they are done. My main issue is the lack of a subsystem
> > core driver, which both you and Bill have patches for. It's clear that
> > other people have other issues and want to see their problems addressed
> > first.
> > 
> > I also think that the pwm code is simple enough that we don't have
> > to worry too much about the order that things are done in. Any patch
> > that is making the code better should just get in and not have to
> > wait for something else to be completed first.
> > 
> > What we do need now is a maintainer that can coordinate the patches
> > and merge the ones that have been agreed on. Or multiple maintainers.
> 
> Hi,
> 
> I'm looking at adding DT support for pwm-backlight, and I think a central PWM
> API will be required first. Looking through the archives this seems to be the
> last activity in that direction. Perhaps we can get the efforts restarted?
> 
> I pretty much agree with Arnd and Sascha here in that we should try to get a
> basic framework added. Everything else can be added on top later.

I have a branch which adds a basic PWM framework. It doesn't change the
pwm API at all, but only adds support for registering multiple PWM
drivers. All in Kernel drivers are converted to this new framework, but
except the i.MX driver all of them are untested. I'm quite confident
that the drivers itself work, but there will probably be some Kconfig
related issues which I wasn't able to sort out. The corresponding
Maintainers should probably have a look over it. Feel free to post
the patches if you are prepared to work on the comments you receive.
Otherwise I'll see if I find some time maybe next week.

Sascha


You can find my latest work on this here:


The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://git.pengutronix.de/git/imx/linux-2.6.git pwmlib

Sascha Hauer (7):
      PWM: add pwm framework support
      ARM mxs: adjust pwm resources to what the driver expects
      pwm: Add a i.MX23/28 pwm driver
      ARM i.MX: Move i.MX pwm driver to pwm framework
      ARM pxa: Move pxa pwm driver to pwm framework
      ARM Samsung: Move s3c pwm driver to pwm framework
      ARM vt8500: Move vt8500 pwm driver to pwm framework

 Documentation/pwm.txt                              |   56 ++++
 MAINTAINERS                                        |    6 +
 arch/arm/mach-mxs/devices/platform-mxs-pwm.c       |   32 ++-
 arch/arm/mach-pxa/Kconfig                          |   14 -
 arch/arm/plat-mxc/Kconfig                          |    6 -
 arch/arm/plat-mxc/Makefile                         |    1 -
 arch/arm/plat-pxa/Makefile                         |    1 -
 arch/arm/plat-samsung/Makefile                     |    4 -
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/pwm/Kconfig                                |   32 ++
 drivers/pwm/Makefile                               |    6 +
 drivers/pwm/core.c                                 |  220 ++++++++++++++
 arch/arm/plat-mxc/pwm.c => drivers/pwm/imx-pwm.c   |  102 ++-----
 drivers/pwm/mxs-pwm.c                              |  312 ++++++++++++++++++++
 arch/arm/plat-pxa/pwm.c => drivers/pwm/pxa-pwm.c   |  118 +++-----
 .../pwm.c => drivers/pwm/samsung-pwm.c             |  108 ++-----
 .../mach-vt8500/pwm.c => drivers/pwm/vt8500-pwm.c  |  103 ++-----
 include/linux/pwm.h                                |   37 +++
 19 files changed, 832 insertions(+), 329 deletions(-)
 create mode 100644 Documentation/pwm.txt
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/core.c
 rename arch/arm/plat-mxc/pwm.c => drivers/pwm/imx-pwm.c (78%)
 create mode 100644 drivers/pwm/mxs-pwm.c
 rename arch/arm/plat-pxa/pwm.c => drivers/pwm/pxa-pwm.c (72%)
 rename arch/arm/plat-samsung/pwm.c => drivers/pwm/samsung-pwm.c (80%)
 rename arch/arm/mach-vt8500/pwm.c => drivers/pwm/vt8500-pwm.c (75%)

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
