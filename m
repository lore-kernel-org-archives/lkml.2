Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0CUSv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 14:51:57 -0400
Received: from smtp1.rdslink.ro ([81.196.12.70]:47903 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751748Ab0CUSv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 14:51:56 -0400
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Subject: [PATCH 5/5] Staging: cx25821: fix coding style issues in
 cx25821-medusa-video.c
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com, error27@gmail.com,
       palash.bandyopadhyay@conexant.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sun, 21 Mar 2010 20:51:43 +0200
Message-ID: <1269197503.6971.11.camel@tuxtm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 24e5efa163c1fa58f694fd8b44dc3488e0cc92d1 Mon Sep 17 00:00:00 2001
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Date: Sun, 21 Mar 2010 20:46:26 +0200
Subject: [PATCH 5/5] Staging: cx25821: fix coding style issues in cx25821-medusa-video.c
 This is a patch to cx25821-medusa-video.c file that fixes up warnings and errors found by the checkpatch.pl tool
 Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>

---
 drivers/staging/cx25821/cx25821-medusa-video.c |  207 ++++++++++++-----------
 1 files changed, 108 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index d601620..60dd086 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -24,11 +24,12 @@
 #include "cx25821-medusa-video.h"
 #include "cx25821-biffuncs.h"
 
-/////////////////////////////////////////////////////////////////////////////////////////
-//medusa_enable_bluefield_output()
-//
-// Enable the generation of blue filed output if no video
-//
+/*
+ * medusa_enable_bluefield_output()
+ *
+ * Enable the generation of blue filed output if no video
+ *
+*/
 static void medusa_enable_bluefield_output(struct cx25821_dev *dev, int channel,
 					   int enable)
 {
@@ -73,15 +74,15 @@ static void medusa_enable_bluefield_output(struct cx25821_dev *dev, int channel,
 	}
 
 	value = cx25821_i2c_read(&dev->i2c_bus[0], out_ctrl, &tmp);
-	value &= 0xFFFFFF7F;	// clear BLUE_FIELD_EN
+	value &= 0xFFFFFF7F;	/* clear BLUE_FIELD_EN */
 	if (enable)
-		value |= 0x00000080;	// set BLUE_FIELD_EN
+		value |= 0x00000080;	/* set BLUE_FIELD_EN */
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], out_ctrl, value);
 
 	value = cx25821_i2c_read(&dev->i2c_bus[0], out_ctrl_ns, &tmp);
 	value &= 0xFFFFFF7F;
 	if (enable)
-		value |= 0x00000080;	// set BLUE_FIELD_EN
+		value |= 0x00000080;	/* set BLUE_FIELD_EN */
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], out_ctrl_ns, value);
 }
 
@@ -95,17 +96,18 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 	mutex_lock(&dev->lock);
 
 	for (i = 0; i < MAX_DECODERS; i++) {
-		// set video format NTSC-M
+		/* set video format NTSC-M */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0], MODE_CTRL + (0x200 * i),
 				     &tmp);
 		value &= 0xFFFFFFF0;
-		value |= 0x10001;	// enable the fast locking mode bit[16]
+		/* enable the fast locking mode bit[16] */
+		value |= 0x10001;
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0], MODE_CTRL + (0x200 * i),
 				      value);
 
-		// resolution NTSC 720x480
+		/* resolution NTSC 720x480 */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     HORIZ_TIM_CTRL + (0x200 * i), &tmp);
@@ -119,17 +121,17 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     VERT_TIM_CTRL + (0x200 * i), &tmp);
 		value &= 0x00C00C00;
-		value |= 0x1C1E001A;	// vblank_cnt + 2 to get camera ID
+		value |= 0x1C1E001A;	/* vblank_cnt + 2 to get camera ID */
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      VERT_TIM_CTRL + (0x200 * i), value);
 
-		// chroma subcarrier step size
+		/* chroma subcarrier step size */
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      SC_STEP_SIZE + (0x200 * i), 0x43E00000);
 
