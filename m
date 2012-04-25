Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab2DYDGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 23:06:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab2DYDGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 23:06:49 -0400
From: NeilBrown <neilb@suse.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 25 Apr 2012 13:05:24 +1000
Subject: [PATCH 3/3] twl4030: enable wakeup on twl4030 IRQ.
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Message-ID: <20120425030524.7832.66013.stgit@notabene.brown>
In-Reply-To: <20120425025637.7832.14013.stgit@notabene.brown>
References: <20120425025637.7832.14013.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the interrupts that come through this line should trigger
wakeups:
  power button
  RTC alarm
  power available
  usb plug/unplug

so mark the interrupt as a wakeup interrupt.
This is particularly important for when the interrupt arrives during
the late suspend phase.  Without this setting it will be ignored.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/mfd/twl4030-irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 5d656e8..ad733d7 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -757,6 +757,7 @@ int twl4030_init_irq(struct device *dev, int irq_num)
 		dev_err(dev, "could not claim irq%d: %d\n", irq_num, status);
 		goto fail_rqirq;
 	}
+	enable_irq_wake(irq_num);
 
 	return irq_base;
 fail_rqirq:


