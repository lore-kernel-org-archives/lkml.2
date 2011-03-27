Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1C0APl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 20:15:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:34419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab1C0APk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 20:15:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,249,1299484800"; 
   d="scan'208";a="671986303"
Date: Sun, 27 Mar 2011 01:15:37 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [2.6.39] 2nd MFD pull request
Message-ID: <20110327001536.GA4507@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request for the remaining MFD bits for 2.6.39.
Aside from a few actual fixes for regressions introduced by the first batch,
we also have a standalone driver for the MAX8997 IRQ handler, and a patchset
from Thomas Gleixner for cleaning up various MFD IRQ related parts.

Thanks in advance for pulling those in:

The following changes since commit 16c29dafcc86024048f1dbb8349d31cb22c7c55a:

  Merge branch 'syscore' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6 (2011-03-25 21:07:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Andres Salomon (1):
      mfd: Add mfd_clone_cell(), convert cs5535-mfd/olpc-xo1 to it

Axel Lin (2):
      mfd: Constify i2c_device_id tables
      mfd: Add MODULE_DEVICE_TABLE to rdc321x-southbridge

Daniel Drake (1):
      mfd: OLPC: Clean up names to match what OLPC actually uses

Guenter Roeck (1):
      mfd: Select MFD_CORE if TPS6105X driver is configured

MyungJoo Ham (1):
      mfd: Add MAX8997/8966 IRQ control

Samuel Ortiz (1):
      mfd: Clean up max8997 IRQ namespace

Thomas Gleixner (10):
      mfd: asic3: Cleanup irq handling
      mfd: 88pm860x: Remove unused irq_desc leftovers
      mfd: ezx-pcap: Remvove open coded irq handling
      mfd: htc-egpio: Cleanup interrupt handling
      mfd: htc-i2cpld: Cleanup interrupt handling
      mfd: mx8925: Remove irq_desc leftovers
      mfd: twl4030: Cleanup interrupt handling
      mfd: twl6030: Cleanup interrupt handling
      mfd: Cleanup irq namespace
      mfd: Fold irq_set_chip/irq_set_handler

 arch/x86/platform/olpc/olpc-xo1.c   |   23 +-
 drivers/mfd/88pm860x-core.c         |   11 +-
 drivers/mfd/Kconfig                 |    1 +
 drivers/mfd/Makefile                |    2 +-
 drivers/mfd/ab3550-core.c           |   12 +-
 drivers/mfd/ab8500-core.c           |   12 +-
 drivers/mfd/asic3.c                 |   38 ++--
 drivers/mfd/cs5535-mfd.c            |   16 ++
 drivers/mfd/ezx-pcap.c              |   34 ++--
 drivers/mfd/htc-egpio.c             |   23 +--
 drivers/mfd/htc-i2cpld.c            |   33 +--
 drivers/mfd/jz4740-adc.c            |   16 +-
 drivers/mfd/max8925-core.c          |   10 +-
 drivers/mfd/max8997-irq.c           |  377 +++++++++++++++++++++++++++++++++++
 drivers/mfd/max8998-irq.c           |    8 +-
 drivers/mfd/max8998.c               |    4 +-
 drivers/mfd/mfd-core.c              |   53 +----
 drivers/mfd/pcf50633-core.c         |    2 +-
 drivers/mfd/rdc321x-southbridge.c   |    1 +
 drivers/mfd/stmpe.c                 |   12 +-
 drivers/mfd/t7l66xb.c               |   21 +-
 drivers/mfd/tc3589x.c               |   12 +-
 drivers/mfd/tc6393xb.c              |   21 +-
 drivers/mfd/tps6586x.c              |    6 +-
 drivers/mfd/twl4030-irq.c           |   66 ++-----
 drivers/mfd/twl6030-irq.c           |   25 +--
 drivers/mfd/wl1273-core.c           |    2 +-
 drivers/mfd/wm831x-irq.c            |    8 +-
 drivers/mfd/wm8350-irq.c            |    8 +-
 drivers/mfd/wm8994-irq.c            |    8 +-
 include/linux/mfd/core.h            |   27 ++-
 include/linux/mfd/max8997-private.h |   21 ++
 include/linux/mfd/max8997.h         |    7 +-
 33 files changed, 618 insertions(+), 302 deletions(-)
 create mode 100644 drivers/mfd/max8997-irq.c

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
