Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1K1Wru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:47:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60985 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754993Ab1K1WpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:45:05 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/8] mfd: Define some additional wm8994 registers
Date: Mon, 28 Nov 2011 22:44:32 +0000
Message-Id: <1322520274-13789-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111128224017.GA13163@opensource.wolfsonmicro.com>
 <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bunch of definitions for wm8994 registers that are not currently
used by software.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm8994/registers.h |   96 ++++++++++++++++++++++++++++++++++
 sound/soc/codecs/wm8994-tables.c     |   12 ++--
 2 files changed, 102 insertions(+), 6 deletions(-)

diff --git a/include/linux/mfd/wm8994/registers.h b/include/linux/mfd/wm8994/registers.h
index 83a9cae..8317b19 100644
--- a/include/linux/mfd/wm8994/registers.h
+++ b/include/linux/mfd/wm8994/registers.h
@@ -95,11 +95,15 @@
 #define WM8994_FLL1_CONTROL_3                   0x222
 #define WM8994_FLL1_CONTROL_4                   0x223
 #define WM8994_FLL1_CONTROL_5                   0x224
+#define WM8958_FLL1_EFS_1                       0x226
+#define WM8958_FLL1_EFS_2                       0x227
 #define WM8994_FLL2_CONTROL_1                   0x240
 #define WM8994_FLL2_CONTROL_2                   0x241
 #define WM8994_FLL2_CONTROL_3                   0x242
 #define WM8994_FLL2_CONTROL_4                   0x243
 #define WM8994_FLL2_CONTROL_5                   0x244
+#define WM8958_FLL2_EFS_1                       0x246
+#define WM8958_FLL2_EFS_2                       0x247
 #define WM8994_AIF1_CONTROL_1                   0x300
 #define WM8994_AIF1_CONTROL_2                   0x301
 #define WM8994_AIF1_MASTER_SLAVE                0x302
@@ -116,6 +120,7 @@
 #define WM8994_AIF2DAC_LRCLK                    0x315
 #define WM8994_AIF2DAC_DATA                     0x316
 #define WM8994_AIF2ADC_DATA                     0x317
+#define WM1811_AIF2TX_CONTROL                   0x318
 #define WM8958_AIF3_CONTROL_1                   0x320
 #define WM8958_AIF3_CONTROL_2                   0x321
 #define WM8958_AIF3DAC_DATA                     0x322
@@ -166,6 +171,7 @@
 #define WM8994_AIF1_DAC1_EQ_BAND_5_A            0x491
 #define WM8994_AIF1_DAC1_EQ_BAND_5_B            0x492
 #define WM8994_AIF1_DAC1_EQ_BAND_5_PG           0x493
+#define WM8994_AIF1_DAC1_EQ_BAND_1_C            0x494
 #define WM8994_AIF1_DAC2_EQ_GAINS_1             0x4A0
 #define WM8994_AIF1_DAC2_EQ_GAINS_2             0x4A1
 #define WM8994_AIF1_DAC2_EQ_BAND_1_A            0x4A2
@@ -186,6 +192,7 @@
 #define WM8994_AIF1_DAC2_EQ_BAND_5_A            0x4B1
 #define WM8994_AIF1_DAC2_EQ_BAND_5_B            0x4B2
 #define WM8994_AIF1_DAC2_EQ_BAND_5_PG           0x4B3
+#define WM8994_AIF1_DAC2_EQ_BAND_1_C            0x4B4
 #define WM8994_AIF2_ADC_LEFT_VOLUME             0x500
 #define WM8994_AIF2_ADC_RIGHT_VOLUME            0x501
 #define WM8994_AIF2_DAC_LEFT_VOLUME             0x502
@@ -219,6 +226,7 @@
 #define WM8994_AIF2_EQ_BAND_5_A                 0x591
 #define WM8994_AIF2_EQ_BAND_5_B                 0x592
 #define WM8994_AIF2_EQ_BAND_5_PG                0x593
+#define WM8994_AIF2_EQ_BAND_1_C                 0x594
 #define WM8994_DAC1_MIXER_VOLUMES               0x600
 #define WM8994_DAC1_LEFT_MIXER_ROUTING          0x601
 #define WM8994_DAC1_RIGHT_MIXER_ROUTING         0x602
