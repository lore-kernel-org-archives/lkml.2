Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1F3JvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:51:22 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:37594 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043Ab1F3JvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:51:16 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 0/7] twl4030: finish threaded IRQ conversion
Date: Thu, 30 Jun 2011 12:51:03 +0300
Message-Id: <1309427470-605-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following patches where boot-tested on beagle xM
and everything seems fine. MMC root filesystem still
mounts, /proc/interrupts looks like ps aux | grep irq
shows our threads, etc.

please give it a thorough review as there are places
where I was confused of what to do.

Later patches could (should?) come making use of
Sparse IRQ numbers (by allocating irq_descs dynamically)
and I'm not sure I like that chained handler too much.

If I understood correctly the chained handler is simply
avoiding a request_threaded_irq() on e.g. twl4030-gpio.c
driver. Not sure if it's that nice. Anyway, here we have
the final conversion.

Felipe Balbi (7):
  mfd: twl4030-irq: remove trailing whitespaces
  mfd: twl4030-irq: implement bus_lock/bus_sync_unlock methods
  mfd: twl4030-irq: drop the kthread
  mfd: twl4030-irq: drop mask_work
  mfd: twl4030-irq: drop edge_work
  mfd: twl4030-irq: set irq nested flag
  rtc: twl: move to threaded irq

 drivers/mfd/twl4030-irq.c |  342 +++++++++++++++++----------------------------
 drivers/rtc/rtc-twl.c     |   10 +--
 2 files changed, 132 insertions(+), 220 deletions(-)

-- 
1.7.6