-		// enable VIP optional active
+		/* enable VIP optional active */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     OUT_CTRL_NS + (0x200 * i), &tmp);
@@ -139,7 +141,7 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      OUT_CTRL_NS + (0x200 * i), value);
 
-		// enable VIP optional active (VIP_OPT_AL) for direct output.
+		/* enable VIP optional active (VIP_OPT_AL) for direct output. */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0], OUT_CTRL1 + (0x200 * i),
 				     &tmp);
@@ -149,19 +151,21 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0], OUT_CTRL1 + (0x200 * i),
 				      value);
 
-		// clear VPRES_VERT_EN bit, fixes the chroma run away problem
-		// when the input switching rate < 16 fields
-		//
+		/*
+		 * clear VPRES_VERT_EN bit, fixes the chroma run away problem
+		 * when the input switching rate < 16 fields
+		*/
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     MISC_TIM_CTRL + (0x200 * i), &tmp);
-		value = setBitAtPos(value, 14);	// disable special play detection
+		/* disable special play detection */
+		value = setBitAtPos(value, 14);
 		value = clearBitAtPos(value, 15);
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      MISC_TIM_CTRL + (0x200 * i), value);
 
-		// set vbi_gate_en to 0
+		/* set vbi_gate_en to 0 */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0], DFE_CTRL1 + (0x200 * i),
 				     &tmp);
@@ -170,12 +174,12 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0], DFE_CTRL1 + (0x200 * i),
 				      value);
 
-		// Enable the generation of blue field output if no video
+		/* Enable the generation of blue field output if no video */
 		medusa_enable_bluefield_output(dev, i, 1);
 	}
 
 	for (i = 0; i < MAX_ENCODERS; i++) {
-		// NTSC hclock
+		/* NTSC hclock */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     DENC_A_REG_1 + (0x100 * i), &tmp);
@@ -185,7 +189,7 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      DENC_A_REG_1 + (0x100 * i), value);
 
-		// burst begin and burst end
+		/* burst begin and burst end */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     DENC_A_REG_2 + (0x100 * i), &tmp);
@@ -204,7 +208,7 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      DENC_A_REG_3 + (0x100 * i), value);
 
-		// set NTSC vblank, no phase alternation, 7.5 IRE pedestal
+		/* set NTSC vblank, no phase alternation, 7.5 IRE pedestal */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     DENC_A_REG_4 + (0x100 * i), &tmp);
@@ -227,17 +231,19 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      DENC_A_REG_6 + (0x100 * i), 0x009A89C1);
 
-		// Subcarrier Increment
+		/* Subcarrier Increment */
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      DENC_A_REG_7 + (0x100 * i), 0x21F07C1F);
 	}
 
-	//set picture resolutions
-	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], HSCALE_CTRL, 0x0);	//0 - 720
-	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], VSCALE_CTRL, 0x0);	//0 - 480
+	/* set picture resolutions */
+	/* 0 - 720 */
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], HSCALE_CTRL, 0x0);
+	/* 0 - 480 */
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], VSCALE_CTRL, 0x0);
 
-	// set Bypass input format to NTSC 525 lines
+	/* set Bypass input format to NTSC 525 lines */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], BYP_AB_CTRL, &tmp);
 	value |= 0x00080200;
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], BYP_AB_CTRL, value);
@@ -252,7 +258,7 @@ static int medusa_PALCombInit(struct cx25821_dev *dev, int dec)
 	int ret_val = -1;
 	u32 value = 0, tmp = 0;
 
-	// Setup for 2D threshold
+	/* Setup for 2D threshold */
 	ret_val =
 	    cx25821_i2c_write(&dev->i2c_bus[0], COMB_2D_HFS_CFG + (0x200 * dec),
 			      0x20002861);
@@ -263,7 +269,7 @@ static int medusa_PALCombInit(struct cx25821_dev *dev, int dec)
 	    cx25821_i2c_write(&dev->i2c_bus[0], COMB_2D_LF_CFG + (0x200 * dec),
 			      0x200A1023);
 
