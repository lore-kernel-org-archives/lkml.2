Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2JPHnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:43:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35682 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab2JPHma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:42:30 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH RESEND 4/8] input: TSC: ti_tscadc: Remove definition of End Of Interrupt register
Date: Tue, 16 Oct 2012 12:55:41 +0530
Message-ID: <1350372345-27108-5-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1350372345-27108-1-git-send-email-rachna@ti.com>
References: <1350372345-27108-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The touchscreen IP uses level sensitive interrupts rather
than edge sensitive interrupts and therefore the is no need
to use the EOI register to have the module re-strobe the
interrupt line if there pending interrupts exist.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/input/touchscreen/ti_tscadc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/ti_tscadc.c b/drivers/input/touchscreen/ti_tscadc.c
index 2cc19b0..ec0a442 100644
--- a/drivers/input/touchscreen/ti_tscadc.c
+++ b/drivers/input/touchscreen/ti_tscadc.c
@@ -27,7 +27,6 @@
 #include <linux/input/ti_tscadc.h>
 #include <linux/delay.h>
 
-#define REG_IRQEOI		0x020
 #define REG_RAWIRQSTATUS	0x024
 #define REG_IRQSTATUS		0x028
 #define REG_IRQENABLE		0x02C
@@ -330,8 +329,6 @@ static irqreturn_t tscadc_irq(int irq, void *dev)
 	}
 
 	tscadc_writel(ts_dev, REG_IRQSTATUS, irqclr);
-	/* check pending interrupts */
-	tscadc_writel(ts_dev, REG_IRQEOI, 0x0);
 
 	tscadc_writel(ts_dev, REG_SE, STPENB_STEPENB);
 	return IRQ_HANDLED;
-- 
1.7.0.4

