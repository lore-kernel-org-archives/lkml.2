Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2DISGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:06:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:38967 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332Ab2DISGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:06:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="130377744"
Subject: [PATCH v2 0/4] rework quirks for the "kt" serial port
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Date: Mon, 09 Apr 2012 11:21:58 -0700
Message-ID: <20120409182041.317.33360.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1: http://marc.info/?l=linux-serial&m=133373702606784&w=2

1/ rebased series on 3.4-rc2 to fix up a collision in patch 2 and
   dropped the recently accepted patches out of this series

2/ introduced quirk infrastructure for open firmware serial devices and
   hooked it up for Tegra's serial quirk

3/ updated the changelog in patch 4 to show the problems with quirk
   handling during resume

4/ added Alan's ack to patches 2-4.  patch 1 is new.

Patch 1-3 are targetted at 3.5 (pending an ack from Tegra folks), patch
4 is a RFC as the KT resume case was already fixed by "Revert
"serial/8250_pci: init-quirk msi support for kt serial controller"

---

Dan Williams (3):
      of_serial: add support for setup quirks
      tegra, serial8250: add ->handle_break() uart_port op
      serial/8250_pci: fix suspend/resume vs init/exit quirks

Sudhakar Mamillapalli (1):
      serial/8250_pci: Clear FIFOs for Intel ME Serial Over Lan device on BI


 arch/arm/configs/tegra_defconfig      |    1 
 arch/arm/mach-tegra/board-harmony.c   |    4 +
 arch/arm/mach-tegra/board-paz00.c     |    5 ++
 arch/arm/mach-tegra/board-seaboard.c  |    4 +
 arch/arm/mach-tegra/board-trimslice.c |    4 +
 arch/arm/mach-tegra/devices.h         |    1 
 drivers/tty/serial/8250/8250.c        |   44 +++++----------
 drivers/tty/serial/8250/8250.h        |    2 +
 drivers/tty/serial/8250/8250_pci.c    |   45 ++++++++++++++++
 drivers/tty/serial/Kconfig            |    8 +++
 drivers/tty/serial/of_serial.c        |   95 ++++++++++++++++++++++++++-------
 include/linux/of_serial.h             |   17 ++++++
 include/linux/serial_8250.h           |    1 
 include/linux/serial_core.h           |    5 ++
 14 files changed, 183 insertions(+), 53 deletions(-)
 create mode 100644 include/linux/of_serial.h
