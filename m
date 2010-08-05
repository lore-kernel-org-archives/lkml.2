Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960Ab0HEHbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:31:55 -0400
Received: from mail.perches.com ([173.55.12.10]:2272 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759871Ab0HEH3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:55 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/9] drivers/input/misc: Use pr_fmt and pr_<level>
Date: Thu,  5 Aug 2010 00:29:45 -0700
Message-Id: <fb900077a3ed3e7f50e780a653ddbe2a43e9ab87.1280992118.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
In-Reply-To: <cover.1280992116.git.joe@perches.com>
References: <cover.1280992116.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup #define dbginfo
Remove #define err, use pr_err

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/misc/ati_remote.c   |   22 ++++++++++++----------
 drivers/input/misc/ati_remote2.c  |    6 ++++--
 drivers/input/misc/cm109.c        |   23 +++++++++--------------
 drivers/input/misc/hp_sdc_rtc.c   |   10 ++++++----
 drivers/input/misc/m68kspkr.c     |    4 +++-
 drivers/input/misc/powermate.c    |   19 +++++++++++--------
 drivers/input/misc/uinput.c       |   25 ++++++++++++++-----------
 drivers/input/misc/winbond-cir.c  |    6 ++++--
 drivers/input/misc/wistron_btns.c |   29 +++++++++++++++--------------
 drivers/input/misc/yealink.c      |    5 +++--
 10 files changed, 81 insertions(+), 68 deletions(-)

diff --git a/drivers/input/misc/ati_remote.c b/drivers/input/misc/ati_remote.c
index bce5712..c705ac0 100644
--- a/drivers/input/misc/ati_remote.c
+++ b/drivers/input/misc/ati_remote.c
@@ -85,6 +85,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -139,9 +141,11 @@ static int repeat_delay = REPEAT_DELAY;
 module_param(repeat_delay, int, 0644);
 MODULE_PARM_DESC(repeat_delay, "Delay before sending repeats, default = 500 msec");
 
-#define dbginfo(dev, format, arg...) do { if (debug) dev_info(dev , format , ## arg); } while (0)
-#undef err
-#define err(format, arg...) printk(KERN_ERR format , ## arg)
+#define dbginfo(dev, format, arg...)		\
+do {						\
+	if (debug)				\
+		dev_info(dev, format, ##arg);	\
+} while (0)
 
 static struct usb_device_id ati_remote_table[] = {
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA_REMOTE_PRODUCT_ID) },
@@ -738,7 +742,7 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 	int err = -ENOMEM;
 
 	if (iface_host->desc.bNumEndpoints != 2) {
-		err("%s: Unexpected desc.bNumEndpoints\n", __func__);
+		pr_err("%s: Unexpected desc.bNumEndpoints\n", __func__);
 		return -ENODEV;
 	}
 
@@ -746,11 +750,11 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 	endpoint_out = &iface_host->endpoint[1].desc;
 
 	if (!usb_endpoint_is_int_in(endpoint_in)) {
-		err("%s: Unexpected endpoint_in\n", __func__);
+		pr_err("%s: Unexpected endpoint_in\n", __func__);
 		return -ENODEV;
 	}
 	if (le16_to_cpu(endpoint_in->wMaxPacketSize) == 0) {
-		err("%s: endpoint_in message size==0? \n", __func__);
+		pr_err("%s: endpoint_in message size==0?\n", __func__);
 		return -ENODEV;
 	}
 
@@ -838,11 +842,9 @@ static int __init ati_remote_init(void)
 
 	result = usb_register(&ati_remote_driver);
 	if (result)
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": usb_register error #%d\n", result);
+		pr_err("usb_register error #%d\n", result);
 	else
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
 
 	return result;
 }
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index 2325765..7b75f96 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -9,6 +9,8 @@
  * as published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/usb/input.h>
 #include <linux/slab.h>
 
