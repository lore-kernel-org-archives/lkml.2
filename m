Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0LDJQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 04:16:24 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:55611 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab0LDJQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 04:16:21 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 4/6] w35und: Kill struct hwdata ->NullPacketCount
Date: Sat,  4 Dec 2010 11:16:15 +0200
Message-Id: <1291454177-5102-4-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291454177-5102-1-git-send-email-penberg@kernel.org>
References: <1291454177-5102-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills the NullPacketCount member of struct hwdata. It's not used for
anything so it's safe to remove it.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/wbhal.h |    6 ------
 drivers/staging/winbond/wbusb.c |    9 ---------
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/winbond/wbhal.h b/drivers/staging/winbond/wbhal.h
index 821a1b3..6f4cd76 100644
--- a/drivers/staging/winbond/wbhal.h
+++ b/drivers/staging/winbond/wbhal.h
@@ -342,9 +342,6 @@ struct wb35_descriptor { /* Skip length = 8 DWORD */
 	void	*buffer_address[MAX_DESCRIPTOR_BUFFER_INDEX];
 };
 
-
-#define DEFAULT_NULL_PACKET_COUNT	180000	/* 180 seconds */
-
 #define MAX_TXVGA_EEPROM		9	/* How many word(u16) of EEPROM will be used for TxVGA */
 #define MAX_RF_PARAMETER		32
 
@@ -517,9 +514,6 @@ struct hw_data {
 
 	/* For error recover */
 	u32		HwStop;
-
-	/* For avoid AP disconnect */
-	u32		NullPacketCount;
 };
 
 #endif
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 82040f4..dcb6d5b 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -611,15 +611,6 @@ static void hal_led_control(unsigned long data)
 			}
 			break;
 		}
-
-		/* Active send null packet to avoid AP disconnect */
-		if (pHwData->LED_LinkOn) {
-			pHwData->NullPacketCount += TimeInterval;
-			if (pHwData->NullPacketCount >=
-			    DEFAULT_NULL_PACKET_COUNT) {
-				pHwData->NullPacketCount = 0;
-			}
-		}
 	}
 
 	pHwData->time_count += TimeInterval;
-- 
1.7.0.4

