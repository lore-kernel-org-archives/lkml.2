Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2IFMuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:50:16 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:37493 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755102Ab2IFMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:50:10 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v4 00/21] OMAP UART Patches
Date: Thu,  6 Sep 2012 15:45:19 +0300
Message-Id: <1346935540-1792-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <20120906122948.GC29202@arwen.pp.htv.fi>
References: <20120906122948.GC29202@arwen.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here's v4 of the omap uart patchset. No changes other than a rebase on top of
Greg's tty-next branch and Tony's Acked-by being added to a couple patches

Note: I'm resending the series with Vikram's Software Flow Control fix anyway
as it can just be ignored if it's decided it needs to go into this merge
window.

Changes since v3:
	. Rebased on top of Greg's tty-next branch
	. Added Tony's Acked-by

Changes since v2:
        . Added a bunch of new patches
        . Fixed a problem where we would always return IRQ_NONE even though we
                handled IRQ

Changes since v1:
        . improved commit log on patch 9/13 (formerly 10/13)
        . removed patch 2/13
        . added a new patch switching from spin_lock_irqsave() to spin_lock and
                spin_unlock_irqrestore to spin_unlock

Felipe Balbi (18):
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
 arch/arm/plat-omap/include/plat/omap-serial.h |  49 +-
 drivers/tty/serial/omap-serial.c              | 740 +++++++++-----------------
 include/linux/serial_reg.h                    |   4 +
 4 files changed, 282 insertions(+), 526 deletions(-)

-- 
1.7.12.rc3

