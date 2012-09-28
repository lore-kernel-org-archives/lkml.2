Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030207Ab2I1TBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:01:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030191Ab2I1TBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo Van Doorn <ivdoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 147/262] rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
Date: Fri, 28 Sep 2012 11:51:16 -0700
Message-Id: <20120928183015.426695824@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit 6ced58a5dbb94dbfbea1b33ca3c56d1e929cd548 upstream.

The register is 16 bits wide, not 32.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo Van Doorn <ivdoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.h |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -283,7 +283,7 @@ static int rt2500usb_rfkill_poll(struct
 	u16 reg;
 
 	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
-	return rt2x00_get_field32(reg, MAC_CSR19_BIT7);
+	return rt2x00_get_field16(reg, MAC_CSR19_BIT7);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
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


