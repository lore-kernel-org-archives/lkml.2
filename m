Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2KHNDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:03:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:26051 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab2KHNDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244101798"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH v2 00/26] pstore, mmc: add mmc as backend for pstore
Date: Thu,  8 Nov 2012 15:05:58 +0200
Message-Id: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dragos Tatulea <dragos.tatulea@intel.com>

These patches enable using the mmc card to store panic information.

They include changes for pstore and mmc:
 - add block device backend for pstore
 - add logic in mmc for writing in panic mode

A mmc host driver must implement mmc_panic_ops. This patchset contains
an implementation for sdhci.

v2:
    - Added some detailed description to some commits. Not all of them
though because they are very small and self explanatory.
    - Added clarification on what mmc host controller drivers have to
implement to support panic dumping.

Adrian Hunter (26):
  pstore: allow for big files
  pstore: add flags
  pstore: add flush
  blkoops: add a block device oops / panic logger
  block: add panic write
  mmc: block: add panic write support
  mmc: panic write: bypass host claiming
  mmc: panic write: bypass request completion
  mmc: panic write: suppress host not claimed warnings
  mmc: panic write: do not msleep
  mmc: panic write: bypass clock gating
  mmc: panic write: bypass regulators
  mmc: panic write: trap non panic tasks
  mmc: panic write: bypass bus ref locking
  mmc: sdhci: panic write: bypass spin lock
  mmc: sdhci: panic write: no sleeping
  mmc: sdhci: panic write: call tasklets inline
  mmc: sdhci: panic write: no timeout timer
  mmc: sdhci: panic write: no runtime pm
  mmc: sdhci: panic write: no tuning
  mmc: sdhci: panic write: poll interrupts
  mmc: sdhci: panic write: no dma mapping
  mmc: sdhci: panic write: resume suspended host
  mmc: sdhci: panic write: abort request in progress
  mmc: sdhci: panic write: trap nonpanic tasks
  mmc: sdhci-pci: add panic write support

 Documentation/blockdev/00-INDEX    |    2 +
 Documentation/blockdev/blkoops.txt |  104 +++
 drivers/acpi/apei/erst.c           |   16 +-
 drivers/block/Kconfig              |   13 +
 drivers/block/Makefile             |    1 +
 drivers/block/blkoops.c            | 1569 ++++++++++++++++++++++++++++++++++++
 drivers/mmc/card/Kconfig           |   11 +
 drivers/mmc/card/block.c           |  257 +++++-
 drivers/mmc/core/core.c            |   61 +-
 drivers/mmc/core/core.h            |    6 +-
 drivers/mmc/core/host.c            |   11 +
 drivers/mmc/core/mmc.c             |    4 +-
 drivers/mmc/core/mmc_ops.c         |   10 +-
 drivers/mmc/core/sd.c              |    4 +-
 drivers/mmc/core/sd_ops.c          |    2 +-
 drivers/mmc/core/sdio.c            |    4 +-
 drivers/mmc/core/sdio_irq.c        |    4 +-
 drivers/mmc/core/sdio_ops.c        |    2 +-
 drivers/mmc/host/sdhci-pci.c       |    5 +
 drivers/mmc/host/sdhci.c           |  441 ++++++++--
 drivers/mmc/host/sdhci.h           |   24 +
 fs/pstore/inode.c                  |   26 +-
 fs/pstore/internal.h               |    5 +-
 fs/pstore/platform.c               |   23 +-
 fs/pstore/ram.c                    |   15 +-
 include/linux/blkdev.h             |   77 ++
 include/linux/genhd.h              |    3 +
 include/linux/mmc/host.h           |   92 +++
 include/linux/mmc/sdhci.h          |    9 +
 include/linux/pstore.h             |   12 +-
 30 files changed, 2690 insertions(+), 123 deletions(-)
 create mode 100644 Documentation/blockdev/blkoops.txt
 create mode 100644 drivers/block/blkoops.c

-- 
1.7.9.5

