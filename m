Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab0I3N4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:56:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60141 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab0I3N4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:56:46 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: dmaengine patches
Date: Thu, 30 Sep 2010 15:56:31 +0200
Message-Id: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches are new versions of patches previously
posted with the latest comments from Dan integrated. New
in this series is a dma driver for the older i.MX SoCs. I decided
to implement the dmaengine driver for these SoCs as a user of
the old dma driver. This allows us keep both dma drivers in the
tree and to convert the users of the dma driver smoothly and one
by one to the new driver and remove the old driver afterwards.

Sascha

The following changes since commit 32163f4b2cef28a5aab8b226ffecfc6379a53786:

  alpha: fix usp value in multithreaded coredumps (2010-09-25 14:38:13 -0700)

are available in the git repository at:
  git://git.pengutronix.de/git/imx/linux-2.6.git sdma-dmaengine

Sascha Hauer (4):
      dmaengine: add possibility for cyclic transfers
      dmaengine: add wrapper functions for device control functions
      dmaengine: Add Freescale i.MX SDMA support
      dmaengine: Add Freescale i.MX1/21/27 DMA driver

 arch/arm/mach-imx/include/mach/dma-v1.h |    8 +-
 arch/arm/plat-mxc/include/mach/dma.h    |   67 ++
 arch/arm/plat-mxc/include/mach/sdma.h   |   17 +
 drivers/dma/Kconfig                     |   16 +
 drivers/dma/Makefile                    |    2 +
 drivers/dma/dmaengine.c                 |    2 +
 drivers/dma/imx-dma.c                   |  426 ++++++++++
 drivers/dma/imx-sdma.c                  | 1392 +++++++++++++++++++++++++++++++
 include/linux/dmaengine.h               |   43 +-
 9 files changed, 1966 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/dma.h
 create mode 100644 arch/arm/plat-mxc/include/mach/sdma.h
 create mode 100644 drivers/dma/imx-dma.c
 create mode 100644 drivers/dma/imx-sdma.c

