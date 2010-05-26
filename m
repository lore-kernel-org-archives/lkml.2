Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873Ab0EZXnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:43:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934489Ab0EZXkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:40:53 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 05/15] Staging: winbond: Fix spacing around brackets, braces, etc.
Date: Thu, 27 May 2010 00:39:42 +0100
Message-Id: <1274917192-16962-5-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches phy_calibration.c to correct the spacing around brackets, braces, less than/greater than, equals and remove some extraneous braces as reported by checkpatch.pl

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/phy_calibration.c |  471 ++++++++++-------------------
 1 files changed, 159 insertions(+), 312 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 7893586..c007c06 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -25,12 +25,11 @@
 #define FIXED(X)        ((s32)((X) * 32768.0))
 #define DEG2RAD(X)      0.017453 * (X)
 
-static const s32 Angles[] =
-{
-    FIXED(DEG2RAD(45.0)),    FIXED(DEG2RAD(26.565)),  FIXED(DEG2RAD(14.0362)),
-    FIXED(DEG2RAD(7.12502)), FIXED(DEG2RAD(3.57633)), FIXED(DEG2RAD(1.78991)),
-    FIXED(DEG2RAD(0.895174)),FIXED(DEG2RAD(0.447614)),FIXED(DEG2RAD(0.223811)),
-    FIXED(DEG2RAD(0.111906)),FIXED(DEG2RAD(0.055953)),FIXED(DEG2RAD(0.027977))
+static const s32 Angles[] = {
+    FIXED(DEG2RAD(45.0)),     FIXED(DEG2RAD(26.565)),   FIXED(DEG2RAD(14.0362)),
+    FIXED(DEG2RAD(7.12502)),  FIXED(DEG2RAD(3.57633)),  FIXED(DEG2RAD(1.78991)),
+    FIXED(DEG2RAD(0.895174)), FIXED(DEG2RAD(0.447614)), FIXED(DEG2RAD(0.223811)),
+    FIXED(DEG2RAD(0.111906)), FIXED(DEG2RAD(0.055953)), FIXED(DEG2RAD(0.027977))
 };
 
 /****************** LOCAL FUNCTION DECLARATION SECTION **********************/
@@ -46,9 +45,7 @@ s32 _s13_to_s32(u32 data)
     val = (data & 0x0FFF);
 
     if ((data & BIT(12)) != 0)
-    {
         val |= 0xFFFFF000;
-    }
 
     return ((s32) val);
 }
@@ -58,13 +55,9 @@ u32 _s32_to_s13(s32 data)
     u32     val;
 
     if (data > 4095)
-    {
         data = 4095;
-    }
     else if (data < -4096)
-    {
         data = -4096;
-    }
 
     val = data & 0x1FFF;
 
@@ -79,9 +72,7 @@ s32 _s4_to_s32(u32 data)
     val = (data & 0x0007);
 
     if ((data & BIT(3)) != 0)
-    {
         val |= 0xFFFFFFF8;
-    }
 
     return val;
 }
@@ -91,13 +82,9 @@ u32 _s32_to_s4(s32 data)
     u32     val;
 
     if (data > 7)
-    {
         data = 7;
-    }
     else if (data < -8)
-    {
         data = -8;
-    }
 
     val = data & 0x000F;
 
@@ -112,9 +99,7 @@ s32 _s5_to_s32(u32 data)
     val = (data & 0x000F);
 
     if ((data & BIT(4)) != 0)
-    {
         val |= 0xFFFFFFF0;
-    }
 
     return val;
 }
@@ -124,13 +109,9 @@ u32 _s32_to_s5(s32 data)
     u32     val;
 
     if (data > 15)
-    {
         data = 15;
-    }
     else if (data < -16)
-    {
         data = -16;
-    }
 
     val = data & 0x001F;
 
@@ -145,9 +126,7 @@ s32 _s6_to_s32(u32 data)
     val = (data & 0x001F);
 
     if ((data & BIT(5)) != 0)
-    {
         val |= 0xFFFFFFE0;
-    }
 
     return val;
 }
@@ -157,13 +136,9 @@ u32 _s32_to_s6(s32 data)
     u32     val;
 
     if (data > 31)
-    {
         data = 31;
-    }
     else if (data < -32)
-    {
         data = -32;
-    }
 
     val = data & 0x003F;
 
@@ -178,9 +153,7 @@ s32 _s9_to_s32(u32 data)
     val = data & 0x00FF;
 
     if ((data & BIT(8)) != 0)
-    {
         val |= 0xFFFFFF00;
-    }
 
     return val;
 }
@@ -190,13 +163,9 @@ u32 _s32_to_s9(s32 data)
     u32     val;
 
     if (data > 255)
-    {
         data = 255;
-    }
     else if (data < -256)
-    {
         data = -256;
-    }
 
     val = data & 0x01FF;
 
@@ -207,13 +176,9 @@ u32 _s32_to_s9(s32 data)
 s32 _floor(s32 n)
 {
     if (n > 0)
-    {
         n += 5;
-    }
     else
-    {
         n -= 5;
-    }
 
     return (n/10);
 }
@@ -240,8 +205,7 @@ u32 _sqrt(u32 sqsum)
     next = g4;
     step = 0;
     seed = 0;
