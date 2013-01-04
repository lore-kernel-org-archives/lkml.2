Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3ADH5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:57:02 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50457 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab3ADH45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:56:57 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>, <rmk+kernel@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <zonque@gmail.com>
CC: <afzal@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <ivan.djelic@parrot.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v4 0/3] mtd: nand: OMAP: ELM error correction support for BCH ecc
Date: Fri, 4 Jan 2013 13:26:48 +0530
Message-ID: <1357286211-5012-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
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

This series is based on linux 3.8-rc2 and tested with [1].
Also this patch series depend on [1] for NAND flash device
tree data and gpmc nand device tree binding documentation updates.

1. [PATCH v7 0/5] OMAP GPMC DT bindings
http://www.spinics.net/lists/linux-omap/msg83505.html

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

Changes since v3:
	- Availability and usability of ELM module is detected from device
	  tree nodes by checking availability of ELM node in device tree.

Philip Avinash (3):
  mtd: nand: omap2: Update nerrors using ecc.strength
  mtd: devices: elm: Add support for ELM error correction
  mtd: nand: omap2: Support for hardware BCH error correction.

 Documentation/devicetree/bindings/mtd/elm.txt      |   16 +
 .../devicetree/bindings/mtd/gpmc-nand.txt          |    4 +
 drivers/mtd/devices/Makefile                       |    4 +-
 drivers/mtd/devices/elm.c                          |  405 ++++++++++++++
 drivers/mtd/nand/omap2.c                           |  583 ++++++++++++++++++--
 include/linux/platform_data/elm.h                  |   54 ++
 6 files changed, 1023 insertions(+), 43 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mtd/elm.txt
 create mode 100644 drivers/mtd/devices/elm.c
 create mode 100644 include/linux/platform_data/elm.h

-- 
1.7.9.5

