Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1IWKsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:48:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:46440 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab1IWKsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:48:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,428,1312182000"; 
   d="scan'208";a="68908874"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/2] wireless: at76c50x: use native hex_pack_byte() method
Date: Fri, 23 Sep 2011 13:47:27 +0300
Message-Id: <71d8213731be21f26a82255a4fffdbe1b6dd4a44.1316774801.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <fa146966b0ce1e7f04d59eb27cc0e968f51b22de.1316774801.git.andriy.shevchenko@linux.intel.com>
References: <20110919232602.ac450450.akpm00@gmail.com>
 <fa146966b0ce1e7f04d59eb27cc0e968f51b22de.1316774801.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <fa146966b0ce1e7f04d59eb27cc0e968f51b22de.1316774801.git.andriy.shevchenko@linux.intel.com>
References: <fa146966b0ce1e7f04d59eb27cc0e968f51b22de.1316774801.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/at76c50x-usb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 2986014..157507a6 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -500,7 +500,6 @@ exit:
 
 #define HEX2STR_BUFFERS 4
 #define HEX2STR_MAX_LEN 64
-#define BIN2HEX(x) ((x) < 10 ? '0' + (x) : (x) + 'A' - 10)
 
 /* Convert binary data into hex string */
 static char *hex2str(void *buf, int len)
@@ -520,10 +519,8 @@ static char *hex2str(void *buf, int len)
 	}
 
 	while (len--) {
-		*obuf++ = BIN2HEX(*ibuf >> 4);
-		*obuf++ = BIN2HEX(*ibuf & 0xf);
+		obuf = hex_pack_byte(obuf, *ibuf++);
 		*obuf++ = '-';
-		ibuf++;
 	}
 	*(--obuf) = '\0';
 
-- 
1.7.6.3

