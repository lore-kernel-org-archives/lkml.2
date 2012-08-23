Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab2HWKhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:37:11 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:50979 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758193Ab2HWKhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:07 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 00/23] OMAP UART patches
Date: Thu, 23 Aug 2012 13:32:40 +0300
Message-Id: <1345717983-18179-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here's v3 and hopefully final version of this series. A whole bunch of new
patches added but the good thing is that now I had another engineer's help to
test, so he's got his Tested-by in all patches.

Changes since v2:
	. Added a bunch of new patches
	. Fixed a problem where we would always return IRQ_NONE even though we
		handled IRQ

Changes since v1:
        . improved commit log on patch 9/13 (formerly 10/13)
        . removed patch 2/13
        . added a new patch switching from spin_lock_irqsave() to spin_lock and
                spin_unlock_irqrestore to spin_unlock

Alan, if you prefer in pull request form, here it is:

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git uart

for you to fetch changes up to a29230f14d8466c9b8c25171715378bf52189453:

  serial: omap: enable RX and TX FIFO usage (2012-08-23 09:25:16 +0300)

----------------------------------------------------------------
Felipe Balbi (20):
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
      serial: omap: optimization with section annotations
      serial: omap: drop "inline" from IRQ handler prototype
      serial: omap: implement set_wake
      serial: omap: make sure to put() on poll_get_char
      serial: omap: remove unnecessary header and add a missing one
      serial: omap: move uart_omap_port definition to C file
      serial: omap: enable RX and TX FIFO usage

Ruchika Kharwar (2):
      serial: omap: fix sequence of pm_runtime_* calls.
      serial: omap: unlock the port lock

Vikram Pandita (1):
      serial: omap: fix software flow control

 arch/arm/mach-omap2/serial.c                  |  15 +-
 arch/arm/plat-omap/include/plat/omap-serial.h |  47 +-
 drivers/tty/serial/omap-serial.c              | 808 ++++++++++----------------
 include/linux/serial_reg.h                    |   4 +
 4 files changed, 330 insertions(+), 544 deletions(-)

-- 
1.7.12.rc3

