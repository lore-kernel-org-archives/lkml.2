Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab0DDFXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 01:23:17 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:64075 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0DDFXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 01:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=n3I7j2LTlmlJA959km0Zr5sd/ASnvNy+k6Zuaici91GfUqnHBeFasbeZ2bQ5qlk6gg
         ecPDGG2jTLVC1Yujh5lRHExeFfeVgOhdfQfbMx6mSjXvaQ3rTG4e64vqgaj/AqKNYB1D
         M3J10Jb1s0FZ3xAEBnXvzA6K8pV2XXUPB9wnw=
From: Vikram Dhillon <opensolarisdev@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Vikram Dhillon <opensolarisdev@gmail.com>
Subject: [PATCH 4/4] Staging: Otus: Hal: hpani.c Fixed some style issues
Date: Sun,  4 Apr 2010 01:22:53 -0400
Message-Id: <1270358573-5528-1-git-send-email-opensolarisdev@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some style issues in accordance with checkpatch.pl

Signed-by: Vikram Dhillon <opensolarisdev@gmail.com>
---
 drivers/staging/otus/hal/hpani.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/otus/hal/hpani.c b/drivers/staging/otus/hal/hpani.c
index 0afecd8..4df7704 100644
--- a/drivers/staging/otus/hal/hpani.c
+++ b/drivers/staging/otus/hal/hpani.c
@@ -18,8 +18,8 @@
 #include "hpusb.h"
 
 
-extern u16_t zfDelayWriteInternalReg(zdev_t* dev, u32_t addr, u32_t val);
-extern u16_t zfFlushDelayWrite(zdev_t* dev);
+extern u16_t zfDelayWriteInternalReg(zdev_t *dev, u32_t addr, u32_t val);
+extern u16_t zfFlushDelayWrite(zdev_t *dev);
 
 /*
  * Anti noise immunity support.  We track phy errors and react
@@ -52,13 +52,13 @@ extern u16_t zfFlushDelayWrite(zdev_t* dev);
 #define ZM_HAL_EP_RND(x, mul) \
     ((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
 
-s32_t BEACON_RSSI(zdev_t* dev)
+s32_t BEACON_RSSI(zdev_t *dev)
 {
     s32_t rssi;
     struct zsHpPriv *HpPriv;
 
     zmw_get_wlan_dev(dev);
-    HpPriv = (struct zsHpPriv*)wd->hpPrivate;
+    HpPriv = (struct zsHpPriv *)wd->hpPrivate;
 
     rssi = ZM_HAL_EP_RND(HpPriv->stats.ast_nodestats.ns_avgbrssi, ZM_HAL_RSSI_EP_MULTIPLIER);
 
@@ -70,7 +70,7 @@ s32_t BEACON_RSSI(zdev_t* dev)
  * resets the channel statistics
  */
 
-void zfHpAniAttach(zdev_t* dev)
+void zfHpAniAttach(zdev_t *dev)
 {
 #define N(a)     (sizeof(a) / sizeof(a[0]))
     u32_t i;
@@ -82,11 +82,10 @@ void zfHpAniAttach(zdev_t* dev)
     const int firpwr[]           = { -78, -78, -78, -78, -80 };
 
     zmw_get_wlan_dev(dev);
-    HpPriv = (struct zsHpPriv*)wd->hpPrivate;
+    HpPriv = (struct zsHpPriv *)wd->hpPrivate;
 
-    for (i = 0; i < 5; i++)
-    {
-        HpPriv->totalSizeDesired[i] = totalSizeDesired[i];
+    for (i = 0; i < 5; i++) {
+	HpPriv->totalSizeDesired[i] = totalSizeDesired[i];
         HpPriv->coarseHigh[i] = coarseHigh[i];
         HpPriv->coarseLow[i] = coarseLow[i];
         HpPriv->firpwr[i] = firpwr[i];
@@ -96,8 +95,7 @@ void zfHpAniAttach(zdev_t* dev)
     HpPriv->hasHwPhyCounters = 1;
 
     memset((char *)&HpPriv->ani, 0, sizeof(HpPriv->ani));
-    for (i = 0; i < N(wd->regulationTable.allowChannel); i++)
-    {
+    for (i = 0; i < N(wd->regulationTable.allowChannel); i++) {
         /* New ANI stuff */
         HpPriv->ani[i].ofdmTrigHigh = ZM_HAL_ANI_OFDM_TRIG_HIGH;
         HpPriv->ani[i].ofdmTrigLow = ZM_HAL_ANI_OFDM_TRIG_LOW;
@@ -109,14 +107,12 @@ void zfHpAniAttach(zdev_t* dev)
         HpPriv->ani[i].cckWeakSigThreshold = ZM_HAL_ANI_CCK_WEAK_SIG_THR;
         HpPriv->ani[i].spurImmunityLevel = ZM_HAL_ANI_SPUR_IMMUNE_LVL;
         HpPriv->ani[i].firstepLevel = ZM_HAL_ANI_FIRSTEP_LVL;
-        if (HpPriv->hasHwPhyCounters)
-        {
+        if (HpPriv->hasHwPhyCounters) {
             HpPriv->ani[i].ofdmPhyErrBase = 0;//AR_PHY_COUNTMAX - ZM_HAL_ANI_OFDM_TRIG_HIGH;
             HpPriv->ani[i].cckPhyErrBase = 0;//AR_PHY_COUNTMAX - ZM_HAL_ANI_CCK_TRIG_HIGH;
         }
     }
-    if (HpPriv->hasHwPhyCounters)
-    {
+    if (HpPriv->hasHwPhyCounters) {
         //zm_debug_msg2("Setting OfdmErrBase = 0x", HpPriv->ani[0].ofdmPhyErrBase);
         //zm_debug_msg2("Setting cckErrBase = 0x", HpPriv->ani[0].cckPhyErrBase);
         //OS_REG_WRITE(ah, AR_PHY_ERR_1, HpPriv->ani[0].ofdmPhyErrBase);
@@ -135,7 +131,7 @@ void zfHpAniAttach(zdev_t* dev)
 /*
  * Control Adaptive Noise Immunity Parameters
  */
-u8_t zfHpAniControl(zdev_t* dev, ZM_HAL_ANI_CMD cmd, int param)
+u8_t zfHpAniControl(zdev_t *dev, ZM_HAL_ANI_CMD cmd, int param)
 {
 #define N(a) (sizeof(a)/sizeof(a[0]))
     typedef s32_t TABLE[];
@@ -143,7 +139,7 @@ u8_t zfHpAniControl(zdev_t* dev, ZM_HAL_ANI_CMD cmd, int param)
     struct zsAniState *aniState;
 
     zmw_get_wlan_dev(dev);
-    HpPriv = (struct zsHpPriv*)wd->hpPrivate;
+    HpPriv = (struct zsHpPriv *)wd->hpPrivate;
     aniState = HpPriv->curani;
 
     switch (cmd)
@@ -152,8 +148,7 @@ u8_t zfHpAniControl(zdev_t* dev, ZM_HAL_ANI_CMD cmd, int param)
     {
         u32_t level = param;
 
-        if (level >= N(HpPriv->totalSizeDesired))
-        {
+        if (level >= N(HpPriv->totalSizeDesired)) {
           zm_debug_msg1("level out of range, desired level : ", level);
           zm_debug_msg1("max level : ", N(HpPriv->totalSizeDesired));
           return FALSE;
-- 
1.6.3.3

