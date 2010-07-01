Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0GALXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:23:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0GALXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oiGw224TwRbodxnlyDwMUeaW2ch//bl5amMnhrOww4m+aUcXFfYsUxeJ0iH1npgGcF
         vIjsRKky4DizQx72pkh0KOHd1xmzb24wlxjXGvxCgKqNF56svJywJQV1bububZtzuT2N
         HwsbT2NEkHeaiAQBcixrWrhPSGkuZCpGF1kEo=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Simon Horman <horms@verge.net.au>,
       Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/16] staging/otus: use ARRAY_SIZE
Date: Thu,  1 Jul 2010 15:22:55 +0400
Message-Id: <1277983377-29390-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/otus/hal/hpmain.c |   42 ++++++++----------------------------
 1 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/otus/hal/hpmain.c b/drivers/staging/otus/hal/hpmain.c
index 5f412e0..cc543fd 100644
--- a/drivers/staging/otus/hal/hpmain.c
+++ b/drivers/staging/otus/hal/hpmain.c
@@ -430,7 +430,7 @@ void zfInitPhy(zdev_t* dev,  u32_t frequency, u8_t bw40)
      * Register setting by mode
      */
 
-    entries = sizeof(ar5416Modes) / sizeof(*ar5416Modes);
+    entries = ARRAY_SIZE(ar5416Modes);
     zm_msg1_scan(ZM_LV_2, "Modes register setting entries=", entries);
     for (i=0; i<entries; i++)
     {
@@ -496,7 +496,7 @@ void zfInitPhy(zdev_t* dev,  u32_t frequency, u8_t bw40)
     /*
      * Common Register setting
      */
-    entries = sizeof(ar5416Common) / sizeof(*ar5416Common);
+    entries = ARRAY_SIZE(ar5416Common);
     for (i=0; i<entries; i++)
     {
         reg_write(ar5416Common[i][0], ar5416Common[i][1]);
@@ -506,7 +506,7 @@ void zfInitPhy(zdev_t* dev,  u32_t frequency, u8_t bw40)
     /*
      * RF Gain setting by freqIndex
      */
-    entries = sizeof(ar5416BB_RfGain) / sizeof(*ar5416BB_RfGain);
+    entries = ARRAY_SIZE(ar5416BB_RfGain);
     for (i=0; i<entries; i++)
     {
         reg_write(ar5416BB_RfGain[i][0], ar5416BB_RfGain[i][freqIndex]);
@@ -963,7 +963,6 @@ u32_t reverse_bits(u32_t chan_sel)
 /* Bank 0 1 2 3 5 6 7 */
 void zfSetRfRegs(zdev_t* dev, u32_t frequency)
 {
-    u16_t entries;
     u16_t freqIndex = 0;
     u16_t i;
 
@@ -984,51 +983,30 @@ void zfSetRfRegs(zdev_t* dev, u32_t frequency)
     }
 
 #if 1
-    entries = sizeof(otusBank) / sizeof(*otusBank);
-    for (i=0; i<entries; i++)
-    {
+    for (i = 0; i < ARRAY_SIZE(otusBank); i++)
         reg_write(otusBank[i][0], otusBank[i][freqIndex]);
-    }
 #else
     /* Bank0 */
-    entries = sizeof(ar5416Bank0) / sizeof(*ar5416Bank0);
-    for (i=0; i<entries; i++)
-    {
+    for (i = 0; i < ARRAY_SIZE(ar5416Bank0); i++)
         reg_write(ar5416Bank0[i][0], ar5416Bank0[i][1]);
-    }
     /* Bank1 */
-    entries = sizeof(ar5416Bank1) / sizeof(*ar5416Bank1);
-    for (i=0; i<entries; i++)
-    {
+    for (i = 0; i < ARRAY_SIZE(ar5416Bank1); i++)
         reg_write(ar5416Bank1[i][0], ar5416Bank1[i][1]);
-    }
     /* Bank2 */
-    entries = sizeof(ar5416Bank2) / sizeof(*ar5416Bank2);
-    for (i=0; i<entries; i++)
-    {
+    for (i = 0; i < ARRAY_SIZE(ar5416Bank2); i++)
         reg_write(ar5416Bank2[i][0], ar5416Bank2[i][1]);
-    }
     /* Bank3 */
-    entries = sizeof(ar5416Bank3) / sizeof(*ar5416Bank3);
-    for (i=0; i<entries; i++)
-    {
+    for (i = 0; i < ARRAY_SIZE(ar5416Bank3); i++)
         reg_write(ar5416Bank3[i][0], ar5416Bank3[i][freqIndex]);
-    }
     /* Bank5 */
     reg_write (0x98b0,  0x00000013);
     reg_write (0x98e4,  0x00000002);
     /* Bank6 */
-    entries = sizeof(ar5416Bank6) / sizeof(*ar5416Bank6);
-    for (i=0; i<entries; i++)
-    {
+    for (i = 0; i < ARRAY_SIZE(ar5416Bank6); i++)
         reg_write(ar5416Bank6[i][0], ar5416Bank6[i][freqIndex]);
-    }
     /* Bank7 */
-    entries = sizeof(ar5416Bank7) / sizeof(*ar5416Bank7);
-    for (i=0; i<entries; i++)
-    {
+    for (i = 0; i < ARRAY_SIZE(ar5416Bank7); i++)
         reg_write(ar5416Bank7[i][0], ar5416Bank7[i][1]);
-    }
 #endif
 
     zfFlushDelayWrite(dev);
-- 
1.7.0.4

