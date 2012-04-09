Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2DITdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:33:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:13288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390Ab2DITdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:33:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="126975026"
Subject: [PATCH v3 0/3] rework quirks for the "kt" serial port
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Date: Mon, 09 Apr 2012 12:48:52 -0700
Message-ID: <20120409194514.8004.53204.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since: v2: http://marc.info/?l=linux-serial&m=133399499209069&w=2

Fixed a brown-paper-bag bug caught by Arnd and dropped "of_serial: add
support for setup quirks" in favor of a simple "if (type == PORT_TEGRA)"
check.

---

Dan Williams (2):
      tegra, serial8250: add ->handle_break() uart_port op
      serial/8250_pci: fix suspend/resume vs init/exit quirks

Sudhakar Mamillapalli (1):
      serial/8250_pci: Clear FIFOs for Intel ME Serial Over Lan device on BI


 arch/arm/configs/tegra_defconfig      |    1 +
 arch/arm/mach-tegra/board-harmony.c   |    4 +++
 arch/arm/mach-tegra/board-paz00.c     |    5 ++++
 arch/arm/mach-tegra/board-seaboard.c  |    4 +++
 arch/arm/mach-tegra/board-trimslice.c |    4 +++
 arch/arm/mach-tegra/devices.h         |    1 -
 drivers/tty/serial/8250/8250.c        |   44 ++++++++++----------------------
 drivers/tty/serial/8250/8250.h        |    2 +
 drivers/tty/serial/8250/8250_pci.c    |   45 +++++++++++++++++++++++++++++++++
 drivers/tty/serial/Kconfig            |    8 ++++++
 drivers/tty/serial/of_serial.c        |   25 ++++++++++++++++++
 include/linux/of_serial.h             |   17 ++++++++++++
 include/linux/serial_8250.h           |    1 +
 include/linux/serial_core.h           |    5 ++++
 14 files changed, 134 insertions(+), 32 deletions(-)
 create mode 100644 include/linux/of_serial.h
