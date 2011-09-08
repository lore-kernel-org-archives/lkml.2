Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1IHW76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 18:59:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57334 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754013Ab1IHW7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 18:59:17 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19aodsf7uta1TuIucnPDR4/2aYO7kmlahTz1Tc6kJ
	ET3boitfcVVabq
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <apatard@mandriva.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Daniel Kenji Toyama <kenji.toyama@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/xgifb: Remove dead code in vb_def.h
Date: Thu,  8 Sep 2011 19:32:30 +0200
Message-Id: <1315503150-22785-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xgifb/vb_def.h NewScratch is always defined, due to these lines at
the beginning of the file:
 #ifndef NewScratch
 #define NewScratch
 #endif

Thus we can eliminate all #else branches of #ifndef NewScratch
and since the NewScratch define isn't used anywhere else we can remove
it too.

This patch removes the dead defines in vb_def.h
Found using undertaker:
http://vamos.informatik.uni-erlangen.de/trac/undertaker/

KernelVersion: linux-staging 20110825

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_def.h |   75 ----------------------------------------
 1 files changed, 0 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index 339c071..43a2dfc 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -3,9 +3,6 @@
 #ifndef _INITDEF_
 #define _INITDEF_
 
-#ifndef NewScratch
-#define NewScratch
-#endif
 /* shampoo */
 
 #define SEQ_ADDRESS_PORT            0x0014
@@ -616,16 +613,13 @@
 #define Monitor1Sense        0x20
 #define HiTVSense            0x40
 
-#ifdef NewScratch
 #define YPbPrSense           0x80   /* NEW SCRATCH */
-#endif
 
 #define TVSense              0xc7
 
 #define TVOverScan           0x10               /* CR35 */
 #define TVOverScanShift      4
 
-#ifdef NewScratch
 #define NTSCMode             0x00
 #define PALMode              0x00
 #define NTSCJMode            0x02
@@ -635,9 +629,6 @@
 #define YPbPrMode525p        0x20
 #define YPbPrMode750p        0x40
 #define YPbPrMode1080i       0x60
-#else                    /* Old Scratch */
-#define ClearBufferFlag      0x20
-#endif
 
 
 #define LCDRGB18Bit          0x01               /* CR37 */
@@ -647,19 +638,10 @@
 #define LCDSyncBit           0xe0 /* H/V polarity & sync ID */
 #define LCDSyncShift         6
 
-#ifdef NewScratch
 #define ScalingLCD           0x08
-#else  /* Old Scratch */
-#define ExtChipType          0x0e
-#define ExtChip301           0x02
-#define ExtChipLVDS          0x04
-#define ExtChipCH7019        0x06
-#define ScalingLCD           0x10
-#endif
 
 #define EnableDualEdge       0x01 /* CR38 */
 #define SetToLCDA            0x02
-#ifdef NewScratch
 #define SetYPbPr             0x04
 #define DisableChannelA      0x08
 #define DisableChannelB      0x10
@@ -667,16 +649,6 @@
 #define ExtChip301           0x20
 #define ExtChipLVDS          0x40
 #define ExtChipCH7019        0x60
-#else                    /* Old Scratch */
-#define YPbPrSense           0x04
-#define SetYPbPr             0x08
-#define YPbPrMode            0x30
-#define YPbPrMode525i        0x00
-#define YPbPrMode525p        0x10
-#define YPbPrMode750p        0x20
-#define YPbPrMode1080i       0x30
-#define PALMNMode            0xc0
-#endif
 
 #define BacklightControlBit  0x01 /* CR3A */
 #define Win9xforJap          0x40
@@ -694,7 +666,6 @@
 #define EnableForceMDinBIOS  0x40
 #define EnableForceMDinDrv   0x80
 
-#ifdef NewScratch /* New Scratch */
 /* ---------------------- VUMA Information */
 #define LCDSettingFromCMOS    0x04 /* CR3C */
 #define TVSettingFromCMOS     0x08
@@ -730,52 +701,6 @@
 #define StartOSDEvent         0x04
 #define IgnoreHKEvent         0x08
 #define IgnoreOSDEvent        0x10
-#else                    /* Old Scratch */
-#define OSD_SBIOS               0x02 /* SR17 */
-#define DisableLogo             0x04
-#define SelectKDOS              0x08
-#define KorWinMode              0x10
-#define KorMode3Bit             0x0020
-#define PSCCtrlBit              0x40
-#define NPSCCtrlBitShift        6
-#define BlueScreenBit           0x80
-
-#define HKEvent                 0x0f /* CR79 */
-#define HK_ModeSwitch           0x01
-#define HK_Expanding            0x02
-#define HK_OverScan             0x03
-#define HK_Brightness           0x04
-#define HK_Contrast             0x05
-#define HK_Mute                 0x06
-#define HK_Volume               0x07
-#define ActivePAL               0x0020
-#define ActivePALShift          5
-#define ActiveNonExpanding      0x40
-#define ActiveNonExpandingShift 6
-#define ActiveOverScan          0x80
-#define ActiveOverScanShift     7
-
-#define ModeSwitchStatus        0x0b /* SR15 */
-#define ActiveCRT1              0x01
-#define ActiveLCD               0x02
-#define ActiveCRT2              0x08
-
-#define TVSwitchStatus          0xf0 /* SR16 */
-#define TVConfigShift           3
-#define ActiveTV                0x01
-#define ActiveYPbPr             0x04
-#define ActiveAVideo            0x10
-#define ActiveSVideo            0x0020
-#define ActiveSCART             0x40
-#define ActiveHiTV              0x80
-
-#define EnableHKEvent           0x01 /* CR7A */
-#define EnableOSDEvent          0x02
-#define StartOSDEvent           0x04
-#define CMOSSupport             0x08
-#define HotKeySupport           0x10
-#define IngoreHKOSDEvent        0x20
-#endif
 
 /* //------------- Misc. Definition */
 #define SelectCRT1Rate               00h
-- 
1.7.3.4