-	// Setup flat chroma and luma thresholds
+	/* Setup flat chroma and luma thresholds */
 	value =
 	    cx25821_i2c_read(&dev->i2c_bus[0],
 			     COMB_FLAT_THRESH_CTRL + (0x200 * dec), &tmp);
@@ -272,12 +278,12 @@ static int medusa_PALCombInit(struct cx25821_dev *dev, int dec)
 	    cx25821_i2c_write(&dev->i2c_bus[0],
 			      COMB_FLAT_THRESH_CTRL + (0x200 * dec), value);
 
-	// set comb 2D blend
+	/* set comb 2D blend */
 	ret_val =
 	    cx25821_i2c_write(&dev->i2c_bus[0], COMB_2D_BLEND + (0x200 * dec),
 			      0x210F0F0F);
 
-	// COMB MISC CONTROL
+	/* COMB MISC CONTROL */
 	ret_val =
 	    cx25821_i2c_write(&dev->i2c_bus[0], COMB_MISC_CTRL + (0x200 * dec),
 			      0x41120A7F);
@@ -295,17 +301,18 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 	mutex_lock(&dev->lock);
 
 	for (i = 0; i < MAX_DECODERS; i++) {
-		// set video format PAL-BDGHI
+		/* set video format PAL-BDGHI */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0], MODE_CTRL + (0x200 * i),
 				     &tmp);
 		value &= 0xFFFFFFF0;
-		value |= 0x10004;	// enable the fast locking mode bit[16]
+		/* enable the fast locking mode bit[16] */
+		value |= 0x10004;
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0], MODE_CTRL + (0x200 * i),
 				      value);
 
-		// resolution PAL 720x576
+		/* resolution PAL 720x576 */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     HORIZ_TIM_CTRL + (0x200 * i), &tmp);
@@ -315,22 +322,22 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      HORIZ_TIM_CTRL + (0x200 * i), value);
 
-		// vblank656_cnt=x26, vactive_cnt=240h, vblank_cnt=x24
+		/* vblank656_cnt=x26, vactive_cnt=240h, vblank_cnt=x24 */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     VERT_TIM_CTRL + (0x200 * i), &tmp);
 		value &= 0x00C00C00;
-		value |= 0x28240026;	// vblank_cnt + 2 to get camera ID
+		value |= 0x28240026;	/* vblank_cnt + 2 to get camera ID */
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      VERT_TIM_CTRL + (0x200 * i), value);
 
-		// chroma subcarrier step size
+		/* chroma subcarrier step size */
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      SC_STEP_SIZE + (0x200 * i), 0x5411E2D0);
 
-		// enable VIP optional active
+		/* enable VIP optional active */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     OUT_CTRL_NS + (0x200 * i), &tmp);
@@ -340,7 +347,7 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      OUT_CTRL_NS + (0x200 * i), value);
 
-		// enable VIP optional active (VIP_OPT_AL) for direct output.
+		/* enable VIP optional active (VIP_OPT_AL) for direct output. */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0], OUT_CTRL1 + (0x200 * i),
 				     &tmp);
@@ -350,18 +357,21 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0], OUT_CTRL1 + (0x200 * i),
 				      value);
 
-		// clear VPRES_VERT_EN bit, fixes the chroma run away problem
-		// when the input switching rate < 16 fields
+		/*
+		 * clear VPRES_VERT_EN bit, fixes the chroma run away problem
+		 * when the input switching rate < 16 fields
+		 */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     MISC_TIM_CTRL + (0x200 * i), &tmp);
-		value = setBitAtPos(value, 14);	// disable special play detection
+		/* disable special play detection */
+		value = setBitAtPos(value, 14);
 		value = clearBitAtPos(value, 15);
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      MISC_TIM_CTRL + (0x200 * i), value);
 
