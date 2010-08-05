Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab0HEHay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:30:54 -0400
Received: from mail.perches.com ([173.55.12.10]:2282 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759736Ab0HEH35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:57 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/9] drivers/input: Use pr_fmt and pr_<level>
Date: Thu,  5 Aug 2010 00:29:50 -0700
Message-Id: <755f5bb12b71f441972d58c896c97d1a4860bb5e.1280992119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
In-Reply-To: <cover.1280992116.git.joe@perches.com>
References: <cover.1280992116.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/apm-power.c     |   14 ++++++--------
 drivers/input/evbug.c         |   18 ++++++++++--------
 drivers/input/evdev.c         |   15 ++++++++-------
 drivers/input/ff-core.c       |    6 +++---
 drivers/input/ff-memless.c    |    8 ++++----
 drivers/input/input-polldev.c |    5 +++--
 drivers/input/input.c         |   22 +++++++++++-----------
 drivers/input/joydev.c        |    4 +++-
 drivers/input/mousedev.c      |   10 ++++++----
 drivers/input/xen-kbdfront.c  |   10 +++++-----
 10 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/drivers/input/apm-power.c b/drivers/input/apm-power.c
index 7d61a96..e90ee3d 100644
--- a/drivers/input/apm-power.c
+++ b/drivers/input/apm-power.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -23,8 +25,7 @@ static void system_power_event(unsigned int keycode)
 	switch (keycode) {
 	case KEY_SUSPEND:
 		apm_queue_event(APM_USER_SUSPEND);
-
-		printk(KERN_INFO "apm-power: Requesting system suspend...\n");
+		pr_info("Requesting system suspend...\n");
 		break;
 	default:
 		break;
@@ -65,18 +66,15 @@ static int apmpower_connect(struct input_handler *handler,
 
 	error = input_register_handle(handle);
 	if (error) {
-		printk(KERN_ERR
-			"apm-power: Failed to register input power handler, "
-			"error %d\n", error);
+		pr_err("Failed to register input power handler, error %d\n",
+		       error);
 		kfree(handle);
 		return error;
 	}
 
 	error = input_open_device(handle);
 	if (error) {
-		printk(KERN_ERR
-			"apm-power: Failed to open input power device, "
-			"error %d\n", error);
+		pr_err("Failed to open input power device, error %d\n", error);
 		input_unregister_handle(handle);
 		kfree(handle);
 		return error;
diff --git a/drivers/input/evbug.c b/drivers/input/evbug.c
index f7c5c14..cd4e667 100644
--- a/drivers/input/evbug.c
+++ b/drivers/input/evbug.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/input.h>
@@ -38,8 +40,8 @@ MODULE_LICENSE("GPL");
 
 static void evbug_event(struct input_handle *handle, unsigned int type, unsigned int code, int value)
 {
-	printk(KERN_DEBUG "evbug.c: Event. Dev: %s, Type: %d, Code: %d, Value: %d\n",
-		dev_name(&handle->dev->dev), type, code, value);
+	printk(KERN_DEBUG pr_fmt("Event. Dev: %s, Type: %d, Code: %d, Value: %d\n"),
+	       dev_name(&handle->dev->dev), type, code, value);
 }
 
 static int evbug_connect(struct input_handler *handler, struct input_dev *dev,
@@ -64,10 +66,10 @@ static int evbug_connect(struct input_handler *handler, struct input_dev *dev,
 	if (error)
 		goto err_unregister_handle;
 
-	printk(KERN_DEBUG "evbug.c: Connected device: %s (%s at %s)\n",
-		dev_name(&dev->dev),
-		dev->name ?: "unknown",
-		dev->phys ?: "unknown");
+	printk(KERN_DEBUG pr_fmt("Connected device: %s (%s at %s)\n"),
+	       dev_name(&dev->dev),
+	       dev->name ?: "unknown",
+	       dev->phys ?: "unknown");
 
 	return 0;
 
@@ -80,8 +82,8 @@ static int evbug_connect(struct input_handler *handler, struct input_dev *dev,
 
 static void evbug_disconnect(struct input_handle *handle)
 {
-	printk(KERN_DEBUG "evbug.c: Disconnected device: %s\n",
-		dev_name(&handle->dev->dev));
+	printk(KERN_DEBUG pr_fmt("Disconnected device: %s\n"),
+	       dev_name(&handle->dev->dev));
 
 	input_close_device(handle);
 	input_unregister_handle(handle);
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 783cdd3..5264254 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -8,6 +8,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define EVDEV_MINOR_BASE	64
 #define EVDEV_MINORS		32
 #define EVDEV_MIN_BUFFER_SIZE	64U
@@ -522,12 +524,11 @@ static int handle_eviocgbit(struct input_dev *dev,
 	if (type == EV_KEY && size == OLD_KEY_MAX) {
 		len = OLD_KEY_MAX;
 		if (printk_timed_ratelimit(&keymax_warn_time, 10 * 1000))
-			printk(KERN_WARNING
-				"evdev.c(EVIOCGBIT): Suspicious buffer size %u, "
-				"limiting output to %zu bytes. See "
-				"http://userweb.kernel.org/~dtor/eviocgbit-bug.html\n",
-				OLD_KEY_MAX,
-				BITS_TO_LONGS(OLD_KEY_MAX) * sizeof(long));
+			pr_warning("(EVIOCGBIT): Suspicious buffer size %u, "
+				   "limiting output to %zu bytes. See "
+				   "http://userweb.kernel.org/~dtor/eviocgbit-bug.html\n",
+				   OLD_KEY_MAX,
+				   BITS_TO_LONGS(OLD_KEY_MAX) * sizeof(long));
 	}
 
 	return bits_to_user(bits, len, size, p, compat_mode);
@@ -866,7 +867,7 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 			break;
 
 	if (minor == EVDEV_MINORS) {
-		printk(KERN_ERR "evdev: no more free evdev devices\n");
+		pr_err("no more free evdev devices\n");
 		return -ENFILE;
 	}
 
diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index 03078c0..24aca70 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -23,7 +23,8 @@
 
 /* #define DEBUG */
 
-#define debug(format, arg...) pr_debug("ff-core: " format "\n", ## arg)
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define debug(format, arg...) pr_debug(format "\n", ## arg)
 
 #include <linux/input.h>
 #include <linux/module.h>
@@ -315,8 +316,7 @@ int input_ff_create(struct input_dev *dev, int max_effects)
 	int i;
 
 	if (!max_effects) {
-		printk(KERN_ERR
-		       "ff-core: cannot allocate device without any effects\n");
+		pr_err("cannot allocate device without any effects\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index 1d881c9..236e702 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -23,7 +23,8 @@
 
 /* #define DEBUG */
 
-#define debug(format, arg...) pr_debug("ff-memless: " format "\n", ## arg)
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define debug(format, arg...) pr_debug(format "\n", ##arg)
 
 #include <linux/slab.h>
 #include <linux/input.h>
@@ -215,8 +216,7 @@ static int get_compatible_type(struct ff_device *ff, int effect_type)
 	if (effect_type == FF_PERIODIC && test_bit(FF_RUMBLE, ff->ffbit))
 		return FF_RUMBLE;
 
-	printk(KERN_ERR
-	       "ff-memless: invalid type in get_compatible_type()\n");
+	pr_err("invalid type in get_compatible_type()\n");
 
 	return 0;
 }
@@ -312,7 +312,7 @@ static void ml_combine_effects(struct ff_effect *effect,
 		break;
 
 	default:
-		printk(KERN_ERR "ff-memless: invalid type in ml_combine_effects()\n");
+		pr_err("invalid type in ml_combine_effects()\n");
 		break;
 	}
 
diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index 10c9b0a..0559e30 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -8,6 +8,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
@@ -33,8 +35,7 @@ static int input_polldev_start_workqueue(void)
 	if (!polldev_users) {
 		polldev_wq = create_singlethread_workqueue("ipolldevd");
 		if (!polldev_wq) {
-			printk(KERN_ERR "input-polldev: failed to create "
-				"ipolldevd workqueue\n");
+			pr_err("failed to create ipolldevd workqueue\n");
 			retval = -ENOMEM;
 			goto out;
 		}
diff --git a/drivers/input/input.c b/drivers/input/input.c
index bbb95c1..0d30405 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -10,6 +10,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/input.h>
@@ -1056,10 +1058,8 @@ static int input_attach_handler(struct input_dev *dev, struct input_handler *han
 
 	error = handler->connect(handler, dev, id);
 	if (error && error != -ENODEV)
-		printk(KERN_ERR
-			"input: failed to attach handler %s to device %s, "
-			"error: %d\n",
-			handler->name, kobject_name(&dev->dev.kobj), error);
+		pr_err("failed to attach handler %s to device %s, error: %d\n",
+		       handler->name, kobject_name(&dev->dev.kobj), error);
 
 	return error;
 }
@@ -1890,9 +1890,8 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
 		break;
 
 	default:
-		printk(KERN_ERR
-			"input_set_capability: unknown type %u (code %u)\n",
-			type, code);
+		pr_err("input_set_capability: unknown type %u (code %u)\n",
+		       type, code);
 		dump_stack();
 		return;
 	}
@@ -1980,8 +1979,9 @@ int input_register_device(struct input_dev *dev)
 		return error;
 
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
-	printk(KERN_INFO "input: %s as %s\n",
-		dev->name ? dev->name : "Unspecified device", path ? path : "N/A");
+	pr_info("%s as %s\n",
+		dev->name ? dev->name : "Unspecified device",
+		path ? path : "N/A");
 	kfree(path);
 
 	error = mutex_lock_interruptible(&input_mutex);
@@ -2262,7 +2262,7 @@ static int __init input_init(void)
 
 	err = class_register(&input_class);
 	if (err) {
-		printk(KERN_ERR "input: unable to register input_dev class\n");
+		pr_err("unable to register input_dev class\n");
 		return err;
 	}
 
@@ -2272,7 +2272,7 @@ static int __init input_init(void)
 
 	err = register_chrdev(INPUT_MAJOR, "input", &input_fops);
 	if (err) {
-		printk(KERN_ERR "input: unable to register char major %d", INPUT_MAJOR);
+		pr_err("unable to register char major %d", INPUT_MAJOR);
 		goto fail2;
 	}
 
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index d85bd8a..304261b 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -10,6 +10,8 @@
  * (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 #include <asm/system.h>
 #include <linux/delay.h>
@@ -802,7 +804,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 			break;
 
 	if (minor == JOYDEV_MINORS) {
-		printk(KERN_ERR "joydev: no more free joydev devices\n");
+		pr_err("no more free joydev devices\n");
 		return -ENFILE;
 	}
 
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 83c24cc..5016d64 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -9,6 +9,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MOUSEDEV_MINOR_BASE	32
 #define MOUSEDEV_MINORS		32
 #define MOUSEDEV_MIX		31
@@ -976,7 +978,7 @@ static int mousedev_connect(struct input_handler *handler,
 			break;
 
 	if (minor == MOUSEDEV_MINORS) {
-		printk(KERN_ERR "mousedev: no more free mousedev devices\n");
+		pr_err("no more free mousedev devices\n");
 		return -ENFILE;
 	}
 
@@ -1086,13 +1088,13 @@ static int __init mousedev_init(void)
 #ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
 	error = misc_register(&psaux_mouse);
 	if (error)
-		printk(KERN_WARNING "mice: could not register psaux device, "
-			"error: %d\n", error);
+		pr_warning("could not register psaux device, error: %d\n",
+			   error);
 	else
 		psaux_registered = 1;
 #endif
 
-	printk(KERN_INFO "mice: PS/2 mouse device common for all mice\n");
+	pr_info("PS/2 mouse device common for all mice\n");
 
 	return 0;
 }
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index ebb1190..57ecff1 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -17,6 +17,8 @@
  * Switch to grant tables together with xen-fbfront.c.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -84,9 +86,8 @@ static irqreturn_t input_handler(int rq, void *dev_id)
 				input_report_key(dev, event->key.keycode,
 						 event->key.pressed);
 			else
-				printk(KERN_WARNING
-				       "xenkbd: unhandled keycode 0x%x\n",
-				       event->key.keycode);
+				pr_warning("unhandled keycode 0x%x\n",
+					   event->key.keycode);
 			break;
 		case XENKBD_TYPE_POS:
 			input_report_abs(dev, ABS_X, event->pos.abs_x);
@@ -290,8 +291,7 @@ InitWait:
 			ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
 					    "request-abs-pointer", "1");
 			if (ret)
-				printk(KERN_WARNING
-				       "xenkbd: can't request abs-pointer");
+				pr_warning("can't request abs-pointer\n");
 		}
 		xenbus_switch_state(dev, XenbusStateConnected);
 		break;
-- 
1.7.2.19.g9a302

