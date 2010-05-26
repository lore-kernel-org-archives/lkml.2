Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934905Ab0EZXnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:43:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33626 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934896Ab0EZXk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:40:58 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 06/15] Staging: winbond: Replace C99 comments with C88
Date: Thu, 27 May 2010 00:39:43 +0100
Message-Id: <1274917192-16962-6-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches phy_calibration.c to replace all the C99 style comments (//) with C89 style (/* ... */), as reported by checkpatch.pl.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/phy_calibration.c |  387 ++++++++++++++---------------
 1 files changed, 191 insertions(+), 196 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index c007c06..e51b1e7 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -19,7 +19,7 @@
 
 /****************** LOCAL CONSTANT AND MACRO SECTION ************************/
 #define LOOP_TIMES      20
-#define US              1000//MICROSECOND
+#define US              1000 /*MICROSECOND*/
 
 #define AG_CONST        0.6072529350
 #define FIXED(X)        ((s32)((X) * 32768.0))
@@ -33,8 +33,8 @@ static const s32 Angles[] = {
 };
 
 /****************** LOCAL FUNCTION DECLARATION SECTION **********************/
-//void    _phy_rf_write_delay(struct hw_data *phw_data);
-//void    phy_init_rf(struct hw_data *phw_data);
+/*void    _phy_rf_write_delay(struct hw_data *phw_data); */
+/*void    phy_init_rf(struct hw_data *phw_data); */
 
 /****************** FUNCTION DEFINITION SECTION *****************************/
 
@@ -184,9 +184,9 @@ s32 _floor(s32 n)
 }
 
 /****************************************************************************/
-// The following code is sqare-root function.
-// sqsum is the input and the output is sq_rt;
-// The maximum of sqsum = 2^27 -1;
+/* The following code is sqare-root function.
+ * sqsum is the input and the output is sq_rt;
+ * The maximum of sqsum = 2^27 -1; */
 u32 _sqrt(u32 sqsum)
 {
     u32     sq_rt;
@@ -260,8 +260,8 @@ void _sin_cos(s32 angle, s32 *sin, s32 *cos)
     s32 X, Y, TargetAngle, CurrAngle;
     unsigned    Step;
 
-    X = FIXED(AG_CONST);      // AG_CONST * cos(0)
-    Y = 0;                    // AG_CONST * sin(0)
+    X = FIXED(AG_CONST);      /* AG_CONST * cos(0) */
+    Y = 0;                    /* AG_CONST * sin(0) */
     TargetAngle = abs(angle);
     CurrAngle = 0;
 
@@ -316,21 +316,21 @@ void _reset_rx_cal(struct hw_data *phw_data)
 
 	hw_get_dxx_reg(phw_data, 0x54, &val);
 
-	if (phw_data->revision == 0x2002) // 1st-cut
+	if (phw_data->revision == 0x2002) /* 1st-cut */
 		val &= 0xFFFF0000;
-	else // 2nd-cut
+	else /* 2nd-cut */
 		val &= 0x000003FF;
 
 	hw_set_dxx_reg(phw_data, 0x54, val);
 }
 
 
-// ************for winbond calibration*********
-//
-
-//
-//
-// *********************************************
+/************for winbond calibration*********
+ *
+ *
+ *
+ *
+ *********************************************/
 void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequency)
 {
     u32     reg_agc_ctrl3;
@@ -341,29 +341,29 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
     PHY_DEBUG(("[CAL] -> [1]_rxadc_dc_offset_cancellation()\n"));
     phy_init_rf(phw_data);
 
-    // set calibration channel
+    /* set calibration channel */
     if ((RF_WB_242 == phw_data->phy_type) ||
-		(RF_WB_242_1 == phw_data->phy_type)) { // 20060619.5 Add
+		(RF_WB_242_1 == phw_data->phy_type)) { /* 20060619.5 Add */
         if ((frequency >= 2412) && (frequency <= 2484)) {
-            // w89rf242 change frequency to 2390Mhz
+            /* w89rf242 change frequency to 2390Mhz */
             PHY_DEBUG(("[CAL] W89RF242/11G/Channel=2390Mhz\n"));
 			phy_set_rf_data(phw_data, 3, (3<<24)|0x025586);
 
         }
     } 
 
-	// reset cancel_dc_i[9:5] and cancel_dc_q[4:0] in register DC_Cancel
+	/* reset cancel_dc_i[9:5] and cancel_dc_q[4:0] in register DC_Cancel */
 	hw_get_dxx_reg(phw_data, 0x5C, &val);
 	val &= ~(0x03FF);
 	hw_set_dxx_reg(phw_data, 0x5C, val);
 
-	// reset the TX and RX IQ calibration data
+	/* reset the TX and RX IQ calibration data */
 	hw_set_dxx_reg(phw_data, 0x3C, 0);
 	hw_set_dxx_reg(phw_data, 0x54, 0);
 
-	hw_set_dxx_reg(phw_data, 0x58, 0x30303030); // IQ_Alpha Changed
+	hw_set_dxx_reg(phw_data, 0x58, 0x30303030); /* IQ_Alpha Changed */
 
-	// a. Disable AGC
+	/* a. Disable AGC */
 	hw_get_dxx_reg(phw_data, REG_AGC_CTRL3, &reg_agc_ctrl3);
 	reg_agc_ctrl3 &= ~BIT(2);
 	reg_agc_ctrl3 |= (MASK_LNA_FIX_GAIN|MASK_AGC_FIX);
@@ -373,7 +373,7 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
 	val |= MASK_AGC_FIX_GAIN;
 	hw_set_dxx_reg(phw_data, REG_AGC_CTRL5, val);
 
-	// b. Turn off BB RX
+	/* b. Turn off BB RX */
 	hw_get_dxx_reg(phw_data, REG_A_ACQ_CTRL, &reg_a_acq_ctrl);
 	reg_a_acq_ctrl |= MASK_AMER_OFF_REG;
 	hw_set_dxx_reg(phw_data, REG_A_ACQ_CTRL, reg_a_acq_ctrl);
@@ -382,9 +382,9 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
 	reg_b_acq_ctrl |= MASK_BMER_OFF_REG;
 	hw_set_dxx_reg(phw_data, REG_B_ACQ_CTRL, reg_b_acq_ctrl);
 
-	// c. Make sure MAC is in receiving mode
-	// d. Turn ON ADC calibration
-	//    - ADC calibrator is triggered by this signal rising from 0 to 1
+	/* c. Make sure MAC is in receiving mode */
+	/* d. Turn ON ADC calibration */
+	/*    - ADC calibrator is triggered by this signal rising from 0 to 1 */
 	hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &val);
 	val &= ~MASK_ADC_DC_CAL_STR;
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, val);
@@ -392,7 +392,7 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
 	val |= MASK_ADC_DC_CAL_STR;
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, val);
 
-	// e. The result are shown in "adc_dc_cal_i[8:0] and adc_dc_cal_q[8:0]"
+	/* e. The result are shown in "adc_dc_cal_i[8:0] and adc_dc_cal_q[8:0]" */
 #ifdef _DEBUG
 	hw_get_dxx_reg(phw_data, REG_OFFSET_READ, &val);
 	PHY_DEBUG(("[CAL]    REG_OFFSET_READ = 0x%08X\n", val));
