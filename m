Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0CVOR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:17:26 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:34186 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0CVORY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:17:24 -0400
X-SENDER-IP: [83.226.248.59]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am9LADwZp0tT4vg7PGdsb2JhbACHXpNODAEBAQE3La1pjHqEfQQ
X-IronPort-AV: E=Sophos;i="4.51,287,1267398000"; 
   d="scan'208";a="54173686"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: phy_calibration.c Coding style fixes 2/2
Date: Mon, 22 Mar 2010 15:17:27 +0100
Message-Id: <1269267447-6245-2-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269267447-6245-1-git-send-email-lindley@coyote.org>
References: <1269267447-6245-1-git-send-email-lindley@coyote.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the rest of the checkpatch.pl problems except long lines.
I removed () from returns and added () to a macro.
I removed a lot of unneccesary {}.
Generated .o file is still identical to before.

This patch applies after the 1/2 one.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/phy_calibration.c |   73 +++++++++++------------------
 1 files changed, 28 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index e5df155..5e53af3 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -18,7 +18,7 @@
 
 #define AG_CONST	0.6072529350
 #define FIXED(X)	((s32)((X) * 32768.0))
-#define DEG2RAD(X)	0.017453 * (X)
+#define DEG2RAD(X)	(0.017453 * (X))
 
 /****************** LOCAL TYPE DEFINITION SECTION ***************************/
 typedef s32		fixed; /* 16.16 fixed-point */
@@ -46,22 +46,20 @@ s32 _s13_to_s32(u32 data)
 
 	val = (data & 0x0FFF);
 
-	if ((data & BIT(12)) != 0) {
+	if ((data & BIT(12)) != 0)
 		val |= 0xFFFFF000;
-	}
 
-	return ((s32) val);
+	return (s32) val;
 }
 
 u32 _s32_to_s13(s32 data)
 {
 	u32	val;
 
-	if (data > 4095) {
+	if (data > 4095)
 		data = 4095;
-	} else if (data < -4096) {
+	else if (data < -4096)
 		data = -4096;
-	}
 
 	val = data & 0x1FFF;
 
@@ -75,9 +73,8 @@ s32 _s4_to_s32(u32 data)
 
 	val = (data & 0x0007);
 
-	if ((data & BIT(3)) != 0) {
+	if ((data & BIT(3)) != 0)
 		val |= 0xFFFFFFF8;
-	}
 
 	return val;
 }
@@ -86,11 +83,10 @@ u32 _s32_to_s4(s32 data)
 {
 	u32	val;
 
-	if (data > 7) {
+	if (data > 7)
 		data = 7;
-	} else if (data < -8) {
+	else if (data < -8)
 		data = -8;
-	}
 
 	val = data & 0x000F;
 
@@ -104,9 +100,8 @@ s32 _s5_to_s32(u32 data)
 
 	val = (data & 0x000F);
 
-	if ((data & BIT(4)) != 0) {
+	if ((data & BIT(4)) != 0)
 		val |= 0xFFFFFFF0;
-	}
 
 	return val;
 }
@@ -115,11 +110,10 @@ u32 _s32_to_s5(s32 data)
 {
 	u32	val;
 
-	if (data > 15) {
+	if (data > 15)
 		data = 15;
-	} else if (data < -16) {
+	else if (data < -16)
 		data = -16;
-	}
 
 	val = data & 0x001F;
 
@@ -133,9 +127,8 @@ s32 _s6_to_s32(u32 data)
 
 	val = (data & 0x001F);
 
-	if ((data & BIT(5)) != 0) {
+	if ((data & BIT(5)) != 0)
 		val |= 0xFFFFFFE0;
-	}
 
 	return val;
 }
@@ -144,11 +137,10 @@ u32 _s32_to_s6(s32 data)
 {
 	u32	val;
 
-	if (data > 31) {
+	if (data > 31)
 		data = 31;
-	} else if (data < -32) {
+	else if (data < -32)
 		data = -32;
-	}
 
 	val = data & 0x003F;
 
@@ -162,9 +154,8 @@ s32 _s9_to_s32(u32 data)
 
 	val = data & 0x00FF;
 
-	if ((data & BIT(8)) != 0) {
+	if ((data & BIT(8)) != 0)
 		val |= 0xFFFFFF00;
-	}
 
 	return val;
 }