@@ -975,9 +977,9 @@ static int __init ati_remote2_init(void)
 
 	r = usb_register(&ati_remote2_driver);
 	if (r)
-		printk(KERN_ERR "ati_remote2: usb_register() = %d\n", r);
+		pr_err("usb_register() = %d\n", r);
 	else
-		printk(KERN_INFO "ati_remote2: " DRIVER_DESC " " DRIVER_VERSION "\n");
+		pr_info(DRIVER_DESC " " DRIVER_VERSION "\n");
 
 	return r;
 }
diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 2b0eba6..9ae40cb 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -28,6 +28,8 @@
  *   - Read/write EEPROM
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -518,8 +520,7 @@ static int cm109_input_open(struct input_dev *idev)
 
 	error = usb_autopm_get_interface(dev->intf);
 	if (error < 0) {
-		err("%s - cannot autoresume, result %d",
-		    __func__, error);
+		err("%s: cannot autoresume, result %d",  __func__, error);
 		return error;
 	}
 
@@ -855,23 +856,18 @@ static int __init cm109_select_keymap(void)
 	/* Load the phone keymap */
 	if (!strcasecmp(phone, "kip1000")) {
 		keymap = keymap_kip1000;
-		printk(KERN_INFO KBUILD_MODNAME ": "
-			"Keymap for Komunikate KIP1000 phone loaded\n");
+		pr_info("Keymap for Komunikate KIP1000 phone loaded\n");
 	} else if (!strcasecmp(phone, "gtalk")) {
 		keymap = keymap_gtalk;
-		printk(KERN_INFO KBUILD_MODNAME ": "
-			"Keymap for Genius G-talk phone loaded\n");
+		pr_info("Keymap for Genius G-talk phone loaded\n");
 	} else if (!strcasecmp(phone, "usbph01")) {
 		keymap = keymap_usbph01;
-		printk(KERN_INFO KBUILD_MODNAME ": "
-			"Keymap for Allied-Telesis Corega USBPH01 phone loaded\n");
+		pr_info("Keymap for Allied-Telesis Corega USBPH01 phone loaded\n");
 	} else if (!strcasecmp(phone, "atcom")) {
 		keymap = keymap_atcom;
-		printk(KERN_INFO KBUILD_MODNAME ": "
-			"Keymap for ATCom AU-100 phone loaded\n");
+		pr_info("Keymap for ATCom AU-100 phone loaded\n");
 	} else {
-		printk(KERN_ERR KBUILD_MODNAME ": "
-			"Unsupported phone: %s\n", phone);
+		pr_err("Unsupported phone: %s\n", phone);
 		return -EINVAL;
 	}
 
@@ -890,8 +886,7 @@ static int __init cm109_init(void)
 	if (err)
 		return err;
 
-	printk(KERN_INFO KBUILD_MODNAME ": "
-		DRIVER_DESC ": " DRIVER_VERSION " (C) " DRIVER_AUTHOR "\n");
+	pr_info(DRIVER_DESC ": " DRIVER_VERSION " (C) " DRIVER_AUTHOR "\n");
 
 	return 0;
 }
diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index c190664..209a1af 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -33,6 +33,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/hp_sdc.h>
 #include <linux/errno.h>
 #include <linux/types.h>
@@ -703,13 +705,13 @@ static int __init hp_sdc_rtc_init(void)
 	if ((ret = hp_sdc_request_timer_irq(&hp_sdc_rtc_isr)))
 		return ret;
 	if (misc_register(&hp_sdc_rtc_dev) != 0)
-		printk(KERN_INFO "Could not register misc. dev for i8042 rtc\n");
+		pr_info("Could not register misc. dev for i8042 rtc\n");
 
         create_proc_read_entry ("driver/rtc", 0, NULL,
 				hp_sdc_rtc_read_proc, NULL);
 
