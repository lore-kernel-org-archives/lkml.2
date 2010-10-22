Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab0JVV5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:57:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51103 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0JVV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Wf55D0YkmjI3g2NnwqQoTZjGw/nhWhkMFz2wNMTR7MpyllRHF1wIK6CySzVxtx8uEW
         1m/pBZxnCplY+NlCx8ZRCm9ZatzwdjohqargZF/Kp2jLmyhhJoTPim1ZC2MgjuIZTmPd
         5KLtsPkw/LdxN1bUEo1w2JbgkyfBJjxrHzuww=
From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Subject: [PATCH] rtc: rs5c313: Replase from ctrl_* to __raw_*
Date: Sat, 23 Oct 2010 07:01:54 +0900
Message-Id: <1287784914-5714-1-git-send-email-iwamatsu@nigauri.org>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ctrl_* is deprecated. We should to use __raw_*.

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
---
 drivers/rtc/rtc-rs5c313.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c313.c b/drivers/rtc/rtc-rs5c313.c
index e6ea3f5..49ec910 100644
--- a/drivers/rtc/rtc-rs5c313.c
+++ b/drivers/rtc/rtc-rs5c313.c
@@ -1,6 +1,6 @@
 /*
  * Ricoh RS5C313 RTC device/driver
- *  Copyright (C) 2007 Nobuhiro Iwamatsu
+ *  Copyright (C) 2007, 2010 Nobuhiro Iwamatsu
  *
  *  2005-09-19 modifed by kogiidena
  *
@@ -80,21 +80,21 @@
 /* SCSPTR1 data */
 unsigned char scsptr1_data;
 
-#define RS5C313_CEENABLE    ctrl_outb(RS5C313_CE_RTCCE, RS5C313_CE);
-#define RS5C313_CEDISABLE   ctrl_outb(0x00, RS5C313_CE)
-#define RS5C313_MISCOP      ctrl_outb(0x02, 0xB0000008)
+#define RS5C313_CEENABLE    __raw_writeb(RS5C313_CE_RTCCE, RS5C313_CE);
+#define RS5C313_CEDISABLE   __raw_writeb(0x00, RS5C313_CE)
+#define RS5C313_MISCOP      __raw_writeb(0x02, 0xB0000008)
 
 static void rs5c313_init_port(void)
 {
 	/* Set SCK as I/O port and Initialize SCSPTR1 data & I/O port. */
-	ctrl_outb(ctrl_inb(SCSMR1) & ~SCSMR1_CA, SCSMR1);
-	ctrl_outb(ctrl_inb(SCSCR1) & ~SCSCR1_CKE, SCSCR1);
+	__raw_writeb(__raw_readb(SCSMR1) & ~SCSMR1_CA, SCSMR1);
+	__raw_writeb(__raw_readb(SCSCR1) & ~SCSCR1_CKE, SCSCR1);
 
 	/* And Initialize SCL for RS5C313 clock */
-	scsptr1_data = ctrl_inb(SCSPTR1) | SCL;	/* SCL:H */
-	ctrl_outb(scsptr1_data, SCSPTR1);
-	scsptr1_data = ctrl_inb(SCSPTR1) | SCL_OEN;	/* SCL output enable */
-	ctrl_outb(scsptr1_data, SCSPTR1);
+	scsptr1_data = __raw_readb(SCSPTR1) | SCL;	/* SCL:H */
+	__raw_writeb(scsptr1_data, SCSPTR1);
+	scsptr1_data = __raw_readb(SCSPTR1) | SCL_OEN;	/* SCL output enable */
+	__raw_writeb(scsptr1_data, SCSPTR1);
 	RS5C313_CEDISABLE;	/* CE:L */
 }
 
@@ -106,21 +106,21 @@ static void rs5c313_write_data(unsigned char data)
 		/* SDA:Write Data */
 		scsptr1_data = (scsptr1_data & ~SDA) |
 				((((0x80 >> i) & data) >> (7 - i)) << 2);
-		ctrl_outb(scsptr1_data, SCSPTR1);
+		__raw_writeb(scsptr1_data, SCSPTR1);
 		if (i == 0) {
 			scsptr1_data |= SDA_OEN;	/* SDA:output enable */
-			ctrl_outb(scsptr1_data, SCSPTR1);
+			__raw_writeb(scsptr1_data, SCSPTR1);
 		}
 		ndelay(700);
 		scsptr1_data &= ~SCL;	/* SCL:L */
-		ctrl_outb(scsptr1_data, SCSPTR1);
+		__raw_writeb(scsptr1_data, SCSPTR1);
 		ndelay(700);
 		scsptr1_data |= SCL;	/* SCL:H */
-		ctrl_outb(scsptr1_data, SCSPTR1);
+		__raw_writeb(scsptr1_data, SCSPTR1);
 	}
 
 	scsptr1_data &= ~SDA_OEN;	/* SDA:output disable */
-	ctrl_outb(scsptr1_data, SCSPTR1);
+	__raw_writeb(scsptr1_data, SCSPTR1);
 }
 
 static unsigned char rs5c313_read_data(void)
@@ -131,12 +131,12 @@ static unsigned char rs5c313_read_data(void)
 	for (i = 0; i < 8; i++) {
 		ndelay(700);
 		/* SDA:Read Data */
-		data |= ((ctrl_inb(SCSPTR1) & SDA) >> 2) << (7 - i);
+		data |= ((__raw_readb(SCSPTR1) & SDA) >> 2) << (7 - i);
 		scsptr1_data &= ~SCL;	/* SCL:L */
-		ctrl_outb(scsptr1_data, SCSPTR1);
+		__raw_writeb(scsptr1_data, SCSPTR1);
 		ndelay(700);
 		scsptr1_data |= SCL;	/* SCL:H */
-		ctrl_outb(scsptr1_data, SCSPTR1);
+		__raw_writeb(scsptr1_data, SCSPTR1);
 	}
 	return data & 0x0F;
 }
-- 
1.7.2.3

