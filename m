Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2HUJX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:23:57 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:33445 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200Ab2HUJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:20:02 -0400
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
Subject: [RFC/PATCH 02/13] serial: omap: always return IRQ_HANDLED
Date: Tue, 21 Aug 2012 12:15:44 +0300
Message-Id: <1345540555-24359-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345540555-24359-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if we enter our IRQ handler just to notice
that the our device didn't generate the IRQ,
that still means "handling" and IRQ, so let's
return IRQ_HANDLED.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 5c0d0bc..b4b95fc 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -417,7 +417,7 @@ static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 	if (iir & UART_IIR_NO_INT) {
 		pm_runtime_mark_last_busy(&up->pdev->dev);
 		pm_runtime_put_autosuspend(&up->pdev->dev);
-		return IRQ_NONE;
+		return IRQ_HANDLED;
 	}
 
 	spin_lock_irqsave(&up->port.lock, flags);
-- 
1.7.12.rc3