-		// set vbi_gate_en to 0
+		/* set vbi_gate_en to 0 */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0], DFE_CTRL1 + (0x200 * i),
 				     &tmp);
@@ -372,12 +382,12 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 
 		medusa_PALCombInit(dev, i);
 
-		// Enable the generation of blue field output if no video
+		/* Enable the generation of blue field output if no video */
 		medusa_enable_bluefield_output(dev, i, 1);
 	}
 
 	for (i = 0; i < MAX_ENCODERS; i++) {
-		// PAL hclock
+		/* PAL hclock */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     DENC_A_REG_1 + (0x100 * i), &tmp);
@@ -387,7 +397,7 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      DENC_A_REG_1 + (0x100 * i), value);
 
-		// burst begin and burst end
+		/* burst begin and burst end */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     DENC_A_REG_2 + (0x100 * i), &tmp);
@@ -397,7 +407,7 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      DENC_A_REG_2 + (0x100 * i), value);
 
-		// hblank and vactive
+		/* hblank and vactive */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     DENC_A_REG_3 + (0x100 * i), &tmp);
@@ -407,7 +417,7 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      DENC_A_REG_3 + (0x100 * i), value);
 
-		// set PAL vblank, phase alternation, 0 IRE pedestal
+		/* set PAL vblank, phase alternation, 0 IRE pedestal */
 		value =
 		    cx25821_i2c_read(&dev->i2c_bus[0],
 				     DENC_A_REG_4 + (0x100 * i), &tmp);
@@ -430,17 +440,19 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      DENC_A_REG_6 + (0x100 * i), 0x00A493CF);
 
-		// Subcarrier Increment
+		/* Subcarrier Increment */
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      DENC_A_REG_7 + (0x100 * i), 0x2A098ACB);
 	}
 
-	//set picture resolutions
-	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], HSCALE_CTRL, 0x0);	//0 - 720
-	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], VSCALE_CTRL, 0x0);	//0 - 576
+	/* set picture resolutions */
+	/* 0 - 720 */
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], HSCALE_CTRL, 0x0);
+	/* 0 - 576 */
+	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], VSCALE_CTRL, 0x0);
 
-	// set Bypass input format to PAL 625 lines
+	/* set Bypass input format to PAL 625 lines */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], BYP_AB_CTRL, &tmp);
 	value &= 0xFFF7FDFF;
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], BYP_AB_CTRL, value);
@@ -455,18 +467,17 @@ int medusa_set_videostandard(struct cx25821_dev *dev)
 	int status = STATUS_SUCCESS;
 	u32 value = 0, tmp = 0;
 
-	if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK) {
+	if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
 		status = medusa_initialize_pal(dev);
-	} else {
+	else
 		status = medusa_initialize_ntsc(dev);
-	}
 
-	// Enable DENC_A output
+	/* Enable DENC_A output */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_A_REG_4, &tmp);
 	value = setBitAtPos(value, 4);
 	status = cx25821_i2c_write(&dev->i2c_bus[0], DENC_A_REG_4, value);
 
-	// Enable DENC_B output
+	/* Enable DENC_B output */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_B_REG_4, &tmp);
 	value = setBitAtPos(value, 4);
 	status = cx25821_i2c_write(&dev->i2c_bus[0], DENC_B_REG_4, value);
@@ -486,10 +497,10 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 
 	mutex_lock(&dev->lock);
 
