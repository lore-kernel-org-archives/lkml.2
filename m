Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1I0Lve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:51:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:24481 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab1I0Lvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:51:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,449,1312182000"; 
   d="scan'208";a="56133593"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHv2] wireless: at76c50x: use native hex_pack_byte() method
Date: Tue, 27 Sep 2011 14:51:02 +0300
Message-Id: <a1f4782ddfc14a689a056a911f1efac6e9e9a6da.1317124055.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <71d8213731be21f26a82255a4fffdbe1b6dd4a44.1316774801.git.andriy.shevchenko@linux.intel.com>
References: <71d8213731be21f26a82255a4fffdbe1b6dd4a44.1316774801.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/at76c50x-usb.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 2986014..96daaad 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -500,7 +500,6 @@ exit:
 
 #define HEX2STR_BUFFERS 4
 #define HEX2STR_MAX_LEN 64
-#define BIN2HEX(x) ((x) < 10 ? '0' + (x) : (x) + 'A' - 10)
 
 /* Convert binary data into hex string */
 static char *hex2str(void *buf, int len)
@@ -514,18 +513,15 @@ static char *hex2str(void *buf, int len)
 	if (len > HEX2STR_MAX_LEN)
 		len = HEX2STR_MAX_LEN;
 
-	if (len <= 0) {
-		ret[0] = '\0';
-		return ret;
-	}
-
 	while (len--) {
-		*obuf++ = BIN2HEX(*ibuf >> 4);
-		*obuf++ = BIN2HEX(*ibuf & 0xf);
+		obuf = pack_hex_byte(obuf, *ibuf++);
 		*obuf++ = '-';
-		ibuf++;
 	}
-	*(--obuf) = '\0';
+
+	if (*obuf == '-')
+		obuf--;
+
+	*obuf = '\0';
 
 	return ret;
 }
-- 
1.7.6.3

