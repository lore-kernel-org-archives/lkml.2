Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0KSP4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:56:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab0KSPz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:55:28 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/5] Backlight: Add backlight type
Date: Fri, 19 Nov 2010 10:53:52 -0500
Message-Id: <1290182036-30484-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be multiple ways of controlling the backlight on a given machine.
Allow drivers to expose the type of interface they are providing, making
it possible for userspace to make appropriate policy decisions.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
---
 Documentation/ABI/stable/sysfs-class-backlight     |   20 ++++++++++++++++++++
 drivers/acpi/video.c                               |    1 +
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |    2 ++
 drivers/hid/hid-picolcd.c                          |    1 +
 drivers/macintosh/via-pmu-backlight.c              |    1 +
 drivers/platform/x86/acer-wmi.c                    |    1 +
 drivers/platform/x86/asus-laptop.c                 |    1 +
 drivers/platform/x86/asus_acpi.c                   |    1 +
 drivers/platform/x86/classmate-laptop.c            |    1 +
 drivers/platform/x86/compal-laptop.c               |    1 +
 drivers/platform/x86/dell-laptop.c                 |    1 +
 drivers/platform/x86/eeepc-laptop.c                |    1 +
 drivers/platform/x86/eeepc-wmi.c                   |    1 +
 drivers/platform/x86/fujitsu-laptop.c              |    1 +
 drivers/platform/x86/msi-laptop.c                  |    1 +
 drivers/platform/x86/msi-wmi.c                     |    1 +
 drivers/platform/x86/panasonic-laptop.c            |    1 +
 drivers/platform/x86/sony-laptop.c                 |    1 +
 drivers/platform/x86/thinkpad_acpi.c               |    1 +
 drivers/platform/x86/toshiba_acpi.c                |    1 +
 drivers/staging/olpc_dcon/olpc_dcon.c              |    1 +
 drivers/staging/samsung-laptop/samsung-laptop.c    |    1 +
 drivers/usb/misc/appledisplay.c                    |    1 +
 drivers/video/atmel_lcdfb.c                        |    1 +
 drivers/video/aty/aty128fb.c                       |    1 +
 drivers/video/aty/atyfb_base.c                     |    1 +
 drivers/video/aty/radeon_backlight.c               |    1 +
 drivers/video/backlight/88pm860x_bl.c              |    1 +
 drivers/video/backlight/adp5520_bl.c               |    1 +
 drivers/video/backlight/adp8860_bl.c               |    1 +
 drivers/video/backlight/adx_bl.c                   |    1 +
 drivers/video/backlight/atmel-pwm-bl.c             |    1 +
 drivers/video/backlight/backlight.c                |   15 +++++++++++++++
 drivers/video/backlight/corgi_lcd.c                |    1 +
 drivers/video/backlight/cr_bllcd.c                 |    1 +
 drivers/video/backlight/da903x_bl.c                |    1 +
 drivers/video/backlight/ep93xx_bl.c                |    1 +
 drivers/video/backlight/generic_bl.c               |    1 +
 drivers/video/backlight/hp680_bl.c                 |    1 +
 drivers/video/backlight/jornada720_bl.c            |    1 +
 drivers/video/backlight/kb3886_bl.c                |    1 +
 drivers/video/backlight/locomolcd.c                |    1 +
 drivers/video/backlight/max8925_bl.c               |    1 +
 drivers/video/backlight/mbp_nvidia_bl.c            |    1 +
 drivers/video/backlight/omap1_bl.c                 |    1 +
 drivers/video/backlight/pcf50633-backlight.c       |    1 +
 drivers/video/backlight/progear_bl.c               |    1 +
 drivers/video/backlight/pwm_bl.c                   |    1 +
 drivers/video/backlight/s6e63m0.c                  |    1 +
 drivers/video/backlight/tosa_bl.c                  |    1 +
 drivers/video/backlight/wm831x_bl.c                |    1 +
 drivers/video/bf54x-lq043fb.c                      |    1 +
 drivers/video/bfin-t350mcqb-fb.c                   |    1 +
 drivers/video/imxfb.c                              |    1 +
 drivers/video/nvidia/nv_backlight.c                |    1 +
 drivers/video/omap2/displays/panel-acx565akm.c     |    1 +
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |    1 +
 drivers/video/omap2/displays/panel-taal.c          |    2 ++
 drivers/video/riva/fbdev.c                         |    1 +
 include/linux/backlight.h                          |    8 ++++++++
 60 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-backlight b/Documentation/ABI/stable/sysfs-class-backlight
