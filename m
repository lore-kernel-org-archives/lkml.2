Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab2IQBP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:15:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33663 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586Ab2IQAuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:25 -0400
Message-Id: <20120917003640.226414068@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo Van Doorn <ivdoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 101/135] rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit 6ced58a5dbb94dbfbea1b33ca3c56d1e929cd548 upstream.

The register is 16 bits wide, not 32.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo Van Doorn <ivdoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.h |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 3aae36b..b3a1d73 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -283,7 +283,7 @@ static int rt2500usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	u16 reg;
 
 	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
-	return rt2x00_get_field32(reg, MAC_CSR19_BIT7);
+	return rt2x00_get_field16(reg, MAC_CSR19_BIT7);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index b493306..192531d 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -189,14 +189,14 @@
  * MAC_CSR19: GPIO control register.
  */
 #define MAC_CSR19			0x0426
-#define MAC_CSR19_BIT0			FIELD32(0x0001)
-#define MAC_CSR19_BIT1			FIELD32(0x0002)
-#define MAC_CSR19_BIT2			FIELD32(0x0004)
-#define MAC_CSR19_BIT3			FIELD32(0x0008)
-#define MAC_CSR19_BIT4			FIELD32(0x0010)
-#define MAC_CSR19_BIT5			FIELD32(0x0020)
-#define MAC_CSR19_BIT6			FIELD32(0x0040)
-#define MAC_CSR19_BIT7			FIELD32(0x0080)
+#define MAC_CSR19_BIT0			FIELD16(0x0001)
+#define MAC_CSR19_BIT1			FIELD16(0x0002)
+#define MAC_CSR19_BIT2			FIELD16(0x0004)
+#define MAC_CSR19_BIT3			FIELD16(0x0008)
+#define MAC_CSR19_BIT4			FIELD16(0x0010)
+#define MAC_CSR19_BIT5			FIELD16(0x0020)
+#define MAC_CSR19_BIT6			FIELD16(0x0040)
+#define MAC_CSR19_BIT7			FIELD16(0x0080)
 
 /*
  * MAC_CSR20: LED control register.