-	printk(KERN_INFO "HP i8042 SDC + MSM-58321 RTC support loaded "
-			 "(RTC v " RTC_VERSION ")\n");
+	pr_info("HP i8042 SDC + MSM-58321 RTC support loaded "
+		"(RTC v " RTC_VERSION ")\n");
 
 	return 0;
 }
@@ -719,7 +721,7 @@ static void __exit hp_sdc_rtc_exit(void)
 	remove_proc_entry ("driver/rtc", NULL);
         misc_deregister(&hp_sdc_rtc_dev);
 	hp_sdc_release_timer_irq(hp_sdc_rtc_isr);
-        printk(KERN_INFO "HP i8042 SDC + MSM-58321 RTC support unloaded\n");
+	pr_info("HP i8042 SDC + MSM-58321 RTC support unloaded\n");
 }
 
 module_init(hp_sdc_rtc_init);
diff --git a/drivers/input/misc/m68kspkr.c b/drivers/input/misc/m68kspkr.c
index 0c64d9b..13c1bc8 100644
--- a/drivers/input/misc/m68kspkr.c
+++ b/drivers/input/misc/m68kspkr.c
@@ -13,6 +13,8 @@
  * the Free Software Foundation
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -113,7 +115,7 @@ static int __init m68kspkr_init(void)
 	int err;
 
 	if (!mach_beep) {
-		printk(KERN_INFO "m68kspkr: no lowlevel beep support\n");
+		pr_info("no lowlevel beep support\n");
 		return -ENODEV;
         }
 
diff --git a/drivers/input/misc/powermate.c b/drivers/input/misc/powermate.c
index bf170f6..8c3777c 100644
--- a/drivers/input/misc/powermate.c
+++ b/drivers/input/misc/powermate.c
@@ -28,6 +28,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -167,12 +169,12 @@ static void powermate_sync_state(struct powermate_device *pm)
 		pm->configcr->wIndex = cpu_to_le16( pm->static_brightness );
 		pm->requires_update &= ~UPDATE_STATIC_BRIGHTNESS;
 	} else {
-		printk(KERN_ERR "powermate: unknown update required");
+		pr_err("unknown update required\n");
 		pm->requires_update = 0; /* fudge the bug */
 		return;
 	}
 
-/*	printk("powermate: %04x %04x\n", pm->configcr->wValue, pm->configcr->wIndex); */
+/*	pr_info("%04x %04x\n", pm->configcr->wValue, pm->configcr->wIndex); */
 
 	pm->configcr->bRequestType = 0x41; /* vendor request */
 	pm->configcr->bRequest = 0x01;
@@ -183,7 +185,7 @@ static void powermate_sync_state(struct powermate_device *pm)
 			     powermate_config_complete, pm);
 
 	if (usb_submit_urb(pm->config, GFP_ATOMIC))
-		printk(KERN_ERR "powermate: usb_submit_urb(config) failed");
+		pr_err("usb_submit_urb(config) failed\n");
 }
 
 /* Called when our asynchronous control message completes. We may need to issue another immediately */
@@ -193,7 +195,7 @@ static void powermate_config_complete(struct urb *urb)
 	unsigned long flags;
 
 	if (urb->status)
-		printk(KERN_ERR "powermate: config urb returned %d\n", urb->status);
+		pr_err("config urb returned %d\n", urb->status);
 
 	spin_lock_irqsave(&pm->lock, flags);
 	powermate_sync_state(pm);
@@ -346,8 +348,8 @@ static int powermate_probe(struct usb_interface *intf, const struct usb_device_i
 		break;
 	default:
 		input_dev->name = pm_name_soundknob;
-		printk(KERN_WARNING "powermate: unknown product id %04x\n",
-		       le16_to_cpu(udev->descriptor.idProduct));
+		pr_warning("unknown product id %04x\n",
+			   le16_to_cpu(udev->descriptor.idProduct));
 	}
 
 	input_dev->phys = pm->phys;
