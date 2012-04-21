Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab2DTXvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:51:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:65530 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab2DTXvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:51:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="91503808"
Date: Sat, 21 Apr 2012 02:00:03 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Keshava Munegowda <Keshava_mgowda@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [GIT] [3.4] MFD fixes
Message-ID: <20120421000003.GA17403@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request for MFD fixes for 3.4.

We have 3 build fixes, a OMAP USB host PHY reset fix and the twl6040
conversion to an i2c driver. The latter may not sound like a fix but the
twl6040 MFD driver won't probe without it, triggering an OMAP4 audio
regression.

Thanks in advance for pulling them in:

The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git tags/mfd-for-linus-3.4

for you to fetch changes up to 82ea267f7dc853a5e6a724916a70a10656efdfc2:

  mfd: Fix modular builds of rc5t583 regulator support (2012-04-16 21:27:07 +0200)

----------------------------------------------------------------
First MFD pull request for 3.4 fixes

----------------------------------------------------------------
Daniel Lezcano (1):
      mfd : Fix dbx500 compilation error

Dmitry Artamonow (1):
      mfd: Fix asic3_gpio_to_irq

Keshava Munegowda (1):
      ARM: OMAP3: USB: Fix the EHCI ULPI PHY reset issue

Paul Gortmaker (1):
      mfd: Fix modular builds of rc5t583 regulator support

Peter Ujfalusi (1):
      mfd: Convert twl6040 to i2c driver, and separate it from twl core

 arch/arm/mach-omap2/board-4430sdp.c    |   12 ++--
 arch/arm/mach-omap2/board-generic.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |   13 ++--
 arch/arm/mach-omap2/twl-common.c       |   37 +++++++++--
 arch/arm/mach-omap2/twl-common.h       |   10 +--
 drivers/input/misc/Kconfig             |    3 +-
 drivers/input/misc/twl6040-vibra.c     |    4 +-
 drivers/mfd/Kconfig                    |   11 +++-
 drivers/mfd/asic3.c                    |    4 +-
 drivers/mfd/omap-usb-host.c            |   44 ------------
 drivers/mfd/rc5t583.c                  |   39 +-----------
 drivers/mfd/twl6040-core.c             |  114 +++++++++++++++++++-------------
 drivers/usb/host/ehci-omap.c           |   39 ++++++++++-
 include/linux/i2c/twl.h                |   12 ----
 include/linux/mfd/db5500-prcmu.h       |   88 ++++++++++--------------
 include/linux/mfd/rc5t583.h            |   47 +++++++++++--
 include/linux/mfd/twl6040.h            |   27 ++++++++
 sound/soc/codecs/Kconfig               |    3 +-
 sound/soc/codecs/twl6040.c             |    3 +-
 sound/soc/omap/Kconfig                 |    2 +-
 20 files changed, 276 insertions(+), 238 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