@@ -407,23 +407,22 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
 	val &= ~MASK_ADC_DC_CAL_STR;
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, val);
 
-	// f. Turn on BB RX
-	//hw_get_dxx_reg(phw_data, REG_A_ACQ_CTRL, &reg_a_acq_ctrl);
+	/* f. Turn on BB RX */
+	/* hw_get_dxx_reg(phw_data, REG_A_ACQ_CTRL, &reg_a_acq_ctrl); */
 	reg_a_acq_ctrl &= ~MASK_AMER_OFF_REG;
 	hw_set_dxx_reg(phw_data, REG_A_ACQ_CTRL, reg_a_acq_ctrl);
 
-	//hw_get_dxx_reg(phw_data, REG_B_ACQ_CTRL, &reg_b_acq_ctrl);
+	/* hw_get_dxx_reg(phw_data, REG_B_ACQ_CTRL, &reg_b_acq_ctrl); */
 	reg_b_acq_ctrl &= ~MASK_BMER_OFF_REG;
 	hw_set_dxx_reg(phw_data, REG_B_ACQ_CTRL, reg_b_acq_ctrl);
 
-	// g. Enable AGC
-	//hw_get_dxx_reg(phw_data, REG_AGC_CTRL3, &val);
+	/* g. Enable AGC */
+	/* hw_get_dxx_reg(phw_data, REG_AGC_CTRL3, &val); */
 	reg_agc_ctrl3 |= BIT(2);
 	reg_agc_ctrl3 &= ~(MASK_LNA_FIX_GAIN|MASK_AGC_FIX);
 	hw_set_dxx_reg(phw_data, REG_AGC_CTRL3, reg_agc_ctrl3);
 }
-
-////////////////////////////////////////////////////////
+/******************************************************/
 void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 {
 	u32     reg_agc_ctrl3;
@@ -440,22 +439,22 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 
 	PHY_DEBUG(("[CAL] -> [2]_txidac_dc_offset_cancellation()\n"));
 
-	// a. Set to "TX calibration mode"
+	/* a. Set to "TX calibration mode" */
 
-	//0x01 0xEE3FC2  ; 3B8FF  ; Calibration (6a). enable TX IQ calibration loop circuits
+	/* 0x01 0xEE3FC2  ; 3B8FF  ; Calibration (6a). enable TX IQ calibration loop circuits */
 	phy_set_rf_data(phw_data, 1, (1<<24)|0xEE3FC2);
-	//0x0B 0x1905D6  ; 06417  ; Calibration (6b). enable TX I/Q cal loop squaring circuit
+	/* 0x0B 0x1905D6  ; 06417  ; Calibration (6b). enable TX I/Q cal loop squaring circuit */
 	phy_set_rf_data(phw_data, 11, (11<<24)|0x1901D6);
-	//0x05 0x24C60A  ; 09318  ; Calibration (6c). setting TX-VGA gain: TXGCH=2 & GPK=110 --> to be optimized
+	/* 0x05 0x24C60A  ; 09318  ; Calibration (6c). setting TX-VGA gain: TXGCH=2 & GPK=110 --> to be optimized */
 	phy_set_rf_data(phw_data, 5, (5<<24)|0x24C48A);
-    //0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized
+	/* 0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized */
 	phy_set_rf_data(phw_data, 6, (6<<24)|0x06890C);
-	//0x00 0xFDF1C0  ; 3F7C7  ; Calibration (6e). turn on IQ imbalance/Test mode
+	/* 0x00 0xFDF1C0  ; 3F7C7  ; Calibration (6e). turn on IQ imbalance/Test mode */
 	phy_set_rf_data(phw_data, 0, (0<<24)|0xFDF1C0);
 
-	hw_set_dxx_reg(phw_data, 0x58, 0x30303030); // IQ_Alpha Changed
+	hw_set_dxx_reg(phw_data, 0x58, 0x30303030); /* IQ_Alpha Changed */
 
-	// a. Disable AGC
+	/* a. Disable AGC */
 	hw_get_dxx_reg(phw_data, REG_AGC_CTRL3, &reg_agc_ctrl3);
 	reg_agc_ctrl3 &= ~BIT(2);
 	reg_agc_ctrl3 |= (MASK_LNA_FIX_GAIN|MASK_AGC_FIX);
@@ -465,19 +464,19 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 	val |= MASK_AGC_FIX_GAIN;
 	hw_set_dxx_reg(phw_data, REG_AGC_CTRL5, val);
 
-	// b. set iqcal_mode[1:0] to 0x2 and set iqcal_tone[3:2] to 0
+	/* b. set iqcal_mode[1:0] to 0x2 and set iqcal_tone[3:2] to 0 */
 	hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl);
 
 	PHY_DEBUG(("[CAL]    MODE_CTRL (read) = 0x%08X\n", reg_mode_ctrl));
 	reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE);
 
-	// mode=2, tone=0
-	//reg_mode_ctrl |= (MASK_CALIB_START|2);
+	/* mode=2, tone=0 */
+	/* reg_mode_ctrl |= (MASK_CALIB_START|2); */
 
-	// mode=2, tone=1
-	//reg_mode_ctrl |= (MASK_CALIB_START|2|(1<<2));
+	/* mode=2, tone=1 */
+	/* reg_mode_ctrl |= (MASK_CALIB_START|2|(1<<2)); */
 
