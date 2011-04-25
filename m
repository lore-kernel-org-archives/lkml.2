Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab1DYJ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:57:21 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:52027 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758143Ab1DYJ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:57:20 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Joerg Heckenbach <joerg@heckenbach-aw.de>
Subject: [PATCH] usbvision: add Nogatech USB MicroCam
Date: Mon, 25 Apr 2011 11:57:08 +0200
User-Agent: KMail/1.9.10
Cc: Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104251157.10921.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Nogatech USB MicroCam PAL (NV3001P) and NTSC (NV3000N) support to
usbvision driver.
PAL version is tested, NTSC untested.
Data captured using usbsnoop, init_values are listed in the INF file along
with image dimensions, offsets and frame rates.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff -up linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-cards.c 
linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-cards.c
--- linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-cards.c	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-cards.c	2011-04-24 20:11:42.000000000 +0200
@@ -1025,6 +1025,34 @@ struct usbvision_device_data_st  usbvisi
 		.y_offset       = -1,
 		.model_string   = "Hauppauge WinTv-USB",
 	},
+	[MICROCAM_NTSC] = {
+		.interface      = -1,
+		.codec          = CODEC_WEBCAM,
+		.video_channels = 1,
+		.video_norm     = V4L2_STD_NTSC,
+		.audio_channels = 0,
+		.radio          = 0,
+		.vbi            = 0,
+		.tuner          = 0,
+		.tuner_type     = 0,
+		.x_offset       = 71,
+		.y_offset       = 15,
+		.model_string   = "Nogatech USB MicroCam NTSC (NV3000N)",
+	},
+	[MICROCAM_PAL] = {
+		.interface      = -1,
+		.codec          = CODEC_WEBCAM,
+		.video_channels = 1,
+		.video_norm     = V4L2_STD_PAL,
+		.audio_channels = 0,
+		.radio          = 0,
+		.vbi            = 0,
+		.tuner          = 0,
+		.tuner_type     = 0,
+		.x_offset       = 71,
+		.y_offset       = 18,
+		.model_string   = "Nogatech USB MicroCam PAL (NV3001P)",
+	},
 };
 const int usbvision_device_data_size = ARRAY_SIZE(usbvision_device_data);
 
@@ -1042,6 +1070,8 @@ struct usb_device_id usbvision_table[] =
 	{ USB_DEVICE(0x0573, 0x2d00), .driver_info = HPG_WINTV_LIVE_PAL_BG },
 	{ USB_DEVICE(0x0573, 0x2d01), .driver_info = HPG_WINTV_LIVE_PRO_NTSC_MN },
 	{ USB_DEVICE(0x0573, 0x2101), .driver_info = ZORAN_PMD_NOGATECH },
+	{ USB_DEVICE(0x0573, 0x3000), .driver_info = MICROCAM_NTSC },
+	{ USB_DEVICE(0x0573, 0x3001), .driver_info = MICROCAM_PAL },
 	{ USB_DEVICE(0x0573, 0x4100), .driver_info = NOGATECH_USB_TV_NTSC_FM },
 	{ USB_DEVICE(0x0573, 0x4110), .driver_info = PNY_USB_TV_NTSC_FM },
 	{ USB_DEVICE(0x0573, 0x4450), .driver_info = PV_PLAYTV_USB_PRO_PAL_FM },
@@ -1088,8 +1118,7 @@ struct usb_device_id usbvision_table[] =
 	{ USB_DEVICE(0x2304, 0x0110), .driver_info = PINNA_PCTV_USB_PAL_FM },
 	{ USB_DEVICE(0x2304, 0x0111), .driver_info = MIRO_PCTV_USB },
 	{ USB_DEVICE(0x2304, 0x0112), .driver_info = PINNA_PCTV_USB_NTSC_FM },
-	{ USB_DEVICE(0x2304, 0x0113),
-	  .driver_info = PINNA_PCTV_USB_NTSC_FM_V3 },
+	{ USB_DEVICE(0x2304, 0x0113), .driver_info = PINNA_PCTV_USB_NTSC_FM_V3 },
 	{ USB_DEVICE(0x2304, 0x0210), .driver_info = PINNA_PCTV_USB_PAL_FM_V2 },
 	{ USB_DEVICE(0x2304, 0x0212), .driver_info = PINNA_PCTV_USB_NTSC_FM_V2 },
 	{ USB_DEVICE(0x2304, 0x0214), .driver_info = PINNA_PCTV_USB_PAL_FM_V3 },
diff -up linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-cards.h 
linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-cards.h
--- linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-cards.h	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-cards.h	2011-04-20 22:10:14.000000000 +0200
@@ -63,5 +63,7 @@
 #define PINNA_PCTV_BUNGEE_PAL_FM                 62
 #define HPG_WINTV                                63
 #define PINNA_PCTV_USB_NTSC_FM_V3                64
