Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2HUMUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:20:15 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:41862 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755220Ab2HUMUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:20:11 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 00/13] OMAP Serial patches
Date: Tue, 21 Aug 2012 15:15:58 +0300
Message-Id: <1345551371-18862-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345540555-24359-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here's a series of cleanup patches to the OMAP serial
driver. A later series could be made re-implementing
DMA using the DMA Engine API. Note that for RX DMA
we could be using RX Timeout IRQ as a hint that we better
use PIO instead ;-)

All patches were tested on my pandaboard, but I'd really
like to receive Tested-by on other platforms.

After this goes in, I'll probably try to get UART wakeup
working again and only after that look at DMA.

Changes since v1:

	. improved commit log on patch 9/13 (formerly 10/13)
	. removed patch 2/13
	. added a new patch switching from spin_lock_irqsave() to spin_lock and
		spin_unlock_irqrestore to spin_unlock

Retested with my pandaboard, UART continues to work:

 # grep -i uart /proc/interrupts
 106:        124          0       GIC  OMAP UART2
 #  grep -i uart /proc/interrupts
 106:        189          0       GIC  OMAP UART2
 #  grep -i uart /proc/interrupts
 106:        255          0       GIC  OMAP UART2
 #  grep -i uart /proc/interrupts
 106:        321          0       GIC  OMAP UART2
 #  grep -i uart /proc/interrupts
 106:        387          0       GIC  OMAP UART2
 #  grep -i uart /proc/interrupts
 106:        453          0       GIC  OMAP UART2
 #  grep -i uart /proc/interrupts
 106:        519          0       GIC  OMAP UART2

cheers

ps: if anyone knows a better test for UART, let me know.

for convenience of anyone testing, patches are available on my git tree [1] on
branch uart

[1] git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git uart

Felipe Balbi (13):
  serial: omap: define and use to_uart_omap_port()
  serial: omap: define helpers for pdata function pointers
  serial: omap: don't access the platform_device
  serial: omap: drop DMA support
  serial: add OMAP-specific defines
  serial: omap: simplify IRQ handling
  serial: omap: refactor receive_chars() into rdi/rlsi handlers
  serial: omap: move THRE check to transmit_chars()
  serial: omap: stick to put_autosuspend
  serial: omap: set dev->drvdata before enabling pm_runtime
  serial: omap: drop unnecessary check from remove
  serial: omap: make sure to suspend device before remove
  serial: omap: don't save IRQ flags on hardirq

 arch/arm/mach-omap2/serial.c                  |  15 +-
 arch/arm/plat-omap/include/plat/omap-serial.h |  12 +-
 drivers/tty/serial/omap-serial.c              | 713 +++++++++-----------------
 include/linux/serial_reg.h                    |   4 +
 4 files changed, 254 insertions(+), 490 deletions(-)

-- 
1.7.12.rc3

