Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1K1LpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:45:13 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:11459 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab1K1Lob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:44:31 -0500
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <7ef1bbedbcd7377afdb7f380d47cc4c76ff46ae3.1322479017.git.n.voss@weinmann.de>
In-Reply-To: <cover.1322479017.git.n.voss@weinmann.de>
References: <cover.1322479017.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Mon, 28 Nov 2011 12:06:31 +0100
Subject: [PATCH v8 6/7] i2c-at91: removed local include
To: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register definitions are directly placed into the driver file.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/i2c/busses/i2c-at91.c |   33 ++++++++++++++++-
 drivers/i2c/busses/i2c-at91.h |   80 -----------------------------------------
 2 files changed, 31 insertions(+), 82 deletions(-)
 delete mode 100644 drivers/i2c/busses/i2c-at91.h

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 3ef89e9..34deef4 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -29,11 +29,40 @@
 
 #include <mach/cpu.h>
 
-#include "i2c-at91.h"
-
 #define TWI_CLK_HZ		100000			/* max 400 Kbits/s */
 #define AT91_I2C_TIMEOUT	msecs_to_jiffies(100)	/* transfer timeout */
 
+/* AT91 TWI register definitions */
+#define	AT91_TWI_CR		0x0000	/* Control Register */
+#define	AT91_TWI_START		0x0001	/* Send a Start Condition */
+#define	AT91_TWI_STOP		0x0002	/* Send a Stop Condition */
+#define	AT91_TWI_MSEN		0x0004	/* Master Transfer Enable */
+#define	AT91_TWI_SVDIS		0x0020	/* Slave Transfer Disable */
+#define	AT91_TWI_SWRST		0x0080	/* Software Reset */
+
+#define	AT91_TWI_MMR		0x0004	/* Master Mode Register */
+#define	AT91_TWI_IADRSZ_1	0x0100	/* Internal Device Address Size */
+#define	AT91_TWI_MREAD		0x1000	/* Master Read Direction */
+
+#define	AT91_TWI_IADR		0x000c	/* Internal Address Register */
+
+#define	AT91_TWI_CWGR		0x0010	/* Clock Waveform Generator Reg */
+
+#define	AT91_TWI_SR		0x0020	/* Status Register */
+#define	AT91_TWI_TXCOMP		0x0001	/* Transmission Complete */
+#define	AT91_TWI_RXRDY		0x0002	/* Receive Holding Register Ready */
+#define	AT91_TWI_TXRDY		0x0004	/* Transmit Holding Register Ready */
+
+#define	AT91_TWI_OVRE		0x0040	/* Overrun Error */
+#define	AT91_TWI_UNRE		0x0080	/* Underrun Error */
+#define	AT91_TWI_NACK		0x0100	/* Not Acknowledged */
+
+#define	AT91_TWI_IER		0x0024	/* Interrupt Enable Register */
+#define	AT91_TWI_IDR		0x0028	/* Interrupt Disable Register */
+#define	AT91_TWI_IMR		0x002c	/* Interrupt Mask Register */
+#define	AT91_TWI_RHR		0x0030	/* Receive Holding Register */
+#define	AT91_TWI_THR		0x0034	/* Transmit Holding Register */
+
 struct at91_twi_dev {
 	struct device		*dev;
 	void __iomem		*base;
diff --git a/drivers/i2c/busses/i2c-at91.h b/drivers/i2c/busses/i2c-at91.h
deleted file mode 100644
index a898159..0000000
--- a/drivers/i2c/busses/i2c-at91.h
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * Copyright (C) 2005 Ivan Kokshaysky
- * Copyright (C) SAN People
- *
- * Two-wire Interface (TWI) registers.
- * Based on AT91RM9200 datasheet revision E.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91_TWI_H
-#define AT91_TWI_H
-
-#define	AT91_TWI_CR		0x00		/* Control Register */
-#define	AT91_TWI_START		(1 <<  0)	/* Send a Start Condition */
-#define	AT91_TWI_STOP		(1 <<  1)	/* Send a Stop Condition */
-#define	AT91_TWI_MSEN		(1 <<  2)	/* Master Transfer Enable */
-#define	AT91_TWI_MSDIS		(1 <<  3)	/* Master Transfer Disable */
-#define	AT91_TWI_SVEN		(1 <<  4)	/* Slave Transfer Enable
-						 *  [SAM9260 only] */
-#define	AT91_TWI_SVDIS		(1 <<  5)	/* Slave Transfer Disable
-						 *  [SAM9260 only] */
-#define	AT91_TWI_SWRST		(1 <<  7)	/* Software Reset */
-
-#define	AT91_TWI_MMR		0x04		/* Master Mode Register */
-#define	AT91_TWI_IADRSZ		(3    <<  8)	/* Internal Device Address
-						 *  Size */
-#define	AT91_TWI_IADRSZ_NO	(0 << 8)
-#define	AT91_TWI_IADRSZ_1	(1 << 8)
-#define	AT91_TWI_IADRSZ_2	(2 << 8)
-#define	AT91_TWI_IADRSZ_3	(3 << 8)
-#define	AT91_TWI_MREAD		(1    << 12)	/* Master Read Direction */
-#define	AT91_TWI_DADR		(0x7f << 16)	/* Device Address */
-
-#define	AT91_TWI_SMR		0x08		/* Slave Mode Register
-						 *  [SAM9260 only] */
-#define	AT91_TWI_SADR		(0x7f << 16)	/* Slave Address */
-
-#define	AT91_TWI_IADR		0x0c		/* Internal Address Register */
-
-#define	AT91_TWI_CWGR		0x10		/* Clock Waveform Generator
-						 *  Register */
-#define	AT91_TWI_CLDIV		(0xff <<  0)	/* Clock Low Divisor */
-#define	AT91_TWI_CHDIV		(0xff <<  8)	/* Clock High Divisor */
-#define	AT91_TWI_CKDIV		(7    << 16)	/* Clock Divider */
-
-#define	AT91_TWI_SR		0x20		/* Status Register */
-#define	AT91_TWI_TXCOMP		(1 <<  0)	/* Transmission Complete */
-#define	AT91_TWI_RXRDY		(1 <<  1)	/* Receive Holding Register
-						 *  Ready */
-#define	AT91_TWI_TXRDY		(1 <<  2)	/* Transmit Holding Register
-						 *  Ready */
-#define	AT91_TWI_SVREAD		(1 <<  3)	/* Slave Read [SAM9260 only] */
-#define	AT91_TWI_SVACC		(1 <<  4)	/* Slave Access
-						 *  [SAM9260 only] */
-#define	AT91_TWI_GACC		(1 <<  5)	/* General Call Access
-						 *  [SAM9260 only] */
-#define	AT91_TWI_OVRE		(1 <<  6)	/* Overrun Error
-						 *  [AT91RM9200 only] */
-#define	AT91_TWI_UNRE		(1 <<  7)	/* Underrun Error
-						 *  [AT91RM9200 only] */
-#define	AT91_TWI_NACK		(1 <<  8)	/* Not Acknowledged */
-#define	AT91_TWI_ARBLST		(1 <<  9)	/* Arbitration Lost
-						 *  [SAM9260 only] */
-#define	AT91_TWI_SCLWS		(1 << 10)	/* Clock Wait State
-						 *  [SAM9260 only] */
-#define	AT91_TWI_EOSACC		(1 << 11)	/* End of Slave Address
-						 *  [SAM9260 only] */
-
-#define	AT91_TWI_IER		0x24		/* Interrupt Enable Register */
-#define	AT91_TWI_IDR		0x28		/* Interrupt Disable Register */
-#define	AT91_TWI_IMR		0x2c		/* Interrupt Mask Register */
-#define	AT91_TWI_RHR		0x30		/* Receive Holding Register */
-#define	AT91_TWI_THR		0x34		/* Transmit Holding Register */
-
-#endif
-
-- 
1.7.5.4

