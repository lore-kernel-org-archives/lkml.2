Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab0D3RRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:17:49 -0400
Received: from smtp.nokia.com ([192.100.122.230]:62611 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982Ab0D3RRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:17:31 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Duncan Sands <duncan.sands@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 03/10] usb: atm: speedtch: use new hex_to_bin() method
Date: Fri, 30 Apr 2010 12:34:02 +0300
Message-Id: <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:04.0804 (UTC) FILETIME=[464A3C40:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using own implementation which potentialy has bugs involve
hex_to_bin() function. It requires to have hex_to_bin() implementation
introduced by starter patch in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Duncan Sands <duncan.sands@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/usb/atm/speedtch.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 1e9ba4b..1335456 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -127,8 +127,6 @@ MODULE_PARM_DESC(ModemOption, "default: 0x10,0x00,0x00,0x00,0x20");
 #define ENDPOINT_ISOC_DATA	0x07
 #define ENDPOINT_FIRMWARE	0x05
 
-#define hex2int(c) ( (c >= '0') && (c <= '9') ? (c - '0') : ((c & 0xf) + 9) )
-
 struct speedtch_params {
 	unsigned int altsetting;
 	unsigned int BMaxDSL;
@@ -669,7 +667,8 @@ static int speedtch_atm_start(struct usbatm_data *usbatm, struct atm_dev *atm_de
 	memset(atm_dev->esi, 0, sizeof(atm_dev->esi));
 	if (usb_string(usb_dev, usb_dev->descriptor.iSerialNumber, mac_str, sizeof(mac_str)) == 12) {
 		for (i = 0; i < 6; i++)
-			atm_dev->esi[i] = (hex2int(mac_str[i * 2]) * 16) + (hex2int(mac_str[i * 2 + 1]));
+			atm_dev->esi[i] = (hex_to_bin(mac_str[i * 2]) << 4) +
+				hex_to_bin(mac_str[i * 2 + 1]);
 	}
 
 	/* Start modem synchronisation */
-- 
1.6.3.3