-	// mode=2, tone=2
+	/* mode=2, tone=2 */
 	reg_mode_ctrl |= (MASK_CALIB_START|2|(2<<2));
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 	PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
@@ -488,8 +487,8 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 	for (loop = 0; loop < LOOP_TIMES; loop++) {
 		PHY_DEBUG(("[CAL] [%d.] ==================================\n", loop));
 
-		// c.
-		// reset cancel_dc_i[9:5] and cancel_dc_q[4:0] in register DC_Cancel
+		/* c. */
+		/* reset cancel_dc_i[9:5] and cancel_dc_q[4:0] in register DC_Cancel */
 		reg_dc_cancel &= ~(0x03FF);
 		PHY_DEBUG(("[CAL]    DC_CANCEL (write) = 0x%08X\n", reg_dc_cancel));
 		hw_set_dxx_reg(phw_data, 0x5C, reg_dc_cancel);
@@ -504,7 +503,7 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 		PHY_DEBUG(("[CAL]    mag_0=%d (iqcal_image_i=%d, iqcal_image_q=%d)\n",
 				   mag_0, iqcal_image_i, iqcal_image_q));
 
-		// d.
+		/* d. */
 		reg_dc_cancel |= (1 << CANCEL_DC_I_SHIFT);
 		PHY_DEBUG(("[CAL]    DC_CANCEL (write) = 0x%08X\n", reg_dc_cancel));
 		hw_set_dxx_reg(phw_data, 0x5C, reg_dc_cancel);
@@ -519,7 +518,7 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 		PHY_DEBUG(("[CAL]    mag_1=%d (iqcal_image_i=%d, iqcal_image_q=%d)\n",
 				   mag_1, iqcal_image_i, iqcal_image_q));
 
-		// e. Calculate the correct DC offset cancellation value for I
+		/* e. Calculate the correct DC offset cancellation value for I */
 		if (mag_0 != mag_1)
 			fix_cancel_dc_i = (mag_0*10000) / (mag_0*10000 - mag_1*10000);
 		else {
@@ -544,13 +543,12 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 	hw_set_dxx_reg(phw_data, 0x5C, reg_dc_cancel);
 	PHY_DEBUG(("[CAL]    DC_CANCEL (write) = 0x%08X\n", reg_dc_cancel));
 
-	// g.
+	/* g. */
 	reg_mode_ctrl &= ~MASK_CALIB_START;
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 	PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 }
-
-///////////////////////////////////////////////////////
+/*****************************************************/
 void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 {
 	u32     reg_agc_ctrl3;
@@ -566,20 +564,20 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 	int     loop;
 
 	PHY_DEBUG(("[CAL] -> [3]_txqdac_dc_offset_cacellation()\n"));
-	//0x01 0xEE3FC2  ; 3B8FF  ; Calibration (6a). enable TX IQ calibration loop circuits
+	/* 0x01 0xEE3FC2  ; 3B8FF  ; Calibration (6a). enable TX IQ calibration loop circuits */
 	phy_set_rf_data(phw_data, 1, (1<<24)|0xEE3FC2);
-	//0x0B 0x1905D6  ; 06417  ; Calibration (6b). enable TX I/Q cal loop squaring circuit
+	/* 0x0B 0x1905D6  ; 06417  ; Calibration (6b). enable TX I/Q cal loop squaring circuit */
 	phy_set_rf_data(phw_data, 11, (11<<24)|0x1901D6);
-	//0x05 0x24C60A  ; 09318  ; Calibration (6c). setting TX-VGA gain: TXGCH=2 & GPK=110 --> to be optimized
+	/* 0x05 0x24C60A  ; 09318  ; Calibration (6c). setting TX-VGA gain: TXGCH=2 & GPK=110 --> to be optimized */
 	phy_set_rf_data(phw_data, 5, (5<<24)|0x24C48A);
-    //0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized
+	/* 0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized */
 	phy_set_rf_data(phw_data, 6, (6<<24)|0x06890C);
-	//0x00 0xFDF1C0  ; 3F7C7  ; Calibration (6e). turn on IQ imbalance/Test mode
+	/* 0x00 0xFDF1C0  ; 3F7C7  ; Calibration (6e). turn on IQ imbalance/Test mode */
 	phy_set_rf_data(phw_data, 0, (0<<24)|0xFDF1C0);
 
-	hw_set_dxx_reg(phw_data, 0x58, 0x30303030); // IQ_Alpha Changed
+	hw_set_dxx_reg(phw_data, 0x58, 0x30303030); /* IQ_Alpha Changed */
 
-	// a. Disable AGC
+	/* a. Disable AGC */
 	hw_get_dxx_reg(phw_data, REG_AGC_CTRL3, &reg_agc_ctrl3);
 	reg_agc_ctrl3 &= ~BIT(2);
 	reg_agc_ctrl3 |= (MASK_LNA_FIX_GAIN|MASK_AGC_FIX);
@@ -589,11 +587,11 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 	val |= MASK_AGC_FIX_GAIN;
 	hw_set_dxx_reg(phw_data, REG_AGC_CTRL5, val);
 
-	// a. set iqcal_mode[1:0] to 0x3 and set iqcal_tone[3:2] to 0
+	/* a. set iqcal_mode[1:0] to 0x3 and set iqcal_tone[3:2] to 0 */
 	hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl);
 	PHY_DEBUG(("[CAL]    MODE_CTRL (read) = 0x%08X\n", reg_mode_ctrl));
 
-	//reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE);
+	/* reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE); */
 	reg_mode_ctrl &= ~(MASK_IQCAL_MODE);
 	reg_mode_ctrl |= (MASK_CALIB_START|3);
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
@@ -605,8 +603,8 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 	for (loop = 0; loop < LOOP_TIMES; loop++) {
 		PHY_DEBUG(("[CAL] [%d.] ==================================\n", loop));
 
-		// b.
-		// reset cancel_dc_q[4:0] in register DC_Cancel
+		/* b. */
+		/* reset cancel_dc_q[4:0] in register DC_Cancel */
 		reg_dc_cancel &= ~(0x001F);
 		PHY_DEBUG(("[CAL]    DC_CANCEL (write) = 0x%08X\n", reg_dc_cancel));
 		hw_set_dxx_reg(phw_data, 0x5C, reg_dc_cancel);
@@ -621,7 +619,7 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 		PHY_DEBUG(("[CAL]    mag_0=%d (iqcal_image_i=%d, iqcal_image_q=%d)\n",
 				   mag_0, iqcal_image_i, iqcal_image_q));
 
-		// c.
+		/* c. */
 		reg_dc_cancel |= (1 << CANCEL_DC_Q_SHIFT);
 		PHY_DEBUG(("[CAL]    DC_CANCEL (write) = 0x%08X\n", reg_dc_cancel));
 		hw_set_dxx_reg(phw_data, 0x5C, reg_dc_cancel);
@@ -636,7 +634,7 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 		PHY_DEBUG(("[CAL]    mag_1=%d (iqcal_image_i=%d, iqcal_image_q=%d)\n",
 				   mag_1, iqcal_image_i, iqcal_image_q));
 
-		// d. Calculate the correct DC offset cancellation value for I
+		/* d. Calculate the correct DC offset cancellation value for I */
 		if (mag_0 != mag_1) {
 			fix_cancel_dc_q = (mag_0*10000) / (mag_0*10000 - mag_1*10000);
 		} else {
@@ -662,13 +660,13 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 	PHY_DEBUG(("[CAL]    DC_CANCEL (write) = 0x%08X\n", reg_dc_cancel));
 
 
-	// f.
+	/* f. */
 	reg_mode_ctrl &= ~MASK_CALIB_START;
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 	PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 }
 
-//20060612.1.a 20060718.1 Modify
+/* 20060612.1.a 20060718.1 Modify */
 u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 						   s32 a_2_threshold,
 						   s32 b_2_threshold)
@@ -712,11 +710,11 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 
 		iqcal_tone_i_avg = 0;
 		iqcal_tone_q_avg = 0;
-		if (!hw_set_dxx_reg(phw_data, 0x3C, 0x00)) // 20060718.1 modify
+		if (!hw_set_dxx_reg(phw_data, 0x3C, 0x00)) /* 20060718.1 modify */
 			return 0;
 		for (capture_time = 0; capture_time < 10; capture_time++) {
-			// a. Set iqcal_mode[1:0] to 0x2 and set "calib_start" to 0x1 to
-			//    enable "IQ alibration Mode II"
+			/* a. Set iqcal_mode[1:0] to 0x2 and set "calib_start" to 0x1 to
+				enable "IQ alibration Mode II" */
 			reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE);
 			reg_mode_ctrl &= ~MASK_IQCAL_MODE;
 			reg_mode_ctrl |= (MASK_CALIB_START|0x02);
@@ -724,7 +722,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-			// b.
+			/* b. */
 			hw_get_dxx_reg(phw_data, REG_CALIB_READ1, &val);
 			PHY_DEBUG(("[CAL]    CALIB_READ1 = 0x%08X\n", val));
 
@@ -738,21 +736,21 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			iq_mag_0_tx = (s32) _sqrt(sqsum);
 			PHY_DEBUG(("[CAL]    ** iq_mag_0_tx=%d\n", iq_mag_0_tx));
 
-			// c. Set "calib_start" to 0x0
+			/* c. Set "calib_start" to 0x0 */
 			reg_mode_ctrl &= ~MASK_CALIB_START;
 			hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-			// d. Set iqcal_mode[1:0] to 0x3 and set "calib_start" to 0x1 to
-			//    enable "IQ alibration Mode II"
-			//hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &val);
+			/* d. Set iqcal_mode[1:0] to 0x3 and set "calib_start" to 0x1 to
+				enable "IQ alibration Mode II" */
+			/* hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &val); */
 			hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl);
 			reg_mode_ctrl &= ~MASK_IQCAL_MODE;
 			reg_mode_ctrl |= (MASK_CALIB_START|0x03);
 			hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-			// e.
