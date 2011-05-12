Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1ELN2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:28:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:37868 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab1ELN2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:28:01 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH v2 2/4] MFD: TWL6030: fix irq definitions
Date: Thu, 12 May 2011 14:27:56 +0100
Message-Id: <1305206878-18094-3-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
References: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charger fault IRQs from the twl will in future patches be handled
by a seperate IRQ handler in the charger driver than the general charger
IRQ. Give them different IRQ numbers now to allow the charger driver to
be merged in the future.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/twl6030-irq.c |    4 ++--
 include/linux/i2c/twl.h   |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index dfbae34..eb3b5f8 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -76,8 +76,8 @@ static int twl6030_interrupt_mapping[24] = {
 	USBOTG_INTR_OFFSET,	/* Bit 18	ID			*/
 	USB_PRES_INTR_OFFSET,	/* Bit 19	VBUS			*/
 	CHARGER_INTR_OFFSET,	/* Bit 20	CHRG_CTRL		*/
-	CHARGER_INTR_OFFSET,	/* Bit 21	EXT_CHRG		*/
-	CHARGER_INTR_OFFSET,	/* Bit 22	INT_CHRG		*/
+	CHARGERFAULT_INTR_OFFSET,	/* Bit 21	EXT_CHRG	*/
+	CHARGERFAULT_INTR_OFFSET,	/* Bit 22	INT_CHRG	*/
 	RSV_INTR_OFFSET,	/* Bit 23	Reserved		*/
 };
 /*----------------------------------------------------------------------*/
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index d70e704..ba4f886 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -91,6 +91,7 @@
 #define BCI_INTR_OFFSET		2
 #define MADC_INTR_OFFSET	3
 #define USB_INTR_OFFSET		4
+#define CHARGERFAULT_INTR_OFFSET 5
 #define BCI_PRES_INTR_OFFSET	9
 #define USB_PRES_INTR_OFFSET	10
 #define RTC_INTR_OFFSET		11
-- 
1.7.4.1

