Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1IWLcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:32:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:31662 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1IWLcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:32:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="54926703"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH] alsa: 6fire: don't use custom hex_to_bin()
Date: Fri, 23 Sep 2011 14:32:11 +0300
Message-Id: <e23268a9c837d75a24c2d209f1623c505371eb1d.1316777507.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
 sound/usb/6fire/firmware.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/sound/usb/6fire/firmware.c b/sound/usb/6fire/firmware.c
index 3ebbdec..3b5f517 100644
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -17,6 +17,7 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/bitrev.h>
+#include <linux/kernel.h>
 
 #include "firmware.h"
 #include "chip.h"
@@ -60,21 +61,19 @@ struct ihex_record {
 	unsigned int txt_offset; /* current position in txt_data */
 };
 
-static u8 usb6fire_fw_ihex_nibble(const u8 n)
-{
-	if (n >= '0' && n <= '9')
-		return n - '0';
-	else if (n >= 'A' && n <= 'F')
-		return n - ('A' - 10);
-	else if (n >= 'a' && n <= 'f')
-		return n - ('a' - 10);
-	return 0;
-}
-
 static u8 usb6fire_fw_ihex_hex(const u8 *data, u8 *crc)
 {
-	u8 val = (usb6fire_fw_ihex_nibble(data[0]) << 4) |
-			usb6fire_fw_ihex_nibble(data[1]);
+	u8 val = 0;
+	int hval;
+
+	hval = hex_to_bin(data[0]);
+	if (hval >= 0)
+		val |= (hval << 4);
+
+	hval = hex_to_bin(data[1]);
+	if (hval >= 0)
+		val |= hval;
+
 	*crc += val;
 	return val;
 }
-- 
1.7.6.3