@@ -369,8 +371,9 @@ static int powermate_probe(struct usb_interface *intf, const struct usb_device_i
 	maxp = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
 
 	if (maxp < POWERMATE_PAYLOAD_SIZE_MIN || maxp > POWERMATE_PAYLOAD_SIZE_MAX) {
-		printk(KERN_WARNING "powermate: Expected payload of %d--%d bytes, found %d bytes!\n",
-			POWERMATE_PAYLOAD_SIZE_MIN, POWERMATE_PAYLOAD_SIZE_MAX, maxp);
+		pr_warning("Expected payload of %d--%d bytes, found %d bytes!\n",
+			   POWERMATE_PAYLOAD_SIZE_MIN,
+			   POWERMATE_PAYLOAD_SIZE_MAX, maxp);
 		maxp = POWERMATE_PAYLOAD_SIZE_MAX;
 	}
 
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index bb53fd33..92b56da 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -29,6 +29,9 @@
  *	0.1	20/06/2002
  *		- first public version
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -246,7 +249,7 @@ static int uinput_create_device(struct uinput_device *udev)
 	int error;
 
 	if (udev->state != UIST_SETUP_COMPLETE) {
-		printk(KERN_DEBUG "%s: write device info first\n", UINPUT_NAME);
+		printk(KERN_DEBUG pr_fmt("write device info first\n"));
 		return -EINVAL;
 	}
 
@@ -306,10 +309,10 @@ static int uinput_validate_absbits(struct input_dev *dev)
 
 		if (input_abs_get_max(dev, cnt) <= input_abs_get_min(dev, cnt)) {
 			printk(KERN_DEBUG
-				"%s: invalid abs[%02x] min:%d max:%d\n",
-				UINPUT_NAME, cnt,
-				input_abs_get_min(dev, cnt),
-				input_abs_get_max(dev, cnt));
+			       pr_fmt("invalid abs[%02x] min:%d max:%d\n"),
+			       cnt,
+			       input_abs_get_min(dev, cnt),
+			       input_abs_get_max(dev, cnt));
 			retval = -EINVAL;
 			break;
 		}
@@ -317,12 +320,12 @@ static int uinput_validate_absbits(struct input_dev *dev)
 		if (input_abs_get_flat(dev, cnt) >
 		    input_abs_get_max(dev, cnt) - input_abs_get_min(dev, cnt)) {
 			printk(KERN_DEBUG
-				"%s: abs_flat #%02x out of range: %d "
-				"(min:%d/max:%d)\n",
-				UINPUT_NAME, cnt,
-				input_abs_get_flat(dev, cnt),
-				input_abs_get_min(dev, cnt),
-				input_abs_get_max(dev, cnt));
+			       pr_fmt("abs_flat #%02x out of range: %d "
+				      "(min:%d/max:%d)\n"),
+			       cnt,
+			       input_abs_get_flat(dev, cnt),
+			       input_abs_get_min(dev, cnt),
+			       input_abs_get_max(dev, cnt));
 			retval = -EINVAL;
 			break;
 		}
diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index 64f1de7..5cc6607 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -44,6 +44,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/pnp.h>
 #include <linux/interrupt.h>
@@ -1581,13 +1583,13 @@ wbcir_init(void)
 	case IR_PROTOCOL_RC6:
 		break;
 	default:
-		printk(KERN_ERR DRVNAME ": Invalid protocol argument\n");
+		pr_err("Invalid protocol argument\n");
 		return -EINVAL;
 	}
 
 	ret = pnp_register_driver(&wbcir_driver);
 	if (ret)
-		printk(KERN_ERR DRVNAME ": Unable to register driver\n");
+		pr_err("Unable to register driver\n");
 
 	return ret;
 }
diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
index 12501de..8aff2fe 100644
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -17,6 +17,9 @@
  * with this program; if not, write to the Free Software Foundation, Inc.,
  * 59 Temple Place Suite 330, Boston, MA 02111-1307, USA.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/io.h>
 #include <linux/dmi.h>
 #include <linux/init.h>
