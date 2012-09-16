Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab2IPP0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 11:26:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:21863 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab2IPP0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 11:26:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,431,1344236400"; 
   d="scan'208";a="205460481"
Date: Sun, 16 Sep 2012 17:26:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        AnilKumar Ch <anilkumar@ti.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Feng Tang <feng.tang@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [GIT] [3.6] MFD fixes
Message-ID: <20120916152636.GJ3647@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Those are the pending MFD fixes for 3.6. The stats don't look that nice
because we had to extend an MFD API and fix all the callers from the MFD
directory.

We have 5 pending fixes:

- A tps65217 build error fix.
- A lcp_ich regression fix caused by the MFD driver failing to initialize the
  watchdog sub device due to ACPI conflicts.
- 2 MAX77693 interrupt handling bug fixes.
- An MFD core fix, adding an IRQ domain argument to the MFD device addition
  API in order to prevent silent and potentially harmful remapping behaviour
  changes for drivers supporting non-DT platforms.

Thanks in advance for pulling them in.

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git tags/mfd-for-linus-3.6-2

for you to fetch changes up to b186b12487efc80c44f2f0d26cc26eb249cf1524:

  mfd: MAX77693: Fix NULL pointer error when initializing irqs (2012-09-16 00:33:09 +0200)

----------------------------------------------------------------
This is the remaining MFD fixes for 3.6, with 5 pending fixes:

- A tps65217 build error fix.
- A lcp_ich regression fix caused by the MFD driver failing to initialize the
  watchdog sub device due to ACPI conflicts.
- 2 MAX77693 interrupt handling bug fixes.
- An MFD core fix, adding an IRQ domain argument to the MFD device addition
  API in order to prevent silent and potentially harmful remapping behaviour
  changes for drivers supporting non-DT platforms.

----------------------------------------------------------------
AnilKumar Ch (1):
      mfd: Move tps65217 regulator plat data handling to regulator

Chanwoo Choi (2):
      mfd: MAX77693: Fix interrupt handling bug
      mfd: MAX77693: Fix NULL pointer error when initializing irqs

Feng Tang (1):
      mfd: lpc_ich: Fix a 3.5 kernel regression for iTCO_wdt driver

Mark Brown (1):
      mfd: core: Push irqdomain mapping out into devices

 drivers/extcon/extcon-max77693.c       |   19 +++--
 drivers/mfd/88pm800.c                  |    5 +-
 drivers/mfd/88pm805.c                  |    3 +-
 drivers/mfd/88pm860x-core.c            |   21 +++---
 drivers/mfd/aat2870-core.c             |    2 +-
 drivers/mfd/ab3100-core.c              |    2 +-
 drivers/mfd/ab8500-core.c              |   10 +--
 drivers/mfd/arizona-core.c             |    6 +-
 drivers/mfd/asic3.c                    |    6 +-
 drivers/mfd/cs5535-mfd.c               |    2 +-
 drivers/mfd/da9052-core.c              |    2 +-
 drivers/mfd/davinci_voicecodec.c       |    2 +-
 drivers/mfd/db8500-prcmu.c             |    2 +-
 drivers/mfd/htc-pasic3.c               |    5 +-
 drivers/mfd/intel_msic.c               |    4 +-
 drivers/mfd/janz-cmodio.c              |    2 +-
 drivers/mfd/jz4740-adc.c               |    3 +-
 drivers/mfd/lm3533-core.c              |    7 +-
 drivers/mfd/lpc_ich.c                  |   24 +-----
 drivers/mfd/lpc_sch.c                  |    6 +-
 drivers/mfd/max77686.c                 |    2 +-
 drivers/mfd/max77693-irq.c             |   36 +++++++--
 drivers/mfd/max77693.c                 |   16 +++-
 drivers/mfd/max8925-core.c             |   12 +--
 drivers/mfd/max8997.c                  |    2 +-
 drivers/mfd/max8998.c                  |    8 +-
 drivers/mfd/mc13xxx-core.c             |    2 +-
 drivers/mfd/mfd-core.c                 |   12 +--
 drivers/mfd/palmas.c                   |    3 +-
 drivers/mfd/rc5t583.c                  |    2 +-
 drivers/mfd/rdc321x-southbridge.c      |    3 +-
 drivers/mfd/sec-core.c                 |    8 +-
 drivers/mfd/sta2x11-mfd.c              |    4 +-
 drivers/mfd/stmpe.c                    |    2 +-
 drivers/mfd/t7l66xb.c                  |    2 +-
 drivers/mfd/tc3589x.c                  |    8 +-
 drivers/mfd/tc6387xb.c                 |    2 +-
 drivers/mfd/tc6393xb.c                 |    4 +-
 drivers/mfd/ti-ssp.c                   |    2 +-
 drivers/mfd/timberdale.c               |   12 +--
 drivers/mfd/tps6105x.c                 |    2 +-
 drivers/mfd/tps6507x.c                 |    2 +-
 drivers/mfd/tps65090.c                 |    2 +-
 drivers/mfd/tps65217.c                 |  130 +++++++++++---------------------
 drivers/mfd/tps6586x.c                 |    3 +-
 drivers/mfd/tps65910.c                 |    2 +-
 drivers/mfd/tps65912-core.c            |    2 +-
 drivers/mfd/twl4030-audio.c            |    2 +-
 drivers/mfd/twl6040-core.c             |    2 +-
 drivers/mfd/vx855.c                    |    2 +-
 drivers/mfd/wl1273-core.c              |    2 +-
 drivers/mfd/wm831x-core.c              |   16 ++--
 drivers/mfd/wm8400-core.c              |    2 +-
 drivers/mfd/wm8994-core.c              |    4 +-
 drivers/regulator/tps65217-regulator.c |  124 ++++++++++++++++++++++++++----
 drivers/staging/nvec/nvec.c            |    2 +-
 include/linux/mfd/core.h               |    4 +-
 include/linux/mfd/tps65217.h           |   12 ++-
 58 files changed, 343 insertions(+), 247 deletions(-)



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