@@ -264,7 +272,43 @@
 #define WM8958_DSP2_RELEASETIME                 0xA03
 #define WM8958_DSP2_VERMAJMIN                   0xA04
 #define WM8958_DSP2_VERBUILD                    0xA05
+#define WM8958_DSP2_TESTREG                     0xA06
+#define WM8958_DSP2_XORREG                      0xA07
+#define WM8958_DSP2_SHIFTMAXX                   0xA08
+#define WM8958_DSP2_SHIFTMAXY                   0xA09
+#define WM8958_DSP2_SHIFTMAXZ                   0xA0A
+#define WM8958_DSP2_SHIFTMAXEXTLO               0xA0B
+#define WM8958_DSP2_AESSELECT                   0xA0C
 #define WM8958_DSP2_EXECCONTROL                 0xA0D
+#define WM8958_DSP2_SAMPLEBREAK                 0xA0E
+#define WM8958_DSP2_COUNTBREAK                  0xA0F
+#define WM8958_DSP2_INTSTATUS                   0xA10
+#define WM8958_DSP2_EVENTSTATUS                 0xA11
+#define WM8958_DSP2_INTMASK                     0xA12
+#define WM8958_DSP2_CONFIGDWIDTH                0xA13
+#define WM8958_DSP2_CONFIGINSTR                 0xA14
+#define WM8958_DSP2_CONFIGDMEM                  0xA15
+#define WM8958_DSP2_CONFIGDELAYS                0xA16
+#define WM8958_DSP2_CONFIGNUMIO                 0xA17
+#define WM8958_DSP2_CONFIGEXTDEPTH              0xA18
+#define WM8958_DSP2_CONFIGMULTIPLIER            0xA19
+#define WM8958_DSP2_CONFIGCTRLDWIDTH            0xA1A
+#define WM8958_DSP2_CONFIGPIPELINE              0xA1B
+#define WM8958_DSP2_SHIFTMAXEXTHI               0xA1C
+#define WM8958_DSP2_SWVERSIONREG                0xA1D
+#define WM8958_DSP2_CONFIGXMEM                  0xA1E
+#define WM8958_DSP2_CONFIGYMEM                  0xA1F
+#define WM8958_DSP2_CONFIGZMEM                  0xA20
+#define WM8958_FW_BUILD_1                       0x2000
+#define WM8958_FW_BUILD_0                       0x2001
+#define WM8958_FW_ID_1                          0x2002
+#define WM8958_FW_ID_0                          0x2003
+#define WM8958_FW_MAJOR_1                       0x2004
+#define WM8958_FW_MAJOR_0                       0x2005
+#define WM8958_FW_MINOR_1                       0x2006
+#define WM8958_FW_MINOR_0                       0x2007
+#define WM8958_FW_PATCH_1                       0x2008
+#define WM8958_FW_PATCH_0                       0x2009
 #define WM8958_MBC_BAND_2_LOWER_CUTOFF_C1_1     0x2200
 #define WM8958_MBC_BAND_2_LOWER_CUTOFF_C1_2     0x2201
 #define WM8958_MBC_BAND_2_LOWER_CUTOFF_C2_1     0x2202
@@ -333,6 +377,14 @@
 #define WM8958_MBC_B2_PG2_2                     0x242D
 #define WM8958_MBC_B1_PG2_1                     0x242E
 #define WM8958_MBC_B1_PG2_2                     0x242F
+#define WM8958_MBC_CROSSOVER_1                  0x2600
+#define WM8958_MBC_CROSSOVER_2                  0x2601
+#define WM8958_MBC_HPF_1                        0x2602
+#define WM8958_MBC_HPF_2                        0x2603
+#define WM8958_MBC_LPF_1                        0x2606
+#define WM8958_MBC_LPF_2                        0x2607
+#define WM8958_MBC_RMS_LIMIT_1                  0x260A
+#define WM8958_MBC_RMS_LIMIT_2                  0x260B
 #define WM8994_WRITE_SEQUENCER_0                0x3000
 #define WM8994_WRITE_SEQUENCER_1                0x3001
 #define WM8994_WRITE_SEQUENCER_2                0x3002
