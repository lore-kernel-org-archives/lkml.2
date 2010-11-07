Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab0KGNOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 08:14:53 -0500
Received: from nm6-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.234]:41144 "HELO
	nm6-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751374Ab0KGNOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 08:14:52 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Nov 2010 08:14:51 EST
X-Yahoo-Newman-Id: 31321.42369.bm@omp1014.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject;
  b=Ypn/o7id2mP+myQbpg5Z6rKpj2QnksBb0A/bF+SpaBsNGvBID3uJHh0OYk+l4Ob4nlXg2fSUlyF3bIk2MsiDFCoEebkdfK6puNgTlzgq+v7d/AbxYho5bSrA5/hBM6sW0UJj9PqBkVKEXeFpXOPHmd5BHBev3vZvs3dLyqKZHdw=  ;
Message-ID: <966510.59743.qm@smtp129.mail.ukl.yahoo.com>
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-YMail-OSG: BIs6BckVM1kDTgSArsfO7EC8WzBxLGN32HjocO6RxK_YJVb
 nEpb1F4ELjJAbHzrJ2yXfT_FLrix3WYSNE.qKMNO4rAnOK0eKYMPCl1zRmnK
 WDqnRqg2xpkYZAedAYM7skVE8j4p6vlm6eQXGmntWrPc8dIwz6NYJvjxhVRH
 vrQGJ8ztO8oMVyvZb4bxfL1uwkP_OMxnJ13xb_XXJpwlnqal5lepHV6XQxNs
 daQKV212nDN_jW.sJuM.8T2IeCHe9kIJsLO_LPZaj0J6xN0TJzaeX8eGI2dY
 H_ATsXKAgOn0gZbbiWZ040O1xlActs59FdVF1gq09qVigMOc56N5zbvH2CGd
 l1k4rldb6
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 07 Nov 2010 14:09:45 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] backlight: constify backlight_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against mainline.

---

Subject: [PATCH] backlight: constify backlight_ops

backlight_device_register already expects a const "ops" argument,
so let's make the backlight_ops instances const.

Inspired by hunks of the grsecurity patch, updated for newer kernels.
Even though backlight_ops is already part of the list of "should be const"
operations structures of 2.6.35 checkpatch.pl, one non-const struct instance
constified by this patch has been added after 2.6.35.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 drivers/acpi/video.c                            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c     |    4 ++--
 drivers/macintosh/via-pmu-backlight.c           |    4 ++--
 drivers/platform/x86/acer-wmi.c                 |    2 +-
 drivers/platform/x86/asus-laptop.c              |    2 +-
 drivers/platform/x86/asus_acpi.c                |    2 +-
 drivers/platform/x86/dell-laptop.c              |    2 +-
 drivers/platform/x86/eeepc-laptop.c             |    2 +-
 drivers/platform/x86/fujitsu-laptop.c           |    2 +-
 drivers/platform/x86/sony-laptop.c              |    2 +-
 drivers/platform/x86/thinkpad_acpi.c            |    2 +-
 drivers/platform/x86/toshiba_acpi.c             |    2 +-
 drivers/staging/msm/msm_fb_bl.c                 |    2 +-
 drivers/staging/olpc_dcon/olpc_dcon.c           |    2 +-
 drivers/staging/samsung-laptop/samsung-laptop.c |    2 +-
 drivers/video/atmel_lcdfb.c                     |    2 +-
 drivers/video/aty/aty128fb.c                    |    2 +-
 drivers/video/aty/atyfb_base.c                  |    2 +-
 drivers/video/aty/radeon_backlight.c            |    2 +-
 drivers/video/backlight/88pm860x_bl.c           |    2 +-
 drivers/video/backlight/max8925_bl.c            |    2 +-
 drivers/video/nvidia/nv_backlight.c             |    2 +-
 drivers/video/omap2/displays/panel-taal.c       |    2 +-
 drivers/video/riva/fbdev.c                      |    2 +-
 24 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 5cd0228..15a0fde 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -260,7 +260,7 @@ static int acpi_video_set_brightness(struct backlight_device *bd)
 				vd->brightness->levels[request_level]);
 }
 