+#define MICROCAM_NTSC                            65
+#define MICROCAM_PAL                             66
 
 extern const int usbvision_device_data_size;
diff -up linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-core.c 
linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-core.c
--- linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-core.c	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-core.c	2011-04-25 11:49:44.000000000 +0200
@@ -1679,6 +1679,53 @@ int usbvision_power_off(struct usb_usbvi
 	return err_code;
 }
 
+static int usbvision_init_webcam(struct usb_usbvision *usbvision)
+{
+	int rc;
+	int i;
+	static char init_values[38][3] = {
+		{ 0x04, 0x12, 0x08 }, { 0x05, 0xff, 0xc8 }, { 0x06, 0x18, 0x07 }, { 0x07, 0x90, 0x00 },
+		{ 0x09, 0x00, 0x00 }, { 0x0a, 0x00, 0x00 }, { 0x0b, 0x08, 0x00 }, { 0x0d, 0xcc, 0xcc },
+		{ 0x0e, 0x13, 0x14 }, { 0x10, 0x9b, 0x83 }, { 0x11, 0x5a, 0x3f }, { 0x12, 0xe4, 0x73 },
+		{ 0x13, 0x88, 0x84 }, { 0x14, 0x89, 0x80 }, { 0x15, 0x00, 0x20 }, { 0x16, 0x00, 0x00 },
+		{ 0x17, 0xff, 0xa0 }, { 0x18, 0x6b, 0x20 }, { 0x19, 0x22, 0x40 }, { 0x1a, 0x10, 0x07 },
+		{ 0x1b, 0x00, 0x47 }, { 0x1c, 0x03, 0xe0 }, { 0x1d, 0x00, 0x00 }, { 0x1e, 0x00, 0x00 },
+		{ 0x1f, 0x00, 0x00 }, { 0x20, 0x00, 0x00 }, { 0x21, 0x00, 0x00 }, { 0x22, 0x00, 0x00 },
+		{ 0x23, 0x00, 0x00 }, { 0x24, 0x00, 0x00 }, { 0x25, 0x00, 0x00 }, { 0x26, 0x00, 0x00 },
+		{ 0x27, 0x00, 0x00 }, { 0x28, 0x00, 0x00 }, { 0x29, 0x00, 0x00 }, { 0x08, 0x80, 0x60 },
+		{ 0x0f, 0x2d, 0x24 }, { 0x0c, 0x80, 0x80 }
+	};
+	char value[3];
+
+	/* the only difference between PAL and NTSC init_values */
+	if (usbvision_device_data[usbvision->dev_model].video_norm == V4L2_STD_NTSC)
+		init_values[4][1] = 0x34;
+
+	for (i = 0; i < sizeof(init_values) / 3; i++) {
+		memcpy(value, init_values[i], 3);
+		usbvision_write_reg(usbvision, USBVISION_SER_MODE, 0x00);
+		rc = usb_control_msg(usbvision->dev,
+				     usb_sndctrlpipe(usbvision->dev, 1),
+				     USBVISION_OP_CODE,
+				     USB_DIR_OUT | USB_TYPE_VENDOR |
+				     USB_RECIP_ENDPOINT, 0,
+				     (__u16) USBVISION_SER_DAT1, value,
+				     3, HZ);
+		if (rc < 0)
+			return rc;
+		usbvision_write_reg(usbvision, USBVISION_SER_MODE, 0x10);
+		usbvision_write_reg(usbvision, USBVISION_SER_CONT, 0x13);
+		usbvision_write_reg(usbvision, USBVISION_IOPIN_REG, 0x00);
+		usbvision_write_reg(usbvision, USBVISION_SER_MODE, 0x00);
+		usbvision_write_reg(usbvision, USBVISION_IOPIN_REG, 0x02);
+		usbvision_write_reg(usbvision, USBVISION_SER_MODE, 0x01);
+		usbvision_write_reg(usbvision, USBVISION_SER_MODE, 0x02);
+		usbvision_write_reg(usbvision, USBVISION_SER_MODE, 0x03);
+	}
+
+	return 0;
+}
+
 /*
  * usbvision_set_video_format()
  *
@@ -1797,6 +1844,13 @@ int usbvision_set_output(struct usb_usbv
 
 	frame_drop = FRAMERATE_MAX;	/* We can allow the maximum here, because dropping is controlled */
 