@@ -2389,6 +2441,10 @@
 /*
  * R548 (0x224) - FLL1 Control (5)
  */
+#define WM8958_FLL1_BYP                         0x8000  /* FLL1_BYP */
+#define WM8958_FLL1_BYP_MASK                    0x8000  /* FLL1_BYP */
+#define WM8958_FLL1_BYP_SHIFT                       15  /* FLL1_BYP */
+#define WM8958_FLL1_BYP_WIDTH                        1  /* FLL1_BYP */
 #define WM8994_FLL1_FRC_NCO_VAL_MASK            0x1F80  /* FLL1_FRC_NCO_VAL - [12:7] */
 #define WM8994_FLL1_FRC_NCO_VAL_SHIFT                7  /* FLL1_FRC_NCO_VAL - [12:7] */
 #define WM8994_FLL1_FRC_NCO_VAL_WIDTH                6  /* FLL1_FRC_NCO_VAL - [12:7] */
@@ -2404,6 +2460,24 @@
 #define WM8994_FLL1_REFCLK_SRC_WIDTH                 2  /* FLL1_REFCLK_SRC - [1:0] */
 
 /*
+ * R550 (0x226) - FLL1 EFS 1
+ */
+#define WM8958_FLL1_LAMBDA_MASK                 0xFFFF  /* FLL1_LAMBDA - [15:0] */
+#define WM8958_FLL1_LAMBDA_SHIFT                     0  /* FLL1_LAMBDA - [15:0] */
+#define WM8958_FLL1_LAMBDA_WIDTH                    16  /* FLL1_LAMBDA - [15:0] */
+
+/*
+ * R551 (0x227) - FLL1 EFS 2
+ */
+#define WM8958_FLL1_LFSR_SEL_MASK               0x0006  /* FLL1_LFSR_SEL - [2:1] */
+#define WM8958_FLL1_LFSR_SEL_SHIFT                   1  /* FLL1_LFSR_SEL - [2:1] */
+#define WM8958_FLL1_LFSR_SEL_WIDTH                   2  /* FLL1_LFSR_SEL - [2:1] */
+#define WM8958_FLL1_EFS_ENA                     0x0001  /* FLL1_EFS_ENA */
+#define WM8958_FLL1_EFS_ENA_MASK                0x0001  /* FLL1_EFS_ENA */
+#define WM8958_FLL1_EFS_ENA_SHIFT                    0  /* FLL1_EFS_ENA */
+#define WM8958_FLL1_EFS_ENA_WIDTH                    1  /* FLL1_EFS_ENA */
+
+/*
  * R576 (0x240) - FLL2 Control (1)
  */
 #define WM8994_FLL2_FRAC                        0x0004  /* FLL2_FRAC */
@@ -2452,6 +2526,10 @@
 /*
  * R580 (0x244) - FLL2 Control (5)
  */
+#define WM8958_FLL2_BYP                         0x8000  /* FLL2_BYP */
+#define WM8958_FLL2_BYP_MASK                    0x8000  /* FLL2_BYP */
+#define WM8958_FLL2_BYP_SHIFT                       15  /* FLL2_BYP */
+#define WM8958_FLL2_BYP_WIDTH                        1  /* FLL2_BYP */
 #define WM8994_FLL2_FRC_NCO_VAL_MASK            0x1F80  /* FLL2_FRC_NCO_VAL - [12:7] */
 #define WM8994_FLL2_FRC_NCO_VAL_SHIFT                7  /* FLL2_FRC_NCO_VAL - [12:7] */
 #define WM8994_FLL2_FRC_NCO_VAL_WIDTH                6  /* FLL2_FRC_NCO_VAL - [12:7] */