-	// validate the width - cannot be negative
+	/* validate the width - cannot be negative */
 	if (width > MAX_WIDTH) {
 		printk
-		    ("cx25821 %s() : width %d > MAX_WIDTH %d ! resetting to MAX_WIDTH \n",
+		    ("cx25821 %s() : width %d > MAX_WIDTH %d ! resetting to MAX_WIDTH\n",
 		     __func__, width, MAX_WIDTH);
 		width = MAX_WIDTH;
 	}
@@ -523,14 +534,14 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 		vscale = 0x1E00;
 		break;
 
-	default:		//720
+	default:		/* 720 */
 		hscale = 0x0;
 		vscale = 0x0;
 		break;
 	}
 
 	for (; decoder < decoder_count; decoder++) {
-		// write scaling values for each decoder
+		/* write scaling values for each decoder */
 		ret_val =
 		    cx25821_i2c_write(&dev->i2c_bus[0],
 				      HSCALE_CTRL + (0x200 * decoder), hscale);
@@ -552,7 +563,7 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 
 	mutex_lock(&dev->lock);
 
-	// no support
+	/* no support */
 	if (decoder < VDEC_A && decoder > VDEC_H) {
 		mutex_unlock(&dev->lock);
 		return;
@@ -577,11 +588,10 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 
 	_display_field_cnt[decoder] = duration;
 
-	// update hardware
+	/* update hardware */
 	fld_cnt = cx25821_i2c_read(&dev->i2c_bus[0], disp_cnt_reg, &tmp);
 
-	if (!(decoder % 2))	// EVEN decoder
-	{
+	if (!(decoder % 2)) {	/* EVEN decoder */
 		fld_cnt &= 0xFFFF0000;
 		fld_cnt |= duration;
 	} else {
@@ -594,8 +604,7 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 	mutex_unlock(&dev->lock);
 }
 
-/////////////////////////////////////////////////////////////////////////////////////////
-// Map to Medusa register setting
+/* Map to Medusa register setting */
 static int mapM(int srcMin,
 		int srcMax, int srcVal, int dstMin, int dstMax, int *dstVal)
 {
@@ -603,20 +612,21 @@ static int mapM(int srcMin,
 	int denominator;
 	int quotient;
 
-	if ((srcMin == srcMax) || (srcVal < srcMin) || (srcVal > srcMax)) {
+	if ((srcMin == srcMax) || (srcVal < srcMin) || (srcVal > srcMax))
 		return -1;
-	}
-	// This is the overall expression used:
-	// *dstVal = (srcVal - srcMin)*(dstMax - dstMin) / (srcMax - srcMin) + dstMin;
-	// but we need to account for rounding so below we use the modulus
-	// operator to find the remainder and increment if necessary.
+	/*
+	 * This is the overall expression used:
+	 * *dstVal =
+	 *   (srcVal - srcMin)*(dstMax - dstMin) / (srcMax - srcMin) + dstMin;
+	 * but we need to account for rounding so below we use the modulus
+	 * operator to find the remainder and increment if necessary.
+	 */
 	numerator = (srcVal - srcMin) * (dstMax - dstMin);
 	denominator = srcMax - srcMin;
 	quotient = numerator / denominator;
 
-	if (2 * (numerator % denominator) >= denominator) {
+	if (2 * (numerator % denominator) >= denominator)
 		quotient++;
-	}
 
 	*dstVal = quotient + dstMin;
 
@@ -636,7 +646,6 @@ static unsigned long convert_to_twos(long numeric, unsigned long bits_len)
 	}
 }
 
-/////////////////////////////////////////////////////////////////////////////////////////
 int medusa_set_brightness(struct cx25821_dev *dev, int brightness, int decoder)
 {
 	int ret_val = 0;
@@ -665,7 +674,6 @@ int medusa_set_brightness(struct cx25821_dev *dev, int brightness, int decoder)
 	return ret_val;
 }
 
-/////////////////////////////////////////////////////////////////////////////////////////
 int medusa_set_contrast(struct cx25821_dev *dev, int contrast, int decoder)
 {
 	int ret_val = 0;
@@ -695,7 +703,6 @@ int medusa_set_contrast(struct cx25821_dev *dev, int contrast, int decoder)
 	return ret_val;
 }
 
-/////////////////////////////////////////////////////////////////////////////////////////
 int medusa_set_hue(struct cx25821_dev *dev, int hue, int decoder)
 {
 	int ret_val = 0;
@@ -727,7 +734,6 @@ int medusa_set_hue(struct cx25821_dev *dev, int hue, int decoder)
 	return ret_val;
 }
 
-/////////////////////////////////////////////////////////////////////////////////////////
 int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)
 {
 	int ret_val = 0;
@@ -768,9 +774,8 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)
 	return ret_val;
 }
 
-/////////////////////////////////////////////////////////////////////////////////////////
-// Program the display sequence and monitor output.
-//
+/* Program the display sequence and monitor output. */
+
 int medusa_video_init(struct cx25821_dev *dev)
 {
 	u32 value = 0, tmp = 0;
@@ -781,7 +786,7 @@ int medusa_video_init(struct cx25821_dev *dev)
 
 	_num_decoders = dev->_max_num_decoders;
 
-	// disable Auto source selection on all video decoders
+	/* disable Auto source selection on all video decoders */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], MON_A_CTRL, &tmp);
 	value &= 0xFFFFF0FF;
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], MON_A_CTRL, value);
@@ -790,7 +795,7 @@ int medusa_video_init(struct cx25821_dev *dev)
 		mutex_unlock(&dev->lock);
 		return -EINVAL;
 	}
