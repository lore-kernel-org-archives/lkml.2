Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab2DJUzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:55:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:14661 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab2DJUzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:55:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="127468099"
Subject: [PATCH v4 0/3] rework quirks for the "kt" serial port
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Date: Tue, 10 Apr 2012 14:10:48 -0700
Message-ID: <20120410210438.13805.40525.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v3: http://marc.info/?l=linux-serial&m=133400008811070&w=2

* Cleaned up "tegra, serial8250: add ->handle_break() uart_port op" to
  incorporate Stephen's feedback of just using CONFIG_ARCH_TEGRA instead
  of adding CONFIG_SERIAL_TEGRA.

* Added Arnd's ack

* The other two patches have not changed.

---

Dan Williams (2):
      tegra, serial8250: add ->handle_break() uart_port op
      serial/8250_pci: fix suspend/resume vs init/exit quirks

Sudhakar Mamillapalli (1):
      serial/8250_pci: Clear FIFOs for Intel ME Serial Over Lan device on BI


 arch/arm/mach-tegra/board-harmony.c   |    2 +
 arch/arm/mach-tegra/board-paz00.c     |    3 ++
 arch/arm/mach-tegra/board-seaboard.c  |    2 +
 arch/arm/mach-tegra/board-trimslice.c |    2 +
 drivers/tty/serial/8250/8250.c        |   44 ++++++++++----------------------
 drivers/tty/serial/8250/8250.h        |    2 +
 drivers/tty/serial/8250/8250_pci.c    |   45 +++++++++++++++++++++++++++++++++
 drivers/tty/serial/of_serial.c        |   26 +++++++++++++++++++
 include/linux/of_serial.h             |   17 ++++++++++++
 include/linux/serial_8250.h           |    1 +
 include/linux/serial_core.h           |    5 ++++
 11 files changed, 118 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/of_serial.h