@@ -173,11 +164,10 @@ u32 _s32_to_s9(s32 data)
 {
 	u32	val;
 
-	if (data > 255) {
+	if (data > 255)
 		data = 255;
-	} else if (data < -256) {
+	else if (data < -256)
 		data = -256;
-	}
 
 	val = data & 0x01FF;
 
@@ -187,13 +177,12 @@ u32 _s32_to_s9(s32 data)
 /****************************************************************************/
 s32 _floor(s32 n)
 {
-	if (n > 0) {
+	if (n > 0)
 		n += 5;
-	} else {
+	else
 		n -= 5;
-	}
 
-	return (n/10);
+	return n / 10;
 }
 
 /*
@@ -330,11 +319,10 @@ void _reset_rx_cal(struct hw_data *phw_data)
 
 	hw_get_dxx_reg(phw_data, 0x54, &val);
 
-	if (phw_data->revision == 0x2002) { /* 1st-cut */
+	if (phw_data->revision == 0x2002) /* 1st-cut */
 		val &= 0xFFFF0000;
-	} else { /* 2nd-cut */
+	else /* 2nd-cut */
 		val &= 0x000003FF;
-	}
 
 	hw_set_dxx_reg(phw_data, 0x54, val);
 }
@@ -525,9 +513,8 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 		if (mag_0 != mag_1) {
 			fix_cancel_dc_i = (mag_0 * 10000) / (mag_0 * 10000 - mag_1 * 10000);
 		} else {
-			if (mag_0 == mag_1) {
+			if (mag_0 == mag_1)
 				PHY_DEBUG(("[CAL]   ***** mag_0 = mag_1 !!\n"));
-			}
 
 			fix_cancel_dc_i = 0;
 		}
@@ -535,9 +522,8 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 		PHY_DEBUG(("[CAL]    ** fix_cancel_dc_i = %d (0x%04X)\n",
 				   fix_cancel_dc_i, _s32_to_s5(fix_cancel_dc_i)));
 
-		if ((abs(mag_1 - mag_0) * 6) > mag_0) {
+		if ((abs(mag_1 - mag_0) * 6) > mag_0)
 			break;
-		}
 	}
 
 	if (loop >= 19)
@@ -641,9 +627,8 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 		if (mag_0 != mag_1) {
 			fix_cancel_dc_q = (mag_0*10000) / (mag_0*10000 - mag_1*10000);
 		} else {
-			if (mag_0 == mag_1) {
+			if (mag_0 == mag_1)
 				PHY_DEBUG(("[CAL]   ***** mag_0 = mag_1 !!\n"));
-			}
 
 			fix_cancel_dc_q = 0;
 		}
@@ -651,9 +636,8 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 		PHY_DEBUG(("[CAL]    ** fix_cancel_dc_q = %d (0x%04X)\n",
 				   fix_cancel_dc_q, _s32_to_s5(fix_cancel_dc_q)));
 
-		if ((abs(mag_1 - mag_0) * 6) > mag_0) {
+		if ((abs(mag_1 - mag_0) * 6) > mag_0)
 			break;
-		}
 	}
 
 	if (loop >= 19)
@@ -834,11 +818,10 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 		/* 1280 * 32768 = 41943040 */
 		temp1 = (41943040 / cos_2b) * cos_b;
 
-		if (phw_data->revision == 0x2002) { /* 1st-cut */
+		if (phw_data->revision == 0x2002) /* 1st-cut */
 			temp2 = (41943040 / cos_2b) * sin_b * (-1);
-		} else { /* 2nd-cut */
+		else /* 2nd-cut */
 			temp2 = (41943040 * 4 / cos_2b) * sin_b * (-1);
-		}
 
 		tx_cal_flt_b[0] = _floor(temp1 / (32768 + a_2));
 		tx_cal_flt_b[1] = _floor(temp2 / (32768 + a_2));
-- 
1.7.0.2

