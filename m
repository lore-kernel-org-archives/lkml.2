Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab0F1L5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:57:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0F1LzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s4aqItmP/uetFo8X3IVtdLG4utBidrSHuoJevc2NYtVGqHQ8oFVOsdEOnMKuAW0jFt
         NM2QySGVpSRRTd4VL3Zh0nTHfJsLIkirYJbXsvylheLT17R9iAAJjFqYUeazg6TBvsnJ
         5+CLwllfWZcgqzn1qYQnn7Vh9z6wS7wz/3+P8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kulikov Vasiliy <segooon@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dan Carpenter <error27@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:16 +0400
Message-Id: <1277726117-24699-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/otus/hal/hpani.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/otus/hal/hpani.c b/drivers/staging/otus/hal/hpani.c
index f53e483..9b9420c 100644
--- a/drivers/staging/otus/hal/hpani.c
+++ b/drivers/staging/otus/hal/hpani.c
@@ -72,7 +72,6 @@ s32_t BEACON_RSSI(zdev_t *dev)
 
 void zfHpAniAttach(zdev_t *dev)
 {
-#define N(a)     (sizeof(a) / sizeof(a[0]))
     u32_t i;
     struct zsHpPriv *HpPriv;
 
@@ -125,7 +124,6 @@ void zfHpAniAttach(zdev_t *dev)
     HpPriv->stats.ast_nodestats.ns_avgbrssi = ZM_RSSI_DUMMY_MARKER;
     HpPriv->stats.ast_nodestats.ns_avgrssi = ZM_RSSI_DUMMY_MARKER;
     HpPriv->stats.ast_nodestats.ns_avgtxrssi = ZM_RSSI_DUMMY_MARKER;
-#undef N
 }
 
 /*
@@ -133,7 +131,6 @@ void zfHpAniAttach(zdev_t *dev)
  */
 u8_t zfHpAniControl(zdev_t *dev, ZM_HAL_ANI_CMD cmd, int param)
 {
-#define N(a) (sizeof(a)/sizeof(a[0]))
     typedef s32_t TABLE[];
     struct zsHpPriv *HpPriv;
     struct zsAniState *aniState;
@@ -148,9 +145,9 @@ u8_t zfHpAniControl(zdev_t *dev, ZM_HAL_ANI_CMD cmd, int param)
     {
         u32_t level = param;
 
-        if (level >= N(HpPriv->totalSizeDesired)) {
+        if (level >= ARRAY_SIZE(HpPriv->totalSizeDesired)) {
           zm_debug_msg1("level out of range, desired level : ", level);
-          zm_debug_msg1("max level : ", N(HpPriv->totalSizeDesired));
+          zm_debug_msg1("max level : ", ARRAY_SIZE(HpPriv->totalSizeDesired));
           return FALSE;
         }
 
@@ -260,10 +257,10 @@ u8_t zfHpAniControl(zdev_t *dev, ZM_HAL_ANI_CMD cmd, int param)
         const TABLE firstep = { 0, 4, 8 };
         u32_t level = param;
 
-        if (level >= N(firstep))
+        if (level >= ARRAY_SIZE(firstep))
         {
             zm_debug_msg1("level out of range, desired level : ", level);
-            zm_debug_msg1("max level : ", N(firstep));
+            zm_debug_msg1("max level : ", ARRAY_SIZE(firstep));
             return FALSE;
         }
         zfDelayWriteInternalReg(dev, AR_PHY_FIND_SIG,
@@ -283,10 +280,10 @@ u8_t zfHpAniControl(zdev_t *dev, ZM_HAL_ANI_CMD cmd, int param)
         const TABLE cycpwrThr1 = { 2, 4, 6, 8, 10, 12, 14, 16 };
         u32_t level = param;
 
-        if (level >= N(cycpwrThr1))
+        if (level >= ARRAY_SIZE(cycpwrThr1))
         {
             zm_debug_msg1("level out of range, desired level : ", level);
-            zm_debug_msg1("max level : ", N(cycpwrThr1));
+            zm_debug_msg1("max level : ", ARRAY_SIZE(cycpwrThr1));
             return FALSE;
         }
         zfDelayWriteInternalReg(dev, AR_PHY_TIMING5,
@@ -335,7 +332,6 @@ u8_t zfHpAniControl(zdev_t *dev, ZM_HAL_ANI_CMD cmd, int param)
         return FALSE;
     }
     return TRUE;
-#undef  N
 }
 
 void zfHpAniRestart(zdev_t* dev)
-- 
1.7.0.4