@@ -111,15 +114,15 @@ static int __init map_bios(void)
 	base = ioremap(0xF0000, 0x10000); /* Can't fail */
 	offset = locate_wistron_bios(base);
 	if (offset < 0) {
-		printk(KERN_ERR "wistron_btns: BIOS entry point not found\n");
+		pr_err("BIOS entry point not found\n");
 		iounmap(base);
 		return -ENODEV;
 	}
 
 	entry_point = readl(base + offset + 5);
 	printk(KERN_DEBUG
-		"wistron_btns: BIOS signature found at %p, entry point %08X\n",
-		base + offset, entry_point);
+	       pr_fmt("BIOS signature found at %p, entry point %08X\n"),
+	       base + offset, entry_point);
 
 	if (entry_point >= 0xF0000) {
 		bios_code_map_base = base;
@@ -128,9 +131,8 @@ static int __init map_bios(void)
 		iounmap(base);
 		bios_code_map_base = ioremap(entry_point & ~0x3FFF, 0x4000);
 		if (bios_code_map_base == NULL) {
-			printk(KERN_ERR
-				"wistron_btns: Can't map BIOS code at %08X\n",
-				entry_point & ~0x3FFF);
+			pr_err("Can't map BIOS code at %08X\n",
+			       entry_point & ~0x3FFF);
 			goto err;
 		}
 		bios_entry_point = bios_code_map_base + (entry_point & 0x3FFF);
@@ -138,7 +140,7 @@ static int __init map_bios(void)
 	/* The Windows driver maps 0x10000 bytes, we keep only one page... */
 	bios_data_map_base = ioremap(0x400, 0xc00);
 	if (bios_data_map_base == NULL) {
-		printk(KERN_ERR "wistron_btns: Can't map BIOS data\n");
+		pr_err("Can't map BIOS data\n");
 		goto err_code;
 	}
 	return 0;
@@ -1006,13 +1008,13 @@ static int __init select_keymap(void)
 		else if (strcmp (keymap_name, "generic") == 0)
 			keymap = keymap_wistron_generic;
 		else {
-			printk(KERN_ERR "wistron_btns: Keymap unknown\n");
+			pr_err("Keymap unknown\n");
 			return -EINVAL;
 		}
 	}
 	if (keymap == NULL) {
 		if (!force) {
-			printk(KERN_ERR "wistron_btns: System unknown\n");
+			pr_err("System unknown\n");
 			return -ENODEV;
 		}
 		keymap = keymap_empty;
@@ -1132,8 +1134,7 @@ static void handle_key(u8 code)
 		}
 		jiffies_last_press = jiffies;
 	} else
-		printk(KERN_NOTICE
-			"wistron_btns: Unknown key code %02X\n", code);
+		pr_notice("Unknown key code %02X\n", code);
 }
 
 static void poll_bios(bool discard)
@@ -1190,9 +1191,9 @@ static int __devinit wistron_setup_keymap(struct input_dev *dev,
 
 	case KE_END:
 		if (entry->code & FE_UNTESTED)
-			printk(KERN_WARNING "Untested laptop multimedia keys, "
-				"please report success or failure to "
-				"eric.piel@tremplin-utc.net\n");
+			pr_warning("Untested laptop multimedia keys, "
+				   "please report success or failure to "
+				   "eric.piel@tremplin-utc.net\n");
 		break;
 	}
 
diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index 41201c6..39af7c0 100644
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -46,6 +46,8 @@
  *   20050816 henk	Merge 2.6.13-rc6
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -992,8 +994,7 @@ static int __init yealink_dev_init(void)
 {
 	int ret = usb_register(&yealink_driver);
 	if (ret == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
 	return ret;
 }
 
-- 
1.7.2.19.g9a302

