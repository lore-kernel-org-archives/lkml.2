Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2K2LrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:47:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59432 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2K2LrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:47:18 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>, <afzal@ti.com>,
        <tony@atomide.com>, <broonie@opensource.wolfsonmicro.com>,
        <rmk+kernel@arm.linux.org.uk>, <gregkh@linuxfoundation.org>
CC: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <ivan.djelic@parrot.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v3 0/3] mtd: nand: OMAP: ELM error correction support for BCH ecc
Date: Thu, 29 Nov 2012 17:16:31 +0530
Message-ID: <1354189595-12784-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support to use ELM as BCH 4 & 8 bit error correction module. Also performance
enhancement by adding single shot read_page and write_page functions for the
nand flashes with page size less than 4 KB.

ELM module can be used to correct errors reported by BCH 4, 8 & 16 bit
ECC scheme. For now only 4 & 8 bit support is added.

BCH 4 & 8 bit error detection support is already available in mainline
kernel and works with software error correction.

This series is based on [1] and tested with RFC: OMAP GPMC bindings
patch series

1. linux-next/20121129

Tested on am335x-evm for BCH 4 and 8 bit error correction.

Changes since v1:
	- Erased page is identified by checking byte [13/7] in read
	  ecc. To filter out bit flips in OOB area, check 0 bits in
	  the byte greater than 4.
	- GPMC ecc engine configuration moves to omap2.c NAND driver.

Changes since v2:
	- Added runtime detection of elm module, instead of depending
	  on platform data.
	- Added bit flip correction in OOB ecc data if bit flip happen
	  OOB data.

Philip, Avinash (3):
  mtd: nand: omap2: Update nerrors using ecc.strength
  mtd: devices: elm: Add support for ELM error correction
  mtd: nand: omap2: Support for hardware BCH error correction.

 Documentation/devicetree/bindings/mtd/elm.txt |   17 +
 drivers/mtd/devices/Makefile                  |    4 +-
 drivers/mtd/devices/elm.c                     |  418 ++++++++++++++++++
 drivers/mtd/nand/omap2.c                      |  563 +++++++++++++++++++++++--
 include/linux/platform_data/elm.h             |   55 +++
 5 files changed, 1017 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mtd/elm.txt
 create mode 100644 drivers/mtd/devices/elm.c
 create mode 100644 include/linux/platform_data/elm.h