@@ -2467,6 +2545,24 @@
 #define WM8994_FLL2_REFCLK_SRC_WIDTH                 2  /* FLL2_REFCLK_SRC - [1:0] */
 
 /*
+ * R582 (0x246) - FLL2 EFS 1
+ */
+#define WM8958_FLL2_LAMBDA_MASK                 0xFFFF  /* FLL2_LAMBDA - [15:0] */
+#define WM8958_FLL2_LAMBDA_SHIFT                     0  /* FLL2_LAMBDA - [15:0] */
+#define WM8958_FLL2_LAMBDA_WIDTH                    16  /* FLL2_LAMBDA - [15:0] */
+
+/*
+ * R583 (0x247) - FLL2 EFS 2
+ */
+#define WM8958_FLL2_LFSR_SEL_MASK               0x0006  /* FLL2_LFSR_SEL - [2:1] */
+#define WM8958_FLL2_LFSR_SEL_SHIFT                   1  /* FLL2_LFSR_SEL - [2:1] */
+#define WM8958_FLL2_LFSR_SEL_WIDTH                   2  /* FLL2_LFSR_SEL - [2:1] */
+#define WM8958_FLL2_EFS_ENA                     0x0001  /* FLL2_EFS_ENA */
+#define WM8958_FLL2_EFS_ENA_MASK                0x0001  /* FLL2_EFS_ENA */
+#define WM8958_FLL2_EFS_ENA_SHIFT                    0  /* FLL2_EFS_ENA */
+#define WM8958_FLL2_EFS_ENA_WIDTH                    1  /* FLL2_EFS_ENA */
+
+/*
  * R768 (0x300) - AIF1 Control (1)
  */
 #define WM8994_AIF1ADCL_SRC                     0x8000  /* AIF1ADCL_SRC */
diff --git a/sound/soc/codecs/wm8994-tables.c b/sound/soc/codecs/wm8994-tables.c
index df5a8b9..6ed19d9 100644
--- a/sound/soc/codecs/wm8994-tables.c
+++ b/sound/soc/codecs/wm8994-tables.c
@@ -78,7 +78,7 @@ const struct wm8994_access_mask wm8994_access_masks[WM8994_CACHE_SIZE] = {
 	{ 0x0000, 0x0000 }, /* R74 */
 	{ 0x0000, 0x0000 }, /* R75 */
 	{ 0x8000, 0x8000 }, /* R76    - Charge Pump (1) */
-	{ 0x0000, 0x0000 }, /* R77 */
+	{ 0x8000, 0x8000 }, /* R77    - Charge Pump (2) */
 	{ 0x0000, 0x0000 }, /* R78 */
 	{ 0x0000, 0x0000 }, /* R79 */
 	{ 0x0000, 0x0000 }, /* R80 */
@@ -1651,7 +1651,7 @@ const u16 wm8994_reg_defaults[WM8994_CACHE_SIZE] = {
 	0x0000,     /* R74 */
 	0x0000,     /* R75 */
 	0x1F25,     /* R76    - Charge Pump (1) */
-	0x0000,     /* R77 */
+	0xAB19,     /* R77    - Charge Pump (2) */
 	0x0000,     /* R78 */
 	0x0000,     /* R79 */
 	0x0000,     /* R80 */
@@ -2124,8 +2124,8 @@ const u16 wm8994_reg_defaults[WM8994_CACHE_SIZE] = {
 	0x0000,     /* R547   - FLL1 Control (4) */
 	0x0C80,     /* R548   - FLL1 Control (5) */
 	0x0000,     /* R549 */
-	0x0000,     /* R550 */
-	0x0000,     /* R551 */
+	0x0000,     /* R550   - FLL1 EFS 1 */
+	0x0006,     /* R551   - FLL1 EFS 2 */
 	0x0000,     /* R552 */
 	0x0000,     /* R553 */
 	0x0000,     /* R554 */
@@ -2156,8 +2156,8 @@ const u16 wm8994_reg_defaults[WM8994_CACHE_SIZE] = {
 	0x0000,     /* R579   - FLL2 Control (4) */
 	0x0C80,     /* R580   - FLL2 Control (5) */
 	0x0000,     /* R581 */
-	0x0000,     /* R582 */
-	0x0000,     /* R583 */
+	0x0000,     /* R582   - FLL2 EFS 1 */
+	0x0006,     /* R583   - FLL2 EFS 2 */
 	0x0000,     /* R584 */
 	0x0000,     /* R585 */
 	0x0000,     /* R586 */
-- 
1.7.7.3

