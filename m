Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab0D3RJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:09:22 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61176 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab0D3RIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:08:42 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/10] staging: rt2860: use new hex_to_bin() method
Date: Fri, 30 Apr 2010 12:34:06 +0300
Message-Id: <d6886a8b94bf8726d7bde807b3ca19f65739ce4d.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <7cd86c01ad4a376fb8a48ffe307ce7c0510cecc0.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <c1ca828fb308042aa32428b345abcb43ccb02c39.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <2eb558b7b0b20dfea0b61223db6146cb8fdbe52d.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <7cd86c01ad4a376fb8a48ffe307ce7c0510cecc0.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:05.0679 (UTC) FILETIME=[46CFBFF0:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using own implementation involve hex_to_bin() function.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/staging/rt2860/common/rtmp_init.c |   15 ++-------------
 drivers/staging/rt2860/rtmp.h             |    2 --
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index 21a95ff..a090385 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -2810,17 +2810,6 @@ void UserCfgInit(struct rt_rtmp_adapter *pAd)
 }
 
 /* IRQL = PASSIVE_LEVEL */
-u8 BtoH(char ch)
-{
-	if (ch >= '0' && ch <= '9')
-		return (ch - '0');	/* Handle numerals */
-	if (ch >= 'A' && ch <= 'F')
-		return (ch - 'A' + 0xA);	/* Handle capitol hex digits */
-	if (ch >= 'a' && ch <= 'f')
-		return (ch - 'a' + 0xA);	/* Handle small hex digits */
-	return (255);
-}
-
 /* */
 /*  FUNCTION: AtoH(char *, u8 *, int) */
 /* */
@@ -2847,8 +2836,8 @@ void AtoH(char *src, u8 *dest, int destlen)
 	destTemp = (u8 *)dest;
 
 	while (destlen--) {
-		*destTemp = BtoH(*srcptr++) << 4;	/* Put 1st ascii byte in upper nibble. */
-		*destTemp += BtoH(*srcptr++);	/* Add 2nd ascii byte to above. */
+		*destTemp = hex_to_bin(*srcptr++) << 4;	/* Put 1st ascii byte in upper nibble. */
+		*destTemp += hex_to_bin(*srcptr++);	/* Add 2nd ascii byte to above. */
 		destTemp++;
 	}
 }
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 4401a55..73bf325 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2367,8 +2367,6 @@ void RTMPMoveMemory(void *pDest, void *pSrc, unsigned long Length);
 
 void AtoH(char *src, u8 *dest, int destlen);
 
-u8 BtoH(char ch);
-
 void RTMPPatchMacBbpBug(struct rt_rtmp_adapter *pAd);
 
 void RTMPInitTimer(struct rt_rtmp_adapter *pAd,
-- 
1.6.3.3

