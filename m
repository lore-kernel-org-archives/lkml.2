Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2JCOrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:47:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56080 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab2JCOrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:47:37 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>
CC: <afzal@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <ivan.djelic@parrot.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 0/4] mtd: nand: OMAP: Add support to use ELM as error correction module
Date: Wed, 3 Oct 2012 19:59:45 +0530
Message-ID: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support to use ELM as BCH 4 & 8 bit error correction module and
adds support for single shot read_page and write_page functions

Platforms containing the ELM module can be used to correct errors
reported by BCH 4, 8 & 16 bit ECC scheme. For now only 4 & 8 bit
support is added.

BCH 4 & 8 bit error detection support is already available in mainline
kernel and works with software error correction.

This series is based on top of [1] &[2]

1. linux-next/master
2. linux-omap-dt/for_3.7/dts_part2

Nand driver tested for BCH 4 & 8 bit error correction per sector.
This being tested by introducing bit errors at multiple sectors inside page.

Philip, Avinash (4):
  mtd: nand: omap2: Update nerrors using ecc.strength
  mtd: devices: elm: Add support for ELM error correction
  ARM: OMAP2: gpmc: Add support for BCH ECC scheme
  mtd: nand: omap2: Add data correction support

 arch/arm/mach-omap2/gpmc.c                   |  120 +++++++-
 arch/arm/plat-omap/include/plat/gpmc.h       |    1 +
 drivers/mtd/devices/Makefile                 |    4 +-
 drivers/mtd/devices/elm.c                    |  446 ++++++++++++++++++++++++++
 drivers/mtd/nand/omap2.c                     |  368 +++++++++++++++++++--
 include/linux/platform_data/elm.h            |   64 ++++
 include/linux/platform_data/mtd-nand-omap2.h |    1 +
 7 files changed, 958 insertions(+), 46 deletions(-)
 create mode 100644 drivers/mtd/devices/elm.c
 create mode 100644 include/linux/platform_data/elm.h