-    while (((seed+1)*(step+1)) <= next)
-    {
+    while (((seed+1)*(step+1)) <= next) {
     	step++;
     	seed++;
     }
@@ -251,8 +215,7 @@ u32 _sqrt(u32 sqsum)
 
     step = 0;
     seed = 2 * seed * 10;
-    while (((seed+1)*(step+1)) <= next)
-    {
+    while (((seed+1)*(step+1)) <= next ) {
         step++;
     	seed++;
     }
@@ -261,8 +224,7 @@ u32 _sqrt(u32 sqsum)
     next = (next - seed * step) * 100 + g2;
     seed = (seed + step) * 10;
     step = 0;
-    while (((seed+1)*(step+1)) <= next)
-    {
+    while (((seed+1)*(step+1)) <= next) {
         step++;
     	seed++;
     }
@@ -272,8 +234,7 @@ u32 _sqrt(u32 sqsum)
     seed = (seed + step) * 10;
     step = 0;
 
-    while (((seed+1)*(step+1)) <= next)
-    {
+    while (((seed+1)*(step+1)) <= next) {
         step++;
     	seed++;
     }
@@ -283,8 +244,7 @@ u32 _sqrt(u32 sqsum)
     seed = (seed + step) * 10;
     step = 0;
 
-    while (((seed+1)*(step+1)) <= next)
-    {
+    while (((seed+1)*(step+1)) <= next) {
         step++;
     	seed++;
     }
@@ -300,38 +260,31 @@ void _sin_cos(s32 angle, s32 *sin, s32 *cos)
     s32 X, Y, TargetAngle, CurrAngle;
     unsigned    Step;
 
-    X=FIXED(AG_CONST);      // AG_CONST * cos(0)
-    Y=0;                    // AG_CONST * sin(0)
-    TargetAngle=abs(angle);
-    CurrAngle=0;
+    X = FIXED(AG_CONST);      // AG_CONST * cos(0)
+    Y = 0;                    // AG_CONST * sin(0)
+    TargetAngle = abs(angle);
+    CurrAngle = 0;
 
-    for (Step=0; Step < 12; Step++)
-    {
+    for (Step = 0; Step < 12; Step++) {
 	s32 NewX;
 
-        if(TargetAngle > CurrAngle)
-        {
-            NewX=X - (Y >> Step);
-            Y=(X >> Step) + Y;
-            X=NewX;
+        if (TargetAngle > CurrAngle) {
+            NewX = X - (Y >> Step);
+            Y = (X >> Step) + Y;
+            X = NewX;
             CurrAngle += Angles[Step];
-        }
-        else
-        {
-            NewX=X + (Y >> Step);
-            Y=-(X >> Step) + Y;
-            X=NewX;
+        } else {
+            NewX = X + (Y >> Step);
+            Y = -(X >> Step) + Y;
+            X = NewX;
             CurrAngle -= Angles[Step];
         }
     }
 
-    if (angle > 0)
-    {
+    if (angle > 0) {
         *cos = X;
         *sin = Y;
-    }
-    else
-    {
+    } else {
         *cos = X;
         *sin = -Y;
     }
@@ -343,7 +296,7 @@ static unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number, u32 *
 		number += 0x1000;
 	return Wb35Reg_ReadSync(pHwData, number, pValue);
 }
-#define hw_get_dxx_reg( _A, _B, _C ) hal_get_dxx_reg( _A, _B, (u32 *)_C )
+#define hw_get_dxx_reg(_A, _B, _C) hal_get_dxx_reg(_A, _B, (u32 *)_C)
 
 static unsigned char hal_set_dxx_reg(struct hw_data *pHwData, u16 number, u32 value)
 {
@@ -354,7 +307,7 @@ static unsigned char hal_set_dxx_reg(struct hw_data *pHwData, u16 number, u32 va
 	ret = Wb35Reg_WriteSync(pHwData, number, value);
 	return ret;
 }
-#define hw_set_dxx_reg( _A, _B, _C ) hal_set_dxx_reg( _A, _B, (u32)_C )
+#define hw_set_dxx_reg(_A, _B, _C) hal_set_dxx_reg(_A, _B, (u32)_C)
 
 
 void _reset_rx_cal(struct hw_data *phw_data)
@@ -364,13 +317,9 @@ void _reset_rx_cal(struct hw_data *phw_data)
 	hw_get_dxx_reg(phw_data, 0x54, &val);
 
 	if (phw_data->revision == 0x2002) // 1st-cut
-	{
 		val &= 0xFFFF0000;
-	}
 	else // 2nd-cut
-	{
 		val &= 0x000003FF;
-	}
 
 	hw_set_dxx_reg(phw_data, 0x54, val);
 }
@@ -393,21 +342,15 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
     phy_init_rf(phw_data);
 
     // set calibration channel
-    if( (RF_WB_242 == phw_data->phy_type) ||
-		(RF_WB_242_1 == phw_data->phy_type) ) // 20060619.5 Add
-    {
-        if ((frequency >= 2412) && (frequency <= 2484))
-        {
+    if ((RF_WB_242 == phw_data->phy_type) ||
+		(RF_WB_242_1 == phw_data->phy_type)) { // 20060619.5 Add
+        if ((frequency >= 2412) && (frequency <= 2484)) {
             // w89rf242 change frequency to 2390Mhz
             PHY_DEBUG(("[CAL] W89RF242/11G/Channel=2390Mhz\n"));
 			phy_set_rf_data(phw_data, 3, (3<<24)|0x025586);
 
         }
-    }
-    else
-	{
-
-	}
+    } 
 
 	// reset cancel_dc_i[9:5] and cancel_dc_q[4:0] in register DC_Cancel
 	hw_get_dxx_reg(phw_data, 0x5C, &val);
@@ -542,8 +485,7 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 	hw_get_dxx_reg(phw_data, 0x5C, &reg_dc_cancel);
 	PHY_DEBUG(("[CAL]    DC_CANCEL (read) = 0x%08X\n", reg_dc_cancel));
 
-	for (loop = 0; loop < LOOP_TIMES; loop++)
-	{
+	for (loop = 0; loop < LOOP_TIMES; loop++) {
 		PHY_DEBUG(("[CAL] [%d.] ==================================\n", loop));
 
 		// c.
@@ -579,15 +521,10 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 
 		// e. Calculate the correct DC offset cancellation value for I
 		if (mag_0 != mag_1)
-		{
 			fix_cancel_dc_i = (mag_0*10000) / (mag_0*10000 - mag_1*10000);
-		}
-		else
-		{
+		else {
 			if (mag_0 == mag_1)
-			{
 				PHY_DEBUG(("[CAL]   ***** mag_0 = mag_1 !!\n"));
-			}
 
 			fix_cancel_dc_i = 0;
 		}
@@ -596,12 +533,10 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 				   fix_cancel_dc_i, _s32_to_s5(fix_cancel_dc_i)));
 
 		if ((abs(mag_1-mag_0)*6) > mag_0)
-		{
 			break;
-		}
 	}
 
-	if ( loop >= 19 )
+	if (loop >= 19)
 	   fix_cancel_dc_i = 0;
 
 	reg_dc_cancel &= ~(0x03FF);
@@ -667,8 +602,7 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 	hw_get_dxx_reg(phw_data, 0x5C, &reg_dc_cancel);
 	PHY_DEBUG(("[CAL]    DC_CANCEL (read) = 0x%08X\n", reg_dc_cancel));
 
-	for (loop = 0; loop < LOOP_TIMES; loop++)
-	{
+	for (loop = 0; loop < LOOP_TIMES; loop++) {
 		PHY_DEBUG(("[CAL] [%d.] ==================================\n", loop));
 
 		// b.
@@ -703,16 +637,11 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 				   mag_1, iqcal_image_i, iqcal_image_q));
 
 		// d. Calculate the correct DC offset cancellation value for I
-		if (mag_0 != mag_1)
-		{
+		if (mag_0 != mag_1) {
 			fix_cancel_dc_q = (mag_0*10000) / (mag_0*10000 - mag_1*10000);
-		}
-		else
-		{
+		} else {
 			if (mag_0 == mag_1)
-			{
 				PHY_DEBUG(("[CAL]   ***** mag_0 = mag_1 !!\n"));
-			}
 
 			fix_cancel_dc_q = 0;
 		}
@@ -720,13 +649,11 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 		PHY_DEBUG(("[CAL]    ** fix_cancel_dc_q = %d (0x%04X)\n",
 				   fix_cancel_dc_q, _s32_to_s5(fix_cancel_dc_q)));
 
-		if ((abs(mag_1-mag_0)*6) > mag_0)
-		{
+		if ((abs(mag_1-mag_0)*6) > mag_0) 
 			break;
-		}
 	}
 
-	if ( loop >= 19 )
+	if (loop >= 19)
 	   fix_cancel_dc_q = 0;
 
 	reg_dc_cancel &= ~(0x001F);
@@ -765,7 +692,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 	s32     temp1, temp2;
 	u32     val;
 	u16     loop;
-	s32     iqcal_tone_i_avg,iqcal_tone_q_avg;
+	s32     iqcal_tone_i_avg, iqcal_tone_q_avg;
 	u8      verify_count;
 	int capture_time;
 
@@ -780,16 +707,14 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 
 	loop = LOOP_TIMES;
 
-	while (loop > 0)
-	{
+	while (loop > 0) {
 		PHY_DEBUG(("[CAL] [%d.] <_tx_iq_calibration_loop>\n", (LOOP_TIMES-loop+1)));
 
-		iqcal_tone_i_avg=0;
-		iqcal_tone_q_avg=0;
-		if( !hw_set_dxx_reg(phw_data, 0x3C, 0x00) ) // 20060718.1 modify
+		iqcal_tone_i_avg = 0;
+		iqcal_tone_q_avg = 0;
+		if (!hw_set_dxx_reg(phw_data, 0x3C, 0x00)) // 20060718.1 modify
 			return 0;
-		for(capture_time=0;capture_time<10;capture_time++)
-		{
+		for (capture_time = 0; capture_time < 10; capture_time++) {
 			// a. Set iqcal_mode[1:0] to 0x2 and set "calib_start" to 0x1 to
 			//    enable "IQ alibration Mode II"
 			reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE);
@@ -835,14 +760,11 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			iqcal_tone_q = _s13_to_s32((val & 0x03FFE000) >> 13);
 			PHY_DEBUG(("[CAL]    ** iqcal_tone_i = %d, iqcal_tone_q = %d\n",
 			iqcal_tone_i, iqcal_tone_q));
-			if( capture_time == 0)
-			{
+			if (capture_time == 0)
 				continue;
-			}
-			else
-			{
-				iqcal_tone_i_avg=( iqcal_tone_i_avg*(capture_time-1) +iqcal_tone_i)/capture_time;
-				iqcal_tone_q_avg=( iqcal_tone_q_avg*(capture_time-1) +iqcal_tone_q)/capture_time;
+			else {
+				iqcal_tone_i_avg = (iqcal_tone_i_avg*(capture_time-1) + iqcal_tone_i)/capture_time;
+				iqcal_tone_q_avg = (iqcal_tone_q_avg*(capture_time-1) + iqcal_tone_q)/capture_time;
 			}
 		}
 
@@ -860,8 +782,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		// f.
 		divisor = ((iq_mag_0_tx * iq_mag_0_tx * 2)/1024 - rot_i_b) * 2;
 
-		if (divisor == 0)
-		{
+		if (divisor == 0) {
 			PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> ERROR *******\n"));
 			PHY_DEBUG(("[CAL] ** divisor=0 to calculate EPS and THETA !!\n"));
 			PHY_DEBUG(("[CAL] ******************************************\n"));
@@ -878,16 +799,14 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 
 		//if ((abs(a_2) < 150) && (abs(b_2) < 100))
 		//if ((abs(a_2) < 200) && (abs(b_2) < 200))
-		if ((abs(a_2) < a_2_threshold) && (abs(b_2) < b_2_threshold))
-		{
+		if ((abs(a_2) < a_2_threshold) && (abs(b_2) < b_2_threshold)) {
 			verify_count++;
 
 			PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> *************\n"));
 			PHY_DEBUG(("[CAL] ** VERIFY OK # %d !!\n", verify_count));
 			PHY_DEBUG(("[CAL] ******************************************\n"));
 
-			if (verify_count > 2)
-			{
+			if (verify_count > 2) {
 				PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> *********\n"));
 				PHY_DEBUG(("[CAL] ** TX_IQ_CALIBRATION (EPS,THETA) OK !!\n"));
 				PHY_DEBUG(("[CAL] **************************************\n"));
@@ -895,9 +814,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			}
 
 			continue;
-		}
-		else
-		{
+		} else {
 			verify_count = 0;
 		}
 
@@ -906,8 +823,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		PHY_DEBUG(("[CAL]    ** sin(b/2)=%d, cos(b/2)=%d\n", sin_b, cos_b));
 		PHY_DEBUG(("[CAL]    ** sin(b)=%d, cos(b)=%d\n", sin_2b, cos_2b));
 
-		if (cos_2b == 0)
-		{
+		if (cos_2b == 0) {
 			PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> ERROR *******\n"));
 			PHY_DEBUG(("[CAL] ** cos(b)=0 !!\n"));
 			PHY_DEBUG(("[CAL] ******************************************\n"));
@@ -919,13 +835,9 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 
 		//temp2 = (41943040/cos_2b)*sin_b*(-1);
 		if (phw_data->revision == 0x2002) // 1st-cut
-		{
 			temp2 = (41943040/cos_2b)*sin_b*(-1);
-		}
 		else // 2nd-cut
-		{
 			temp2 = (41943040*4/cos_2b)*sin_b*(-1);
-		}
 
 		tx_cal_flt_b[0] = _floor(temp1/(32768+a_2));
 		tx_cal_flt_b[1] = _floor(temp2/(32768+a_2));
@@ -957,17 +869,14 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		//}
 
 		// g.
-		if (phw_data->revision == 0x2002) // 1st-cut
-		{
+		if (phw_data->revision == 0x2002) { // 1st-cut
 			hw_get_dxx_reg(phw_data, 0x54, &val);
 			PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
 			tx_cal_reg[0] = _s4_to_s32((val & 0xF0000000) >> 28);
 			tx_cal_reg[1] = _s4_to_s32((val & 0x0F000000) >> 24);
 			tx_cal_reg[2] = _s4_to_s32((val & 0x00F00000) >> 20);
 			tx_cal_reg[3] = _s4_to_s32((val & 0x000F0000) >> 16);
-		}
-		else // 2nd-cut
-		{
+		} else { // 2nd-cut
 			hw_get_dxx_reg(phw_data, 0x3C, &val);
 			PHY_DEBUG(("[CAL]    ** 0x3C = 0x%08X\n", val));
 			tx_cal_reg[0] = _s5_to_s32((val & 0xF8000000) >> 27);
@@ -982,22 +891,17 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		PHY_DEBUG(("[CAL]       tx_cal_reg[2] = %d\n", tx_cal_reg[2]));
 		PHY_DEBUG(("[CAL]       tx_cal_reg[3] = %d\n", tx_cal_reg[3]));
 
-		if (phw_data->revision == 0x2002) // 1st-cut
-		{
-			if (((tx_cal_reg[0]==7) || (tx_cal_reg[0]==(-8))) &&
-				((tx_cal_reg[3]==7) || (tx_cal_reg[3]==(-8))))
-			{
+		if (phw_data->revision == 0x2002) { // 1st-cut
+			if (((tx_cal_reg[0] == 7) || (tx_cal_reg[0] == (-8))) &&
+				((tx_cal_reg[3] == 7) || (tx_cal_reg[3] == (-8)))) {
 				PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> *********\n"));
 				PHY_DEBUG(("[CAL] ** TX_IQ_CALIBRATION SATUATION !!\n"));
 				PHY_DEBUG(("[CAL] **************************************\n"));
 				break;
 			}
-		}
-		else // 2nd-cut
-		{
-			if (((tx_cal_reg[0]==31) || (tx_cal_reg[0]==(-32))) &&
-				((tx_cal_reg[3]==31) || (tx_cal_reg[3]==(-32))))
-			{
+		} else { // 2nd-cut
+			if (((tx_cal_reg[0] == 31) || (tx_cal_reg[0] == (-32))) &&
+				((tx_cal_reg[3] == 31) || (tx_cal_reg[3] == (-32)))) {
 				PHY_DEBUG(("[CAL] ** <_tx_iq_calibration_loop> *********\n"));
 				PHY_DEBUG(("[CAL] ** TX_IQ_CALIBRATION SATUATION !!\n"));
 				PHY_DEBUG(("[CAL] **************************************\n"));
@@ -1014,8 +918,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		PHY_DEBUG(("[CAL]       apply tx_cal[2] = %d\n", tx_cal[2]));
 		PHY_DEBUG(("[CAL]       apply tx_cal[3] = %d\n", tx_cal[3]));
 
-		if (phw_data->revision == 0x2002) // 1st-cut
-		{
+		if (phw_data->revision == 0x2002) { // 1st-cut
 			val &= 0x0000FFFF;
 			val |= ((_s32_to_s4(tx_cal[0]) << 28)|
 					(_s32_to_s4(tx_cal[1]) << 24)|
@@ -1024,9 +927,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			hw_set_dxx_reg(phw_data, 0x54, val);
 			PHY_DEBUG(("[CAL]    ** CALIB_DATA = 0x%08X\n", val));
 			return 0;
-		}
-		else // 2nd-cut
-		{
+		} else { // 2nd-cut
 			val &= 0x000003FF;
 			val |= ((_s32_to_s5(tx_cal[0]) << 27)|
 					(_s32_to_s6(tx_cal[1]) << 21)|
@@ -1078,7 +979,7 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 
 	msleep(30); // 20060612.1.a 30ms delay. Add the follow 2 lines
 	//To adjust TXVGA to fit iq_mag_0 range from 1250 ~ 1750
-	adjust_TXVGA_for_iq_mag( phw_data );
+	adjust_TXVGA_for_iq_mag(phw_data);
 
 	// a. Disable AGC
 	hw_get_dxx_reg(phw_data, REG_AGC_CTRL3, &reg_agc_ctrl3);
@@ -1092,16 +993,12 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 
 	result = _tx_iq_calibration_loop_winbond(phw_data, 150, 100);
 
-	if (result > 0)
-	{
-		if (phw_data->revision == 0x2002) // 1st-cut
-		{
+	if (result > 0) {
+		if (phw_data->revision == 0x2002) { // 1st-cut
 			hw_get_dxx_reg(phw_data, 0x54, &val);
 			val &= 0x0000FFFF;
 			hw_set_dxx_reg(phw_data, 0x54, val);
-		}
-		else // 2nd-cut
-		{
+		} else { // 2nd-cut
 			hw_get_dxx_reg(phw_data, 0x3C, &val);
 			val &= 0x000003FF;
 			hw_set_dxx_reg(phw_data, 0x3C, val);
@@ -1109,32 +1006,24 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 
 		result = _tx_iq_calibration_loop_winbond(phw_data, 300, 200);
 
-		if (result > 0)
-		{
-			if (phw_data->revision == 0x2002) // 1st-cut
-			{
+		if (result > 0) {
+			if (phw_data->revision == 0x2002) { // 1st-cut
 				hw_get_dxx_reg(phw_data, 0x54, &val);
 				val &= 0x0000FFFF;
 				hw_set_dxx_reg(phw_data, 0x54, val);
-			}
-			else // 2nd-cut
-			{
+			} else { // 2nd-cut
 				hw_get_dxx_reg(phw_data, 0x3C, &val);
 				val &= 0x000003FF;
 				hw_set_dxx_reg(phw_data, 0x3C, val);
 			}
 
 			result = _tx_iq_calibration_loop_winbond(phw_data, 500, 400);
-			if (result > 0)
-			{
-				if (phw_data->revision == 0x2002) // 1st-cut
-				{
+			if (result > 0) {
+				if (phw_data->revision == 0x2002) { // 1st-cut
 					hw_get_dxx_reg(phw_data, 0x54, &val);
 					val &= 0x0000FFFF;
 					hw_set_dxx_reg(phw_data, 0x54, val);
-				}
-				else // 2nd-cut
-				{
+				} else { // 2nd-cut
 					hw_get_dxx_reg(phw_data, 0x3C, &val);
 					val &= 0x000003FF;
 					hw_set_dxx_reg(phw_data, 0x3C, val);
@@ -1143,20 +1032,16 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 
 				result = _tx_iq_calibration_loop_winbond(phw_data, 700, 500);
 
-				if (result > 0)
-				{
+				if (result > 0) {
 					PHY_DEBUG(("[CAL] ** <_tx_iq_calibration> **************\n"));
 					PHY_DEBUG(("[CAL] ** TX_IQ_CALIBRATION FAILURE !!\n"));
 					PHY_DEBUG(("[CAL] **************************************\n"));
 
-					if (phw_data->revision == 0x2002) // 1st-cut
-					{
+					if (phw_data->revision == 0x2002) { // 1st-cut
 						hw_get_dxx_reg(phw_data, 0x54, &val);
 						val &= 0x0000FFFF;
 						hw_set_dxx_reg(phw_data, 0x54, val);
-					}
-					else // 2nd-cut
-					{
+					} else { // 2nd-cut
 						hw_get_dxx_reg(phw_data, 0x3C, &val);
 						val &= 0x000003FF;
 						hw_set_dxx_reg(phw_data, 0x3C, val);
@@ -1179,24 +1064,20 @@ void _tx_iq_calibration_winbond(struct hw_data *phw_data)
 	hw_set_dxx_reg(phw_data, REG_AGC_CTRL3, reg_agc_ctrl3);
 
 #ifdef _DEBUG
-	if (phw_data->revision == 0x2002) // 1st-cut
-	{
+	if (phw_data->revision == 0x2002) { // 1st-cut
 		hw_get_dxx_reg(phw_data, 0x54, &val);
 		PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
 		tx_cal_reg[0] = _s4_to_s32((val & 0xF0000000) >> 28);
 		tx_cal_reg[1] = _s4_to_s32((val & 0x0F000000) >> 24);
 		tx_cal_reg[2] = _s4_to_s32((val & 0x00F00000) >> 20);
 		tx_cal_reg[3] = _s4_to_s32((val & 0x000F0000) >> 16);
-	}
-	else // 2nd-cut
-	{
+	} else { // 2nd-cut
 		hw_get_dxx_reg(phw_data, 0x3C, &val);
 		PHY_DEBUG(("[CAL]    ** 0x3C = 0x%08X\n", val));
 		tx_cal_reg[0] = _s5_to_s32((val & 0xF8000000) >> 27);
 		tx_cal_reg[1] = _s6_to_s32((val & 0x07E00000) >> 21);
 		tx_cal_reg[2] = _s6_to_s32((val & 0x001F8000) >> 15);
 		tx_cal_reg[3] = _s5_to_s32((val & 0x00007C00) >> 10);
-
 	}
 
 	PHY_DEBUG(("[CAL]    ** tx_cal_reg[0] = %d\n", tx_cal_reg[0]));
@@ -1236,8 +1117,8 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 	u32     pwr_image;
 	u8      verify_count;
 
-	s32     iqcal_tone_i_avg,iqcal_tone_q_avg;
-	s32     iqcal_image_i_avg,iqcal_image_q_avg;
+	s32     iqcal_tone_i_avg, iqcal_tone_q_avg;
+	s32     iqcal_image_i_avg, iqcal_image_q_avg;
 	u16		capture_time;
 
 	PHY_DEBUG(("[CAL] -> [5]_rx_iq_calibration_loop()\n"));
@@ -1267,54 +1148,49 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 	//for (loop = 0; loop < 1; loop++)
 	//for (loop = 0; loop < LOOP_TIMES; loop++)
 	loop = LOOP_TIMES;
-	while (loop > 0)
-	{
+	while (loop > 0) {
 		PHY_DEBUG(("[CAL] [%d.] <_rx_iq_calibration_loop>\n", (LOOP_TIMES-loop+1)));
-		iqcal_tone_i_avg=0;
-		iqcal_tone_q_avg=0;
-		iqcal_image_i_avg=0;
-		iqcal_image_q_avg=0;
-		capture_time=0;
-
-		for(capture_time=0; capture_time<10; capture_time++)
-		{
-		// i. Set "calib_start" to 0x0
-		reg_mode_ctrl &= ~MASK_CALIB_START;
-		if( !hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl) )//20060718.1 modify
-			return 0;
-		PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
-
-		reg_mode_ctrl &= ~MASK_IQCAL_MODE;
-		reg_mode_ctrl |= (MASK_CALIB_START|0x1);
-		hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
-		PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
-
-		// c.
-		hw_get_dxx_reg(phw_data, REG_CALIB_READ1, &val);
-		PHY_DEBUG(("[CAL]    CALIB_READ1 = 0x%08X\n", val));
+		iqcal_tone_i_avg = 0;
+		iqcal_tone_q_avg = 0;
+		iqcal_image_i_avg = 0;
+		iqcal_image_q_avg = 0;
+		capture_time = 0;
+
+		for (capture_time = 0; capture_time < 10; capture_time++) {
+			// i. Set "calib_start" to 0x0
+			reg_mode_ctrl &= ~MASK_CALIB_START;
+			if (!hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl)) //20060718.1 modify
+				return 0;
+			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-		iqcal_tone_i = _s13_to_s32(val & 0x00001FFF);
-		iqcal_tone_q = _s13_to_s32((val & 0x03FFE000) >> 13);
-		PHY_DEBUG(("[CAL]    ** iqcal_tone_i = %d, iqcal_tone_q = %d\n",
-				   iqcal_tone_i, iqcal_tone_q));
+			reg_mode_ctrl &= ~MASK_IQCAL_MODE;
+			reg_mode_ctrl |= (MASK_CALIB_START|0x1);
+			hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
+			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-		hw_get_dxx_reg(phw_data, REG_CALIB_READ2, &val);
-		PHY_DEBUG(("[CAL]    CALIB_READ2 = 0x%08X\n", val));
+			// c.
+			hw_get_dxx_reg(phw_data, REG_CALIB_READ1, &val);
+			PHY_DEBUG(("[CAL]    CALIB_READ1 = 0x%08X\n", val));
 
-		iqcal_image_i = _s13_to_s32(val & 0x00001FFF);
-		iqcal_image_q = _s13_to_s32((val & 0x03FFE000) >> 13);
-		PHY_DEBUG(("[CAL]    ** iqcal_image_i = %d, iqcal_image_q = %d\n",
-				   iqcal_image_i, iqcal_image_q));
-			if( capture_time == 0)
-			{
+			iqcal_tone_i = _s13_to_s32(val & 0x00001FFF);
+			iqcal_tone_q = _s13_to_s32((val & 0x03FFE000) >> 13);
+			PHY_DEBUG(("[CAL]    ** iqcal_tone_i = %d, iqcal_tone_q = %d\n",
+					   iqcal_tone_i, iqcal_tone_q));
+	
+			hw_get_dxx_reg(phw_data, REG_CALIB_READ2, &val);
+			PHY_DEBUG(("[CAL]    CALIB_READ2 = 0x%08X\n", val));
+
+			iqcal_image_i = _s13_to_s32(val & 0x00001FFF);
+			iqcal_image_q = _s13_to_s32((val & 0x03FFE000) >> 13);
+			PHY_DEBUG(("[CAL]    ** iqcal_image_i = %d, iqcal_image_q = %d\n",
+					   iqcal_image_i, iqcal_image_q));
+			if (capture_time == 0)
 				continue;
-			}
-			else
-			{
-				iqcal_image_i_avg=( iqcal_image_i_avg*(capture_time-1) +iqcal_image_i)/capture_time;
-				iqcal_image_q_avg=( iqcal_image_q_avg*(capture_time-1) +iqcal_image_q)/capture_time;
-				iqcal_tone_i_avg=( iqcal_tone_i_avg*(capture_time-1) +iqcal_tone_i)/capture_time;
-				iqcal_tone_q_avg=( iqcal_tone_q_avg*(capture_time-1) +iqcal_tone_q)/capture_time;
+			else {
+				iqcal_image_i_avg = (iqcal_image_i_avg*(capture_time-1) + iqcal_image_i)/capture_time;
+				iqcal_image_q_avg = (iqcal_image_q_avg*(capture_time-1) + iqcal_image_q)/capture_time;
+				iqcal_tone_i_avg = (iqcal_tone_i_avg*(capture_time-1) + iqcal_tone_i)/capture_time;
+				iqcal_tone_q_avg = (iqcal_tone_q_avg*(capture_time-1) + iqcal_tone_q)/capture_time;
 			}
 		}
 
@@ -1340,8 +1216,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		PHY_DEBUG(("[CAL]    ** rot_image_q_b = %d\n", rot_image_q_b));
 
 		// f.
-		if (rot_tone_i_b == 0)
-		{
+		if (rot_tone_i_b == 0) {
 			PHY_DEBUG(("[CAL] ** <_rx_iq_calibration_loop> ERROR *******\n"));
 			PHY_DEBUG(("[CAL] ** rot_tone_i_b=0 to calculate EPS and THETA !!\n"));
 			PHY_DEBUG(("[CAL] ******************************************\n"));
@@ -1363,8 +1238,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		PHY_DEBUG(("[CAL]    ** sin(b/2)=%d, cos(b/2)=%d\n", sin_b, cos_b));
 		PHY_DEBUG(("[CAL]    ** sin(b)=%d, cos(b)=%d\n", sin_2b, cos_2b));
 
-		if (cos_2b == 0)
-		{
+		if (cos_2b == 0) {
 			PHY_DEBUG(("[CAL] ** <_rx_iq_calibration_loop> ERROR *******\n"));
 			PHY_DEBUG(("[CAL] ** cos(b)=0 !!\n"));
 			PHY_DEBUG(("[CAL] ******************************************\n"));
@@ -1376,13 +1250,9 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 
 		//temp2 = (41943040/cos_2b)*sin_b*(-1);
 		if (phw_data->revision == 0x2002) // 1st-cut
-		{
 			temp2 = (41943040/cos_2b)*sin_b*(-1);
-		}
 		else // 2nd-cut
-		{
 			temp2 = (41943040*4/cos_2b)*sin_b*(-1);
-		}
 
 		rx_cal_flt_b[0] = _floor(temp1/(32768+a_2));
 		rx_cal_flt_b[1] = _floor(temp2/(32768-a_2));
@@ -1410,16 +1280,14 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		PHY_DEBUG(("[CAL]    ** pwr_tone  = %d\n", pwr_tone));
 		PHY_DEBUG(("[CAL]    ** pwr_image  = %d\n", pwr_image));
 
-		if (pwr_tone > pwr_image)
-		{
+		if (pwr_tone > pwr_image) {
 			verify_count++;
 
 			PHY_DEBUG(("[CAL] ** <_rx_iq_calibration_loop> *************\n"));
 			PHY_DEBUG(("[CAL] ** VERIFY OK # %d !!\n", verify_count));
 			PHY_DEBUG(("[CAL] ******************************************\n"));
 
-			if (verify_count > 2)
-			{
+			if (verify_count > 2) {
 				PHY_DEBUG(("[CAL] ** <_rx_iq_calibration_loop> *********\n"));
 				PHY_DEBUG(("[CAL] ** RX_IQ_CALIBRATION OK !!\n"));
 				PHY_DEBUG(("[CAL] **************************************\n"));
@@ -1432,15 +1300,12 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		hw_get_dxx_reg(phw_data, 0x54, &val);
 		PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
 
-		if (phw_data->revision == 0x2002) // 1st-cut
-		{
+		if (phw_data->revision == 0x2002) { // 1st-cut
 			rx_cal_reg[0] = _s4_to_s32((val & 0x0000F000) >> 12);
 			rx_cal_reg[1] = _s4_to_s32((val & 0x00000F00) >>  8);
 			rx_cal_reg[2] = _s4_to_s32((val & 0x000000F0) >>  4);
 			rx_cal_reg[3] = _s4_to_s32((val & 0x0000000F));
-		}
-		else // 2nd-cut
-		{
+		} else { // 2nd-cut
 			rx_cal_reg[0] = _s5_to_s32((val & 0xF8000000) >> 27);
 			rx_cal_reg[1] = _s6_to_s32((val & 0x07E00000) >> 21);
 			rx_cal_reg[2] = _s6_to_s32((val & 0x001F8000) >> 15);
@@ -1452,22 +1317,17 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		PHY_DEBUG(("[CAL]       rx_cal_reg[2] = %d\n", rx_cal_reg[2]));
 		PHY_DEBUG(("[CAL]       rx_cal_reg[3] = %d\n", rx_cal_reg[3]));
 
-		if (phw_data->revision == 0x2002) // 1st-cut
-		{
-			if (((rx_cal_reg[0]==7) || (rx_cal_reg[0]==(-8))) &&
-				((rx_cal_reg[3]==7) || (rx_cal_reg[3]==(-8))))
-			{
+		if (phw_data->revision == 0x2002) { // 1st-cut
+			if (((rx_cal_reg[0] == 7) || (rx_cal_reg[0] == (-8))) &&
+				((rx_cal_reg[3] == 7) || (rx_cal_reg[3] == (-8)))) {
 				PHY_DEBUG(("[CAL] ** <_rx_iq_calibration_loop> *********\n"));
 				PHY_DEBUG(("[CAL] ** RX_IQ_CALIBRATION SATUATION !!\n"));
 				PHY_DEBUG(("[CAL] **************************************\n"));
 				break;
 			}
-		}
-		else // 2nd-cut
-		{
-			if (((rx_cal_reg[0]==31) || (rx_cal_reg[0]==(-32))) &&
-				((rx_cal_reg[3]==31) || (rx_cal_reg[3]==(-32))))
-			{
+		} else { // 2nd-cut
+			if (((rx_cal_reg[0] == 31) || (rx_cal_reg[0] == (-32))) &&
+				((rx_cal_reg[3] == 31) || (rx_cal_reg[3] == (-32)))) {
 				PHY_DEBUG(("[CAL] ** <_rx_iq_calibration_loop> *********\n"));
 				PHY_DEBUG(("[CAL] ** RX_IQ_CALIBRATION SATUATION !!\n"));
 				PHY_DEBUG(("[CAL] **************************************\n"));
@@ -1485,17 +1345,14 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		PHY_DEBUG(("[CAL]       apply rx_cal[3] = %d\n", rx_cal[3]));
 
 		hw_get_dxx_reg(phw_data, 0x54, &val);
-		if (phw_data->revision == 0x2002) // 1st-cut
-		{
+		if (phw_data->revision == 0x2002) { // 1st-cut
 			val &= 0x0000FFFF;
 			val |= ((_s32_to_s4(rx_cal[0]) << 12)|
 					(_s32_to_s4(rx_cal[1]) <<  8)|
 					(_s32_to_s4(rx_cal[2]) <<  4)|
 					(_s32_to_s4(rx_cal[3])));
 			hw_set_dxx_reg(phw_data, 0x54, val);
-		}
-		else // 2nd-cut
-		{
+		} else { // 2nd-cut
 			val &= 0x000003FF;
 			val |= ((_s32_to_s5(rx_cal[0]) << 27)|
 					(_s32_to_s6(rx_cal[1]) << 21)|
@@ -1503,8 +1360,8 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 					(_s32_to_s5(rx_cal[3]) << 10));
 			hw_set_dxx_reg(phw_data, 0x54, val);
 
-			if( loop == 3 )
-			return 0;
+			if (loop == 3)
+				return 0;
 		}
 		PHY_DEBUG(("[CAL]    ** CALIB_DATA = 0x%08X\n", val));
 
@@ -1547,18 +1404,15 @@ void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 
 	result = _rx_iq_calibration_loop_winbond(phw_data, 12589, frequency);
 
-	if (result > 0)
-	{
+	if (result > 0) {
 		_reset_rx_cal(phw_data);
 		result = _rx_iq_calibration_loop_winbond(phw_data, 7943, frequency);
 
-		if (result > 0)
-		{
+		if (result > 0) {
 			_reset_rx_cal(phw_data);
 			result = _rx_iq_calibration_loop_winbond(phw_data, 5011, frequency);
 
-			if (result > 0)
-			{
+			if (result > 0) {
 				PHY_DEBUG(("[CAL] ** <_rx_iq_calibration> **************\n"));
 				PHY_DEBUG(("[CAL] ** RX_IQ_CALIBRATION FAILURE !!\n"));
 				PHY_DEBUG(("[CAL] **************************************\n"));
@@ -1571,15 +1425,12 @@ void _rx_iq_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 	hw_get_dxx_reg(phw_data, 0x54, &val);
 	PHY_DEBUG(("[CAL]    ** 0x54 = 0x%08X\n", val));
 
-	if (phw_data->revision == 0x2002) // 1st-cut
-	{
+	if (phw_data->revision == 0x2002) { // 1st-cut
 		rx_cal_reg[0] = _s4_to_s32((val & 0x0000F000) >> 12);
 		rx_cal_reg[1] = _s4_to_s32((val & 0x00000F00) >>  8);
 		rx_cal_reg[2] = _s4_to_s32((val & 0x000000F0) >>  4);
 		rx_cal_reg[3] = _s4_to_s32((val & 0x0000000F));
-	}
-	else // 2nd-cut
-	{
+	} else { // 2nd-cut
 		rx_cal_reg[0] = _s5_to_s32((val & 0xF8000000) >> 27);
 		rx_cal_reg[1] = _s6_to_s32((val & 0x07E00000) >> 21);
 		rx_cal_reg[2] = _s6_to_s32((val & 0x001F8000) >> 15);
@@ -1634,32 +1485,31 @@ void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 }
 
 //===========================
-void phy_set_rf_data(  struct hw_data * pHwData,  u32 index,  u32 value )
+void phy_set_rf_data(struct hw_data * pHwData,  u32 index,  u32 value)
 {
-   u32 ltmp=0;
+   u32 ltmp = 0;
 
-    switch( pHwData->phy_type )
-	{
+    switch (pHwData->phy_type) {
 		case RF_MAXIM_2825:
 		case RF_MAXIM_V1: // 11g Winbond 2nd BB(with Phy board (v1) + Maxim 331)
-			ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse( value, 18 );
+			ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
 			break;
 
 		case RF_MAXIM_2827:
-			ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse( value, 18 );
+			ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
 			break;
 
 		case RF_MAXIM_2828:
-			ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse( value, 18 );
+			ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
 			break;
 
 		case RF_MAXIM_2829:
-			ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse( value, 18 );
+			ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
 			break;
 
 		case RF_AIROHA_2230:
 		case RF_AIROHA_2230S: // 20060420 Add this
-			ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse( value, 20 );
+			ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(value, 20);
 			break;
 
 		case RF_AIROHA_7230:
@@ -1668,11 +1518,11 @@ void phy_set_rf_data(  struct hw_data * pHwData,  u32 index,  u32 value )
 
 		case RF_WB_242:
 		case RF_WB_242_1: // 20060619.5 Add
-			ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse( value, 24 );
+			ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse(value, 24);
 			break;
 	}
 
-	Wb35Reg_WriteSync( pHwData, 0x0864, ltmp );
+	Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 }
 
 // 20060717 modify as Bruce's mail
@@ -1690,15 +1540,14 @@ unsigned char adjust_TXVGA_for_iq_mag(struct hw_data *phw_data)
 
 
 	reg_state = 0;
-	for( init_txvga=0; init_txvga<10; init_txvga++)
-	{
-		current_txvga = ( 0x24C40A|(init_txvga<<6) );
-		phy_set_rf_data(phw_data, 5, ((5<<24)|current_txvga) );
+	for (init_txvga = 0; init_txvga < 10; init_txvga++) {
+		current_txvga = (0x24C40A|(init_txvga<<6));
+		phy_set_rf_data(phw_data, 5, ((5<<24)|current_txvga));
 		phw_data->txvga_setting_for_cal = current_txvga;
 
 		msleep(30); // 20060612.1.a
 
-		if( !hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl) ) // 20060718.1 modify
+		if (!hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl)) // 20060718.1 modify
 			return false;
 
 		PHY_DEBUG(("[CAL]    MODE_CTRL (read) = 0x%08X\n", reg_mode_ctrl));
@@ -1731,19 +1580,17 @@ unsigned char adjust_TXVGA_for_iq_mag(struct hw_data *phw_data)
 		iq_mag_0_tx = (s32) _sqrt(sqsum);
 		PHY_DEBUG(("[CAL]    ** auto_adjust_txvga_for_iq_mag_0_tx=%d\n", iq_mag_0_tx));
 
-		if( iq_mag_0_tx>=700 && iq_mag_0_tx<=1750 )
+		if (iq_mag_0_tx >= 700 && iq_mag_0_tx <= 1750)
 			break;
-		else if(iq_mag_0_tx > 1750)
-		{
-			init_txvga=-2;
+		else if (iq_mag_0_tx > 1750) {
+			init_txvga = -2;
 			continue;
-		}
-		else
+		} else
 			continue;
 
 	}
 
-	if( iq_mag_0_tx>=700 && iq_mag_0_tx<=1750 )
+	if (iq_mag_0_tx >= 700 && iq_mag_0_tx <= 1750)
 		return true;
 	else
 		return false;
-- 
1.7.0.4