+			/* e. */
 			hw_get_dxx_reg(phw_data, REG_CALIB_READ1, &val);
 			PHY_DEBUG(("[CAL]    CALIB_READ1 = 0x%08X\n", val));
 
@@ -779,7 +777,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		PHY_DEBUG(("[CAL]    ** rot_i_b = %d, rot_q_b = %d\n",
 				   rot_i_b, rot_q_b));
 
-		// f.
+		/* f. */
 		divisor = ((iq_mag_0_tx * iq_mag_0_tx * 2)/1024 - rot_i_b) * 2;
 
 		if (divisor == 0) {
@@ -797,8 +795,8 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		phw_data->iq_rsdl_gain_tx_d2 = a_2;
 		phw_data->iq_rsdl_phase_tx_d2 = b_2;
 
-		//if ((abs(a_2) < 150) && (abs(b_2) < 100))
-		//if ((abs(a_2) < 200) && (abs(b_2) < 200))
+		/* if ((abs(a_2) < 150) && (abs(b_2) < 100)) */
+		/* if ((abs(a_2) < 200) && (abs(b_2) < 200)) */
 		if ((abs(a_2) < a_2_threshold) && (abs(b_2) < b_2_threshold)) {
 			verify_count++;
 
@@ -830,13 +828,13 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			break;
 		}
 
-		// 1280 * 32768 = 41943040
+		/* 1280 * 32768 = 41943040 */
 		temp1 = (41943040/cos_2b)*cos_b;
 
-		//temp2 = (41943040/cos_2b)*sin_b*(-1);
-		if (phw_data->revision == 0x2002) // 1st-cut
+		/* temp2 = (41943040/cos_2b)*sin_b*(-1); */
+		if (phw_data->revision == 0x2002) /* 1st-cut */
 			temp2 = (41943040/cos_2b)*sin_b*(-1);
-		else // 2nd-cut
+		else /* 2nd-cut */
 			temp2 = (41943040*4/cos_2b)*sin_b*(-1);
 
 		tx_cal_flt_b[0] = _floor(temp1/(32768+a_2));
@@ -859,24 +857,24 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		PHY_DEBUG(("[CAL]       tx_cal[2] = %d\n", tx_cal[2]));
 		PHY_DEBUG(("[CAL]       tx_cal[3] = %d\n", tx_cal[3]));
 
-		//if ((tx_cal[0] == 0) && (tx_cal[1] == 0) &&
-		//    (tx_cal[2] == 0) && (tx_cal[3] == 0))
-		//{
-		//    PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> *************\n"));
-		//    PHY_DEBUG(("[CAL] ** TX_IQ_CALIBRATION COMPLETE !!\n"));
-		//    PHY_DEBUG(("[CAL] ******************************************\n"));
-		//    return 0;
-		//}
-
-		// g.
-		if (phw_data->revision == 0x2002) { // 1st-cut
+		/* if ((tx_cal[0] == 0) && (tx_cal[1] == 0) && 
+		    (tx_cal[2] == 0) && (tx_cal[3] == 0))
+		{
+		    PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> *************\n"));
+		    PHY_DEBUG(("[CAL] ** TX_IQ_CALIBRATION COMPLETE !!\n"));
+		    PHY_DEBUG(("[CAL] ******************************************\n"));
+		    return 0;
+		} */
+
+		/* g. */
+		if (phw_data->revision == 0x2002) { /* 1st-cut */
 			hw_get_dxx_reg(phw_data, 0x54, &val);
 			PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
 			tx_cal_reg[0] = _s4_to_s32((val & 0xF0000000) >> 28);
 			tx_cal_reg[1] = _s4_to_s32((val & 0x0F000000) >> 24);
 			tx_cal_reg[2] = _s4_to_s32((val & 0x00F00000) >> 20);
 			tx_cal_reg[3] = _s4_to_s32((val & 0x000F0000) >> 16);
-		} else { // 2nd-cut
+		} else { /* 2nd-cut */
 			hw_get_dxx_reg(phw_data, 0x3C, &val);
 			PHY_DEBUG(("[CAL]    ** 0x3C = 0x%08X\n", val));
 			tx_cal_reg[0] = _s5_to_s32((val & 0xF8000000) >> 27);
@@ -891,7 +889,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		PHY_DEBUG(("[CAL]       tx_cal_reg[2] = %d\n", tx_cal_reg[2]));
 		PHY_DEBUG(("[CAL]       tx_cal_reg[3] = %d\n", tx_cal_reg[3]));
 
-		if (phw_data->revision == 0x2002) { // 1st-cut
+		if (phw_data->revision == 0x2002) { /* 1st-cut */
 			if (((tx_cal_reg[0] == 7) || (tx_cal_reg[0] == (-8))) &&
 				((tx_cal_reg[3] == 7) || (tx_cal_reg[3] == (-8)))) {
 				PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> *********\n"));
@@ -899,7 +897,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 				PHY_DEBUG(("[CAL] **************************************\n"));
 				break;
 			}
-		} else { // 2nd-cut
+		} else { /* 2nd-cut */
 			if (((tx_cal_reg[0] == 31) || (tx_cal_reg[0] == (-32))) &&
 				((tx_cal_reg[3] == 31) || (tx_cal_reg[3] == (-32)))) {
 				PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> *********\n"));
@@ -918,7 +916,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		PHY_DEBUG(("[CAL]       apply tx_cal[2] = %d\n", tx_cal[2]));
 		PHY_DEBUG(("[CAL]       apply tx_cal[3] = %d\n", tx_cal[3]));
 
-		if (phw_data->revision == 0x2002) { // 1st-cut
+		if (phw_data->revision == 0x2002) { /* 1st-cut */
 			val &= 0x0000FFFF;
 			val |= ((_s32_to_s4(tx_cal[0]) << 28)|
 					(_s32_to_s4(tx_cal[1]) << 24)|
@@ -927,7 +925,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			hw_set_dxx_reg(phw_data, 0x54, val);
 			PHY_DEBUG(("[CAL]    ** CALIB_DATA = 0x%08X\n", val));
 			return 0;
-		} else { // 2nd-cut
+		} else { /* 2nd-cut */
 			val &= 0x000003FF;
 			val |= ((_s32_to_s5(tx_cal[0]) << 27)|
 					(_s32_to_s6(tx_cal[1]) << 21)|
@@ -938,7 +936,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			return 0;
 		}
 
-		// i. Set "calib_start" to 0x0
+		/* i. Set "calib_start" to 0x0 */
 		reg_mode_ctrl &= ~MASK_CALIB_START;
 		hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 		PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
@@ -962,26 +960,26 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 
 	PHY_DEBUG(("[CAL] -> [4]_tx_iq_calibration()\n"));
 
-	//0x01 0xEE3FC2  ; 3B8FF  ; Calibration (6a). enable TX IQ calibration loop circuits
+	/* 0x01 0xEE3FC2  ; 3B8FF  ; Calibration (6a). enable TX IQ calibration loop circuits */
 	phy_set_rf_data(phw_data, 1, (1<<24)|0xEE3FC2);
-	//0x0B 0x1905D6  ; 06417  ; Calibration (6b). enable TX I/Q cal loop squaring circuit
-	phy_set_rf_data(phw_data, 11, (11<<24)|0x19BDD6); // 20060612.1.a 0x1905D6);
-	//0x05 0x24C60A  ; 09318  ; Calibration (6c). setting TX-VGA gain: TXGCH=2 & GPK=110 --> to be optimized
-	phy_set_rf_data(phw_data, 5, (5<<24)|0x24C60A); //0x24C60A (high temperature)
-    //0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized
-	phy_set_rf_data(phw_data, 6, (6<<24)|0x34880C); // 20060612.1.a 0x06890C);
-	//0x00 0xFDF1C0  ; 3F7C7  ; Calibration (6e). turn on IQ imbalance/Test mode
+	/* 0x0B 0x1905D6  ; 06417  ; Calibration (6b). enable TX I/Q cal loop squaring circuit */
+	phy_set_rf_data(phw_data, 11, (11<<24)|0x19BDD6); /* 20060612.1.a 0x1905D6); */
+	/* 0x05 0x24C60A  ; 09318  ; Calibration (6c). setting TX-VGA gain: TXGCH=2 & GPK=110 --> to be optimized */
+	phy_set_rf_data(phw_data, 5, (5<<24)|0x24C60A); /* 0x24C60A (high temperature) */
+	/* 0x06 0x06880C  ; 01A20  ; Calibration (6d). RXGCH=00; RXGCL=100 000 (RXVGA=32) --> to be optimized */
+	phy_set_rf_data(phw_data, 6, (6<<24)|0x34880C); /* 20060612.1.a 0x06890C); */
+	/* 0x00 0xFDF1C0  ; 3F7C7  ; Calibration (6e). turn on IQ imbalance/Test mode */
 	phy_set_rf_data(phw_data, 0, (0<<24)|0xFDF1C0);
-	//; [BB-chip]: Calibration (6f).Send test pattern
-	//; [BB-chip]: Calibration (6g). Search RXGCL optimal value
-	//; [BB-chip]: Calibration (6h). Caculate TX-path IQ imbalance and setting TX path IQ compensation table
-	//phy_set_rf_data(phw_data, 3, (3<<24)|0x025586);
+	/*; [BB-chip]: Calibration (6f).Send test pattern */
+	/*; [BB-chip]: Calibration (6g). Search RXGCL optimal value */
+	/*; [BB-chip]: Calibration (6h). Caculate TX-path IQ imbalance and setting TX path IQ compensation table */
+	/* phy_set_rf_data(phw_data, 3, (3<<24)|0x025586); */
 
-	msleep(30); // 20060612.1.a 30ms delay. Add the follow 2 lines
-	//To adjust TXVGA to fit iq_mag_0 range from 1250 ~ 1750
+	msleep(30); /* 20060612.1.a 30ms delay. Add the follow 2 lines */
+	/* To adjust TXVGA to fit iq_mag_0 range from 1250 ~ 1750 */
 	adjust_TXVGA_for_iq_mag(phw_data);
 
-	// a. Disable AGC
+	/* a. Disable AGC */
 	hw_get_dxx_reg(phw_data, REG_AGC_CTRL3, &reg_agc_ctrl3);
 	reg_agc_ctrl3 &= ~BIT(2);
 	reg_agc_ctrl3 |= (MASK_LNA_FIX_GAIN|MASK_AGC_FIX);
@@ -994,11 +992,11 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 	result = _tx_iq_calibration_loop_winbond(phw_data, 150, 100);
 
 	if (result > 0) {
-		if (phw_data->revision == 0x2002) { // 1st-cut
+		if (phw_data->revision == 0x2002) { /* 1st-cut */
 			hw_get_dxx_reg(phw_data, 0x54, &val);
 			val &= 0x0000FFFF;
 			hw_set_dxx_reg(phw_data, 0x54, val);
-		} else { // 2nd-cut
+		} else { /* 2nd-cut */
 			hw_get_dxx_reg(phw_data, 0x3C, &val);
 			val &= 0x000003FF;
 			hw_set_dxx_reg(phw_data, 0x3C, val);
@@ -1007,11 +1005,11 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 		result = _tx_iq_calibration_loop_winbond(phw_data, 300, 200);
 
 		if (result > 0) {
-			if (phw_data->revision == 0x2002) { // 1st-cut
+			if (phw_data->revision == 0x2002) { /* 1st-cut */
 				hw_get_dxx_reg(phw_data, 0x54, &val);
 				val &= 0x0000FFFF;
 				hw_set_dxx_reg(phw_data, 0x54, val);
-			} else { // 2nd-cut
+			} else { /* 2nd-cut */
 				hw_get_dxx_reg(phw_data, 0x3C, &val);
 				val &= 0x000003FF;
 				hw_set_dxx_reg(phw_data, 0x3C, val);
@@ -1019,11 +1017,11 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 
 			result = _tx_iq_calibration_loop_winbond(phw_data, 500, 400);
 			if (result > 0) {
-				if (phw_data->revision == 0x2002) { // 1st-cut
+				if (phw_data->revision == 0x2002) { /* 1st-cut */
 					hw_get_dxx_reg(phw_data, 0x54, &val);
 					val &= 0x0000FFFF;
 					hw_set_dxx_reg(phw_data, 0x54, val);
-				} else { // 2nd-cut
+				} else { /* 2nd-cut */
 					hw_get_dxx_reg(phw_data, 0x3C, &val);
 					val &= 0x000003FF;
 					hw_set_dxx_reg(phw_data, 0x3C, val);
@@ -1037,11 +1035,11 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 					PHY_DEBUG(("[CAL] ** TX_IQ_CALIBRATION FAILURE !!\n"));
 					PHY_DEBUG(("[CAL] **************************************\n"));
 
-					if (phw_data->revision == 0x2002) { // 1st-cut
+					if (phw_data->revision == 0x2002) { /* 1st-cut */
 						hw_get_dxx_reg(phw_data, 0x54, &val);
 						val &= 0x0000FFFF;
 						hw_set_dxx_reg(phw_data, 0x54, val);
-					} else { // 2nd-cut
+					} else { /* 2nd-cut */
 						hw_get_dxx_reg(phw_data, 0x3C, &val);
 						val &= 0x000003FF;
 						hw_set_dxx_reg(phw_data, 0x3C, val);
@@ -1051,27 +1049,27 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 		}
 	}
 
-	// i. Set "calib_start" to 0x0
+	/* i. Set "calib_start" to 0x0 */
 	hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl);
 	reg_mode_ctrl &= ~MASK_CALIB_START;
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 	PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-	// g. Enable AGC
-	//hw_get_dxx_reg(phw_data, REG_AGC_CTRL3, &val);
+	/* g. Enable AGC */
+	/* hw_get_dxx_reg(phw_data, REG_AGC_CTRL3, &val); */
 	reg_agc_ctrl3 |= BIT(2);
 	reg_agc_ctrl3 &= ~(MASK_LNA_FIX_GAIN|MASK_AGC_FIX);
 	hw_set_dxx_reg(phw_data, REG_AGC_CTRL3, reg_agc_ctrl3);
 
 #ifdef _DEBUG
-	if (phw_data->revision == 0x2002) { // 1st-cut
+	if (phw_data->revision == 0x2002) { /* 1st-cut */
 		hw_get_dxx_reg(phw_data, 0x54, &val);
 		PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
 		tx_cal_reg[0] = _s4_to_s32((val & 0xF0000000) >> 28);
 		tx_cal_reg[1] = _s4_to_s32((val & 0x0F000000) >> 24);
 		tx_cal_reg[2] = _s4_to_s32((val & 0x00F00000) >> 20);
 		tx_cal_reg[3] = _s4_to_s32((val & 0x000F0000) >> 16);
-	} else { // 2nd-cut
+	} else { /* 2nd-cut */
 		hw_get_dxx_reg(phw_data, 0x3C, &val);
 		PHY_DEBUG(("[CAL]    ** 0x3C = 0x%08X\n", val));
 		tx_cal_reg[0] = _s5_to_s32((val & 0xF8000000) >> 27);
@@ -1087,11 +1085,10 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 #endif
 
 
-	// for test - BEN
-	// RF Control Override
+	/* for test - BEN */
+	/* RF Control Override */
 }
-
-/////////////////////////////////////////////////////////////////////////////////////////
+/***************************************************************************************/
 u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 frequency)
 {
 	u32     reg_mode_ctrl;
@@ -1125,28 +1122,28 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 	PHY_DEBUG(("[CAL] ** factor = %d\n", factor));
 
 
-// RF Control Override
+/* RF Control Override */
 	hw_get_cxx_reg(phw_data, 0x80, &val);
 	val |= BIT(19);
 	hw_set_cxx_reg(phw_data, 0x80, val);
 
-// RF_Ctrl
+/* RF_Ctrl */
 	hw_get_cxx_reg(phw_data, 0xE4, &val);
 	val |= BIT(0);
 	hw_set_cxx_reg(phw_data, 0xE4, val);
 	PHY_DEBUG(("[CAL] ** RF_CTRL(0xE4) = 0x%08X", val));
 
-	hw_set_dxx_reg(phw_data, 0x58, 0x44444444); // IQ_Alpha
+	hw_set_dxx_reg(phw_data, 0x58, 0x44444444); /* IQ_Alpha */
 
-	// b.
+	/* b. */
 
 	hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl);
 	PHY_DEBUG(("[CAL]    MODE_CTRL (read) = 0x%08X\n", reg_mode_ctrl));
 
 	verify_count = 0;
 
-	//for (loop = 0; loop < 1; loop++)
-	//for (loop = 0; loop < LOOP_TIMES; loop++)
+	/* for (loop = 0; loop < 1; loop++) */
+	/* for (loop = 0; loop < LOOP_TIMES; loop++) */
 	loop = LOOP_TIMES;
 	while (loop > 0) {
 		PHY_DEBUG(("[CAL] [%d.] <_rx_iq_calibration_loop>\n", (LOOP_TIMES-loop+1)));
@@ -1157,9 +1154,9 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		capture_time = 0;
 
 		for (capture_time = 0; capture_time < 10; capture_time++) {
-			// i. Set "calib_start" to 0x0
+			/* i. Set "calib_start" to 0x0 */
 			reg_mode_ctrl &= ~MASK_CALIB_START;
-			if (!hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl)) //20060718.1 modify
+			if (!hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl)) /* 20060718.1 modify */
 				return 0;
 			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
@@ -1168,7 +1165,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 			hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-			// c.
+			/* c. */
 			hw_get_dxx_reg(phw_data, REG_CALIB_READ1, &val);
 			PHY_DEBUG(("[CAL]    CALIB_READ1 = 0x%08X\n", val));
 
@@ -1200,7 +1197,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		iqcal_tone_i = iqcal_tone_i_avg;
 		iqcal_tone_q = iqcal_tone_q_avg;
 
-		// d.
+		/* d. */
 		rot_tone_i_b = (iqcal_tone_i * iqcal_tone_i +
 						iqcal_tone_q * iqcal_tone_q) / 1024;
 		rot_tone_q_b = (iqcal_tone_i * iqcal_tone_q * (-1) +
@@ -1215,7 +1212,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		PHY_DEBUG(("[CAL]    ** rot_image_i_b = %d\n", rot_image_i_b));
 		PHY_DEBUG(("[CAL]    ** rot_image_q_b = %d\n", rot_image_q_b));
 
-		// f.
+		/* f. */
 		if (rot_tone_i_b == 0) {
 			PHY_DEBUG(("[CAL] ** <_rx_iq_calibration_loop> ERROR *******\n"));
 			PHY_DEBUG(("[CAL] ** rot_tone_i_b=0 to calculate EPS and THETA !!\n"));
@@ -1245,13 +1242,13 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 			break;
 		}
 
-		// 1280 * 32768 = 41943040
+		/* 1280 * 32768 = 41943040 */
 		temp1 = (41943040/cos_2b)*cos_b;
 
-		//temp2 = (41943040/cos_2b)*sin_b*(-1);
-		if (phw_data->revision == 0x2002) // 1st-cut
+		/* temp2 = (41943040/cos_2b)*sin_b*(-1); */
+		if (phw_data->revision == 0x2002) /* 1st-cut */
 			temp2 = (41943040/cos_2b)*sin_b*(-1);
-		else // 2nd-cut
+		else /* 2nd-cut */
 			temp2 = (41943040*4/cos_2b)*sin_b*(-1);
 
 		rx_cal_flt_b[0] = _floor(temp1/(32768+a_2));
@@ -1273,7 +1270,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		PHY_DEBUG(("[CAL]       rx_cal[2] = %d\n", rx_cal[2]));
 		PHY_DEBUG(("[CAL]       rx_cal[3] = %d\n", rx_cal[3]));
 
-		// e.
+		/* e. */
 		pwr_tone = (iqcal_tone_i*iqcal_tone_i + iqcal_tone_q*iqcal_tone_q);
 		pwr_image = (iqcal_image_i*iqcal_image_i + iqcal_image_q*iqcal_image_q)*factor;
 
@@ -1296,16 +1293,16 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 
 			continue;
 		}
-		// g.
+		/* g. */
 		hw_get_dxx_reg(phw_data, 0x54, &val);
 		PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
 
-		if (phw_data->revision == 0x2002) { // 1st-cut
+		if (phw_data->revision == 0x2002) { /* 1st-cut */
 			rx_cal_reg[0] = _s4_to_s32((val & 0x0000F000) >> 12);
 			rx_cal_reg[1] = _s4_to_s32((val & 0x00000F00) >>  8);
 			rx_cal_reg[2] = _s4_to_s32((val & 0x000000F0) >>  4);
 			rx_cal_reg[3] = _s4_to_s32((val & 0x0000000F));
-		} else { // 2nd-cut
+		} else { /* 2nd-cut */
 			rx_cal_reg[0] = _s5_to_s32((val & 0xF8000000) >> 27);
 			rx_cal_reg[1] = _s6_to_s32((val & 0x07E00000) >> 21);
 			rx_cal_reg[2] = _s6_to_s32((val & 0x001F8000) >> 15);
@@ -1317,7 +1314,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		PHY_DEBUG(("[CAL]       rx_cal_reg[2] = %d\n", rx_cal_reg[2]));
 		PHY_DEBUG(("[CAL]       rx_cal_reg[3] = %d\n", rx_cal_reg[3]));
 
-		if (phw_data->revision == 0x2002) { // 1st-cut
+		if (phw_data->revision == 0x2002) { /* 1st-cut */
 			if (((rx_cal_reg[0] == 7) || (rx_cal_reg[0] == (-8))) &&
 				((rx_cal_reg[3] == 7) || (rx_cal_reg[3] == (-8)))) {
 				PHY_DEBUG(("[CAL] ** <_rx_iq_calibration_loop> *********\n"));
@@ -1325,7 +1322,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 				PHY_DEBUG(("[CAL] **************************************\n"));
 				break;
 			}
-		} else { // 2nd-cut
+		} else { /* 2nd-cut */
 			if (((rx_cal_reg[0] == 31) || (rx_cal_reg[0] == (-32))) &&
 				((rx_cal_reg[3] == 31) || (rx_cal_reg[3] == (-32)))) {
 				PHY_DEBUG(("[CAL] ** <_rx_iq_calibration_loop> *********\n"));
@@ -1345,14 +1342,14 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		PHY_DEBUG(("[CAL]       apply rx_cal[3] = %d\n", rx_cal[3]));
 
 		hw_get_dxx_reg(phw_data, 0x54, &val);
-		if (phw_data->revision == 0x2002) { // 1st-cut
+		if (phw_data->revision == 0x2002) { /* 1st-cut */
 			val &= 0x0000FFFF;
 			val |= ((_s32_to_s4(rx_cal[0]) << 12)|
 					(_s32_to_s4(rx_cal[1]) <<  8)|
 					(_s32_to_s4(rx_cal[2]) <<  4)|
 					(_s32_to_s4(rx_cal[3])));
 			hw_set_dxx_reg(phw_data, 0x54, val);
-		} else { // 2nd-cut
+		} else { /* 2nd-cut */
 			val &= 0x000003FF;
 			val |= ((_s32_to_s5(rx_cal[0]) << 27)|
 					(_s32_to_s6(rx_cal[1]) << 21)|
@@ -1371,12 +1368,10 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 	return 1;
 }
 
-//////////////////////////////////////////////////////////
-
-//////////////////////////////////////////////////////////////////////////
+/*************************************************************************/
 void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 {
-// figo 20050523 marked thsi flag for can't compile for relesase
+/* figo 20050523 marked thsi flag for can't compile for relesase */
 #ifdef _DEBUG
 	s32     rx_cal_reg[4];
 	u32     val;
@@ -1385,22 +1380,22 @@ void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 	u8      result;
 
 	PHY_DEBUG(("[CAL] -> [5]_rx_iq_calibration()\n"));
-// a. Set RFIC to "RX calibration mode"
-	//; ----- Calibration (7). RX path IQ imbalance calibration loop
-	//	0x01 0xFFBFC2  ; 3FEFF  ; Calibration (7a). enable RX IQ calibration loop circuits
+	/* a. Set RFIC to "RX calibration mode" */
+	/*; ----- Calibration (7). RX path IQ imbalance calibration loop */
+	/* 0x01 0xFFBFC2  ; 3FEFF  ; Calibration (7a). enable RX IQ calibration loop circuits */
 	phy_set_rf_data(phw_data, 1, (1<<24)|0xEFBFC2);
-	//	0x0B 0x1A01D6  ; 06817  ; Calibration (7b). enable RX I/Q cal loop SW1 circuit
+	/* 0x0B 0x1A01D6  ; 06817  ; Calibration (7b). enable RX I/Q cal loop SW1 circuit */
 	phy_set_rf_data(phw_data, 11, (11<<24)|0x1A05D6);
-	//0x05 0x24848A  ; 09212  ; Calibration (7c). setting TX-VGA gain (TXGCH) to 2 --> to be optimized
+	/* 0x05 0x24848A  ; 09212  ; Calibration (7c). setting TX-VGA gain (TXGCH) to 2 --> to be optimized */
 	phy_set_rf_data(phw_data, 5, (5<<24)| phw_data->txvga_setting_for_cal);
-	//0x06 0x06840C  ; 01A10  ; Calibration (7d). RXGCH=00; RXGCL=010 000 (RXVGA) --> to be optimized
+	/* 0x06 0x06840C  ; 01A10  ; Calibration (7d). RXGCH=00; RXGCL=010 000 (RXVGA) --> to be optimized */
 	phy_set_rf_data(phw_data, 6, (6<<24)|0x06834C);
-	//0x00 0xFFF1C0  ; 3F7C7  ; Calibration (7e). turn on IQ imbalance/Test mode
+	/* 0x00 0xFFF1C0  ; 3F7C7  ; Calibration (7e). turn on IQ imbalance/Test mode */
 	phy_set_rf_data(phw_data, 0, (0<<24)|0xFFF1C0);
 
-	//  ; [BB-chip]: Calibration (7f). Send test pattern
-	//	; [BB-chip]: Calibration (7g). Search RXGCL optimal value
-	//	; [BB-chip]: Calibration (7h). Caculate RX-path IQ imbalance and setting RX path IQ compensation table
+	/*  ; [BB-chip]: Calibration (7f). Send test pattern */
+	/*	; [BB-chip]: Calibration (7g). Search RXGCL optimal value */
+	/*	; [BB-chip]: Calibration (7h). Caculate RX-path IQ imbalance and setting RX path IQ compensation table */
 
 	result = _rx_iq_calibration_loop_winbond(phw_data, 12589, frequency);
 
@@ -1425,12 +1420,12 @@ void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 	hw_get_dxx_reg(phw_data, 0x54, &val);
 	PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
 
-	if (phw_data->revision == 0x2002) { // 1st-cut
+	if (phw_data->revision == 0x2002) { /* 1st-cut */
 		rx_cal_reg[0] = _s4_to_s32((val & 0x0000F000) >> 12);
 		rx_cal_reg[1] = _s4_to_s32((val & 0x00000F00) >>  8);
 		rx_cal_reg[2] = _s4_to_s32((val & 0x000000F0) >>  4);
 		rx_cal_reg[3] = _s4_to_s32((val & 0x0000000F));
-	} else { // 2nd-cut
+	} else { /* 2nd-cut */
 		rx_cal_reg[0] = _s5_to_s32((val & 0xF8000000) >> 27);
 		rx_cal_reg[1] = _s6_to_s32((val & 0x07E00000) >> 21);
 		rx_cal_reg[2] = _s6_to_s32((val & 0x001F8000) >> 15);
@@ -1445,7 +1440,7 @@ void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 
 }
 
-////////////////////////////////////////////////////////////////////////
+/**********************************************************************/
 void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 {
 	u32     reg_mode_ctrl;
@@ -1453,7 +1448,7 @@ void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 
 	PHY_DEBUG(("[CAL] -> phy_calibration_winbond()\n"));
 
-	// 20040701 1.1.25.1000 kevin
+	/* 20040701 1.1.25.1000 kevin */
 	hw_get_cxx_reg(phw_data, 0x80, &mac_ctrl);
 	hw_get_cxx_reg(phw_data, 0xE4, &rf_ctrl);
 	hw_get_dxx_reg(phw_data, 0x58, &iq_alpha);
@@ -1461,37 +1456,37 @@ void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 
 
 	_rxadc_dc_offset_cancellation_winbond(phw_data, frequency);
-	//_txidac_dc_offset_cancellation_winbond(phw_data);
-	//_txqdac_dc_offset_cacellation_winbond(phw_data);
+	/* _txidac_dc_offset_cancellation_winbond(phw_data); */
+	/* _txqdac_dc_offset_cacellation_winbond(phw_data); */
 
 	_tx_iq_calibration_winbond(phw_data);
 	_rx_iq_calibration_winbond(phw_data, frequency);
 
-	//------------------------------------------------------------------------
+	/*------------------------------------------------------------------------*/
 	hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl);
-	reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE|MASK_CALIB_START); // set when finish
+	reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE|MASK_CALIB_START); /* set when finish */
 	hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 	PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-	// i. Set RFIC to "Normal mode"
+	/* i. Set RFIC to "Normal mode" */
 	hw_set_cxx_reg(phw_data, 0x80, mac_ctrl);
 	hw_set_cxx_reg(phw_data, 0xE4, rf_ctrl);
 	hw_set_dxx_reg(phw_data, 0x58, iq_alpha);
 
 
-	//------------------------------------------------------------------------
+	/*------------------------------------------------------------------------*/
 	phy_init_rf(phw_data);
 
 }
 
-//===========================
+/*===========================*/
 void phy_set_rf_data(struct hw_data * pHwData,  u32 index,  u32 value)
 {
    u32 ltmp = 0;
 
     switch (pHwData->phy_type) {
 		case RF_MAXIM_2825:
-		case RF_MAXIM_V1: // 11g Winbond 2nd BB(with Phy board (v1) + Maxim 331)
+		case RF_MAXIM_V1: /* 11g Winbond 2nd BB(with Phy board (v1) + Maxim 331) */
 			ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
 			break;
 
@@ -1508,7 +1503,7 @@ void phy_set_rf_data(struct hw_data * pHwData,  u32 index,  u32 value)
 			break;
 
 		case RF_AIROHA_2230:
-		case RF_AIROHA_2230S: // 20060420 Add this
+		case RF_AIROHA_2230S: /* 20060420 Add this */
 			ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(value, 20);
 			break;
 
@@ -1517,7 +1512,7 @@ void phy_set_rf_data(struct hw_data * pHwData,  u32 index,  u32 value)
 			break;
 
 		case RF_WB_242:
-		case RF_WB_242_1: // 20060619.5 Add
+		case RF_WB_242_1: /* 20060619.5 Add */
 			ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse(value, 24);
 			break;
 	}
@@ -1525,7 +1520,7 @@ void phy_set_rf_data(struct hw_data * pHwData,  u32 index,  u32 value)
 	Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 }
 
-// 20060717 modify as Bruce's mail
+/* 20060717 modify as Bruce's mail */
 unsigned char adjust_TXVGA_for_iq_mag(struct hw_data *phw_data)
 {
 	int init_txvga = 0;
@@ -1545,15 +1540,15 @@ unsigned char adjust_TXVGA_for_iq_mag(struct hw_data *phw_data)
 		phy_set_rf_data(phw_data, 5, ((5<<24)|current_txvga));
 		phw_data->txvga_setting_for_cal = current_txvga;
 
-		msleep(30); // 20060612.1.a
+		msleep(30); /* 20060612.1.a */
 
-		if (!hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl)) // 20060718.1 modify
+		if (!hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl)) /* 20060718.1 modify */
 			return false;
 
 		PHY_DEBUG(("[CAL]    MODE_CTRL (read) = 0x%08X\n", reg_mode_ctrl));
 
-		// a. Set iqcal_mode[1:0] to 0x2 and set "calib_start" to 0x1 to
-		//    enable "IQ alibration Mode II"
+		/* a. Set iqcal_mode[1:0] to 0x2 and set "calib_start" to 0x1 to */
+		/*    enable "IQ alibration Mode II" */
 		reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE);
 		reg_mode_ctrl &= ~MASK_IQCAL_MODE;
 		reg_mode_ctrl |= (MASK_CALIB_START|0x02);
@@ -1561,15 +1556,15 @@ unsigned char adjust_TXVGA_for_iq_mag(struct hw_data *phw_data)
 		hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
 		PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-		udelay(1); // 20060612.1.a
+		udelay(1); /* 20060612.1.a */
 
-		udelay(300); // 20060612.1.a
+		udelay(300); /* 20060612.1.a */
 
-		// b.
+		/* b. */
 		hw_get_dxx_reg(phw_data, REG_CALIB_READ1, &val);
 
 		PHY_DEBUG(("[CAL]    CALIB_READ1 = 0x%08X\n", val));
-		udelay(300); // 20060612.1.a
+		udelay(300); /* 20060612.1.a */
 
 		iqcal_tone_i0 = _s13_to_s32(val & 0x00001FFF);
 		iqcal_tone_q0 = _s13_to_s32((val & 0x03FFE000) >> 13);
-- 
1.7.0.4