+	if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM) {
+		if (usbvision_device_data[usbvision->dev_model].video_norm == V4L2_STD_PAL)
+			frame_drop = 25;
+		else
+			frame_drop = 30;
+	}
+
 	/* frame_drop = 7; => frame_phase = 1, 5, 9, 13, 17, 21, 25, 0, 4, 8, ...
 		=> frame_skip = 4;
 		=> frame_rate = (7 + 1) * 25 / 32 = 200 / 32 = 6.25;
@@ -2046,6 +2100,12 @@ int usbvision_set_input(struct usb_usbvi
 		value[7] = 0x00;	/* 0x0010 -> 16 Input video v offset */
 	}
 
+	/* webcam is only 480 pixels wide, both PAL and NTSC version */
+	if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM) {
+		value[0] = 0xe0;
+		value[1] = 0x01;	/* 0x01E0 -> 480 Input video line length */
+	}
+
 	if (usbvision_device_data[usbvision->dev_model].x_offset >= 0) {
 		value[4] = usbvision_device_data[usbvision->dev_model].x_offset & 0xff;
 		value[5] = (usbvision_device_data[usbvision->dev_model].x_offset & 0x0300) >> 8;
@@ -2148,7 +2208,7 @@ static int usbvision_set_dram_settings(s
 			     (__u16) USBVISION_DRM_PRM1, value, 8, HZ);
 
 	if (rc < 0) {
-		dev_err(&usbvision->dev->dev, "%sERROR=%d\n", __func__, rc);
+		dev_err(&usbvision->dev->dev, "%s: ERROR=%d\n", __func__, rc);
 		return rc;
 	}
 
@@ -2180,8 +2240,15 @@ int usbvision_power_on(struct usb_usbvis
 	usbvision_write_reg(usbvision, USBVISION_PWR_REG,
 			USBVISION_SSPND_EN | USBVISION_RES2);
 
+	if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM) {
+		usbvision_write_reg(usbvision, USBVISION_VIN_REG1,
+				USBVISION_16_422_SYNC | USBVISION_HVALID_PO);
+		usbvision_write_reg(usbvision, USBVISION_VIN_REG2,
+				USBVISION_NOHVALID | USBVISION_KEEP_BLANK);
+	}
 	usbvision_write_reg(usbvision, USBVISION_PWR_REG,
 			USBVISION_SSPND_EN | USBVISION_PWR_VID);
+	mdelay(10);
 	err_code = usbvision_write_reg(usbvision, USBVISION_PWR_REG,
 			USBVISION_SSPND_EN | USBVISION_PWR_VID | USBVISION_RES2);
 	if (err_code == 1)
@@ -2310,6 +2377,8 @@ int usbvision_set_audio(struct usb_usbvi
 
 int usbvision_setup(struct usb_usbvision *usbvision, int format)
 {
+	if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM)
+		usbvision_init_webcam(usbvision);
 	usbvision_set_video_format(usbvision, format);
 	usbvision_set_dram_settings(usbvision);
 	usbvision_set_compress_params(usbvision);
diff -up linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision.h linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision.h
--- linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision.h	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision.h	2011-04-24 23:01:59.000000000 +0200
@@ -328,6 +328,7 @@ struct usbvision_frame {
 
 #define CODEC_SAA7113	7113
 #define CODEC_SAA7111	7111
+#define CODEC_WEBCAM	3000
 #define BRIDGE_NT1003	1003
 #define BRIDGE_NT1004	1004
 #define BRIDGE_NT1005   1005
diff -up linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-i2c.c linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-i2c.c
--- linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-i2c.c	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-i2c.c	2011-04-24 21:16:53.000000000 +0200
@@ -222,7 +222,7 @@ int usbvision_i2c_register(struct usb_us
 	i2c_set_adapdata(&usbvision->i2c_adap, &usbvision->v4l2_dev);
 
 	if (usbvision_write_reg(usbvision, USBVISION_SER_MODE, USBVISION_IIC_LRNACK) < 0) {
-		printk(KERN_ERR "usbvision_register: can't write reg\n");
+		printk(KERN_ERR "usbvision_i2c_register: can't write reg\n");
 		return -EBUSY;
 	}
 
diff -up linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-video.c 
linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-video.c
--- linux-2.6.39-rc2-orig/drivers/media/video/usbvision//usbvision-video.c	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision//usbvision-video.c	2011-04-24 21:16:02.000000000 +0200
@@ -1470,7 +1470,8 @@ static void usbvision_configure_video(st
 
 	/* This should be here to make i2c clients to be able to register */
 	/* first switch off audio */
-	usbvision_audio_off(usbvision);
+	if (usbvision_device_data[model].audio_channels > 0)
+		usbvision_audio_off(usbvision);
 	if (!power_on_at_open) {
 		/* and then power up the noisy tuner */
 		usbvision_power_on(usbvision);


-- 
Ondrej Zary