-static struct backlight_ops acpi_backlight_ops = {
+static const struct backlight_ops acpi_backlight_ops = {
 	.get_brightness = acpi_video_get_brightness,
 	.update_status  = acpi_video_set_brightness,
 };
diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 406228f..8933e98 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -58,7 +58,7 @@ static int nv40_set_intensity(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops nv40_bl_ops = {
+static const struct backlight_ops nv40_bl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = nv40_get_intensity,
 	.update_status = nv40_set_intensity,
@@ -81,7 +81,7 @@ static int nv50_set_intensity(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops nv50_bl_ops = {
+static const struct backlight_ops nv50_bl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = nv50_get_intensity,
 	.update_status = nv50_set_intensity,
diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index 1cec02f..ade1e65 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -15,7 +15,7 @@
 
 #define MAX_PMU_LEVEL 0xFF
 
-static struct backlight_ops pmu_backlight_data;
+static const struct backlight_ops pmu_backlight_data;
 static DEFINE_SPINLOCK(pmu_backlight_lock);
 static int sleeping, uses_pmu_bl;
 static u8 bl_curve[FB_BACKLIGHT_LEVELS];
@@ -115,7 +115,7 @@ static int pmu_backlight_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops pmu_backlight_data = {
+static const struct backlight_ops pmu_backlight_data = {
 	.get_brightness	= pmu_backlight_get_brightness,
 	.update_status	= pmu_backlight_update_status,
 
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index c8c6537..1d0b707 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -915,7 +915,7 @@ static int update_bl_status(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops acer_bl_ops = {
+static const struct backlight_ops acer_bl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 60a5a5c..3640599 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -621,7 +621,7 @@ static int update_bl_status(struct backlight_device *bd)
 	return asus_lcd_set(asus, value);
 }
 
-static struct backlight_ops asusbl_ops = {
+static const struct backlight_ops asusbl_ops = {
 	.get_brightness = asus_read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index ca05aef..4633fd8 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1467,7 +1467,7 @@ static int asus_hotk_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
-static struct backlight_ops asus_backlight_data = {
+static const struct backlight_ops asus_backlight_data = {
 	.get_brightness = read_brightness,
 	.update_status  = set_brightness_status,
 };
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index cf8a89a..34657f9 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -546,7 +546,7 @@ out:
 	return buffer->output[1];
 }
 
-static struct backlight_ops dell_ops = {
+static const struct backlight_ops dell_ops = {
 	.get_brightness = dell_get_intensity,
 	.update_status  = dell_send_intensity,
 };
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index b2edfdc..c062a65 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1115,7 +1115,7 @@ static int update_bl_status(struct backlight_device *bd)
 	return set_brightness(bd, bd->props.brightness);
 }
 
-static struct backlight_ops eeepcbl_ops = {
+static const struct backlight_ops eeepcbl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index f44cd26..34d0dc5 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -437,7 +437,7 @@ static int bl_update_status(struct backlight_device *b)
 	return ret;
 }
 
-static struct backlight_ops fujitsubl_ops = {
+static const struct backlight_ops fujitsubl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status = bl_update_status,
 };
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index f200677..f8b2fc9 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -856,7 +856,7 @@ static int sony_backlight_get_brightness(struct backlight_device *bd)
 }
 
 static struct backlight_device *sony_backlight_device;
-static struct backlight_ops sony_backlight_ops = {
+static const struct backlight_ops sony_backlight_ops = {
 	.update_status = sony_backlight_update_status,
 	.get_brightness = sony_backlight_get_brightness,
 };
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2d61186..0e4387c 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6109,7 +6109,7 @@ static void tpacpi_brightness_notify_change(void)
 			       BACKLIGHT_UPDATE_HOTKEY);
 }
 
-static struct backlight_ops ibm_backlight_data = {
+static const struct backlight_ops ibm_backlight_data = {
 	.get_brightness = brightness_get,
 	.update_status  = brightness_update_status,
 };
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 06f304f..81bca5a 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -840,7 +840,7 @@ static void remove_toshiba_proc_entries(void)
 	remove_proc_entry("version", toshiba_proc_dir);
 }
 
-static struct backlight_ops toshiba_backlight_data = {
+static const struct backlight_ops toshiba_backlight_data = {
         .get_brightness = get_lcd,
         .update_status  = set_lcd_status,
 };
diff --git a/drivers/staging/msm/msm_fb_bl.c b/drivers/staging/msm/msm_fb_bl.c
index 033fc94..2a80775 100644
--- a/drivers/staging/msm/msm_fb_bl.c
+++ b/drivers/staging/msm/msm_fb_bl.c
@@ -42,7 +42,7 @@ static int msm_fb_bl_update_status(struct backlight_device *pbd)
 	return 0;
 }
 
-static struct backlight_ops msm_fb_bl_ops = {
+static const struct backlight_ops msm_fb_bl_ops = {
 	.get_brightness = msm_fb_bl_get_brightness,
 	.update_status = msm_fb_bl_update_status,
 };
diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 75aa7a36..d40ff41 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -616,7 +616,7 @@ static struct device_attribute dcon_device_files[] = {
 	__ATTR(resumeline, 0644, dcon_resumeline_show, dcon_resumeline_store),
 };
 
-static struct backlight_ops dcon_bl_ops = {
+static const struct backlight_ops dcon_bl_ops = {
 	.get_brightness = dconbl_get,
 	.update_status = dconbl_set
 };
diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index eb44b60..80eeec6 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -269,7 +269,7 @@ static int update_status(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops backlight_ops = {
+static const struct backlight_ops backlight_ops = {
 	.get_brightness	= get_brightness,
 	.update_status	= update_status,
 };
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 8dce251..bac16345 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -111,7 +111,7 @@ static int atmel_bl_get_brightness(struct backlight_device *bl)
 	return lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
 }
 
-static struct backlight_ops atmel_lcdc_bl_ops = {
+static const struct backlight_ops atmel_lcdc_bl_ops = {
 	.update_status = atmel_bl_update_status,
 	.get_brightness = atmel_bl_get_brightness,
 };
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 34a0851..dd9de2e 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1786,7 +1786,7 @@ static int aty128_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops aty128_bl_data = {
+static const struct backlight_ops aty128_bl_data = {
 	.get_brightness	= aty128_bl_get_brightness,
 	.update_status	= aty128_bl_update_status,
 };
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 5bf9123..4d5c413 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2221,7 +2221,7 @@ static int aty_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops aty_bl_data = {
+static const struct backlight_ops aty_bl_data = {
 	.get_brightness = aty_bl_get_brightness,
 	.update_status	= aty_bl_update_status,
 };
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 256966e..9b811dd 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -128,7 +128,7 @@ static int radeon_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops radeon_bl_data = {
+static const struct backlight_ops radeon_bl_data = {
 	.get_brightness = radeon_bl_get_brightness,
 	.update_status	= radeon_bl_update_status,
 };
diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 38ffc3f..c789c46 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -155,7 +155,7 @@ out:
 	return -EINVAL;
 }
 
-static struct backlight_ops pm860x_backlight_ops = {
+static const struct backlight_ops pm860x_backlight_ops = {
 	.options	= BL_CORE_SUSPENDRESUME,
 	.update_status	= pm860x_backlight_update_status,
 	.get_brightness	= pm860x_backlight_get_brightness,
diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index b2b2c7b..209acc1 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -92,7 +92,7 @@ static int max8925_backlight_get_brightness(struct backlight_device *bl)
 	return ret;
 }
 
-static struct backlight_ops max8925_backlight_ops = {
+static const struct backlight_ops max8925_backlight_ops = {
 	.options	= BL_CORE_SUSPENDRESUME,
 	.update_status	= max8925_backlight_update_status,
 	.get_brightness	= max8925_backlight_get_brightness,
diff --git a/drivers/video/nvidia/nv_backlight.c b/drivers/video/nvidia/nv_backlight.c
index 2fb552a..6aac6d1 100644
--- a/drivers/video/nvidia/nv_backlight.c
+++ b/drivers/video/nvidia/nv_backlight.c
@@ -87,7 +87,7 @@ static int nvidia_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops nvidia_bl_ops = {
+static const struct backlight_ops nvidia_bl_ops = {
 	.get_brightness = nvidia_bl_get_brightness,
 	.update_status	= nvidia_bl_update_status,
 };
diff --git a/drivers/video/omap2/displays/panel-taal.c b/drivers/video/omap2/displays/panel-taal.c
index e1c765d..61026f9 100644
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@ -465,7 +465,7 @@ static int taal_bl_get_intensity(struct backlight_device *dev)
 	return 0;
 }
 
-static struct backlight_ops taal_bl_ops = {
+static const struct backlight_ops taal_bl_ops = {
 	.get_brightness = taal_bl_get_intensity,
 	.update_status  = taal_bl_update_status,
 };
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 618f36b..da38818 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -331,7 +331,7 @@ static int riva_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops riva_bl_ops = {
+static const struct backlight_ops riva_bl_ops = {
 	.get_brightness = riva_bl_get_brightness,
 	.update_status	= riva_bl_update_status,
 };
-- 
1.7.3.2.161.g3089c