-	// Turn off Master source switch enable
+	/* Turn off Master source switch enable */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], MON_A_CTRL, &tmp);
 	value &= 0xFFFFFFDF;
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], MON_A_CTRL, value);
@@ -800,32 +805,31 @@ int medusa_video_init(struct cx25821_dev *dev)
 
 	mutex_unlock(&dev->lock);
 
-	for (i = 0; i < _num_decoders; i++) {
+	for (i = 0; i < _num_decoders; i++)
 		medusa_set_decoderduration(dev, i, _display_field_cnt[i]);
-	}
 
 	mutex_lock(&dev->lock);
 
-	// Select monitor as DENC A input, power up the DAC
+	/* Select monitor as DENC A input, power up the DAC */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_AB_CTRL, &tmp);
 	value &= 0xFF70FF70;
-	value |= 0x00090008;	// set en_active
+	value |= 0x00090008;	/* set en_active */
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], DENC_AB_CTRL, value);
 
 	if (ret_val < 0) {
 		mutex_unlock(&dev->lock);
 		return -EINVAL;
 	}
-	// enable input is VIP/656
+	/* enable input is VIP/656 */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], BYP_AB_CTRL, &tmp);
-	value |= 0x00040100;	// enable VIP
+	value |= 0x00040100;	/* enable VIP */
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], BYP_AB_CTRL, value);
 
 	if (ret_val < 0) {
 		mutex_unlock(&dev->lock);
 		return -EINVAL;
 	}
-	// select AFE clock to output mode
+	/* select AFE clock to output mode */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL, &tmp);
 	value &= 0x83FFFFFF;
 	ret_val =
@@ -836,15 +840,20 @@ int medusa_video_init(struct cx25821_dev *dev)
 		mutex_unlock(&dev->lock);
 		return -EINVAL;
 	}
-	// Turn on all of the data out and control output pins.
+	/* Turn on all of the data out and control output pins. */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], PIN_OE_CTRL, &tmp);
 	value &= 0xFEF0FE00;
 	if (_num_decoders == MAX_DECODERS) {
-		// Note: The octal board does not support control pins(bit16-19).
-		// These bits are ignored in the octal board.
-		value |= 0x010001F8;	// disable VDEC A-C port, default to Mobilygen Interface
+		/*
+		 * Note: The octal board does not support control pins(bit16-19)
+		 * These bits are ignored in the octal board.
+		 *
+		 * disable VDEC A-C port, default to Mobilygen Interface
+		 */
+		value |= 0x010001F8;
 	} else {
-		value |= 0x010F0108;	// disable VDEC A-C port, default to Mobilygen Interface
+		/* disable VDEC A-C port, default to Mobilygen Interface */
+		value |= 0x010F0108;
 	}
 
 	value |= 7;
-- 
1.7.0



