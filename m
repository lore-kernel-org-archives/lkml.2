Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2KZO4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:56:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:45336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab2KZO4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:56:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,320,1352102400"; 
   d="scan'208";a="252615188"
Date: Mon, 26 Nov 2012 15:56:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Kalle Jokiniemi <kalle.jokiniemi@jollamobile.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [GIT] [3.7] MFD fixes
Message-ID: <20121126145639.GU12685@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for 3.7 fixes.

We have:

- A twl fix preventing a buffer overflow.
- A wm5102 register patch fix.
- A wm5110 error misreport fix.
- Arizona fixes: Use the right array size when adding subdevices, correctly
  report underclocked events, synchronize register cache after reset.
- A twl4030 fix for preventing the system to hang from an interrupt flood.

Thanks in advance for pulling them in.

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git tags/mfd-for-linus-3.7

for you to fetch changes up to 8b41669ceba0c2d4c09d69ccb9a3458953dae784:

  mfd: twl4030: Fix chained irq handling on resume from suspend (2012-11-21 17:46:41 +0100)

----------------------------------------------------------------
Charles Keepax (3):
      mfd: arizona: Use correct array for ARRAY_SIZE in mfd_add_devices call
      mfd: arizona: Correctly report when AIF2/AIF1 is underclocked
      mfd: arizona: Sync regcache after reset

Kalle Jokiniemi (1):
      mfd: twl4030: Fix chained irq handling on resume from suspend

Mark Brown (2):
      mfd: wm5102: Update register patch for latest evaluation
      mfd: wm5110: Disable control interface error report for WM5110 rev B

Peter Ujfalusi (1):
      mfd: twl-core: Fix chip ID for the twl6030-pwm module

 drivers/mfd/arizona-core.c  |   14 +-
 drivers/mfd/arizona-irq.c   |    1 +
 drivers/mfd/twl-core.c      |    2 +-
 drivers/mfd/twl4030-irq.c   |    3 +-
 drivers/mfd/wm5102-tables.c |  519 +------------------------------------------
 5 files changed, 16 insertions(+), 523 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
