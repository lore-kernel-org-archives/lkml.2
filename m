Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1LUMih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:38:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:56433 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab1LUMiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104623063"
Date: Wed, 21 Dec 2011 13:43:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Axel Lin <axel.lin@gmail.com>,
        Ilya Yanok <yanok@emcraft.com>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        NeilBrown <neilb@suse.de>
Subject: [GIT] [3.2] MFD fixes
Message-ID: <20111221124339.GF5183@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the MFD fixes for 3.2. We have a few build failure fixes, a TWL oops
fix, some register setting routine fixes and a couple run time fixes for
wm8994 and tlw4030.

Thanks in advance for pulling:

The following changes since commit 384703b8e6cd4c8ef08512e596024e028c91c339:

  Linux 3.2-rc6 (2011-12-16 18:36:26 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Axel Lin (7):
      mfd: Add missed free_irq in da903x_remove
      mfd: Set adp5520 bits if new value is different from the old one
      mfd: Set da903x bits if new value is different from the old one
      mfd: Set tps6586x bits if new value is different from the old one
      mfd: include linux/module.h for ab5500-debugfs
      mfd: add #ifdef CONFIG_DEBUG_FS guard for ab8500_debug_resources
      mfd: Include linux/io.h to jz4740-adc

Ilya Yanok (1):
      mfd: Fix twl-core oops while calling twl_i2c_* for unbound driver

Marcus Folkesson (1):
      mfd: Handle tps65910 clear-mask correctly

Mark Brown (1):
      mfd: Update wm8994 active device checks for WM1811

NeilBrown (2):
      mfd: Base interrupt for twl4030-irq must be one-shot
      mfd: Use request_threaded_irq for twl4030-irq instead of irq_set_chained_handler

 drivers/mfd/ab5500-debugfs.c |    2 +-
 drivers/mfd/ab8500-core.c    |    2 ++
 drivers/mfd/adp5520.c        |    2 +-
 drivers/mfd/da903x.c         |    3 ++-
 drivers/mfd/jz4740-adc.c     |    1 +
 drivers/mfd/tps6586x.c       |    2 +-
 drivers/mfd/tps65910.c       |    2 +-
 drivers/mfd/twl-core.c       |   16 ++++++++--------
 drivers/mfd/twl4030-irq.c    |   18 +++++++++++-------
 drivers/mfd/wm8994-core.c    |    1 +
 10 files changed, 29 insertions(+), 20 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