index 4d637e1..70302f3 100644
--- a/Documentation/ABI/stable/sysfs-class-backlight
+++ b/Documentation/ABI/stable/sysfs-class-backlight
@@ -34,3 +34,23 @@ Contact:	Richard Purdie <rpurdie@rpsys.net>
 Description:
 		Maximum brightness for <backlight>.
 Users:		HAL
+
+What:		/sys/class/backlight/<backlight>/type
+Date:		September 2010
+KernelVersion:	2.6.37
+Contact:	Matthew Garrett <mjg@redhat.com>
+Description:
+		The type of interface controlled by <backlight>.
+		"firmware": The driver uses a standard firmware interface
+		"platform": The driver uses a platform-specific interface
+		"raw": The driver controls hardware registers directly
+
+		In the general case, when multiple backlight
+		interfaces are available for a single device, firmware
+		control should be preferred to platform control should
+		be preferred to raw control. Using a firmware
+		interface reduces the probability of confusion with
+		the hardware and the OS independently updating the
+		backlight state. Platform interfaces are mostly a
+		holdover from pre-standardisation of firmware
+		interfaces.
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 5cd0228..38165a8 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -856,6 +856,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 		count++;
 
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_FIRMWARE;
 		props.max_brightness = device->brightness->count - 3;
 		device->backlight = backlight_device_register(name, NULL, device,
 							      &acpi_backlight_ops,
diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 406228f..9485af3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -97,6 +97,7 @@ static int nouveau_nv40_backlight_init(struct drm_device *dev)
 		return 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 31;
 	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
 				       &nv40_bl_ops, &props);
@@ -120,6 +121,7 @@ static int nouveau_nv50_backlight_init(struct drm_device *dev)
 		return 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 1025;
 	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
 				       &nv50_bl_ops, &props);
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index bc2e077..3418b82 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -944,6 +944,7 @@ static int picolcd_init_backlight(struct picolcd_data *data, struct hid_report *
 	}
 
 	memset(&props, 0, sizeof(props));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
 	bdev = backlight_device_register(dev_name(dev), dev, data,
 			&picolcd_blops, &props);
diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index 1cec02f..364a295 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -163,6 +163,7 @@ void __init pmu_backlight_init()
 	snprintf(name, sizeof(name), "pmubl");
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, NULL, NULL, &pmu_backlight_data,
 				       &props);
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index c8c6537..3d3fcfc 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -926,6 +926,7 @@ static int __devinit acer_backlight_init(struct device *dev)
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = max_brightness;
 	bd = backlight_device_register("acer-wmi", dev, NULL, &acer_bl_ops,
 				       &props);
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 60a5a5c..60b0159 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -648,6 +648,7 @@ static int asus_backlight_init(struct asus_laptop *asus)
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = 15;
+	props.type = BACKLIGHT_PLATFORM;
 
 	bd = backlight_device_register(ASUS_LAPTOP_FILE,
 				       &asus->platform_device->dev, asus,
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index ca05aef..3ea8df5 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1513,6 +1513,7 @@ static int __init asus_acpi_init(void)
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 15;
 	asus_backlight_device = backlight_device_register("asus", NULL, NULL,
 							  &asus_backlight_data,
diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 341cbfe..0ade3a4 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -562,6 +562,7 @@ static int cmpc_ipml_add(struct acpi_device *acpi)
 		return -ENOMEM;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 7;
 	ipml->bd = backlight_device_register("cmpc_bl", &acpi->dev,
 					     acpi->handle, &cmpc_bl_ops,
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 097083c..1e66477 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -962,6 +962,7 @@ static int __init compal_init(void)
 	if (!acpi_video_backlight_support()) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = BACKLIGHT_LEVEL_MAX;
 		compalbl_device = backlight_device_register(DRIVER_NAME,
 							    NULL, NULL,
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index cf8a89a..3a54613 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -651,6 +651,7 @@ static int __init dell_init(void)
 	if (max_intensity) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = max_intensity;
 		dell_backlight_device = backlight_device_register("dell_backlight",
 								  &platform_device->dev,
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index b2edfdc..697505b 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1136,6 +1136,7 @@ static int eeepc_backlight_init(struct eeepc_laptop *eeepc)
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 15;
 	bd = backlight_device_register(EEEPC_LAPTOP_FILE,
 				       &eeepc->platform_device->dev, eeepc,
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 462ceab..29f607b 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -233,6 +233,7 @@ static int eeepc_wmi_backlight_init(struct eeepc_wmi *eeepc)
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = 15;
+	props.type = BACKLIGHT_PLATFORM;
 	bd = backlight_device_register(EEEPC_WMI_FILE,
 				       &platform_device->dev, eeepc,
 				       &eeepc_wmi_bl_ops, &props);
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index f44cd26..f5376c6 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1128,6 +1128,7 @@ static int __init fujitsu_init(void)
 
 		memset(&props, 0, sizeof(struct backlight_properties));
 		max_brightness = fujitsu->max_brightness;
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = max_brightness - 1;
 		fujitsu->bl_device = backlight_device_register("fujitsu-laptop",
 							       NULL, NULL,
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 7e9bb6d..142d385 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -804,6 +804,7 @@ static int __init msi_init(void)
 	} else {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = MSI_LCD_LEVEL_MAX - 1;
 		msibl_device = backlight_device_register("msi-laptop-bl", NULL,
 							 NULL, &msibl_ops,
diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index 42a5469..064d8d6 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -252,6 +252,7 @@ static int __init msi_wmi_init(void)
 	if (!acpi_video_backlight_support()) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = ARRAY_SIZE(backlight_map) - 1;
 		backlight = backlight_device_register(DRV_NAME, NULL, NULL,
 						      &msi_backlight_ops,
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index cc1e0ba..05be30e 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -602,6 +602,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	}
 	/* initialize backlight */
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = pcc->sinf[SINF_AC_MAX_BRIGHT];
 	pcc->backlight = backlight_device_register("panasonic", NULL, pcc,
 						   &pcc_backlight_ops, &props);
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index f200677..138d8ab 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1297,6 +1297,7 @@ static int sony_nc_add(struct acpi_device *device)
 						&handle))) {
 							struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = SONY_MAX_BRIGHTNESS - 1;
 		sony_backlight_device = backlight_device_register("sony", NULL,
 								  NULL,
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2d61186..6dedc97 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6310,6 +6310,7 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 		return 1;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = bright_maxlvl;
 	props.brightness = b & TP_EC_BACKLIGHT_LVLMSK;
 	ibm_backlight_device = backlight_device_register(TPACPI_BACKLIGHT_DEV_NAME,
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 06f304f..a5533a1 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1017,6 +1017,7 @@ static int __init toshiba_acpi_init(void)
 		create_toshiba_proc_entries();
 	}
 
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 	toshiba_backlight_device = backlight_device_register("toshiba",
 							     &toshiba_acpi.p_dev->dev,
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 75aa7a36..a5915f4 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -718,6 +718,7 @@ static int dcon_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 	else {
 		dcon_bl_dev->props.max_brightness = 15;
+		dcon_bl_dev->props.type = BACKLIGHT_RAW;
 		dcon_bl_dev->props.power = FB_BLANK_UNBLANK;
 		dcon_bl_dev->props.brightness = dcon_get_backlight();
 
diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index eb44b60..6c55f38 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -488,6 +488,7 @@ static int __init samsung_init(void)
 
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = MAX_BRIGHT;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
 						     NULL, &backlight_ops,
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 1fa6ce3..68ab460 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -282,6 +282,7 @@ static int appledisplay_probe(struct usb_interface *iface,
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
 	pdata->bd = backlight_device_register(bl_name, NULL, pdata,
 					      &appledisplay_bl_data, &props);
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 8dce251..7d40604 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -127,6 +127,7 @@ static void init_backlight(struct atmel_lcdfb_info *sinfo)
 		return;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
 	bl = backlight_device_register("backlight", &sinfo->pdev->dev, sinfo,
 				       &atmel_lcdc_bl_ops, &props);
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 34a0851..ac3b7e3 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1818,6 +1818,7 @@ static void aty128_bl_init(struct aty128fb_par *par)
 	snprintf(name, sizeof(name), "aty128bl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &aty128_bl_data,
 				       &props);
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 5bf9123..9f9deb5 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2241,6 +2241,7 @@ static void aty_bl_init(struct atyfb_par *par)
 	snprintf(name, sizeof(name), "atybl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &aty_bl_data,
 				       &props);
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 256966e..732f665 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -158,6 +158,7 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 	snprintf(name, sizeof(name), "radeonbl%d", rinfo->info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, rinfo->info->dev, pdata,
 				       &radeon_bl_data, &props);
diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 38ffc3f..d5e51e2 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -227,6 +227,7 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
 	bl = backlight_device_register(name, &pdev->dev, data,
 					&pm860x_backlight_ops, &props);
diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index 9f436e0..af31197 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -303,6 +303,7 @@ static int __devinit adp5520_bl_probe(struct platform_device *pdev)
 	mutex_init(&data->lock);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = ADP5020_MAX_BRIGHTNESS;
 	bl = backlight_device_register(pdev->name, data->master, data,
 				       &adp5520_bl_ops, &props);
diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 734c650..d2a96a4 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -709,6 +709,7 @@ static int __devinit adp8860_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, data);
 
 	memset(&props, 0, sizeof(props));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = ADP8860_MAX_BRIGHTNESS;
 
 	mutex_init(&data->lock);
diff --git a/drivers/video/backlight/adx_bl.c b/drivers/video/backlight/adx_bl.c
index fe9af12..c861c41 100644
--- a/drivers/video/backlight/adx_bl.c
+++ b/drivers/video/backlight/adx_bl.c
@@ -104,6 +104,7 @@ static int __devinit adx_backlight_probe(struct platform_device *pdev)
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
 	bldev = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
 					  bl, &adx_backlight_ops, &props);
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index e6a66da..0443a4f 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -168,6 +168,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = pdata->pwm_duty_max - pdata->pwm_duty_min;
 	bldev = backlight_device_register("atmel-pwm-bl", &pdev->dev, pwmbl,
 					  &atmel_pwm_bl_ops, &props);
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index e207810..074502c 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -19,6 +19,12 @@
 #include <asm/backlight.h>
 #endif
 
+static const char *backlight_types[] = {
+	[BACKLIGHT_RAW] = "raw",
+	[BACKLIGHT_PLATFORM] = "platform",
+	[BACKLIGHT_FIRMWARE] = "firmware",
+};
+
 #if defined(CONFIG_FB) || (defined(CONFIG_FB_MODULE) && \
 			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
 /* This callback gets called when something important happens inside a
@@ -169,6 +175,14 @@ static ssize_t backlight_store_brightness(struct device *dev,
 	return rc;
 }
 
+static ssize_t backlight_show_type(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	return sprintf(buf, "%s\n", backlight_types[bd->props.type]);
+}
+
 static ssize_t backlight_show_max_brightness(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -234,6 +248,7 @@ static struct device_attribute bl_device_attributes[] = {
 	__ATTR(actual_brightness, 0444, backlight_show_actual_brightness,
 		     NULL),
 	__ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
+	__ATTR(type, 0444, backlight_show_type, NULL),
 	__ATTR_NULL,
 };
 
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 1e71c35..af60983 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -562,6 +562,7 @@ static int __devinit corgi_lcd_probe(struct spi_device *spi)
 	lcd->mode = (pdata) ? pdata->init_mode : CORGI_LCD_MODE_VGA;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = pdata->max_intensity;
 	lcd->bl_dev = backlight_device_register("corgi_bl", &spi->dev, lcd,
 						&corgi_bl_ops, &props);
diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index a4f4546..d7d1673 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -193,6 +193,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	bdp = backlight_device_register("cr-backlight", &pdev->dev, NULL,
 					&cr_backlight_ops, &props);
 	if (IS_ERR(bdp)) {
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 87659ed..62043f1 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -136,6 +136,7 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 		da903x_write(data->da903x_dev, DA9034_WLED_CONTROL2,
 				DA9034_WLED_ISET(pdata->output_current));
 
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_brightness;
 	bl = backlight_device_register(pdev->name, data->da903x_dev, data,
 				       &da903x_backlight_ops, &props);
diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index b0cc491..9f1e389 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -87,6 +87,7 @@ static int __init ep93xxbl_probe(struct platform_device *dev)
 	ep93xxbl->mmio = EP93XX_RASTER_BRIGHTNESS;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = EP93XX_MAX_BRIGHT;
 	bl = backlight_device_register(dev->name, &dev->dev, ep93xxbl,
 				       &ep93xxbl_ops, &props);
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 312ca61..8c6befd 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -91,6 +91,7 @@ static int genericbl_probe(struct platform_device *pdev)
 		name = machinfo->name;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = machinfo->max_intensity;
 	bd = backlight_device_register(name, &pdev->dev, NULL, &genericbl_ops,
 				       &props);
diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 267d23f..38aa002 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -109,6 +109,7 @@ static int __devinit hp680bl_probe(struct platform_device *pdev)
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = HP680_MAX_INTENSITY;
 	bd = backlight_device_register("hp680-bl", &pdev->dev, NULL,
 				       &hp680bl_ops, &props);
diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 2f177b3..40e4fa8 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -106,6 +106,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = BL_MAX_BRIGHT;
 	bd = backlight_device_register(S1D_DEVICENAME, &pdev->dev, NULL,
 				       &jornada_bl_ops, &props);
diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index f439a86..72dd555 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -149,6 +149,7 @@ static int kb3886bl_probe(struct platform_device *pdev)
 		machinfo->limit_mask = -1;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = machinfo->max_intensity;
 	kb3886_backlight_device = backlight_device_register("kb3886-bl",
 							    &pdev->dev, NULL,
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index d2f5901..bbca312 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -184,6 +184,7 @@ static int locomolcd_probe(struct locomo_dev *ldev)
 	local_irq_restore(flags);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 4;
 	locomolcd_bl_device = backlight_device_register("locomo-bl",
 							&ldev->dev, NULL,
diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index b2b2c7b..8d25610 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -136,6 +136,7 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 	data->current_brightness = 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
 	bl = backlight_device_register(name, &pdev->dev, data,
 					&max8925_backlight_ops, &props);
diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 1485f73..74c3394 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -367,6 +367,7 @@ static int __init mbp_init(void)
 		return -ENXIO;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 15;
 	mbp_backlight_device = backlight_device_register("mbp_backlight", NULL,
 							 NULL,
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index d3bc562..08d26a7 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -146,6 +146,7 @@ static int omapbl_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = OMAPBL_MAX_INTENSITY;
 	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops,
 					&props);
diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
index 3c424f7..ef5628d 100644
--- a/drivers/video/backlight/pcf50633-backlight.c
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -112,6 +112,7 @@ static int __devinit pcf50633_bl_probe(struct platform_device *pdev)
 	if (!pcf_bl)
 		return -ENOMEM;
 
+	bl_props.type = BACKLIGHT_RAW;
 	bl_props.max_brightness = 0x3f;
 	bl_props.power = FB_BLANK_UNBLANK;
 
diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 809278c..6af183d 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -84,6 +84,7 @@ static int progearbl_probe(struct platform_device *pdev)
 	pci_write_config_byte(sb_dev, SB_MPS1, temp | 0x20);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
 	progear_backlight_device = backlight_device_register("progear-bl",
 							     &pdev->dev, NULL,
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 21866ec..2c2a2c7 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -108,6 +108,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		dev_dbg(&pdev->dev, "got pwm for backlight\n");
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = data->max_brightness;
 	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, pb,
 				       &pwm_backlight_ops, &props);
diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 5927db0..322040f 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -778,6 +778,7 @@ static int __devinit s6e63m0_probe(struct spi_device *spi)
 
 	bd->props.max_brightness = MAX_BRIGHTNESS;
 	bd->props.brightness = MAX_BRIGHTNESS;
+	bd->props.type = BACKLIGHT_RAW;
 	lcd->bd = bd;
 
 	/*
diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 2a04b38..425a736 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -102,6 +102,7 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 	data->i2c = client;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 512 - 1;
 	data->bl = backlight_device_register("tosa-bl", &client->dev, data,
 					     &bl_ops, &props);
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 08fd87f..d4c6eb2 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -193,6 +193,7 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	data->current_brightness = 0;
 	data->isink_reg = isink_reg;
 
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_isel;
 	bl = backlight_device_register("wm831x", &pdev->dev, data,
 				       &wm831x_backlight_ops, &props);
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index e7d0f52..2464b91 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -649,6 +649,7 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 	}
 #ifndef NO_BL_SUPPORT
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 255;
 	bl_dev = backlight_device_register("bf54x-bl", NULL, NULL,
 					   &bfin_lq043fb_bl_ops, &props);
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 3cf7767..d8de29f 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -545,6 +545,7 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 	}
 #ifndef NO_BL_SUPPORT
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 255;
 	bl_dev = backlight_device_register("bf52x-bl", NULL, NULL,
 					   &bfin_lq043fb_bl_ops, &props);
diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index 5c363d0..01d1793 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -502,6 +502,7 @@ static void imxfb_init_backlight(struct imxfb_info *fbi)
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = 0xff;
+	props.type = BACKLIGHT_RAW;
 	writel(fbi->pwmr, fbi->regs + LCDC_PWMR);
 
 	bl = backlight_device_register("imxfb-bl", &fbi->pdev->dev, fbi,
diff --git a/drivers/video/nvidia/nv_backlight.c b/drivers/video/nvidia/nv_backlight.c
index 2fb552a..74ba5da 100644
--- a/drivers/video/nvidia/nv_backlight.c
+++ b/drivers/video/nvidia/nv_backlight.c
@@ -111,6 +111,7 @@ void nvidia_bl_init(struct nvidia_par *par)
 	snprintf(name, sizeof(name), "nvidiabl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &nvidia_bl_ops,
 				       &props);
diff --git a/drivers/video/omap2/displays/panel-acx565akm.c b/drivers/video/omap2/displays/panel-acx565akm.c
index e773106..7e04c92 100644
--- a/drivers/video/omap2/displays/panel-acx565akm.c
+++ b/drivers/video/omap2/displays/panel-acx565akm.c
@@ -534,6 +534,7 @@ static int acx_panel_probe(struct omap_dss_device *dssdev)
 
 	props.fb_blank = FB_BLANK_UNBLANK;
 	props.power = FB_BLANK_UNBLANK;
+	props.type = BACKLIGHT_RAW;
 
 	bldev = backlight_device_register("acx565akm", &md->spi->dev,
 			md, &acx565akm_bl_ops, &props);
diff --git a/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c b/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c
index 9a138f6..d2b35d2 100644
--- a/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c
+++ b/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c
@@ -99,6 +99,7 @@ static int sharp_ls_panel_probe(struct omap_dss_device *dssdev)
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = dssdev->max_backlight_level;
+	props.type = BACKLIGHT_RAW;
 
 	bl = backlight_device_register("sharp-ls", &dssdev->dev, dssdev,
 			&sharp_ls_bl_ops, &props);
diff --git a/drivers/video/omap2/displays/panel-taal.c b/drivers/video/omap2/displays/panel-taal.c
index e1c765d..d16a7cd 100644
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@ -729,6 +729,8 @@ static int taal_probe(struct omap_dss_device *dssdev)
 		props.max_brightness = 255;
 	else
 		props.max_brightness = 127;
+
+	props.type = BACKLIGHT_RAW;
 	bldev = backlight_device_register("taal", &dssdev->dev, dssdev,
 					  &taal_bl_ops, &props);
 	if (IS_ERR(bldev)) {
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 618f36b..9058ba5 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -355,6 +355,7 @@ static void riva_bl_init(struct riva_par *par)
 	snprintf(name, sizeof(name), "rivabl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &riva_bl_ops,
 				       &props);
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 4a3d52e..5b45437 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -32,6 +32,12 @@ enum backlight_update_reason {
 	BACKLIGHT_UPDATE_SYSFS,
 };
 
+enum backlight_type {
+	BACKLIGHT_RAW,
+	BACKLIGHT_PLATFORM,
+	BACKLIGHT_FIRMWARE,
+};
+
 struct backlight_device;
 struct fb_info;
 
@@ -62,6 +68,8 @@ struct backlight_properties {
 	/* FB Blanking active? (values as for power) */
 	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
 	int fb_blank;
+	/* Backlight type */
+	enum backlight_type type;
 	/* Flags used to signal drivers of state changes */
 	/* Upper 4 bits are reserved for driver internal use */
 	unsigned int state;
-- 
1.7.3.2

