Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3AFWnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:43:46 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:40888 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229Ab3AFWnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:43:35 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/8] DMA: COH901318 in-factoring of platform
Date: Sun, 6 Jan 2013 23:43:05 +0100
Message-ID: <1357512185-5562-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This patch series moves the big, complex platform data for the U300
DMA controller COH901318 down into the driver, rids the
<mach/coh901318.h> header from the global scope, creates a proper
platform data header for the few things we acually want to
parametrize from the platform, and all in preparation for device
tree support.

Vinod, it'd be great if you could ACK this so I can merge it
through the ARM SoC tree. The driver is propably more maintainable
in this shape as well without lots of pieces spread out all over
the place.

Linus Walleij (8):
  dma: coh901318: create a proper platform data file
  dma: coh901318: push platform data into driver
  dma: coh901318: remove hardcoded target addresses
  dma: coh901318: skip hard-coded addresses
  dma: coh901318: push header down into the DMA subsystem
  dma: coh901318: push definitions into driver
  dma: coh901318: merge header files
  dma: coh901318: cut down on platform data abstraction

 arch/arm/mach-u300/core.c                   | 1087 +---------------------
 arch/arm/mach-u300/dma_channels.h           |   60 --
 arch/arm/mach-u300/include/mach/coh901318.h |  267 ------
 arch/arm/mach-u300/spi.c                    |    3 +-
 drivers/dma/coh901318.c                     | 1302 ++++++++++++++++++++++++++-
 drivers/dma/coh901318.h                     |  141 +++
 drivers/dma/coh901318_lli.c                 |    4 +-
 drivers/dma/coh901318_lli.h                 |  124 ---
 include/linux/platform_data/dma-coh901318.h |   72 ++
 9 files changed, 1469 insertions(+), 1591 deletions(-)
 delete mode 100644 arch/arm/mach-u300/dma_channels.h
 delete mode 100644 arch/arm/mach-u300/include/mach/coh901318.h
 create mode 100644 drivers/dma/coh901318.h
 delete mode 100644 drivers/dma/coh901318_lli.h
 create mode 100644 include/linux/platform_data/dma-coh901318.h

-- 
1.7.11.3

