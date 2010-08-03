Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab0HCSk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:40:59 -0400
Received: from mail.perches.com ([173.55.12.10]:2218 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029Ab0HCSky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:40:54 -0400
Subject: [PATCH 2.6.37? ] drivers/input: Use pr_<level>
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 11:40:50 -0700
Message-ID: <1280860850.2963.24.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove prefixes from printks and convert to pr_fmt/pr_<level>.

Always make output prefix match module name.
There are some existing uses that do not.  For instance:
spaceorb used "input: " once, probably a copy/paste error,
newtonkbd as well.  Synaptics used "serio: ", etc.

A few miscellaneous typos corrected.
Converted a few uses of usb macros err to pr_err.

Compiled x86 only, some files not compile tested

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/apm-power.c                      |   14 ++---
 drivers/input/evbug.c                          |   18 ++++---
 drivers/input/evdev.c                          |   15 +++---
 drivers/input/ff-core.c                        |    6 +-
 drivers/input/ff-memless.c                     |    8 ++--
 drivers/input/gameport/emu10k1-gp.c            |    4 +-
 drivers/input/gameport/fm801-gp.c              |    8 ++-
 drivers/input/gameport/lightning.c             |    6 ++-
 drivers/input/gameport/ns558.c                 |    8 ++-
 drivers/input/input-polldev.c                  |    5 +-
 drivers/input/input.c                          |   22 ++++----
 drivers/input/joydev.c                         |    4 +-
 drivers/input/joystick/a3d.c                   |    9 ++-
 drivers/input/joystick/adi.c                   |   12 +++--
 drivers/input/joystick/amijoy.c                |    4 +-
 drivers/input/joystick/analog.c                |   15 +++--
 drivers/input/joystick/cobra.c                 |    7 ++-
 drivers/input/joystick/db9.c                   |   16 +++---
 drivers/input/joystick/gf2k.c                  |    7 ++-
 drivers/input/joystick/grip_mp.c               |   15 +++--
 drivers/input/joystick/guillemot.c             |   11 +++-
 drivers/input/joystick/iforce/iforce-packets.c |    8 ++-
 drivers/input/joystick/interact.c              |    7 ++-
 drivers/input/joystick/joydump.c               |   40 ++++++++-------
 drivers/input/joystick/sidewinder.c            |   58 ++++++++++++----------
 drivers/input/joystick/spaceball.c             |    6 ++-
 drivers/input/joystick/spaceorb.c              |   15 ++++--
 drivers/input/joystick/turbografx.c            |   16 +++---
 drivers/input/joystick/walkera0701.c           |    6 ++-
 drivers/input/joystick/xpad.c                  |    4 +-
 drivers/input/keyboard/amikbd.c                |   42 +++++++++++-----
 drivers/input/keyboard/atakbd.c                |    4 +-
 drivers/input/keyboard/hil_kbd.c               |   21 +++-----
 drivers/input/keyboard/hilkbd.c                |   26 +++++-----
 drivers/input/keyboard/jornada680_kbd.c        |    5 +-
 drivers/input/keyboard/jornada720_kbd.c        |   10 ++--
 drivers/input/keyboard/lkkbd.c                 |   54 ++++++++++----------
 drivers/input/keyboard/locomokbd.c             |    6 ++-
 drivers/input/keyboard/newtonkbd.c             |    4 +-
 drivers/input/keyboard/omap-keypad.c           |   25 +++++-----
 drivers/input/keyboard/sunkbd.c                |    9 ++--
 drivers/input/keyboard/xtkbd.c                 |    7 ++-
 drivers/input/misc/ati_remote.c                |   22 +++++----
 drivers/input/misc/ati_remote2.c               |    6 ++-
 drivers/input/misc/cm109.c                     |   23 +++-----
 drivers/input/misc/hp_sdc_rtc.c                |   10 ++--
 drivers/input/misc/m68kspkr.c                  |    4 +-
 drivers/input/misc/powermate.c                 |   19 ++++---
 drivers/input/misc/uinput.c                    |   18 ++++---
 drivers/input/misc/winbond-cir.c               |    6 ++-
 drivers/input/misc/wistron_btns.c              |   29 ++++++-----
 drivers/input/misc/yealink.c                   |    5 +-
 drivers/input/mouse/alps.c                     |   12 +++--
 drivers/input/mouse/appletouch.c               |   64 +++++++++++------------
 drivers/input/mouse/bcm5974.c                  |   48 +++++++++---------
 drivers/input/mouse/elantech.c                 |    4 +-
 drivers/input/mouse/inport.c                   |    8 ++-
 drivers/input/mouse/lifebook.c                 |    5 +-
 drivers/input/mouse/logibm.c                   |   10 ++--
 drivers/input/mouse/logips2pp.c                |   13 +++--
 drivers/input/mouse/pc110pad.c                 |   10 ++--
 drivers/input/mouse/psmouse-base.c             |   52 ++++++++++---------
 drivers/input/mouse/rpcmouse.c                 |    4 +-
 drivers/input/mouse/sentelic.c                 |   13 +++--
 drivers/input/mouse/sermouse.c                 |    6 ++-
 drivers/input/mouse/synaptics.c                |   30 ++++++-----
 drivers/input/mouse/trackpoint.c               |   10 ++--
 drivers/input/mouse/vsxxxaa.c                  |   44 ++++++++---------
 drivers/input/mousedev.c                       |   10 ++--
 drivers/input/serio/ambakmi.c                  |    5 ++-
 drivers/input/serio/ct82c710.c                 |   10 ++--
 drivers/input/serio/gscps2.c                   |   15 +++---
 drivers/input/serio/hil_mlc.c                  |   17 +++---
 drivers/input/serio/hp_sdc.c                   |   53 ++++++++++----------
 drivers/input/serio/hp_sdc_mlc.c               |   45 +++++++++--------
 drivers/input/serio/i8042-x86ia64io.h          |   43 +++++++---------
 drivers/input/serio/i8042.c                    |   62 ++++++++++-------------
 drivers/input/serio/i8042.h                    |   21 +++++---
 drivers/input/serio/maceps2.c                  |    5 ++-
 drivers/input/serio/parkbd.c                   |    8 ++-
 drivers/input/serio/q40kbd.c                   |    6 ++-
 drivers/input/serio/rpckbd.c                   |    6 ++-
 drivers/input/serio/sa1111ps2.c                |   17 ++++---
 drivers/input/serio/serio_raw.c                |   10 ++--
 drivers/input/serio/serport.c                  |    6 ++-
 drivers/input/tablet/acecad.c                  |    5 +-
 drivers/input/tablet/aiptek.c                  |    7 ++-
 drivers/input/tablet/gtco.c                    |    2 +-
 drivers/input/tablet/kbtab.c                   |    5 +-
 drivers/input/tablet/wacom_sys.c               |    7 ++-
 drivers/input/tablet/wacom_wac.c               |    8 ++-
 drivers/input/touchscreen/gunze.c              |    5 ++-
 drivers/input/touchscreen/h3600_ts_input.c     |    8 ++-
 drivers/input/touchscreen/hp680_ts_input.c     |    3 +-
 drivers/input/touchscreen/htcpen.c             |   15 +++---
 drivers/input/touchscreen/inexio.c             |    5 ++-
 drivers/input/touchscreen/jornada720_ts.c      |    4 +-
 drivers/input/touchscreen/mk712.c              |   10 ++--
 drivers/input/touchscreen/mtouch.c             |    7 ++-
 drivers/input/touchscreen/ucb1400_ts.c         |   12 +++--
 drivers/input/touchscreen/usbtouchscreen.c     |    6 ++-
 drivers/input/xen-kbdfront.c                   |   10 ++--
 102 files changed, 844 insertions(+), 676 deletions(-)

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
index bd513fe..f5d1b7f 100644
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
@@ -520,12 +522,11 @@ static int handle_eviocgbit(struct input_dev *dev, unsigned int cmd, void __user
 	if ((_IOC_NR(cmd) & EV_MAX) == EV_KEY && _IOC_SIZE(cmd) == OLD_KEY_MAX) {
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
 
 	return bits_to_user(bits, len, _IOC_SIZE(cmd), p, compat_mode);
@@ -872,7 +873,7 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
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
 
diff --git a/drivers/input/gameport/emu10k1-gp.c b/drivers/input/gameport/emu10k1-gp.c
index 7392992..3b065c7 100644
--- a/drivers/input/gameport/emu10k1-gp.c
+++ b/drivers/input/gameport/emu10k1-gp.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 
 #include <linux/module.h>
@@ -75,7 +77,7 @@ static int __devinit emu_probe(struct pci_dev *pdev, const struct pci_device_id
 	emu = kzalloc(sizeof(struct emu), GFP_KERNEL);
 	port = gameport_allocate_port();
 	if (!emu || !port) {
-		printk(KERN_ERR "emu10k1-gp: Memory allocation failed\n");
+		pr_err("Memory allocation failed\n");
 		release_region(ioport, iolen);
 		kfree(emu);
 		gameport_free_port(port);
diff --git a/drivers/input/gameport/fm801-gp.c b/drivers/input/gameport/fm801-gp.c
index 14d3f3e..9f8b4fa 100644
--- a/drivers/input/gameport/fm801-gp.c
+++ b/drivers/input/gameport/fm801-gp.c
@@ -20,6 +20,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -87,7 +89,7 @@ static int __devinit fm801_gp_probe(struct pci_dev *pci, const struct pci_device
 	gp = kzalloc(sizeof(struct fm801_gp), GFP_KERNEL);
 	port = gameport_allocate_port();
 	if (!gp || !port) {
-		printk(KERN_ERR "fm801-gp: Memory allocation failed\n");
+		pr_err("Memory allocation failed\n");
 		error = -ENOMEM;
 		goto err_out_free;
 	}
@@ -108,8 +110,8 @@ static int __devinit fm801_gp_probe(struct pci_dev *pci, const struct pci_device
 	gp->gameport = port;
 	gp->res_port = request_region(port->io, 0x10, "FM801 GP");
 	if (!gp->res_port) {
-		printk(KERN_DEBUG "fm801-gp: unable to grab region 0x%x-0x%x\n",
-			port->io, port->io + 0x0f);
+		printk(KERN_DEBUG pr_fmt("unable to grab region 0x%x-0x%x\n"),
+		       port->io, port->io + 0x0f);
 		error = -EBUSY;
 		goto err_out_disable_dev;
 	}
diff --git a/drivers/input/gameport/lightning.c b/drivers/input/gameport/lightning.c
index 85d6ee0..73ff2a0 100644
--- a/drivers/input/gameport/lightning.c
+++ b/drivers/input/gameport/lightning.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -228,7 +230,7 @@ static int __init l4_create_ports(int card_no)
 		l4 = &l4_ports[idx];
 
 		if (!(l4->gameport = port = gameport_allocate_port())) {
-			printk(KERN_ERR "lightning: Memory allocation failed\n");
+			pr_err("Memory allocation failed\n");
 			while (--i >= 0) {
 				gameport_free_port(l4->gameport);
 				l4->gameport = NULL;
@@ -287,7 +289,7 @@ static int __init l4_add_card(int card_no)
 	if (result)
 		return result;
 
-	printk(KERN_INFO "gameport: PDPI Lightning 4 %s card v%d.%d at %#x\n",
+	pr_info("PDPI Lightning 4 %s card v%d.%d at %#x\n",
 		card_no ? "secondary" : "primary", rev >> 4, rev, L4_PORT);
 
 	for (i = 0; i < 4; i++) {
diff --git a/drivers/input/gameport/ns558.c b/drivers/input/gameport/ns558.c
index 7c21784..11b3309 100644
--- a/drivers/input/gameport/ns558.c
+++ b/drivers/input/gameport/ns558.c
@@ -27,6 +27,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 
 #include <linux/module.h>
@@ -142,7 +144,7 @@ static int ns558_isa_probe(int io)
 	ns558 = kzalloc(sizeof(struct ns558), GFP_KERNEL);
 	port = gameport_allocate_port();
 	if (!ns558 || !port) {
-		printk(KERN_ERR "ns558: Memory allocation failed.\n");
+		pr_err("Memory allocation failed\n");
 		release_region(io & (-1 << i), (1 << i));
 		kfree(ns558);
 		gameport_free_port(port);
@@ -201,7 +203,7 @@ static int ns558_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *did)
 	struct gameport *port;
 
 	if (!pnp_port_valid(dev, 0)) {
-		printk(KERN_WARNING "ns558: No i/o ports on a gameport? Weird\n");
+		pr_warning("No i/o ports on a gameport? Weird\n");
 		return -ENODEV;
 	}
 
@@ -214,7 +216,7 @@ static int ns558_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *did)
 	ns558 = kzalloc(sizeof(struct ns558), GFP_KERNEL);
 	port = gameport_allocate_port();
 	if (!ns558 || !port) {
-		printk(KERN_ERR "ns558: Memory allocation failed\n");
+		pr_err("Memory allocation failed\n");
 		kfree(ns558);
 		gameport_free_port(port);
 		return -ENOMEM;
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
index 227ae5e..41ba75a 100644
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
@@ -1019,10 +1021,8 @@ static int input_attach_handler(struct input_dev *dev, struct input_handler *han
 
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
@@ -1852,9 +1852,8 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
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
@@ -1942,8 +1941,9 @@ int input_register_device(struct input_dev *dev)
 		return error;
 
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
-	printk(KERN_INFO "input: %s as %s\n",
-		dev->name ? dev->name : "Unspecified device", path ? path : "N/A");
+	pr_info("%s as %s\n",
+		dev->name ? dev->name : "Unspecified device",
+		path ? path : "N/A");
 	kfree(path);
 
 	error = mutex_lock_interruptible(&input_mutex);
@@ -2224,7 +2224,7 @@ static int __init input_init(void)
 
 	err = class_register(&input_class);
 	if (err) {
-		printk(KERN_ERR "input: unable to register input_dev class\n");
+		pr_err("unable to register input_dev class\n");
 		return err;
 	}
 
@@ -2234,7 +2234,7 @@ static int __init input_init(void)
 
 	err = register_chrdev(INPUT_MAJOR, "input", &input_fops);
 	if (err) {
-		printk(KERN_ERR "input: unable to register char major %d", INPUT_MAJOR);
+		pr_err("unable to register char major %d", INPUT_MAJOR);
 		goto fail2;
 	}
 
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 6383458..e8e6bc5 100644
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
@@ -803,7 +805,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 			break;
 
 	if (minor == JOYDEV_MINORS) {
-		printk(KERN_ERR "joydev: no more free joydev devices\n");
+		pr_err("no more free joydev devices\n");
 		return -ENFILE;
 	}
 
diff --git a/drivers/input/joystick/a3d.c b/drivers/input/joystick/a3d.c
index 6489f40..0e92bdd 100644
--- a/drivers/input/joystick/a3d.c
+++ b/drivers/input/joystick/a3d.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -295,8 +297,9 @@ static int a3d_connect(struct gameport *gameport, struct gameport_driver *drv)
 	a3d->mode = data[0];
 
 	if (!a3d->mode || a3d->mode > 5) {
-		printk(KERN_WARNING "a3d.c: Unknown A3D device detected "
-			"(%s, id=%d), contact <vojtech@ucw.cz>\n", gameport->phys, a3d->mode);
+		pr_warning("Unknown A3D device detected "
+			   "(%s, id=%d), contact <vojtech@ucw.cz>\n",
+			   gameport->phys, a3d->mode);
 		err = -ENODEV;
 		goto fail2;
 	}
@@ -359,7 +362,7 @@ static int a3d_connect(struct gameport *gameport, struct gameport_driver *drv)
 		a3d_read(a3d, data);
 
 		if (!(a3d->adc = adc = gameport_allocate_port()))
-			printk(KERN_ERR "a3d: Not enough memory for ADC port\n");
+			pr_err("Not enough memory for ADC port\n");
 		else {
 			adc->port_data = a3d;
 			adc->open = a3d_adc_open;
diff --git a/drivers/input/joystick/adi.c b/drivers/input/joystick/adi.c
index 89c4c08..280c3e2 100644
--- a/drivers/input/joystick/adi.c
+++ b/drivers/input/joystick/adi.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -336,7 +338,8 @@ static void adi_id_decode(struct adi *adi, struct adi_port *port)
 		return;
 
 	if (adi->ret < (t = adi_get_bits(adi, 10))) {
-		printk(KERN_WARNING "adi: Short ID packet: reported: %d != read: %d\n", t, adi->ret);
+		pr_warning("Short ID packet: reported: %d != read: %d\n",
+			   t, adi->ret);
 		return;
 	}
 
@@ -347,7 +350,7 @@ static void adi_id_decode(struct adi *adi, struct adi_port *port)
 	adi->length = adi_get_bits(adi, 10);
 
 	if (adi->length >= ADI_MAX_LENGTH || adi->length < ADI_MIN_LENGTH) {
-		printk(KERN_WARNING "adi: Bad data packet length (%d).\n", adi->length);
+		pr_warning("Bad data packet length (%d)\n", adi->length);
 		adi->length = 0;
 		return;
 	}
@@ -356,7 +359,7 @@ static void adi_id_decode(struct adi *adi, struct adi_port *port)
 	adi->buttons = adi_get_bits(adi, 6);
 
 	if (adi_get_bits(adi, 6) != 8 && adi->hats) {
-		printk(KERN_WARNING "adi: Other than 8-dir POVs not supported yet.\n");
+		pr_warning("Other than 8-dir POVs not supported yet\n");
 		adi->length = 0;
 		return;
 	}
@@ -379,7 +382,8 @@ static void adi_id_decode(struct adi *adi, struct adi_port *port)
 
 	t = 8 + adi->buttons + adi->axes10 * 10 + adi->axes8 * 8 + adi->hats * 4;
 	if (adi->length != t && adi->length != t + (t & 1)) {
-		printk(KERN_WARNING "adi: Expected length %d != data length %d\n", t, adi->length);
+		pr_warning("Expected length %d != data length %d\n",
+			   t, adi->length);
 		adi->length = 0;
 		return;
 	}
diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index 05022f0..7cf2f41 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -84,7 +86,7 @@ static int amijoy_open(struct input_dev *dev)
 		return err;
 
 	if (!amijoy_used && request_irq(IRQ_AMIGA_VERTB, amijoy_interrupt, 0, "amijoy", amijoy_interrupt)) {
-		printk(KERN_ERR "amijoy.c: Can't allocate irq %d\n", IRQ_AMIGA_VERTB);
+		pr_err("Can't allocate irq %d\n", IRQ_AMIGA_VERTB);
 		err = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 4afe0a3..12e9abc 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -531,9 +533,9 @@ static int analog_init_masks(struct analog_port *port)
 		return -1;
 
 	if ((port->mask & 3) != 3 && port->mask != 0xc) {
-		printk(KERN_WARNING "analog.c: Unknown joystick device found  "
-			"(data=%#x, %s), probably not analog joystick.\n",
-			port->mask, port->gameport->phys);
+		pr_warning("Unknown joystick device found  "
+			   "(data=%#x, %s), probably not analog joystick\n",
+			   port->mask, port->gameport->phys);
 		return -1;
 	}
 
@@ -693,8 +695,9 @@ static void analog_disconnect(struct gameport *gameport)
 			input_unregister_device(port->analog[i].dev);
 	gameport_close(gameport);
 	gameport_set_drvdata(gameport, NULL);
-	printk(KERN_INFO "analog.c: %d out of %d reads (%d%%) on %s failed\n",
-		port->bads, port->reads, port->reads ? (port->bads * 100 / port->reads) : 0,
+	pr_info("%d out of %d reads (%d%%) on %s failed\n",
+		port->bads, port->reads,
+		port->reads ? (port->bads * 100 / port->reads) : 0,
 		port->gameport->phys);
 	kfree(port);
 }
@@ -738,7 +741,7 @@ static void analog_parse_options(void)
 		analog_options[i] = 0xff;
 		if (!strlen(js[i])) continue;
 
-		printk(KERN_WARNING "analog.c: Bad config for port %d - \"%s\"\n", i, js[i]);
+		pr_warning("Bad config for port %d - \"%s\"\n", i, js[i]);
 	}
 
 	for (; i < ANALOG_PORTS; i++)
diff --git a/drivers/input/joystick/cobra.c b/drivers/input/joystick/cobra.c
index 3497b87..010a130 100644
--- a/drivers/input/joystick/cobra.c
+++ b/drivers/input/joystick/cobra.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -177,8 +179,9 @@ static int cobra_connect(struct gameport *gameport, struct gameport_driver *drv)
 
 	for (i = 0; i < 2; i++)
 		if ((cobra->exists >> i) & data[i] & 1) {
-			printk(KERN_WARNING "cobra.c: Device %d on %s has the Ext bit set. ID is: %d"
-				" Contact vojtech@ucw.cz\n", i, gameport->phys, (data[i] >> 2) & 7);
+			pr_warning("Device %d on %s has the Ext bit set. ID is: %d"
+				   " Contact vojtech@ucw.cz\n",
+				   i, gameport->phys, (data[i] >> 2) & 7);
 			cobra->exists &= ~(1 << i);
 		}
 
diff --git a/drivers/input/joystick/db9.c b/drivers/input/joystick/db9.c
index 8e7de5c..4ee17ee 100644
--- a/drivers/input/joystick/db9.c
+++ b/drivers/input/joystick/db9.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -564,7 +566,7 @@ static struct db9 __init *db9_probe(int parport, int mode)
 	int err;
 
 	if (mode < 1 || mode >= DB9_MAX_PAD || !db9_modes[mode].n_buttons) {
-		printk(KERN_ERR "db9.c: Bad device type %d\n", mode);
+		pr_err("Bad device type %d\n", mode);
 		err = -EINVAL;
 		goto err_out;
 	}
@@ -573,27 +575,27 @@ static struct db9 __init *db9_probe(int parport, int mode)
 
 	pp = parport_find_number(parport);
 	if (!pp) {
-		printk(KERN_ERR "db9.c: no such parport\n");
+		pr_err("no such parport\n");
 		err = -ENODEV;
 		goto err_out;
 	}
 
 	if (db9_mode->bidirectional && !(pp->modes & PARPORT_MODE_TRISTATE)) {
-		printk(KERN_ERR "db9.c: specified parport is not bidirectional\n");
+		pr_err("specified parport is not bidirectional\n");
 		err = -EINVAL;
 		goto err_put_pp;
 	}
 
 	pd = parport_register_device(pp, "db9", NULL, NULL, NULL, PARPORT_DEV_EXCL, NULL);
 	if (!pd) {
-		printk(KERN_ERR "db9.c: parport busy already - lp.o loaded?\n");
+		pr_err("parport busy already - lp.o loaded?\n");
 		err = -EBUSY;
 		goto err_put_pp;
 	}
 
 	db9 = kzalloc(sizeof(struct db9), GFP_KERNEL);
 	if (!db9) {
-		printk(KERN_ERR "db9.c: Not enough memory\n");
+		pr_err("Not enough memory\n");
 		err = -ENOMEM;
 		goto err_unreg_pardev;
 	}
@@ -609,7 +611,7 @@ static struct db9 __init *db9_probe(int parport, int mode)
 
 		db9->dev[i] = input_dev = input_allocate_device();
 		if (!input_dev) {
-			printk(KERN_ERR "db9.c: Not enough memory for input device\n");
+			pr_err("Not enough memory for input device\n");
 			err = -ENOMEM;
 			goto err_unreg_devs;
 		}
@@ -682,7 +684,7 @@ static int __init db9_init(void)
 			continue;
 
 		if (db9_cfg[i].nargs < 2) {
-			printk(KERN_ERR "db9.c: Device type must be specified.\n");
+			pr_err("Device type must be specified\n");
 			err = -EINVAL;
 			break;
 		}
diff --git a/drivers/input/joystick/gf2k.c b/drivers/input/joystick/gf2k.c
index 45ac70ea..cc17a82 100644
--- a/drivers/input/joystick/gf2k.c
+++ b/drivers/input/joystick/gf2k.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -287,8 +289,9 @@ static int gf2k_connect(struct gameport *gameport, struct gameport_driver *drv)
 #endif
 
 	if (gf2k->id > GF2K_ID_MAX || !gf2k_axes[gf2k->id]) {
-		printk(KERN_WARNING "gf2k.c: Not yet supported joystick on %s. [id: %d type:%s]\n",
-			gameport->phys, gf2k->id, gf2k->id > GF2K_ID_MAX ? "Unknown" : gf2k_names[gf2k->id]);
+		pr_warning("Not yet supported joystick on %s. [id: %d type:%s]\n",
+			   gameport->phys, gf2k->id,
+			   gf2k->id > GF2K_ID_MAX ? "Unknown" : gf2k_names[gf2k->id]);
 		err = -ENODEV;
 		goto fail2;
 	}
diff --git a/drivers/input/joystick/grip_mp.c b/drivers/input/joystick/grip_mp.c
index 2d47baf..4e1d31c 100644
--- a/drivers/input/joystick/grip_mp.c
+++ b/drivers/input/joystick/grip_mp.c
@@ -9,6 +9,8 @@
  *  Copyright (c) 1998-2000 Vojtech Pavlik
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -26,9 +28,9 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 #ifdef GRIP_DEBUG
-#define dbg(format, arg...) printk(KERN_ERR __FILE__ ": " format "\n" , ## arg)
+#define dbg(format, arg...) pr_err(format "\n", ##arg)
 #else
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...) do { if (0) pr_err(format "\n", ##arg); } while (0)
 #endif
 
 #define GRIP_MAX_PORTS	4
@@ -393,8 +395,8 @@ static int get_and_decode_packet(struct grip_mp *grip, int flags)
 	if (!joytype) {
 
 		if (port->registered) {
-			printk(KERN_INFO "grip_mp: removing %s, slot %d\n",
-			       grip_name[port->mode], slot);
+			pr_info("removing %s, slot %d\n",
+				grip_name[port->mode], slot);
 			input_unregister_device(port->dev);
 			port->registered = 0;
 		}
@@ -434,8 +436,9 @@ static int get_and_decode_packet(struct grip_mp *grip, int flags)
 	{
 		static int strange_code = 0;
 		if (strange_code != joytype) {
-			printk(KERN_INFO "Possible non-grip pad/joystick detected.\n");
-			printk(KERN_INFO "Got joy type 0x%x and packet 0x%x.\n", joytype, packet);
+			pr_info("Possible non-grip pad/joystick detected\n");
+			pr_info("Got joy type 0x%x and packet 0x%x\n",
+				joytype, packet);
 			strange_code = joytype;
 		}
 	}
diff --git a/drivers/input/joystick/guillemot.c b/drivers/input/joystick/guillemot.c
index 4058d4b..2056c9a 100644
--- a/drivers/input/joystick/guillemot.c
+++ b/drivers/input/joystick/guillemot.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -211,8 +213,10 @@ static int guillemot_connect(struct gameport *gameport, struct gameport_driver *
 			break;
 
 	if (!guillemot_type[i].name) {
-		printk(KERN_WARNING "guillemot.c: Unknown joystick on %s. [ %02x%02x:%04x, ver %d.%02d ]\n",
-			gameport->phys, data[12], data[13], data[11], data[14], data[15]);
+		pr_warning("Unknown joystick on %s. "
+			   "[ %02x%02x:%04x, ver %d.%02d ]\n",
+			   gameport->phys,
+			   data[12], data[13], data[11], data[14], data[15]);
 		err = -ENODEV;
 		goto fail2;
 	}
@@ -266,7 +270,8 @@ static void guillemot_disconnect(struct gameport *gameport)
 {
 	struct guillemot *guillemot = gameport_get_drvdata(gameport);
 
-	printk(KERN_INFO "guillemot.c: Failed %d reads out of %d on %s\n", guillemot->reads, guillemot->bads, guillemot->phys);
+	pr_info("Failed %d reads out of %d on %s\n",
+		guillemot->reads, guillemot->bads, guillemot->phys);
 	input_unregister_device(guillemot->dev);
 	gameport_close(gameport);
 	kfree(guillemot);
diff --git a/drivers/input/joystick/iforce/iforce-packets.c b/drivers/input/joystick/iforce/iforce-packets.c
index a17b500..08db6ad 100644
--- a/drivers/input/joystick/iforce/iforce-packets.c
+++ b/drivers/input/joystick/iforce/iforce-packets.c
@@ -25,6 +25,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "iforce.h"
 
 static struct {
@@ -37,10 +39,10 @@ void iforce_dump_packet(char *msg, u16 cmd, unsigned char *data)
 {
 	int i;
 
-	printk(KERN_DEBUG __FILE__ ": %s cmd = %04x, data = ", msg, cmd);
+	printk(KERN_DEBUG pr_fmt("%s cmd = %04x, data ="), msg, cmd);
 	for (i = 0; i < LO(cmd); i++)
-		printk("%02x ", data[i]);
-	printk("\n");
+		pr_cont(" %02x", data[i]);
+	pr_cont("\n");
 }
 
 /*
diff --git a/drivers/input/joystick/interact.c b/drivers/input/joystick/interact.c
index 2478289..82bad6f 100644
--- a/drivers/input/joystick/interact.c
+++ b/drivers/input/joystick/interact.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -240,8 +242,9 @@ static int interact_connect(struct gameport *gameport, struct gameport_driver *d
 			break;
 
 	if (!interact_type[i].length) {
-		printk(KERN_WARNING "interact.c: Unknown joystick on %s. [len %d d0 %08x d1 %08x i2 %08x]\n",
-			gameport->phys, i, data[0], data[1], data[2]);
+		pr_warning("Unknown joystick on %s. "
+			   "[len %d d0 %08x d1 %08x i2 %08x]\n",
+			   gameport->phys, i, data[0], data[1], data[2]);
 		err = -ENODEV;
 		goto fail2;
 	}
diff --git a/drivers/input/joystick/joydump.c b/drivers/input/joystick/joydump.c
index cd894a0..5f0d269 100644
--- a/drivers/input/joystick/joydump.c
+++ b/drivers/input/joystick/joydump.c
@@ -27,6 +27,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/gameport.h>
 #include <linux/kernel.h>
@@ -56,34 +58,36 @@ static int joydump_connect(struct gameport *gameport, struct gameport_driver *dr
 	unsigned long flags;
 	unsigned char u;
 
-	printk(KERN_INFO "joydump: ,------------------ START ----------------.\n");
-	printk(KERN_INFO "joydump: | Dumping: %30s |\n", gameport->phys);
-	printk(KERN_INFO "joydump: | Speed: %28d kHz |\n", gameport->speed);
+	pr_info(",------------------ START ----------------.\n");
+	pr_info("| Dumping: %30s |\n", gameport->phys);
+	pr_info("| Speed: %28d kHz |\n", gameport->speed);
 
 	if (gameport_open(gameport, drv, GAMEPORT_MODE_RAW)) {
 
-		printk(KERN_INFO "joydump: | Raw mode not available - trying cooked.    |\n");
+		pr_info("| Raw mode not available - trying cooked.    |\n");
 
 		if (gameport_open(gameport, drv, GAMEPORT_MODE_COOKED)) {
 
-			printk(KERN_INFO "joydump: | Cooked not available either. Failing.   |\n");
-			printk(KERN_INFO "joydump: `------------------- END -----------------'\n");
+			pr_info("| Cooked not available either. Failing.   |\n");
+			pr_info("`------------------- END -----------------'\n");
 			return -ENODEV;
 		}
 
 		gameport_cooked_read(gameport, axes, &buttons);
 
 		for (i = 0; i < 4; i++)
-			printk(KERN_INFO "joydump: | Axis %d: %4d.                           |\n", i, axes[i]);
-		printk(KERN_INFO "joydump: | Buttons %02x.                             |\n", buttons);
-		printk(KERN_INFO "joydump: `------------------- END -----------------'\n");
+			pr_info("| Axis %d: %4d.                           |\n",
+				i, axes[i]);
+		pr_info("| Buttons %02x.                             |\n",
+			buttons);
+		pr_info("`------------------- END -----------------'\n");
 	}
 
 	timeout = gameport_time(gameport, 10000); /* 10 ms */
 
 	buf = kmalloc(BUF_SIZE * sizeof(struct joydump), GFP_KERNEL);
 	if (!buf) {
-		printk(KERN_INFO "joydump: no memory for testing\n");
+		pr_info("no memory for testing\n");
 		goto jd_end;
 	}
 	dump = buf;
@@ -123,24 +127,24 @@ static int joydump_connect(struct gameport *gameport, struct gameport_driver *dr
 	dump = buf;
 	prev = dump;
 
-	printk(KERN_INFO "joydump: >------------------ DATA -----------------<\n");
-	printk(KERN_INFO "joydump: | index: %3d delta: %3d us data: ", 0, 0);
+	pr_info(">------------------ DATA -----------------<\n");
+	pr_info("| index: %3d delta: %3d us data: ", 0, 0);
 	for (j = 7; j >= 0; j--)
-		printk("%d", (dump->data >> j) & 1);
-	printk(" |\n");
+		pr_cont("%d", (dump->data >> j) & 1);
+	pr_cont(" |\n");
 	dump++;
 
 	for (i = 1; i < t; i++, dump++, prev++) {
-		printk(KERN_INFO "joydump: | index: %3d delta: %3d us data: ",
+		pr_info("| index: %3d delta: %3d us data: ",
 			i, dump->time - prev->time);
 		for (j = 7; j >= 0; j--)
-			printk("%d", (dump->data >> j) & 1);
-		printk(" |\n");
+			pr_cont("%d", (dump->data >> j) & 1);
+		pr_cont(" |\n");
 	}
 	kfree(buf);
 
 jd_end:
-	printk(KERN_INFO "joydump: `------------------- END -----------------'\n");
+	pr_info("`------------------- END -----------------'\n");
 
 	return 0;
 }
diff --git a/drivers/input/joystick/sidewinder.c b/drivers/input/joystick/sidewinder.c
index ca13a6b..7fe1404 100644
--- a/drivers/input/joystick/sidewinder.c
+++ b/drivers/input/joystick/sidewinder.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -60,9 +62,10 @@ MODULE_LICENSE("GPL");
 #define SW_LENGTH	512	/* Max number of bits in a packet */
 
 #ifdef SW_DEBUG
-#define dbg(format, arg...) printk(KERN_DEBUG __FILE__ ": " format "\n" , ## arg)
+#define dbg(format, arg...) printk(KERN_DEBUG pr_fmt(format), ##arg)
 #else
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...) \
+	do { if (0) printk(KERN_DEBUG pr_fmt(format), ##arg); } while (0)
 #endif
 
 /*
@@ -197,9 +200,10 @@ static int sw_read_packet(struct gameport *gameport, unsigned char *buf, int len
 #ifdef SW_DEBUG_DATA
 	{
 		int j;
-		printk(KERN_DEBUG "sidewinder.c: Read %d triplets. [", i);
-		for (j = 0; j < i; j++) printk("%d", buf[j]);
-		printk("]\n");
+		printk(KERN_DEBUG pr_fmt("Read %d triplets. ["), i);
+		for (j = 0; j < i; j++)
+			pr_cont(" %d", buf[j]);
+		pr_cont(" ]\n");
 	}
 #endif
 
@@ -433,8 +437,9 @@ static int sw_read(struct sw *sw)
 	if (sw->type == SW_ID_3DP && sw->length == 66 && i != 66) {		/* Broken packet, try to fix */
 
 		if (i == 64 && !sw_check(sw_get_bits(buf,0,64,1))) {		/* Last init failed, 1 bit mode */
-			printk(KERN_WARNING "sidewinder.c: Joystick in wrong mode on %s"
-				" - going to reinitialize.\n", sw->gameport->phys);
+			pr_warning("Joystick in wrong mode on %s"
+				   " - going to reinitialize\n",
+				   sw->gameport->phys);
 			sw->fail = SW_FAIL;					/* Reinitialize */
 			i = 128;						/* Bogus value */
 		}
@@ -459,8 +464,9 @@ static int sw_read(struct sw *sw)
 		if (sw->type == SW_ID_3DP && sw->length == 66			/* Many packets OK */
 			&& sw->ok > SW_OK) {
 
-			printk(KERN_INFO "sidewinder.c: No more trouble on %s"
-				" - enabling optimization again.\n", sw->gameport->phys);
+			pr_info("No more trouble on %s"
+				" - enabling optimization again\n",
+				sw->gameport->phys);
 			sw->length = 22;
 		}
 
@@ -472,16 +478,16 @@ static int sw_read(struct sw *sw)
 
 	if (sw->type == SW_ID_3DP && sw->length == 22 && sw->fail > SW_BAD) {	/* Consecutive bad packets */
 
-		printk(KERN_INFO "sidewinder.c: Many bit errors on %s"
-			" - disabling optimization.\n", sw->gameport->phys);
+		pr_info("Many bit errors on %s - disabling optimization\n",
+			sw->gameport->phys);
 		sw->length = 66;
 	}
 
 	if (sw->fail < SW_FAIL)
 		return -1;							/* Not enough, don't reinitialize yet */
 
-	printk(KERN_WARNING "sidewinder.c: Too many bit errors on %s"
-		" - reinitializing joystick.\n", sw->gameport->phys);
+	pr_warning("Too many bit errors on %s - reinitializing joystick\n",
+		   sw->gameport->phys);
 
 	if (!i && sw->type == SW_ID_3DP) {					/* 3D Pro can be in analog mode */
 		mdelay(3 * SW_TIMEOUT);
@@ -530,10 +536,10 @@ static void sw_print_packet(char *name, int length, unsigned char *buf, char bit
 {
 	int i;
 
-	printk(KERN_INFO "sidewinder.c: %s packet, %d bits. [", name, length);
+	pr_info("%s packet, %d bits. [", name, length);
 	for (i = (((length + 3) >> 2) - 1); i >= 0; i--)
-		printk("%x", (int)sw_get_bits(buf, i << 2, 4, bits));
-	printk("]\n");
+		pr_cont("%x", (int)sw_get_bits(buf, i << 2, 4, bits));
+	pr_cont("]\n");
 }
 
 /*
@@ -613,19 +619,19 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 	if (err)
 		goto fail1;
 
-	dbg("Init 0: Opened %s, io %#x, speed %d",
+	dbg("Init 0: Opened %s, io %#x, speed %d\n",
 		gameport->phys, gameport->io, gameport->speed);
 
 	i = sw_read_packet(gameport, buf, SW_LENGTH, 0);		/* Read normal packet */
 	msleep(SW_TIMEOUT);
-	dbg("Init 1: Mode %d. Length %d.", m , i);
+	dbg("Init 1: Mode %d. Length %d\n", m , i);
 
 	if (!i) {							/* No data. 3d Pro analog mode? */
 		sw_init_digital(gameport);				/* Switch to digital */
 		msleep(SW_TIMEOUT);
 		i = sw_read_packet(gameport, buf, SW_LENGTH, 0);	/* Retry reading packet */
 		msleep(SW_TIMEOUT);
-		dbg("Init 1b: Length %d.", i);
+		dbg("Init 1b: Length %d\n", i);
 		if (!i) {						/* No data -> FAIL */
 			err = -ENODEV;
 			goto fail2;
@@ -634,20 +640,20 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 
 	j = sw_read_packet(gameport, idbuf, SW_LENGTH, i);		/* Read ID. This initializes the stick */
 	m |= sw_guess_mode(idbuf, j);					/* ID packet should carry mode info [3DP] */
-	dbg("Init 2: Mode %d. ID Length %d.", m, j);
+	dbg("Init 2: Mode %d. ID Length %d\n", m, j);
 
 	if (j <= 0) {							/* Read ID failed. Happens in 1-bit mode on PP */
 		msleep(SW_TIMEOUT);
 		i = sw_read_packet(gameport, buf, SW_LENGTH, 0);	/* Retry reading packet */
 		m |= sw_guess_mode(buf, i);
-		dbg("Init 2b: Mode %d. Length %d.", m, i);
+		dbg("Init 2b: Mode %d. Length %d\n", m, i);
 		if (!i) {
 			err = -ENODEV;
 			goto fail2;
 		}
 		msleep(SW_TIMEOUT);
 		j = sw_read_packet(gameport, idbuf, SW_LENGTH, i);	/* Retry reading ID */
-		dbg("Init 2c: ID Length %d.", j);
+		dbg("Init 2c: ID Length %d\n", j);
 	}
 
 	sw->type = -1;
@@ -658,7 +664,7 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 		k--;
 		msleep(SW_TIMEOUT);
 		i = sw_read_packet(gameport, buf, SW_LENGTH, 0);	/* Read data packet */
-		dbg("Init 3: Mode %d. Length %d. Last %d. Tries %d.", m, i, l, k);
+		dbg("Init 3: Mode %d. Length %d. Last %d. Tries %d\n", m, i, l, k);
 
 		if (i > l) {						/* Longer? As we can only lose bits, it makes */
 									/* no sense to try detection for a packet shorter */
@@ -669,7 +675,7 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 			sw->length = i;
 			sw->bits = m;
 
-			dbg("Init 3a: Case %d.\n", i * m);
+			dbg("Init 3a: Case %d\n", i * m);
 
 			switch (i * m) {
 				case 60:
@@ -712,8 +718,8 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 	} while (k && sw->type == -1);
 
 	if (sw->type == -1) {
-		printk(KERN_WARNING "sidewinder.c: unknown joystick device detected "
-			"on %s, contact <vojtech@ucw.cz>\n", gameport->phys);
+		pr_warning("unknown joystick device detected on %s, "
+			   "contact <vojtech@ucw.cz>\n", gameport->phys);
 		sw_print_packet("ID", j * 3, idbuf, 3);
 		sw_print_packet("Data", i * m, buf, m);
 		err = -ENODEV;
diff --git a/drivers/input/joystick/spaceball.c b/drivers/input/joystick/spaceball.c
index 0cd9b29..2690e2b 100644
--- a/drivers/input/joystick/spaceball.c
+++ b/drivers/input/joystick/spaceball.c
@@ -30,6 +30,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -128,12 +130,12 @@ static void spaceball_process_packet(struct spaceball* spaceball)
 
 		case 'E':					/* Device error */
 			spaceball->data[spaceball->idx - 1] = 0;
-			printk(KERN_ERR "spaceball: Device error. [%s]\n", spaceball->data + 1);
+			pr_err("Device error. [%s]\n", spaceball->data + 1);
 			break;
 
 		case '?':					/* Bad command packet */
 			spaceball->data[spaceball->idx - 1] = 0;
-			printk(KERN_ERR "spaceball: Bad command. [%s]\n", spaceball->data + 1);
+			pr_err("Bad command. [%s]\n", spaceball->data + 1);
 			break;
 	}
 
diff --git a/drivers/input/joystick/spaceorb.c b/drivers/input/joystick/spaceorb.c
index a694bf8..55253ac 100644
--- a/drivers/input/joystick/spaceorb.c
+++ b/drivers/input/joystick/spaceorb.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -89,8 +91,8 @@ static void spaceorb_process_packet(struct spaceorb *spaceorb)
 		case 'R':				/* Reset packet */
 			spaceorb->data[spaceorb->idx - 1] = 0;
 			for (i = 1; i < spaceorb->idx && spaceorb->data[i] == ' '; i++);
-			printk(KERN_INFO "input: %s [%s] is %s\n",
-				 dev->name, spaceorb->data + i, spaceorb->phys);
+			pr_info("%s [%s] is %s\n",
+				dev->name, spaceorb->data + i, spaceorb->phys);
 			break;
 
 		case 'D':				/* Ball + button data */
@@ -117,9 +119,12 @@ static void spaceorb_process_packet(struct spaceorb *spaceorb)
 
 		case 'E':				/* Error packet */
 			if (spaceorb->idx != 4) return;
-			printk(KERN_ERR "spaceorb: Device error. [ ");
-			for (i = 0; i < 7; i++) if (data[1] & (1 << i)) printk("%s ", spaceorb_errors[i]);
-			printk("]\n");
+			pr_err("Device error. [");
+			for (i = 0; i < 7; i++) {
+				if (data[1] & (1 << i))
+					pr_cont(" %s", spaceorb_errors[i]);
+			}
+			pr_cont(" ]\n");
 			break;
 	}
 
diff --git a/drivers/input/joystick/turbografx.c b/drivers/input/joystick/turbografx.c
index d53b9e9..a592eaa 100644
--- a/drivers/input/joystick/turbografx.c
+++ b/drivers/input/joystick/turbografx.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/parport.h>
 #include <linux/input.h>
@@ -167,21 +169,21 @@ static struct tgfx __init *tgfx_probe(int parport, int *n_buttons, int n_devs)
 
 	pp = parport_find_number(parport);
 	if (!pp) {
-		printk(KERN_ERR "turbografx.c: no such parport\n");
+		pr_err("no such parport\n");
 		err = -EINVAL;
 		goto err_out;
 	}
 
 	pd = parport_register_device(pp, "turbografx", NULL, NULL, NULL, PARPORT_DEV_EXCL, NULL);
 	if (!pd) {
-		printk(KERN_ERR "turbografx.c: parport busy already - lp.o loaded?\n");
+		pr_err("parport busy already - lp.o loaded?\n");
 		err = -EBUSY;
 		goto err_put_pp;
 	}
 
 	tgfx = kzalloc(sizeof(struct tgfx), GFP_KERNEL);
 	if (!tgfx) {
-		printk(KERN_ERR "turbografx.c: Not enough memory\n");
+		pr_err("Not enough memory\n");
 		err = -ENOMEM;
 		goto err_unreg_pardev;
 	}
@@ -197,14 +199,14 @@ static struct tgfx __init *tgfx_probe(int parport, int *n_buttons, int n_devs)
 			continue;
 
 		if (n_buttons[i] > 6) {
-			printk(KERN_ERR "turbografx.c: Invalid number of buttons %d\n", n_buttons[i]);
+			pr_err("Invalid number of buttons %d\n", n_buttons[i]);
 			err = -EINVAL;
 			goto err_unreg_devs;
 		}
 
 		tgfx->dev[i] = input_dev = input_allocate_device();
 		if (!input_dev) {
-			printk(KERN_ERR "turbografx.c: Not enough memory for input device\n");
+			pr_err("Not enough memory for input device\n");
 			err = -ENOMEM;
 			goto err_unreg_devs;
 		}
@@ -240,7 +242,7 @@ static struct tgfx __init *tgfx_probe(int parport, int *n_buttons, int n_devs)
 	}
 
         if (!tgfx->sticks) {
-		printk(KERN_ERR "turbografx.c: No valid devices specified\n");
+		pr_err("No valid devices specified\n");
 		err = -EINVAL;
 		goto err_free_tgfx;
         }
@@ -285,7 +287,7 @@ static int __init tgfx_init(void)
 			continue;
 
 		if (tgfx_cfg[i].nargs < 2) {
-			printk(KERN_ERR "turbografx.c: at least one joystick must be specified\n");
+			pr_err("at least one joystick must be specified\n");
 			err = -EINVAL;
 			break;
 		}
diff --git a/drivers/input/joystick/walkera0701.c b/drivers/input/joystick/walkera0701.c
index 4dfa1ee..9e69249 100644
--- a/drivers/input/joystick/walkera0701.c
+++ b/drivers/input/joystick/walkera0701.c
@@ -12,6 +12,8 @@
  * the Free Software Foundation.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* #define WK0701_DEBUG */
 
 #define RESERVE 20000
@@ -108,7 +110,7 @@ static inline void walkera0701_parse_frame(struct walkera_dev *w)
 		magic = (w->buf[21] << 4) | w->buf[22];
 		magic_bit = (w->buf[24] & 8) >> 3;
 		printk(KERN_DEBUG
-		       "walkera0701: %4d %4d %4d %4d  %4d %4d %4d %4d (magic %2x %d)\n",
+		       pr_fmt("%4d %4d %4d %4d  %4d %4d %4d %4d (magic %2x %d)\n"),
 		       val1, val2, val3, val4, val5, val6, val7, val8, magic,
 		       magic_bit);
 	}
@@ -207,7 +209,7 @@ static int walkera0701_connect(struct walkera_dev *w, int parport)
 		return -ENODEV;
 
 	if (w->parport->irq == -1) {
-		printk(KERN_ERR "walkera0701: parport without interrupt\n");
+		pr_err("parport without interrupt\n");
 		goto init_err;
 	}
 
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 269a846..17a0314 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -73,6 +73,8 @@
  * Later changes can be tracked in SCM.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1001,7 +1003,7 @@ static int __init usb_xpad_init(void)
 {
 	int result = usb_register(&xpad_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "\n");
+		pr_info(DRIVER_DESC "\n");
 	return result;
 }
 
diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
index 79172af..61f92a5 100644
--- a/drivers/input/keyboard/amikbd.c
+++ b/drivers/input/keyboard/amikbd.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
@@ -144,17 +146,6 @@ static unsigned char amikbd_keycode[0x78] __initdata = {
 	[103]	 = KEY_RIGHTMETA
 };
 
-static const char *amikbd_messages[8] = {
-	[0] = KERN_ALERT "amikbd: Ctrl-Amiga-Amiga reset warning!!\n",
-	[1] = KERN_WARNING "amikbd: keyboard lost sync\n",
-	[2] = KERN_WARNING "amikbd: keyboard buffer overflow\n",
-	[3] = KERN_WARNING "amikbd: keyboard controller failure\n",
-	[4] = KERN_ERR "amikbd: keyboard selftest failure\n",
-	[5] = KERN_INFO "amikbd: initiate power-up key stream\n",
-	[6] = KERN_INFO "amikbd: terminate power-up key stream\n",
-	[7] = KERN_WARNING "amikbd: keyboard interrupt\n"
-};
-
 static irqreturn_t amikbd_interrupt(int irq, void *data)
 {
 	struct input_dev *dev = data;
@@ -177,8 +168,33 @@ static irqreturn_t amikbd_interrupt(int irq, void *data)
 		}
 
 		input_sync(dev);
-	} else				/* scancodes >= 0x78 are error codes */
-		printk(amikbd_messages[scancode - 0x78]);
+	} else {			/* scancodes >= 0x78 are error codes */
+		switch (scancode) {
+		case 0x78:
+			pr_alert("Ctrl-Amiga-Amiga reset warning!!\n");
+			break;
+		case 0x79:
+			pr_warning("keyboard lost sync\n");
+			break;
+		case 0x7a:
+			pr_warning("keyboard buffer overflow\n");
+			break;
+		case 0x7b:
+			pr_warning("keyboard controller failure\n");
+			break;
+		case 0x7c:
+			pr_err("keyboard selftest failure\n");
+			break;
+		case 0x7d:
+			pr_info("initiate power-up key stream\n");
+			break;
+		case 0x7e:
+			pr_info("terminate power-up key stream\n");
+			break;
+		case 0x7f:
+			pr_warning("keyboard interrupt\n");
+			break;
+		}
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/input/keyboard/atakbd.c b/drivers/input/keyboard/atakbd.c
index 1839194..5975052 100644
--- a/drivers/input/keyboard/atakbd.c
+++ b/drivers/input/keyboard/atakbd.c
@@ -40,6 +40,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
@@ -210,7 +212,7 @@ static void atakbd_interrupt(unsigned char scancode, char down)
 			input_sync(atakbd_dev);
 		}
 	} else				/* scancodes >= 0xf2 are mouse data, most likely */
-		printk(KERN_INFO "atakbd: unhandled scancode %x\n", scancode);
+		pr_info("unhandled scancode %x\n", scancode);
 
 	return;
 }
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index c83f4b2..243f3e8 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -31,6 +31,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/hil.h>
 #include <linux/input.h>
 #include <linux/serio.h>
@@ -131,7 +133,7 @@ static void hil_dev_handle_command_response(struct hil_dev *dev)
 		/* These occur when device isn't present */
 		if (p != (HIL_ERR_INT | HIL_PKT_CMD)) {
 			/* Anything else we'd like to know about. */
-			printk(KERN_WARNING PREFIX "Device sent unknown record %x\n", p);
+			pr_warning("Device sent unknown record %x\n", p);
 		}
 		goto out;
 	}
@@ -212,8 +214,7 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
 	bool absdev, ax16;
 
 	if ((p & HIL_CMDCT_POL) != idx - 1) {
-		printk(KERN_WARNING PREFIX
-			"Malformed poll packet %x (idx = %i)\n", p, idx);
+		pr_warning("Malformed poll packet %x (idx = %i)\n", p, idx);
 		return;
 	}
 
@@ -266,7 +267,7 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
 
 static void hil_dev_process_err(struct hil_dev *dev)
 {
-	printk(KERN_WARNING PREFIX "errored HIL packet\n");
+	pr_warning("errored HIL packet\n");
 	dev->idx4 = 0;
 	complete(&dev->cmd_done); /* just in case somebody is waiting */
 }
@@ -346,7 +347,7 @@ static void hil_dev_keyboard_setup(struct hil_dev *kbd)
 	input_dev->name	= strlen(kbd->rnm) ? kbd->rnm : "HIL keyboard";
 	input_dev->phys	= "hpkbd/input0";
 
-	printk(KERN_INFO PREFIX "HIL keyboard found (did = 0x%02x, lang = %s)\n",
+	pr_info("HIL keyboard found (did = 0x%02x, lang = %s)\n",
 		did, hil_language[did & HIL_IDD_DID_TYPE_KB_LANG_MASK]);
 }
 
@@ -430,11 +431,8 @@ static void hil_dev_pointer_setup(struct hil_dev *ptr)
 
 	input_dev->name = strlen(ptr->rnm) ? ptr->rnm : "HIL pointer device";
 
-	printk(KERN_INFO PREFIX
-		"HIL pointer device found (did: 0x%02x, axis: %s)\n",
-		did, txt);
-	printk(KERN_INFO PREFIX
-		"HIL pointer has %i buttons and %i sets of %i axes\n",
+	pr_info("HIL pointer device found (did: 0x%02x, axis: %s)\n", did, txt);
+	pr_info("HIL pointer has %i buttons and %i sets of %i axes\n",
 		ptr->nbtn, naxsets, ptr->naxes);
 }
 
@@ -508,8 +506,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
 	case HIL_IDD_DID_TYPE_CHAR:
 		if (HIL_IDD_NUM_BUTTONS(idd) ||
 		    HIL_IDD_NUM_AXES_PER_SET(*idd)) {
-			printk(KERN_INFO PREFIX
-				"combo devices are not supported.\n");
+			pr_info("combo devices are not supported\n");
 			goto bail1;
 		}
 
diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
index 5f72440..447f49a 100644
--- a/drivers/input/keyboard/hilkbd.c
+++ b/drivers/input/keyboard/hilkbd.c
@@ -15,6 +15,8 @@
  * archive for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci_ids.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
@@ -219,7 +221,7 @@ static int __devinit hil_keyb_init(void)
 
 	err = request_irq(HIL_IRQ, hil_interrupt, 0, "hil", hil_dev.dev_id);
 	if (err) {
-		printk(KERN_ERR "HIL: Can't get IRQ\n");
+		pr_err("Can't get IRQ\n");
 		goto err1;
 	}
 
@@ -232,16 +234,16 @@ static int __devinit hil_keyb_init(void)
 
 	wait_event_interruptible_timeout(hil_wait, hil_dev.valid, 3 * HZ);
 	if (!hil_dev.valid)
-		printk(KERN_WARNING "HIL: timed out, assuming no keyboard present\n");
+		pr_warning("timed out, assuming no keyboard present\n");
 
 	c = hil_dev.c;
 	hil_dev.valid = 0;
 	if (c == 0) {
 		kbid = -1;
-		printk(KERN_WARNING "HIL: no keyboard present\n");
+		pr_warning("no keyboard present\n");
 	} else {
 		kbid = ffz(~c);
-		printk(KERN_INFO "HIL: keyboard found at id %d\n", kbid);
+		pr_info("keyboard found at id %d\n", kbid);
 	}
 
 	/* set it to raw mode */
@@ -268,12 +270,12 @@ static int __devinit hil_keyb_init(void)
 
 	err = input_register_device(hil_dev.dev);
 	if (err) {
-		printk(KERN_ERR "HIL: Can't register device\n");
+		pr_err("Can't register device\n");
 		goto err2;
 	}
 
-	printk(KERN_INFO "input: %s, ID %d at 0x%08lx (irq %d) found and attached\n",
-	       hil_dev.dev->name, kbid, HILBASE, HIL_IRQ);
+	pr_info("%s, ID %d at 0x%08lx (irq %d) found and attached\n",
+		hil_dev.dev->name, kbid, HILBASE, HIL_IRQ);
 
 	return 0;
 
@@ -306,8 +308,8 @@ static int __devinit hil_probe_chip(struct parisc_device *dev)
 		return -ENODEV;
 
 	if (!dev->irq) {
-		printk(KERN_WARNING "HIL: IRQ not found for HIL bus at 0x%p\n",
-			(void *)dev->hpa.start);
+		pr_warning("IRQ not found for HIL bus at 0x%p\n",
+			   (void *)dev->hpa.start);
 		return -ENODEV;
 	}
 
@@ -315,7 +317,7 @@ static int __devinit hil_probe_chip(struct parisc_device *dev)
 	hil_irq  = dev->irq;
 	hil_dev.dev_id = dev;
 
-	printk(KERN_INFO "Found HIL bus at 0x%08lx, IRQ %d\n", hil_base, hil_irq);
+	pr_info("Found HIL bus at 0x%08lx, IRQ %d\n", hil_base, hil_irq);
 
 	return hil_keyb_init();
 }
@@ -368,12 +370,12 @@ static int __init hil_init(void)
 		return -ENODEV;
 
 	if (!hwreg_present((void *)(HILBASE + HIL_DATA))) {
-		printk(KERN_ERR "HIL: hardware register was not found\n");
+		pr_err("hardware register was not found\n");
 		return -ENODEV;
 	}
 
 	if (!request_region(HILBASE + HIL_DATA, 2, "hil")) {
-		printk(KERN_ERR "HIL: IOPORT region already used\n");
+		pr_err("IOPORT region already used\n");
 		return -EIO;
 	}
 
diff --git a/drivers/input/keyboard/jornada680_kbd.c b/drivers/input/keyboard/jornada680_kbd.c
index 5fc976d..e2c7112 100644
--- a/drivers/input/keyboard/jornada680_kbd.c
+++ b/drivers/input/keyboard/jornada680_kbd.c
@@ -16,6 +16,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input-polldev.h>
@@ -231,8 +233,7 @@ static int __devinit jornada680kbd_probe(struct platform_device *pdev)
 	return 0;
 
  failed:
-	printk(KERN_ERR "Jornadakbd: failed to register driver, error: %d\n",
-		error);
+	pr_err("failed to register driver, error: %d\n", error);
 	platform_set_drvdata(pdev, NULL);
 	input_free_polled_device(poll_dev);
 	kfree(jornadakbd);
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index 2cd3e1d..f1995d8 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -15,6 +15,9 @@
  * published by the Free Software Foundation.
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
@@ -67,9 +70,8 @@ static irqreturn_t jornada720_kbd_interrupt(int irq, void *dev_id)
 
 	if (jornada_ssp_inout(GETSCANKEYCODE) != TXDUMMY) {
 		printk(KERN_DEBUG
-			"jornada720_kbd: "
-			"GetKeycode command failed with ETIMEDOUT, "
-			"flushed bus\n");
+		       pr_fmt("GetKeycode command failed with ETIMEDOUT, "
+			      "flushed bus\n"));
 	} else {
 		/* How many keycodes are waiting for us? */
 		count = jornada_ssp_byte(TXDUMMY);
@@ -132,7 +134,7 @@ static int __devinit jornada720_kbd_probe(struct platform_device *pdev)
 			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
 			  "jornadakbd", pdev);
 	if (err) {
-		printk(KERN_INFO "jornadakbd720_kbd: Unable to grab IRQ\n");
+		pr_info("Unable to grab IRQ\n");
 		goto fail1;
 	}
 
diff --git a/drivers/input/keyboard/lkkbd.c b/drivers/input/keyboard/lkkbd.c
index fa9bb6d..41d3770 100644
--- a/drivers/input/keyboard/lkkbd.c
+++ b/drivers/input/keyboard/lkkbd.c
@@ -61,6 +61,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -105,9 +107,9 @@ MODULE_PARM_DESC(lk201_compose_is_alt,
 
 #undef LKKBD_DEBUG
 #ifdef LKKBD_DEBUG
-#define DBG(x...) printk(x)
+#define DBG(format, arg...) pr_info(format, ##arg)
 #else
-#define DBG(x...) do {} while (0)
+#define DBG(format, arg...) do { if (0) pr_info(format, ##arg); } while (0)
 #endif
 
 /* LED control */
@@ -384,18 +386,16 @@ static void lkkbd_detection_done(struct lkkbd *lk)
 
 	default:
 		strlcpy(lk->name, "Unknown DEC keyboard", sizeof(lk->name));
-		printk(KERN_ERR
-			"lkkbd: keyboard on %s is unknown, please report to "
+		pr_err("keyboard on %s is unknown, please report to "
 			"Jan-Benedict Glaw <jbglaw@lug-owl.de>\n", lk->phys);
-		printk(KERN_ERR "lkkbd: keyboard ID'ed as:");
+		pr_err("keyboard ID'ed as:");
 		for (i = 0; i < LK_NUM_IGNORE_BYTES; i++)
-			printk(" 0x%02x", lk->id[i]);
-		printk("\n");
+			pr_cont(" 0x%02x", lk->id[i]);
+		pr_cont("\n");
 		break;
 	}
 
-	printk(KERN_INFO "lkkbd: keyboard on %s identified as: %s\n",
-		lk->phys, lk->name);
+	pr_info("keyboard on %s identified as: %s\n", lk->phys, lk->name);
 
 	/*
 	 * Report errors during keyboard boot-up.
@@ -406,20 +406,18 @@ static void lkkbd_detection_done(struct lkkbd *lk)
 		break;
 
 	case LK_STUCK_KEY:
-		printk(KERN_ERR "lkkbd: Stuck key on keyboard at %s\n",
+		pr_err("Stuck key on keyboard at %s\n",
 			lk->phys);
 		break;
 
 	case LK_SELFTEST_FAILED:
-		printk(KERN_ERR
-			"lkkbd: Selftest failed on keyboard at %s, "
-			"keyboard may not work properly\n", lk->phys);
+		pr_err("Selftest failed on keyboard at %s, "
+		       "keyboard may not work properly\n", lk->phys);
 		break;
 
 	default:
-		printk(KERN_ERR
-			"lkkbd: Unknown error %02x on keyboard at %s\n",
-			lk->id[2], lk->phys);
+		pr_err("Unknown error %02x on keyboard at %s\n",
+		       lk->id[2], lk->phys);
 		break;
 	}
 
@@ -427,9 +425,8 @@ static void lkkbd_detection_done(struct lkkbd *lk)
 	 * Try to hint user if there's a stuck key.
 	 */
 	if (lk->id[2] == LK_STUCK_KEY && lk->id[3] != 0)
-		printk(KERN_ERR
-			"Scancode of stuck key is 0x%02x, keycode is 0x%04x\n",
-			lk->id[3], lk->keycode[lk->id[3]]);
+		pr_err("Scancode of stuck key is 0x%02x, keycode is 0x%04x\n",
+		       lk->id[3], lk->keycode[lk->id[3]]);
 }
 
 /*
@@ -444,10 +441,10 @@ static irqreturn_t lkkbd_interrupt(struct serio *serio,
 	unsigned int keycode;
 	int i;
 
-	DBG(KERN_INFO "Got byte 0x%02x\n", data);
+	DBG("Got byte 0x%02x\n", data);
 
 	if (lk->ignore_bytes > 0) {
-		DBG(KERN_INFO "Ignoring a byte on %s\n", lk->name);
+		DBG("Ignoring a byte on %s\n", lk->name);
 		lk->id[LK_NUM_IGNORE_BYTES - lk->ignore_bytes--] = data;
 
 		if (lk->ignore_bytes == 0)
@@ -464,7 +461,7 @@ static irqreturn_t lkkbd_interrupt(struct serio *serio,
 		break;
 
 	case 0x01:
-		DBG(KERN_INFO "Got 0x01, scheduling re-initialization\n");
+		DBG("Got 0x01, scheduling re-initialization\n");
 		lk->ignore_bytes = LK_NUM_IGNORE_BYTES;
 		lk->id[LK_NUM_IGNORE_BYTES - lk->ignore_bytes--] = data;
 		schedule_work(&lk->tq);
@@ -478,8 +475,10 @@ static irqreturn_t lkkbd_interrupt(struct serio *serio,
 	case LK_PREFIX_KEY_DOWN:
 	case LK_MODE_CHANGE_ACK:
 	case LK_RESPONSE_RESERVED:
-		DBG(KERN_INFO "Got %s and don't know how to handle...\n",
-			response_name(data));
+#ifdef LKKBD_DEBUG
+		DBG("Got %s and don't know how to handle...\n",
+		    response_name(data));
+#endif
 		break;
 
 	default:
@@ -489,9 +488,8 @@ static irqreturn_t lkkbd_interrupt(struct serio *serio,
 					 !test_bit(keycode, input_dev->key));
 			input_sync(input_dev);
 		} else {
-			printk(KERN_WARNING
-				"%s: Unknown key with scancode 0x%02x on %s.\n",
-				__FILE__, data, lk->name);
+			pr_warning("Unknown key with scancode 0x%02x on %s\n",
+				   data, lk->name);
 		}
 	}
 
@@ -565,7 +563,7 @@ static int lkkbd_event(struct input_dev *dev,
 		break;
 
 	default:
-		printk(KERN_ERR "%s(): Got unknown type %d, code %d, value %d\n",
+		pr_err("%s(): Got unknown type %d, code %d, value %d\n",
 			__func__, type, code, value);
 	}
 
diff --git a/drivers/input/keyboard/locomokbd.c b/drivers/input/keyboard/locomokbd.c
index b1ab298..01e60bd 100644
--- a/drivers/input/keyboard/locomokbd.c
+++ b/drivers/input/keyboard/locomokbd.c
@@ -23,6 +23,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -254,7 +256,7 @@ static int __devinit locomokbd_probe(struct locomo_dev *dev)
 				dev->length,
 				LOCOMO_DRIVER_NAME(dev))) {
 		err = -EBUSY;
-		printk(KERN_ERR "locomokbd: Can't acquire access to io memory for keyboard\n");
+		pr_err("Can't acquire access to io memory for keyboard\n");
 		goto err_free_mem;
 	}
 
@@ -299,7 +301,7 @@ static int __devinit locomokbd_probe(struct locomo_dev *dev)
 	/* attempt to get the interrupt */
 	err = request_irq(dev->irq[0], locomokbd_interrupt, 0, "locomokbd", locomokbd);
 	if (err) {
-		printk(KERN_ERR "locomokbd: Can't get irq for keyboard\n");
+		pr_err("Can't get irq for keyboard\n");
 		goto err_release_region;
 	}
 
diff --git a/drivers/input/keyboard/newtonkbd.c b/drivers/input/keyboard/newtonkbd.c
index 48d1cab..2b60858 100644
--- a/drivers/input/keyboard/newtonkbd.c
+++ b/drivers/input/keyboard/newtonkbd.c
@@ -26,6 +26,8 @@
  * Justin Cormack, 68 Dartmouth Park Road, London NW5 1SN, UK.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/input.h>
@@ -76,7 +78,7 @@ static irqreturn_t nkbd_interrupt(struct serio *serio,
 	}
 
 	else if (data == 0xe7) /* end of init sequence */
-		printk(KERN_INFO "input: %s on %s\n", nkbd->dev->name, serio->phys);
+		pr_info("%s on %s\n", nkbd->dev->name, serio->phys);
 	return IRQ_HANDLED;
 
 }
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index a72e61d..2b85872 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -24,6 +24,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -195,15 +197,14 @@ static void omap_kp_tasklet(unsigned long data)
 			if (!(changed & (1 << row)))
 				continue;
 #ifdef NEW_BOARD_LEARNING_MODE
-			printk(KERN_INFO "omap-keypad: key %d-%d %s\n", col,
-			       row, (new_state[col] & (1 << row)) ?
-			       "pressed" : "released");
+			pr_info("key %d-%d %s\n",
+				col, row, (new_state[col] & (1 << row)) ?
+				"pressed" : "released");
 #else
 			key = omap_kp_find_key(col, row);
 			if (key < 0) {
-				printk(KERN_WARNING
-				      "omap-keypad: Spurious key event %d-%d\n",
-				       col, row);
+				pr_warning("Spurious key event %d-%d\n",
+					   col, row);
 				/* We scan again after a couple of seconds */
 				spurious = 1;
 				continue;
@@ -300,7 +301,7 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 	int i, col_idx, row_idx, irq_idx, ret;
 
 	if (!pdata->rows || !pdata->cols || !pdata->keymap) {
-		printk(KERN_ERR "No rows, cols or keymap from pdata\n");
+		pr_err("No rows, cols or keymap from pdata\n");
 		return -EINVAL;
 	}
 
@@ -340,8 +341,7 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 		/* Cols: outputs */
 		for (col_idx = 0; col_idx < omap_kp->cols; col_idx++) {
 			if (gpio_request(col_gpios[col_idx], "omap_kp_col") < 0) {
-				printk(KERN_ERR "Failed to request"
-				       "GPIO%d for keypad\n",
+				pr_err("Failed to request GPIO%d for keypad\n",
 				       col_gpios[col_idx]);
 				goto err1;
 			}
@@ -350,8 +350,7 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 		/* Rows: inputs */
 		for (row_idx = 0; row_idx < omap_kp->rows; row_idx++) {
 			if (gpio_request(row_gpios[row_idx], "omap_kp_row") < 0) {
-				printk(KERN_ERR "Failed to request"
-				       "GPIO%d for keypad\n",
+				pr_err("Failed to request GPIO%d for keypad\n",
 				       row_gpios[row_idx]);
 				goto err2;
 			}
@@ -387,7 +386,7 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 
 	ret = input_register_device(omap_kp->input);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to register omap-keypad input device\n");
+		pr_err("Unable to register omap-keypad input device\n");
 		goto err3;
 	}
 
@@ -478,7 +477,7 @@ static struct platform_driver omap_kp_driver = {
 
 static int __init omap_kp_init(void)
 {
-	printk(KERN_INFO "OMAP Keypad Driver\n");
+	pr_info("OMAP Keypad Driver\n");
 	return platform_driver_register(&omap_kp_driver);
 }
 
diff --git a/drivers/input/keyboard/sunkbd.c b/drivers/input/keyboard/sunkbd.c
index a99a04b..41216ca 100644
--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -137,10 +139,9 @@ static irqreturn_t sunkbd_interrupt(struct serio *serio,
 					 !(data & SUNKBD_RELEASE));
 			input_sync(sunkbd->dev);
 		} else {
-			printk(KERN_WARNING
-				"sunkbd.c: Unknown key (scancode %#x) %s.\n",
-				data & SUNKBD_KEY,
-				data & SUNKBD_RELEASE ? "released" : "pressed");
+			pr_warning("Unknown key (scancode %#x) %s.\n",
+				   data & SUNKBD_KEY,
+				   data & SUNKBD_RELEASE ? "released" : "pressed");
 		}
 	}
 out:
diff --git a/drivers/input/keyboard/xtkbd.c b/drivers/input/keyboard/xtkbd.c
index 37b01d7..292110b 100644
--- a/drivers/input/keyboard/xtkbd.c
+++ b/drivers/input/keyboard/xtkbd.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/input.h>
@@ -76,8 +78,9 @@ static irqreturn_t xtkbd_interrupt(struct serio *serio,
 				input_report_key(xtkbd->dev, xtkbd->keycode[data & XTKBD_KEY], !(data & XTKBD_RELEASE));
 				input_sync(xtkbd->dev);
 			} else {
-				printk(KERN_WARNING "xtkbd.c: Unknown key (scancode %#x) %s.\n",
-					data & XTKBD_KEY, data & XTKBD_RELEASE ? "released" : "pressed");
+				pr_warning("Unknown key (scancode %#x) %s\n",
+					   data & XTKBD_KEY,
+					   data & XTKBD_RELEASE ? "released" : "pressed");
 			}
 	}
 	return IRQ_HANDLED;
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
index b71eb55..d908c4b 100644
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
 
@@ -306,19 +309,18 @@ static int uinput_validate_absbits(struct input_dev *dev)
 
 		if ((dev->absmax[cnt] <= dev->absmin[cnt])) {
 			printk(KERN_DEBUG
-				"%s: invalid abs[%02x] min:%d max:%d\n",
-				UINPUT_NAME, cnt,
-				dev->absmin[cnt], dev->absmax[cnt]);
+			       pr_fmt("invalid abs[%02x] min:%d max:%d\n"),
+			       cnt, dev->absmin[cnt], dev->absmax[cnt]);
 			retval = -EINVAL;
 			break;
 		}
 
 		if (dev->absflat[cnt] > (dev->absmax[cnt] - dev->absmin[cnt])) {
 			printk(KERN_DEBUG
-				"%s: absflat[%02x] out of range: %d "
-				"(min:%d/max:%d)\n",
-				UINPUT_NAME, cnt, dev->absflat[cnt],
-				dev->absmin[cnt], dev->absmax[cnt]);
+			       pr_fmt("absflat[%02x] out of range: %d "
+				      "(min:%d/max:%d)\n"),
+			       cnt, dev->absflat[cnt],
+			       dev->absmin[cnt], dev->absmax[cnt]);
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
 
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 99d5876..feefe22 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -15,6 +15,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
@@ -25,9 +27,9 @@
 
 #undef DEBUG
 #ifdef DEBUG
-#define dbg(format, arg...) printk(KERN_INFO "alps.c: " format "\n", ## arg)
+#define dbg(format, arg...) pr_info(format "\n", ##arg)
 #else
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...) do { if (0) pr_info(format "\n", ##arg); } while (0)
 #endif
 
 #define ALPS_OLDPROTO		0x01	/* old style input */
@@ -605,12 +607,12 @@ static int alps_hw_init(struct psmouse *psmouse)
 	}
 
 	if (alps_tap_mode(psmouse, true)) {
-		printk(KERN_WARNING "alps.c: Failed to enable hardware tapping\n");
+		pr_warning("Failed to enable hardware tapping\n");
 		return -1;
 	}
 
 	if (alps_absolute_mode(psmouse)) {
-		printk(KERN_ERR "alps.c: Failed to enable absolute mode\n");
+		pr_err("Failed to enable absolute mode\n");
 		return -1;
 	}
 
@@ -621,7 +623,7 @@ static int alps_hw_init(struct psmouse *psmouse)
 
 	/* ALPS needs stream mode, otherwise it won't report any data */
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSTREAM)) {
-		printk(KERN_ERR "alps.c: Failed to enable stream mode\n");
+		pr_err("Failed to enable stream mode\n");
 		return -1;
 	}
 
diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index 05edd75..740cb8c 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -28,6 +28,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -212,20 +214,22 @@ struct atp {
 	struct work_struct	work;
 };
 
-#define dbg_dump(msg, tab) \
+#define dbg_dump(msg, tab)						\
+do {									\
 	if (debug > 1) {						\
 		int __i;						\
-		printk(KERN_DEBUG "appletouch: %s", msg);		\
+		printk(KERN_DEBUG pr_fmt("%s"), msg);			\
 		for (__i = 0; __i < ATP_XSENSORS + ATP_YSENSORS; __i++)	\
-			printk(" %02x", tab[__i]);			\
-		printk("\n");						\
-	}
+			pr_cont(" %02x", tab[__i]);			\
+		pr_cont("\n");						\
+	}								\
+} while (0)
 
-#define dprintk(format, a...)						\
-	do {								\
-		if (debug)						\
-			printk(KERN_DEBUG format, ##a);			\
-	} while (0)
+#define dprintk(level, format, a...)					\
+do {									\
+	if (debug > level)						\
+		printk(KERN_DEBUG pr_fmt(format), ##a);			\
+} while (0)
 
 MODULE_AUTHOR("Johannes Berg");
 MODULE_AUTHOR("Stelian Pop");
@@ -273,11 +277,11 @@ static int atp_geyser_init(struct usb_device *udev)
 			ATP_GEYSER_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
-		dprintk("atp_geyser_init: read error\n");
+		dprintk(0, "%s(): read error\n", __func__);
 		for (i = 0; i < 8; i++)
-			dprintk("appletouch[%d]: %d\n", i, data[i]);
+			dprintk(0, "[%d]: %d\n", i, data[i]);
 
-		err("Failed to read mode from device.");
+		err("Failed to read mode from device");
 		ret = -EIO;
 		goto out_free;
 	}
@@ -292,9 +296,9 @@ static int atp_geyser_init(struct usb_device *udev)
 			ATP_GEYSER_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
-		dprintk("atp_geyser_init: write error\n");
+		dprintk(0, "%s(): write error\n", __func__);
 		for (i = 0; i < 8; i++)
-			dprintk("appletouch[%d]: %d\n", i, data[i]);
+			dprintk(0, "[%d]: %d\n", i, data[i]);
 
 		err("Failed to request geyser raw mode");
 		ret = -EIO;
@@ -316,7 +320,7 @@ static void atp_reinit(struct work_struct *work)
 	struct usb_device *udev = dev->udev;
 	int retval;
 
-	dprintk("appletouch: putting appletouch to sleep (reinit)\n");
+	dprintk(0, "putting appletouch to sleep (reinit)\n");
 	atp_geyser_init(udev);
 
 	retval = usb_submit_urb(dev->urb, GFP_ATOMIC);
@@ -407,9 +411,8 @@ static int atp_status_check(struct urb *urb)
 		break;
 	case -EOVERFLOW:
 		if (!dev->overflow_warned) {
-			printk(KERN_WARNING "appletouch: OVERFLOW with data "
-				"length %d, actual length is %d\n",
-				dev->info->datalen, dev->urb->actual_length);
+			pr_warning("OVERFLOW with data length %d, actual length is %d\n",
+				   dev->info->datalen, dev->urb->actual_length);
 			dev->overflow_warned = true;
 		}
 	case -ECONNRESET:
@@ -428,8 +431,7 @@ static int atp_status_check(struct urb *urb)
 
 	/* drop incomplete datasets */
 	if (dev->urb->actual_length != dev->info->datalen) {
-		dprintk("appletouch: incomplete data package"
-			" (first byte: %d, length: %d).\n",
+		dprintk(0, "incomplete data package (first byte: %d, length: %d)\n",
 			dev->data[0], dev->urb->actual_length);
 		return ATP_URB_STATUS_ERROR;
 	}
@@ -445,7 +447,7 @@ static void atp_detect_size(struct atp *dev)
 	for (i = dev->info->xsensors; i < ATP_XSENSORS; i++) {
 		if (dev->xy_cur[i]) {
 
-			printk(KERN_INFO "appletouch: 17\" model detected.\n");
+			pr_info("17\" model detected.\n");
 
 			input_set_abs_params(dev->input, ABS_X, 0,
 					     (dev->info->xsensors_17 - 1) *
@@ -556,10 +558,8 @@ static void atp_complete_geyser_1_2(struct urb *urb)
 			dev->x_old = x;
 			dev->y_old = y;
 
-			if (debug > 1)
-				printk(KERN_DEBUG "appletouch: "
-					"X: %3d Y: %3d Xz: %3d Yz: %3d\n",
-					x, y, x_z, y_z);
+			dprintk(1, "X: %3d Y: %3d Xz: %3d Yz: %3d\n",
+				x, y, x_z, y_z);
 
 			input_report_key(dev->input, BTN_TOUCH, 1);
 			input_report_abs(dev->input, ABS_X, x);
@@ -630,7 +630,7 @@ static void atp_complete_geyser_3_4(struct urb *urb)
 	/* Just update the base values (i.e. touchpad in untouched state) */
 	if (dev->data[dev->info->datalen - 1] & ATP_STATUS_BASE_UPDATE) {
 
-		dprintk(KERN_DEBUG "appletouch: updated base values\n");
+		dprintk(0, "updated base values\n");
 
 		memcpy(dev->xy_old, dev->xy_cur, sizeof(dev->xy_old));
 		goto exit;
@@ -667,10 +667,8 @@ static void atp_complete_geyser_3_4(struct urb *urb)
 			dev->x_old = x;
 			dev->y_old = y;
 
-			if (debug > 1)
-				printk(KERN_DEBUG "appletouch: X: %3d Y: %3d "
-				       "Xz: %3d Yz: %3d\n",
-				       x, y, x_z, y_z);
+			dprintk(1, "X: %3d Y: %3d Xz: %3d Yz: %3d\n",
+				x, y, x_z, y_z);
 
 			input_report_key(dev->input, BTN_TOUCH, 1);
 			input_report_abs(dev->input, ABS_X, x);
@@ -755,7 +753,7 @@ static int atp_handle_geyser(struct atp *dev)
 		if (atp_geyser_init(udev))
 			return -EIO;
 
-		printk(KERN_INFO "appletouch: Geyser mode initialized.\n");
+		pr_info("Geyser mode initialized\n");
 	}
 
 	return 0;
@@ -886,7 +884,7 @@ static void atp_disconnect(struct usb_interface *iface)
 		usb_free_urb(dev->urb);
 		kfree(dev);
 	}
-	printk(KERN_INFO "input: appletouch disconnected\n");
+	pr_info("appletouch disconnected\n");
 }
 
 static int atp_recover(struct atp *dev)
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ea67c49..8b201dc 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -32,6 +32,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -89,8 +91,8 @@ MODULE_AUTHOR("Henrik Rydberg");
 MODULE_DESCRIPTION("Apple USB BCM5974 multitouch driver");
 MODULE_LICENSE("GPL");
 
-#define dprintk(level, format, a...)\
-	{ if (debug >= level) printk(KERN_DEBUG format, ##a); }
+#define dprintk(level, format, a...)				\
+do { if (debug >= level) printk(KERN_DEBUG pr_fmt(format), ##a); } while (0)
 
 static int debug = 1;
 module_param(debug, int, 0644);
@@ -322,8 +324,7 @@ static int report_bt_state(struct bcm5974 *dev, int size)
 	if (size != sizeof(struct bt_data))
 		return -EIO;
 
-	dprintk(7,
-		"bcm5974: button data: %x %x %x %x\n",
+	dprintk(7, "button data: %x %x %x %x\n",
 		dev->bt_data->unknown1, dev->bt_data->button,
 		dev->bt_data->rel_x, dev->bt_data->rel_y);
 
@@ -378,9 +379,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 		raw_x = raw2int(f->abs_x);
 		raw_y = raw2int(f->abs_y);
 
-		dprintk(9,
-			"bcm5974: "
-			"raw: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
+		dprintk(9, "raw: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
 			raw_p, raw_w, raw_x, raw_y, raw_n);
 
 		ptest = int2bound(&c->p, raw_p);
@@ -426,9 +425,9 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 		input_report_abs(input, ABS_X, abs_x);
 		input_report_abs(input, ABS_Y, abs_y);
 
-		dprintk(8,
-			"bcm5974: abs: p: %+05d w: %+05d x: %+05d y: %+05d "
-			"nmin: %d nmax: %d n: %d ibt: %d\n", abs_p, abs_w,
+		dprintk(8, "abs: p: %+05d w: %+05d x: %+05d y: %+05d "
+			"nmin: %d nmax: %d n: %d ibt: %d\n",
+			abs_p, abs_w,
 			abs_x, abs_y, nmin, nmax, dev->fingers, ibt);
 
 	}
@@ -456,7 +455,7 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
 	int retval = 0, size;
 
 	if (!data) {
-		err("bcm5974: out of memory");
+		pr_err("out of memory\n");
 		retval = -ENOMEM;
 		goto out;
 	}
@@ -469,7 +468,7 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
 			BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
-		err("bcm5974: could not read from device");
+		pr_err("could not read from device\n");
 		retval = -EIO;
 		goto out;
 	}
@@ -487,13 +486,12 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
 			BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
-		err("bcm5974: could not write to device");
+		pr_err("could not write to device\n");
 		retval = -EIO;
 		goto out;
 	}
 
-	dprintk(2, "bcm5974: switched to %s mode.\n",
-		on ? "wellspring" : "normal");
+	dprintk(2, "switched to %s mode\n", on ? "wellspring" : "normal");
 
  out:
 	kfree(data);
@@ -512,21 +510,21 @@ static void bcm5974_irq_button(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
-		dbg("bcm5974: button urb shutting down: %d", urb->status);
+		pr_debug("button urb shutting down: %d\n", urb->status);
 		return;
 	default:
-		dbg("bcm5974: button urb status: %d", urb->status);
+		pr_debug("button urb status: %d\n", urb->status);
 		goto exit;
 	}
 
 	if (report_bt_state(dev, dev->bt_urb->actual_length))
-		dprintk(1, "bcm5974: bad button package, length: %d\n",
+		dprintk(1, "bad button package, length: %d\n",
 			dev->bt_urb->actual_length);
 
 exit:
 	error = usb_submit_urb(dev->bt_urb, GFP_ATOMIC);
 	if (error)
-		err("bcm5974: button urb failed: %d", error);
+		pr_err("button urb failed: %d\n", error);
 }
 
 static void bcm5974_irq_trackpad(struct urb *urb)
@@ -541,10 +539,10 @@ static void bcm5974_irq_trackpad(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
-		dbg("bcm5974: trackpad urb shutting down: %d", urb->status);
+		pr_debug("trackpad urb shutting down: %d\n", urb->status);
 		return;
 	default:
-		dbg("bcm5974: trackpad urb status: %d", urb->status);
+		pr_debug("trackpad urb status: %d\n", urb->status);
 		goto exit;
 	}
 
@@ -553,13 +551,13 @@ static void bcm5974_irq_trackpad(struct urb *urb)
 		goto exit;
 
 	if (report_tp_state(dev, dev->tp_urb->actual_length))
-		dprintk(1, "bcm5974: bad trackpad package, length: %d\n",
+		dprintk(1, "bad trackpad package, length: %d\n",
 			dev->tp_urb->actual_length);
 
 exit:
 	error = usb_submit_urb(dev->tp_urb, GFP_ATOMIC);
 	if (error)
-		err("bcm5974: trackpad urb failed: %d", error);
+		pr_err("trackpad urb failed: %d\n", error);
 }
 
 /*
@@ -586,7 +584,7 @@ static int bcm5974_start_traffic(struct bcm5974 *dev)
 
 	error = bcm5974_wellspring_mode(dev, true);
 	if (error) {
-		dprintk(1, "bcm5974: mode switch failed\n");
+		dprintk(1, "mode switch failed\n");
 		goto err_out;
 	}
 
@@ -705,7 +703,7 @@ static int bcm5974_probe(struct usb_interface *iface,
 	dev = kzalloc(sizeof(struct bcm5974), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!dev || !input_dev) {
-		err("bcm5974: out of memory");
+		pr_err("out of memory\n");
 		goto err_free_devs;
 	}
 
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index b18862b..a6c41e0 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -171,8 +171,8 @@ static void elantech_packet_dump(unsigned char *packet, int size)
 
 	printk(KERN_DEBUG pr_fmt("PS/2 packet ["));
 	for (i = 0; i < size; i++)
-		printk("%s0x%02x ", (i) ? ", " : " ", packet[i]);
-	printk("]\n");
+		pr_cont(" 0x%02x", packet[i]);
+	pr_cont(" ]\n");
 }
 
 /*
diff --git a/drivers/input/mouse/inport.c b/drivers/input/mouse/inport.c
index 3827a22..9a522c1 100644
--- a/drivers/input/mouse/inport.c
+++ b/drivers/input/mouse/inport.c
@@ -32,6 +32,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
@@ -133,7 +135,7 @@ static int __init inport_init(void)
 	int err;
 
 	if (!request_region(INPORT_BASE, INPORT_EXTENT, "inport")) {
-		printk(KERN_ERR "inport.c: Can't allocate ports at %#x\n", INPORT_BASE);
+		pr_err("Can't allocate ports at %#x\n", INPORT_BASE);
 		return -EBUSY;
 	}
 
@@ -141,14 +143,14 @@ static int __init inport_init(void)
 	b = inb(INPORT_SIGNATURE_PORT);
 	c = inb(INPORT_SIGNATURE_PORT);
 	if (a == b || a != c) {
-		printk(KERN_INFO "inport.c: Didn't find InPort mouse at %#x\n", INPORT_BASE);
+		pr_info("Didn't find InPort mouse at %#x\n", INPORT_BASE);
 		err = -ENODEV;
 		goto err_release_region;
 	}
 
 	inport_dev = input_allocate_device();
 	if (!inport_dev) {
-		printk(KERN_ERR "inport.c: Not enough memory for input device\n");
+		pr_err("Not enough memory for input device\n");
 		err = -ENOMEM;
 		goto err_release_region;
 	}
diff --git a/drivers/input/mouse/lifebook.c b/drivers/input/mouse/lifebook.c
index c31ad11..2d64e3d 100644
--- a/drivers/input/mouse/lifebook.c
+++ b/drivers/input/mouse/lifebook.c
@@ -12,6 +12,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
@@ -169,8 +171,7 @@ static psmouse_ret_t lifebook_process_byte(struct psmouse *psmouse)
 
 	if (relative_packet) {
 		if (!dev2)
-			printk(KERN_WARNING "lifebook.c: got relative packet "
-				"but no relative device set up\n");
+			pr_warning("got relative packet but no relative device set up\n");
 	} else {
 		if (lifebook_use_6byte_proto) {
 			input_report_abs(dev1, ABS_X,
diff --git a/drivers/input/mouse/logibm.c b/drivers/input/mouse/logibm.c
index e241311..988667f 100644
--- a/drivers/input/mouse/logibm.c
+++ b/drivers/input/mouse/logibm.c
@@ -33,6 +33,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
@@ -104,7 +106,7 @@ static irqreturn_t logibm_interrupt(int irq, void *dev_id)
 static int logibm_open(struct input_dev *dev)
 {
 	if (request_irq(logibm_irq, logibm_interrupt, 0, "logibm", NULL)) {
-		printk(KERN_ERR "logibm.c: Can't allocate irq %d\n", logibm_irq);
+		pr_err("Can't allocate irq %d\n", logibm_irq);
 		return -EBUSY;
 	}
 	outb(LOGIBM_ENABLE_IRQ, LOGIBM_CONTROL_PORT);
@@ -122,7 +124,7 @@ static int __init logibm_init(void)
 	int err;
 
 	if (!request_region(LOGIBM_BASE, LOGIBM_EXTENT, "logibm")) {
-		printk(KERN_ERR "logibm.c: Can't allocate ports at %#x\n", LOGIBM_BASE);
+		pr_err("Can't allocate ports at %#x\n", LOGIBM_BASE);
 		return -EBUSY;
 	}
 
@@ -131,7 +133,7 @@ static int __init logibm_init(void)
 	udelay(100);
 
 	if (inb(LOGIBM_SIGNATURE_PORT) != LOGIBM_SIGNATURE_BYTE) {
-		printk(KERN_INFO "logibm.c: Didn't find Logitech busmouse at %#x\n", LOGIBM_BASE);
+		pr_info("Didn't find Logitech busmouse at %#x\n", LOGIBM_BASE);
 		err = -ENODEV;
 		goto err_release_region;
 	}
@@ -141,7 +143,7 @@ static int __init logibm_init(void)
 
 	logibm_dev = input_allocate_device();
 	if (!logibm_dev) {
-		printk(KERN_ERR "logibm.c: Not enough memory for input device\n");
+		pr_err("Not enough memory for input device\n");
 		err = -ENOMEM;
 		goto err_release_region;
 	}
diff --git a/drivers/input/mouse/logips2pp.c b/drivers/input/mouse/logips2pp.c
index c9983ae..83149ba 100644
--- a/drivers/input/mouse/logips2pp.c
+++ b/drivers/input/mouse/logips2pp.c
@@ -9,6 +9,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
@@ -84,8 +86,8 @@ static psmouse_ret_t ps2pp_process_byte(struct psmouse *psmouse)
 
 #ifdef DEBUG
 		default:
-			printk(KERN_WARNING "psmouse.c: Received PS2++ packet #%x, but don't know how to handle.\n",
-				(packet[1] >> 4) | (packet[0] & 0x30));
+			pr_warning("Received PS2++ packet #%x, but don't know how to handle\n",
+				   (packet[1] >> 4) | (packet[0] & 0x30));
 #endif
 		}
 	} else {
@@ -382,7 +384,7 @@ int ps2pp_init(struct psmouse *psmouse, bool set_properties)
 		}
 
 	} else {
-		printk(KERN_WARNING "logips2pp: Detected unknown logitech mouse model %d\n", model);
+		pr_warning("Detected unknown logitech mouse model %d\n", model);
 	}
 
 	if (set_properties) {
@@ -400,9 +402,8 @@ int ps2pp_init(struct psmouse *psmouse, bool set_properties)
 				error = device_create_file(&psmouse->ps2dev.serio->dev,
 							   &psmouse_attr_smartscroll.dattr);
 				if (error) {
-					printk(KERN_ERR
-						"logips2pp.c: failed to create smartscroll "
-						"sysfs attribute, error: %d\n", error);
+					pr_err("failed to create smartscroll sysfs attribute, error: %d\n",
+					       error);
 					return -1;
 				}
 			}
diff --git a/drivers/input/mouse/pc110pad.c b/drivers/input/mouse/pc110pad.c
index 3941f97..64f9ba7 100644
--- a/drivers/input/mouse/pc110pad.c
+++ b/drivers/input/mouse/pc110pad.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -114,22 +116,22 @@ static int __init pc110pad_init(void)
 		return -ENODEV;
 
 	if (!request_region(pc110pad_io, 4, "pc110pad")) {
-		printk(KERN_ERR "pc110pad: I/O area %#x-%#x in use.\n",
-				pc110pad_io, pc110pad_io + 4);
+		pr_err("I/O area %#x-%#x in use\n",
+		       pc110pad_io, pc110pad_io + 4);
 		return -EBUSY;
 	}
 
 	outb(PC110PAD_OFF, pc110pad_io + 2);
 
 	if (request_irq(pc110pad_irq, pc110pad_interrupt, 0, "pc110pad", NULL)) {
-		printk(KERN_ERR "pc110pad: Unable to get irq %d.\n", pc110pad_irq);
+		pr_err("Unable to get irq %d\n", pc110pad_irq);
 		err = -EBUSY;
 		goto err_release_region;
 	}
 
 	pc110pad_dev = input_allocate_device();
 	if (!pc110pad_dev) {
-		printk(KERN_ERR "pc110pad: Not enough memory.\n");
+		pr_err("Not enough memory\n");
 		err = -ENOMEM;
 		goto err_free_irq;
 	}
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 73a7af2..ed15ab2 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -11,6 +11,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -251,11 +253,12 @@ static int psmouse_handle_byte(struct psmouse *psmouse)
 	switch (rc) {
 	case PSMOUSE_BAD_DATA:
 		if (psmouse->state == PSMOUSE_ACTIVATED) {
-			printk(KERN_WARNING "psmouse.c: %s at %s lost sync at byte %d\n",
-				psmouse->name, psmouse->phys, psmouse->pktcnt);
+			pr_warning("%s at %s lost sync at byte %d\n",
+				   psmouse->name, psmouse->phys,
+				   psmouse->pktcnt);
 			if (++psmouse->out_of_sync_cnt == psmouse->resetafter) {
 				__psmouse_set_state(psmouse, PSMOUSE_IGNORE);
-				printk(KERN_NOTICE "psmouse.c: issuing reconnect request\n");
+				pr_notice("issuing reconnect request\n");
 				serio_reconnect(psmouse->ps2dev.serio);
 				return -1;
 			}
@@ -267,8 +270,8 @@ static int psmouse_handle_byte(struct psmouse *psmouse)
 		psmouse->pktcnt = 0;
 		if (psmouse->out_of_sync_cnt) {
 			psmouse->out_of_sync_cnt = 0;
-			printk(KERN_NOTICE "psmouse.c: %s at %s - driver resynched.\n",
-				psmouse->name, psmouse->phys);
+			pr_notice("%s at %s - driver resynched\n",
+				  psmouse->name, psmouse->phys);
 		}
 		break;
 
@@ -295,9 +298,9 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 		     ((flags & SERIO_PARITY) && !psmouse->ignore_parity))) {
 
 		if (psmouse->state == PSMOUSE_ACTIVATED)
-			printk(KERN_WARNING "psmouse.c: bad data from KBC -%s%s\n",
-				flags & SERIO_TIMEOUT ? " timeout" : "",
-				flags & SERIO_PARITY ? " bad parity" : "");
+			pr_warning("bad data from KBC -%s%s\n",
+				   flags & SERIO_TIMEOUT ? " timeout" : "",
+				   flags & SERIO_PARITY ? " bad parity" : "");
 		ps2_cmd_aborted(&psmouse->ps2dev);
 		goto out;
 	}
@@ -315,8 +318,8 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 
 	if (psmouse->state == PSMOUSE_ACTIVATED &&
 	    psmouse->pktcnt && time_after(jiffies, psmouse->last + HZ/2)) {
-		printk(KERN_INFO "psmouse.c: %s at %s lost synchronization, throwing %d bytes away.\n",
-		       psmouse->name, psmouse->phys, psmouse->pktcnt);
+		pr_info("%s at %s lost synchronization, throwing %d bytes away\n",
+			psmouse->name, psmouse->phys, psmouse->pktcnt);
 		psmouse->badbyte = psmouse->packet[0];
 		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
 		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
@@ -943,7 +946,8 @@ static int psmouse_probe(struct psmouse *psmouse)
  */
 
 	if (ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_DIS))
-		printk(KERN_WARNING "psmouse.c: Failed to reset mouse on %s\n", ps2dev->serio->phys);
+		pr_warning("failed to reset mouse on %s\n",
+			   ps2dev->serio->phys);
 
 	return 0;
 }
@@ -1005,8 +1009,8 @@ static void psmouse_initialize(struct psmouse *psmouse)
 static void psmouse_activate(struct psmouse *psmouse)
 {
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE))
-		printk(KERN_WARNING "psmouse.c: Failed to enable mouse on %s\n",
-			psmouse->ps2dev.serio->phys);
+		pr_warning("failed to enable mouse on %s\n",
+			   psmouse->ps2dev.serio->phys);
 
 	psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
 }
@@ -1020,8 +1024,8 @@ static void psmouse_activate(struct psmouse *psmouse)
 static void psmouse_deactivate(struct psmouse *psmouse)
 {
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_DISABLE))
-		printk(KERN_WARNING "psmouse.c: Failed to deactivate mouse on %s\n",
-			psmouse->ps2dev.serio->phys);
+		pr_warning("failed to deactivate mouse on %s\n",
+			   psmouse->ps2dev.serio->phys);
 
 	psmouse_set_state(psmouse, PSMOUSE_CMD_MODE);
 }
@@ -1115,14 +1119,14 @@ static void psmouse_resync(struct work_struct *work)
 	}
 
 	if (!enabled) {
-		printk(KERN_WARNING "psmouse.c: failed to re-enable mouse on %s\n",
-			psmouse->ps2dev.serio->phys);
+		pr_warning("failed to re-enable mouse on %s\n",
+			   psmouse->ps2dev.serio->phys);
 		failed = true;
 	}
 
 	if (failed) {
 		psmouse_set_state(psmouse, PSMOUSE_IGNORE);
-		printk(KERN_INFO "psmouse.c: resync failed, issuing reconnect request\n");
+		pr_info("resync failed, issuing reconnect request\n");
 		serio_reconnect(serio);
 	} else
 		psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
@@ -1155,8 +1159,8 @@ static void psmouse_cleanup(struct serio *serio)
 	 * Disable stream mode so cleanup routine can proceed undisturbed.
 	 */
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_DISABLE))
-		printk(KERN_WARNING "psmouse.c: Failed to disable mouse on %s\n",
-			psmouse->ps2dev.serio->phys);
+		pr_warning("failed to disable mouse on %s\n",
+			   psmouse->ps2dev.serio->phys);
 
 	if (psmouse->cleanup)
 		psmouse->cleanup(psmouse);
@@ -1400,7 +1404,7 @@ static int psmouse_reconnect(struct serio *serio)
 	int rc = -1;
 
 	if (!drv || !psmouse) {
-		printk(KERN_DEBUG "psmouse: reconnect request, but serio is disconnected, ignoring...\n");
+		printk(KERN_DEBUG pr_fmt("reconnect request, but serio is disconnected, ignoring...\n"));
 		return -1;
 	}
 
@@ -1586,9 +1590,7 @@ static ssize_t psmouse_attr_set_protocol(struct psmouse *psmouse, void *data, co
 
 	while (serio->child) {
 		if (++retry > 3) {
-			printk(KERN_WARNING
-				"psmouse: failed to destroy child port, "
-				"protocol change aborted.\n");
+			pr_warning("failed to destroy child port, protocol change aborted\n");
 			input_free_device(new_dev);
 			return -EIO;
 		}
@@ -1714,7 +1716,7 @@ static int __init psmouse_init(void)
 
 	kpsmoused_wq = create_singlethread_workqueue("kpsmoused");
 	if (!kpsmoused_wq) {
-		printk(KERN_ERR "psmouse: failed to create kpsmoused workqueue\n");
+		pr_err("failed to create kpsmoused workqueue\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/input/mouse/rpcmouse.c b/drivers/input/mouse/rpcmouse.c
index 272dedd..12586ba 100644
--- a/drivers/input/mouse/rpcmouse.c
+++ b/drivers/input/mouse/rpcmouse.c
@@ -17,6 +17,8 @@
  * the complete state and then work out if something has changed.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/interrupt.h>
@@ -87,7 +89,7 @@ static int __init rpcmouse_init(void)
 	rpcmouse_lasty = (short) iomd_readl(IOMD_MOUSEY);
 
 	if (request_irq(IRQ_VSYNCPULSE, rpcmouse_irq, IRQF_SHARED, "rpcmouse", rpcmouse_dev)) {
-		printk(KERN_ERR "rpcmouse: unable to allocate VSYNC interrupt\n");
+		pr_err("unable to allocate VSYNC interrupt\n");
 		err = -EBUSY;
 		goto err_free_dev;
 	}
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 1242775..52dabc7 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -19,6 +19,8 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/input.h>
@@ -608,11 +610,13 @@ static void fsp_packet_debug(unsigned char packet[])
 
 	ps2_packet_cnt++;
 	jiffies_msec = jiffies_to_msecs(jiffies);
-	printk(KERN_DEBUG "%08dms PS/2 packets: %02x, %02x, %02x, %02x\n",
-		jiffies_msec, packet[0], packet[1], packet[2], packet[3]);
+	printk(KERN_DEBUG
+	       pr_fmt("%08dms PS/2 packets: %02x, %02x, %02x, %02x\n"),
+	       jiffies_msec, packet[0], packet[1], packet[2], packet[3]);
 
 	if (jiffies_msec - ps2_last_second > 1000) {
-		printk(KERN_DEBUG "PS/2 packets/sec = %d\n", ps2_packet_cnt);
+		printk(KERN_DEBUG pr_fmt("PS/2 packets/sec = %d\n"),
+		       ps2_packet_cnt);
 		ps2_packet_cnt = 0;
 		ps2_last_second = jiffies_msec;
 	}
@@ -821,8 +825,7 @@ int fsp_init(struct psmouse *psmouse)
 		return -ENODEV;
 	}
 
-	printk(KERN_INFO
-		"Finger Sensing Pad, hw: %d.%d.%d, sw: %s, buttons: %d\n",
+	pr_info("Finger Sensing Pad, hw: %d.%d.%d, sw: %s, buttons: %d\n",
 		ver >> 4, ver & 0x0F, rev, fsp_drv_ver, buttons & 7);
 
 	psmouse->private = priv = kzalloc(sizeof(struct fsp_data), GFP_KERNEL);
diff --git a/drivers/input/mouse/sermouse.c b/drivers/input/mouse/sermouse.c
index 17ff137b..d809a94 100644
--- a/drivers/input/mouse/sermouse.c
+++ b/drivers/input/mouse/sermouse.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -186,8 +188,8 @@ static void sermouse_process_ms(struct sermouse *sermouse, signed char data)
 
 				default: /* We don't decode anything else yet. */
 
-					printk(KERN_WARNING
-						"sermouse.c: Received MZ++ packet %x, don't know how to handle.\n", buf[1]);
+					pr_warning("Received MZ++ packet %x, don't know how to handle\n",
+						   buf[1]);
 					break;
 			}
 
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 8c32440..e02c2a7 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -23,6 +23,8 @@
  * Trademarks are the property of their respective owners.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/input.h>
@@ -157,7 +159,7 @@ static int synaptics_capability(struct psmouse *psmouse)
 
 	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 1) {
 		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_CAPAB, cap)) {
-			printk(KERN_ERR "Synaptics claims to have extended capabilities,"
+			pr_err("Synaptics claims to have extended capabilities,"
 			       " but I'm not able to read them.\n");
 		} else {
 			priv->ext_cap = (cap[0] << 16) | (cap[1] << 8) | cap[2];
@@ -173,7 +175,7 @@ static int synaptics_capability(struct psmouse *psmouse)
 
 	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 4) {
 		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_CAPAB_0C, cap)) {
-			printk(KERN_ERR "Synaptics claims to have extended capability 0x0c,"
+			pr_err("Synaptics claims to have extended capability 0x0c,"
 			       " but I'm not able to read it.\n");
 		} else {
 			priv->ext_cap_0c = (cap[0] << 16) | (cap[1] << 8) | cap[2];
@@ -223,7 +225,7 @@ static int synaptics_resolution(struct psmouse *psmouse)
 	if (SYN_EXT_CAP_REQUESTS(priv->capabilities) >= 5 &&
 	    SYN_CAP_MAX_DIMENSIONS(priv->ext_cap_0c)) {
 		if (synaptics_send_cmd(psmouse, SYN_QUE_EXT_DIMENSIONS, max)) {
-			printk(KERN_ERR "Synaptics claims to have dimensions query,"
+			pr_err("Synaptics claims to have dimensions query,"
 			       " but I'm not able to read it.\n");
 		} else {
 			priv->x_max = (max[0] << 5) | ((max[1] & 0x0f) << 1);
@@ -327,7 +329,7 @@ static void synaptics_pt_activate(struct psmouse *psmouse)
 			priv->mode &= ~SYN_BIT_FOUR_BYTE_CLIENT;
 
 		if (synaptics_mode_cmd(psmouse, priv->mode))
-			printk(KERN_INFO "synaptics: failed to switch guest protocol\n");
+			pr_info("failed to switch guest protocol\n");
 	}
 }
 
@@ -337,7 +339,7 @@ static void synaptics_pt_create(struct psmouse *psmouse)
 
 	serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
 	if (!serio) {
-		printk(KERN_ERR "synaptics: not enough memory to allocate pass-through port\n");
+		pr_err("not enough memory to allocate pass-through port\n");
 		return;
 	}
 
@@ -349,7 +351,7 @@ static void synaptics_pt_create(struct psmouse *psmouse)
 
 	psmouse->pt_activate = synaptics_pt_activate;
 
-	printk(KERN_INFO "serio: %s port at %s\n", serio->name, psmouse->phys);
+	pr_info("%s port at %s\n", serio->name, psmouse->phys);
 	serio_register_port(serio);
 }
 
@@ -552,7 +554,7 @@ static int synaptics_validate_byte(unsigned char packet[], int idx, unsigned cha
 		return (packet[idx] & oldabs_mask[idx]) == oldabs_rslt[idx];
 
 	default:
-		printk(KERN_ERR "synaptics: unknown packet type %d\n", pkt_type);
+		pr_err("unknown packet type %d\n", pkt_type);
 		return 0;
 	}
 }
@@ -563,7 +565,7 @@ static unsigned char synaptics_detect_pkt_type(struct psmouse *psmouse)
 
 	for (i = 0; i < 5; i++)
 		if (!synaptics_validate_byte(psmouse->packet, i, SYN_NEWABS_STRICT)) {
-			printk(KERN_INFO "synaptics: using relaxed packet validation\n");
+			pr_info("using relaxed packet validation\n");
 			return SYN_NEWABS_RELAXED;
 		}
 
@@ -663,7 +665,7 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 		return -1;
 
 	if (synaptics_query_hardware(psmouse)) {
-		printk(KERN_ERR "Unable to query Synaptics hardware.\n");
+		pr_err("Unable to query Synaptics hardware\n");
 		return -1;
 	}
 
@@ -674,7 +676,7 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 		return -1;
 
 	if (synaptics_set_absolute_mode(psmouse)) {
-		printk(KERN_ERR "Unable to initialize Synaptics hardware.\n");
+		pr_err("Unable to initialize Synaptics hardware\n");
 		return -1;
 	}
 
@@ -736,18 +738,18 @@ int synaptics_init(struct psmouse *psmouse)
 	psmouse_reset(psmouse);
 
 	if (synaptics_query_hardware(psmouse)) {
-		printk(KERN_ERR "Unable to query Synaptics hardware.\n");
+		pr_err("Unable to query Synaptics hardware\n");
 		goto init_fail;
 	}
 
 	if (synaptics_set_absolute_mode(psmouse)) {
-		printk(KERN_ERR "Unable to initialize Synaptics hardware.\n");
+		pr_err("Unable to initialize Synaptics hardware\n");
 		goto init_fail;
 	}
 
 	priv->pkt_type = SYN_MODEL_NEWABS(priv->model_id) ? SYN_NEWABS : SYN_OLDABS;
 
-	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
+	pr_info("Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
 		SYN_ID_MODEL(priv->identity),
 		SYN_ID_MAJOR(priv->identity), SYN_ID_MINOR(priv->identity),
 		priv->model_id, priv->capabilities, priv->ext_cap, priv->ext_cap_0c);
@@ -782,7 +784,7 @@ int synaptics_init(struct psmouse *psmouse)
 	 * thye same as rate of standard PS/2 mouse.
 	 */
 	if (psmouse->rate >= 80 && impaired_toshiba_kbc) {
-		printk(KERN_INFO "synaptics: Toshiba %s detected, limiting rate to 40pps.\n",
+		pr_info("Toshiba %s detected, limiting rate to 40pps\n",
 			dmi_get_system_info(DMI_PRODUCT_NAME));
 		psmouse->rate = 40;
 	}
diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index 0643e49..317dccd 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -8,6 +8,8 @@
  * Trademarks are the property of their respective owners.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/serio.h>
@@ -297,7 +299,7 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 		return 0;
 
 	if (trackpoint_read(&psmouse->ps2dev, TP_EXT_BTN, &button_info)) {
-		printk(KERN_WARNING "trackpoint.c: failed to get extended button data\n");
+		pr_warning("failed to get extended button data\n");
 		button_info = 0;
 	}
 
@@ -319,15 +321,13 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 
 	error = sysfs_create_group(&ps2dev->serio->dev.kobj, &trackpoint_attr_group);
 	if (error) {
-		printk(KERN_ERR
-			"trackpoint.c: failed to create sysfs attributes, error: %d\n",
-			error);
+		pr_err("failed to create sysfs attributes, error: %d\n", error);
 		kfree(psmouse->private);
 		psmouse->private = NULL;
 		return -1;
 	}
 
-	printk(KERN_INFO "IBM TrackPoint firmware: 0x%02x, buttons: %d/%d\n",
+	pr_info("IBM TrackPoint firmware: 0x%02x, buttons: %d/%d\n",
 		firmware_id, (button_info & 0xf0) >> 4, button_info & 0x0f);
 
 	return 0;
diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
index bf2c0c8..7af4bc6 100644
--- a/drivers/input/mouse/vsxxxaa.c
+++ b/drivers/input/mouse/vsxxxaa.c
@@ -76,6 +76,8 @@
  * http://www.vt100.net/manx/details?pn=EK-104AA-TM-001;id=21;cp=1
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -92,9 +94,9 @@ MODULE_LICENSE("GPL");
 
 #undef VSXXXAA_DEBUG
 #ifdef VSXXXAA_DEBUG
-#define DBG(x...) printk(x)
+#define DBG(format, arg...) pr_info(format, ##arg)
 #else
-#define DBG(x...) do {} while (0)
+#define DBG(format, arg...) do { if (0) pr_info(format, ##arg); } while (0)
 #endif
 
 #define VSXXXAA_INTRO_MASK	0x80
@@ -137,12 +139,12 @@ static void vsxxxaa_drop_bytes(struct vsxxxaa *mouse, int num)
 static void vsxxxaa_queue_byte(struct vsxxxaa *mouse, unsigned char byte)
 {
 	if (mouse->count == BUFLEN) {
-		printk(KERN_ERR "%s on %s: Dropping a byte of full buffer.\n",
-			mouse->name, mouse->phys);
+		pr_err("%s on %s: Dropping a byte of full buffer\n",
+		       mouse->name, mouse->phys);
 		vsxxxaa_drop_bytes(mouse, 1);
 	}
 
-	DBG(KERN_INFO "Queueing byte 0x%02x\n", byte);
+	DBG("Queueing byte 0x%02x\n", byte);
 
 	mouse->buf[mouse->count++] = byte;
 }
@@ -167,8 +169,7 @@ static void vsxxxaa_detection_done(struct vsxxxaa *mouse)
 		break;
 	}
 
-	printk(KERN_INFO
-		"Found %s version 0x%02x from country 0x%02x on port %s\n",
+	pr_info("Found %s version 0x%02x from country 0x%02x on port %s\n",
 		mouse->name, mouse->version, mouse->country, mouse->phys);
 }
 
@@ -188,10 +189,9 @@ static int vsxxxaa_check_packet(struct vsxxxaa *mouse, int packet_len)
 	/* Check all following bytes */
 	for (i = 1; i < packet_len; i++) {
 		if (IS_HDR_BYTE(mouse->buf[i])) {
-			printk(KERN_ERR
-				"Need to drop %d bytes of a broken packet.\n",
-				i - 1);
-			DBG(KERN_INFO "check: len=%d, b[%d]=0x%02x\n",
+			pr_err("Need to drop %d bytes of a broken packet\n",
+			       i - 1);
+			DBG("check: len=%d, b[%d]=0x%02x\n",
 			    packet_len, i, mouse->buf[i]);
 			return i - 1;
 		}
@@ -246,7 +246,7 @@ static void vsxxxaa_handle_REL_packet(struct vsxxxaa *mouse)
 
 	vsxxxaa_drop_bytes(mouse, 3);
 
-	DBG(KERN_INFO "%s on %s: dx=%d, dy=%d, buttons=%s%s%s\n",
+	DBG("%s on %s: dx=%d, dy=%d, buttons=%s%s%s\n",
 	    mouse->name, mouse->phys, dx, dy,
 	    left ? "L" : "l", middle ? "M" : "m", right ? "R" : "r");
 
@@ -297,7 +297,7 @@ static void vsxxxaa_handle_ABS_packet(struct vsxxxaa *mouse)
 
 	vsxxxaa_drop_bytes(mouse, 5);
 
-	DBG(KERN_INFO "%s on %s: x=%d, y=%d, buttons=%s%s%s%s\n",
+	DBG("%s on %s: x=%d, y=%d, buttons=%s%s%s%s\n",
 	    mouse->name, mouse->phys, x, y,
 	    left ? "L" : "l", middle ? "M" : "m",
 	    right ? "R" : "r", touch ? "T" : "t");
@@ -365,7 +365,7 @@ static void vsxxxaa_handle_POR_packet(struct vsxxxaa *mouse)
 		input_sync(dev);
 
 		if (error != 0)
-			printk(KERN_INFO "Your %s on %s reports error=0x%02x\n",
+			pr_info("Your %s on %s reports error=0x%02x\n",
 				mouse->name, mouse->phys, error);
 
 	}
@@ -374,10 +374,9 @@ static void vsxxxaa_handle_POR_packet(struct vsxxxaa *mouse)
 	 * If the mouse was hot-plugged, we need to force differential mode
 	 * now... However, give it a second to recover from it's reset.
 	 */
-	printk(KERN_NOTICE
-		"%s on %s: Forcing standard packet format, "
-		"incremental streaming mode and 72 samples/sec\n",
-		mouse->name, mouse->phys);
+	pr_notice("%s on %s: Forcing standard packet format, "
+		  "incremental streaming mode and 72 samples/sec\n",
+		  mouse->name, mouse->phys);
 	serio_write(mouse->serio, 'S');	/* Standard format */
 	mdelay(50);
 	serio_write(mouse->serio, 'R');	/* Incremental */
@@ -402,9 +401,9 @@ static void vsxxxaa_parse_buffer(struct vsxxxaa *mouse)
 		 * activity on the mouse.
 		 */
 		while (mouse->count > 0 && !IS_HDR_BYTE(buf[0])) {
-			printk(KERN_ERR "%s on %s: Dropping a byte to regain "
-				"sync with mouse data stream...\n",
-				mouse->name, mouse->phys);
+			pr_err("%s on %s: Dropping a byte to regain "
+			       "sync with mouse data stream...\n",
+			       mouse->name, mouse->phys);
 			vsxxxaa_drop_bytes(mouse, 1);
 		}
 
@@ -437,8 +436,7 @@ static void vsxxxaa_parse_buffer(struct vsxxxaa *mouse)
 		}
 
 		if (stray_bytes > 0) {
-			printk(KERN_ERR "Dropping %d bytes now...\n",
-				stray_bytes);
+			pr_err("Dropping %d bytes now...\n", stray_bytes);
 			vsxxxaa_drop_bytes(mouse, stray_bytes);
 		}
 
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index d8f68f7..dcd4c64 100644
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
@@ -968,7 +970,7 @@ static int mousedev_connect(struct input_handler *handler,
 			break;
 
 	if (minor == MOUSEDEV_MINORS) {
-		printk(KERN_ERR "mousedev: no more free mousedev devices\n");
+		pr_err("no more free mousedev devices\n");
 		return -ENFILE;
 	}
 
@@ -1078,13 +1080,13 @@ static int __init mousedev_init(void)
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
diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakmi.c
index 92563a6..ce02f59 100644
--- a/drivers/input/serio/ambakmi.c
+++ b/drivers/input/serio/ambakmi.c
@@ -9,6 +9,9 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/serio.h>
@@ -82,7 +85,7 @@ static int amba_kmi_open(struct serio *io)
 
 	ret = request_irq(kmi->irq, amba_kmi_int, 0, "kmi-pl050", kmi);
 	if (ret) {
-		printk(KERN_ERR "kmi: failed to claim IRQ%d\n", kmi->irq);
+		pr_err("failed to claim IRQ%d\n", kmi->irq);
 		writeb(0, KMICR);
 		goto clk_disable;
 	}
diff --git a/drivers/input/serio/ct82c710.c b/drivers/input/serio/ct82c710.c
index 4a30846..3c5de1d 100644
--- a/drivers/input/serio/ct82c710.c
+++ b/drivers/input/serio/ct82c710.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
@@ -98,12 +100,12 @@ static int ct82c170_wait(void)
 static void ct82c710_close(struct serio *serio)
 {
 	if (ct82c170_wait())
-		printk(KERN_WARNING "ct82c710.c: Device busy in close()\n");
+		pr_warning("Device busy in close()\n");
 
 	outb_p(inb_p(CT82C710_STATUS) & ~(CT82C710_ENABLE | CT82C710_INTS_ON), CT82C710_STATUS);
 
 	if (ct82c170_wait())
-		printk(KERN_WARNING "ct82c710.c: Device busy in close()\n");
+		pr_warning("Device busy in close()\n");
 
 	free_irq(CT82C710_IRQ, NULL);
 }
@@ -127,7 +129,7 @@ static int ct82c710_open(struct serio *serio)
 	outb_p(status, CT82C710_STATUS);	/* Enable interrupts */
 
 	while (ct82c170_wait()) {
-		printk(KERN_ERR "ct82c710: Device busy in open()\n");
+		pr_err("Device busy in open()\n");
 		status &= ~(CT82C710_ENABLE | CT82C710_INTS_ON);
 		outb_p(status, CT82C710_STATUS);
 		free_irq(CT82C710_IRQ, NULL);
@@ -239,7 +241,7 @@ static int __init ct82c710_init(void)
 
 	serio_register_port(ct82c710_port);
 
-	printk(KERN_INFO "serio: C&T 82c710 mouse port at %#llx irq %d\n",
+	pr_info("C&T 82c710 mouse port at %#llx irq %d\n",
 		(unsigned long long)CT82C710_DATA, CT82C710_IRQ);
 
 	return 0;
diff --git a/drivers/input/serio/gscps2.c b/drivers/input/serio/gscps2.c
index 3c287dd..31c41b0 100644
--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -22,6 +22,8 @@
  *                 was usable/enabled ?)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -42,8 +44,6 @@ MODULE_DESCRIPTION("HP GSC PS2 port driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(parisc, gscps2_device_tbl);
 
-#define PFX "gscps2.c: "
-
 /*
  * Driver constants
  */
@@ -151,7 +151,8 @@ static inline int gscps2_writeb_output(struct gscps2port *ps2port, u8 data)
 	char *addr = ps2port->addr;
 
 	if (!wait_TBE(addr)) {
-		printk(KERN_DEBUG PFX "timeout - could not write byte %#x\n", data);
+		printk(KERN_DEBUG pr_fmt("timeout - could not write byte %#x\n"),
+		       data);
 		return 0;
 	}
 
@@ -287,7 +288,7 @@ static int gscps2_write(struct serio *port, unsigned char data)
 	struct gscps2port *ps2port = port->port_data;
 
 	if (!gscps2_writeb_output(ps2port, data)) {
-		printk(KERN_DEBUG PFX "sending byte %#x failed.\n", data);
+		printk(KERN_DEBUG pr_fmt("sending byte %#x failed\n"), data);
 		return -1;
 	}
 	return 0;
@@ -373,8 +374,8 @@ static int __devinit gscps2_probe(struct parisc_device *dev)
 		goto fail_miserably;
 
 	if (ps2port->id != GSC_ID_KEYBOARD && ps2port->id != GSC_ID_MOUSE) {
-		printk(KERN_WARNING PFX "Unsupported PS/2 port at 0x%08lx (id=%d) ignored\n",
-				hpa, ps2port->id);
+		pr_warning("Unsupported PS/2 port at 0x%08lx (id=%d) ignored\n",
+			   hpa, ps2port->id);
 		ret = -ENODEV;
 		goto fail;
 	}
@@ -384,7 +385,7 @@ static int __devinit gscps2_probe(struct parisc_device *dev)
 		goto fail;
 #endif
 
-	printk(KERN_INFO "serio: %s port at 0x%p irq %d @ %s\n",
+	pr_info("%s port at 0x%p irq %d @ %s\n",
 		ps2port->port->name,
 		ps2port->addr,
 		ps2port->padev->irq,
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index c92f4ed..f0e810e 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -52,6 +52,8 @@
  *	and to initiate probes of the loop for new devices.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/hil_mlc.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -69,8 +71,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 EXPORT_SYMBOL(hil_mlc_register);
 EXPORT_SYMBOL(hil_mlc_unregister);
 
-#define PREFIX "HIL MLC: "
-
 static LIST_HEAD(hil_mlcs);
 static DEFINE_RWLOCK(hil_mlcs_lock);
 static struct timer_list	hil_mlcs_kicker;
@@ -248,7 +248,7 @@ static int hilse_match(hil_mlc *mlc, int unused)
 			goto err;
 
 #ifdef HIL_MLC_DEBUG
-		printk(KERN_DEBUG PREFIX "new in slot %i\n", rc);
+		printk(KERN_DEBUG pr_fmt("new in slot %i\n"), rc);
 #endif
 		hil_mlc_copy_di_scratch(mlc, rc);
 		mlc->di_map[mlc->ddi] = rc;
@@ -260,14 +260,14 @@ static int hilse_match(hil_mlc *mlc, int unused)
 
 	mlc->di_map[mlc->ddi] = rc;
 #ifdef HIL_MLC_DEBUG
-	printk(KERN_DEBUG PREFIX "same in slot %i\n", rc);
+	printk(KERN_DEBUG pr_fmt("same in slot %i\n"), rc);
 #endif
 	mlc->serio_map[rc].di_revmap = mlc->ddi;
 	hil_mlc_clean_serio_map(mlc);
 	return 0;
 
  err:
-	printk(KERN_ERR PREFIX "Residual device slots exhausted, close some serios!\n");
+	pr_err("Residual device slots exhausted, close some serios!\n");
 	return 1;
 }
 
@@ -419,8 +419,7 @@ static int hilse_take_rnm(hil_mlc *mlc, int unused)
 		mlc->di_scratch.rnm[i] =
 			mlc->ipacket[i] & HIL_PKT_DATA_MASK;
 
-	printk(KERN_INFO PREFIX "Device name gotten: %16s\n",
-			mlc->di_scratch.rnm);
+	pr_info("Device name gotten: %16s\n", mlc->di_scratch.rnm);
 
 	return 0;
 }
@@ -626,7 +625,7 @@ static int hilse_donode(hil_mlc *mlc)
 #ifdef HIL_MLC_DEBUG
 	if (mlc->seidx && mlc->seidx != seidx &&
 	    mlc->seidx != 41 && mlc->seidx != 42 && mlc->seidx != 43) {
-		printk(KERN_DEBUG PREFIX "z%i \n {%i}", doze, mlc->seidx);
+		printk(KERN_DEBUG pr_fmt("z%i\n {%i}\n"), doze, mlc->seidx);
 		doze = 0;
 	}
 
@@ -776,7 +775,7 @@ static void hil_mlcs_process(unsigned long unused)
 			if (mlc->seidx != 41 &&
 			    mlc->seidx != 42 &&
 			    mlc->seidx != 43)
-				printk(KERN_DEBUG PREFIX " + ");
+				printk(KERN_DEBUG pr_fmt(" + "));
 #endif
 		}
 	}
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index bcc2d30..e1affca 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -61,6 +61,8 @@
  * sure it doesn't freeze up and to allow for bad reads to time out.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/hp_sdc.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -87,8 +89,6 @@
 # error "HIL is not supported on this platform"
 #endif
 
-#define PREFIX "HP SDC: "
-
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
 MODULE_DESCRIPTION("HP i8042-based SDC Driver");
 MODULE_LICENSE("Dual BSD/GPL");
@@ -259,7 +259,7 @@ static irqreturn_t hp_sdc_isr(int irq, void *dev_id)
 		if (hp_sdc.pup != NULL)
 			hp_sdc.pup(irq, dev_id, status, data);
 		else
-			printk(KERN_INFO PREFIX "HP SDC reports successful PUP.\n");
+			pr_info("HP SDC reports successful PUP.\n");
 		read_unlock(&hp_sdc.hook_lock);
 		break;
 
@@ -280,7 +280,7 @@ static irqreturn_t hp_sdc_nmisr(int irq, void *dev_id)
 	int status;
 
 	status = hp_sdc_status_in8();
-	printk(KERN_WARNING PREFIX "NMI !\n");
+	pr_warning("NMI !\n");
 
 #if 0
 	if (status & HP_SDC_NMISTATUS_FHS) {
@@ -290,7 +290,7 @@ static irqreturn_t hp_sdc_nmisr(int irq, void *dev_id)
 		read_unlock(&hp_sdc.hook_lock);
 	} else {
 		/* TODO: pass this on to the HIL handler, or do SAK here? */
-		printk(KERN_WARNING PREFIX "HIL NMI\n");
+		pr_warning("HIL NMI\n");
 	}
 #endif
 
@@ -322,8 +322,8 @@ static void hp_sdc_tasklet(unsigned long foo)
 			 * we'll need to figure out a way to communicate
 			 * it back to the application. and be less verbose.
 			 */
-			printk(KERN_WARNING PREFIX "read timeout (%ius)!\n",
-			       (int)(tv.tv_usec - hp_sdc.rtv.tv_usec));
+			pr_warning("read timeout (%ius)!\n",
+				   (int)(tv.tv_usec - hp_sdc.rtv.tv_usec));
 			curr->idx += hp_sdc.rqty;
 			hp_sdc.rqty = 0;
 			tmp = curr->seq[curr->actidx];
@@ -624,11 +624,11 @@ int __hp_sdc_enqueue_transaction(hp_sdc_transaction *this)
 			return 0;
 		}
 
-	printk(KERN_WARNING PREFIX "No free slot to add transaction.\n");
+	pr_warning("No free slot to add transaction.\n");
 	return -EBUSY;
 
  fail:
-	printk(KERN_WARNING PREFIX "Transaction add failed: transaction already queued?\n");
+	pr_warning("Transaction add failed: transaction already queued?\n");
 	return -EINVAL;
 }
 
@@ -888,8 +888,8 @@ static int __init hp_sdc_init(void)
 			"HP SDC NMI", &hp_sdc))
 		goto err2;
 
-	printk(KERN_INFO PREFIX "HP SDC at 0x%p, IRQ %d (NMI IRQ %d)\n",
-	       (void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
+	pr_info("HP SDC at 0x%p, IRQ %d (NMI IRQ %d)\n",
+		(void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
 
 	hp_sdc_status_in8();
 	hp_sdc_data_in8();
@@ -922,8 +922,8 @@ static int __init hp_sdc_init(void)
  err1:
 	release_region(hp_sdc.data_io, 2);
  err0:
-	printk(KERN_WARNING PREFIX ": %s SDC IO=0x%p IRQ=0x%x NMI=0x%x\n",
-		errstr, (void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
+	pr_warning("%s SDC IO=0x%p IRQ=0x%x NMI=0x%x\n",
+		   errstr, (void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
 	hp_sdc.dev = NULL;
 
 	return hp_sdc.dev_err;
@@ -992,7 +992,7 @@ static void hp_sdc_exit(void)
 #if defined(__hppa__)
 	cancel_delayed_work_sync(&moduleloader_work);
 	if (unregister_parisc_driver(&hp_sdc_driver))
-		printk(KERN_WARNING PREFIX "Error unregistering HP SDC");
+		pr_warning("Error unregistering HP SDC");
 #endif
 }
 
@@ -1007,7 +1007,7 @@ static int __init hp_sdc_register(void)
 #endif
 
 	if (hp_sdc_disabled) {
-		printk(KERN_WARNING PREFIX "HP SDC driver disabled by no_hpsdc=1.\n");
+		pr_warning("HP SDC driver disabled by no_hpsdc=1\n");
 		return -ENODEV;
 	}
 
@@ -1015,7 +1015,7 @@ static int __init hp_sdc_register(void)
 	hp_sdc.dev_err = 0;
 #if defined(__hppa__)
 	if (register_parisc_driver(&hp_sdc_driver)) {
-		printk(KERN_WARNING PREFIX "Error registering SDC with system bus tree.\n");
+		pr_warning("Error registering SDC with system bus tree\n");
 		return -ENODEV;
 	}
 #elif defined(__mc68000__)
@@ -1035,7 +1035,7 @@ static int __init hp_sdc_register(void)
 	hp_sdc.dev_err   = hp_sdc_init();
 #endif
 	if (hp_sdc.dev == NULL) {
-		printk(KERN_WARNING PREFIX "No SDC found.\n");
+		pr_warning("No SDC found\n");
 		return hp_sdc.dev_err;
 	}
 
@@ -1060,14 +1060,14 @@ static int __init hp_sdc_register(void)
 	up(&tq_init_sem);
 
 	if ((tq_init_seq[0] & HP_SDC_ACT_DEAD) == HP_SDC_ACT_DEAD) {
-		printk(KERN_WARNING PREFIX "Error reading config byte.\n");
+		pr_warning("Error reading config byte\n");
 		hp_sdc_exit();
 		return -ENODEV;
 	}
 	hp_sdc.r11 = tq_init_seq[4];
 	if (hp_sdc.r11 & HP_SDC_CFG_NEW) {
 		const char *str;
-		printk(KERN_INFO PREFIX "New style SDC\n");
+		pr_info("New style SDC\n");
 		tq_init_seq[1] = HP_SDC_CMD_READ_XTD;
 		tq_init.actidx		= 0;
 		tq_init.idx		= 1;
@@ -1076,18 +1076,17 @@ static int __init hp_sdc_register(void)
 		down(&tq_init_sem);
 		up(&tq_init_sem);
 		if ((tq_init_seq[0] & HP_SDC_ACT_DEAD) == HP_SDC_ACT_DEAD) {
-			printk(KERN_WARNING PREFIX "Error reading extended config byte.\n");
+			pr_warning("Error reading extended config byte\n");
 			return -ENODEV;
 		}
 		hp_sdc.r7e = tq_init_seq[4];
 		HP_SDC_XTD_REV_STRINGS(hp_sdc.r7e & HP_SDC_XTD_REV, str)
-		printk(KERN_INFO PREFIX "Revision: %s\n", str);
+		pr_info("Revision: %s\n", str);
 		if (hp_sdc.r7e & HP_SDC_XTD_BEEPER)
-			printk(KERN_INFO PREFIX "TI SN76494 beeper present\n");
+			pr_info("TI SN76494 beeper present\n");
 		if (hp_sdc.r7e & HP_SDC_XTD_BBRTC)
-			printk(KERN_INFO PREFIX "OKI MSM-58321 BBRTC present\n");
-		printk(KERN_INFO PREFIX "Spunking the self test register to force PUP "
-		       "on next firmware reset.\n");
+			pr_info("OKI MSM-58321 BBRTC present\n");
+		pr_info("Spunking the self test register to force PUP on next firmware reset\n");
 		tq_init_seq[0] = HP_SDC_ACT_PRECMD |
 			HP_SDC_ACT_DATAOUT | HP_SDC_ACT_SEMAPHORE;
 		tq_init_seq[1] = HP_SDC_CMD_SET_STR;
@@ -1101,8 +1100,8 @@ static int __init hp_sdc_register(void)
 		down(&tq_init_sem);
 		up(&tq_init_sem);
 	} else
-		printk(KERN_INFO PREFIX "Old style SDC (1820-%s).\n",
-		       (hp_sdc.r11 & HP_SDC_CFG_REV) ? "3300" : "2564/3087");
+		pr_info("Old style SDC (1820-%s)\n",
+			(hp_sdc.r11 & HP_SDC_CFG_REV) ? "3300" : "2564/3087");
 
         return 0;
 }
diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
index 7d2b820..09477f5 100644
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -33,6 +33,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/hil_mlc.h>
 #include <linux/hp_sdc.h>
 #include <linux/errno.h>
@@ -42,8 +44,6 @@
 #include <linux/string.h>
 #include <linux/semaphore.h>
 
-#define PREFIX "HP SDC MLC: "
-
 static hil_mlc hp_sdc_mlc;
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
@@ -66,7 +66,7 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 
 	write_lock(&mlc->lock);
 	if (mlc->icount < 0) {
-		printk(KERN_WARNING PREFIX "HIL Overflow!\n");
+		pr_warning("HIL Overflow!\n");
 		up(&mlc->isem);
 		goto out;
 	}
@@ -104,11 +104,11 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 	goto out;
 
  err:
-	printk(KERN_DEBUG PREFIX "err code %x\n", data);
+	printk(KERN_DEBUG pr_fmt("err code %x\n"), data);
 
 	switch (data) {
 	case HP_SDC_HIL_RC_DONE:
-		printk(KERN_WARNING PREFIX "Bastard SDC reconfigured loop!\n");
+		pr_warning("Bastard SDC reconfigured loop!\n");
 		break;
 
 	case HP_SDC_HIL_ERR:
@@ -121,11 +121,11 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 		break;
 
 	case HP_SDC_HIL_RC:
-		printk(KERN_WARNING PREFIX "Bastard SDC decided to reconfigure loop!\n");
+		pr_warning("Bastard SDC decided to reconfigure loop!\n");
 		break;
 
 	default:
-		printk(KERN_WARNING PREFIX "Unknown HIL Error status (%x)!\n", data);
+		pr_warning("Unknown HIL Error status (%x)!\n", data);
 		break;
 	}
 
@@ -157,16 +157,19 @@ static int hp_sdc_mlc_in(hil_mlc *mlc, suseconds_t timeout)
 						HIL_PKT_ADDR_MASK |
 						HIL_PKT_DATA_MASK));
 			mlc->icount = 14;
-			/* printk(KERN_DEBUG PREFIX ">[%x]\n", mlc->ipacket[0]); */
+			/*
+			printk(KERN_DEBUG pr_fmt(">[%x]\n"), mlc->ipacket[0]);
+			*/
 			goto wasup;
 		}
 		do_gettimeofday(&tv);
 		tv.tv_usec += USEC_PER_SEC * (tv.tv_sec - mlc->instart.tv_sec);
 		if (tv.tv_usec - mlc->instart.tv_usec > mlc->intimeout) {
-			/*	printk("!%i %i",
-				tv.tv_usec - mlc->instart.tv_usec,
-				mlc->intimeout);
-			 */
+			/*
+			printk(KERN_DEBUG pr_fmt("!%i %i\n"),
+			       tv.tv_usec - mlc->instart.tv_usec,
+			       mlc->intimeout);
+			*/
 			rc = 1;
 			up(&mlc->isem);
 		}
@@ -311,7 +314,7 @@ static int __init hp_sdc_mlc_init(void)
 		return -ENODEV;
 #endif
 
-	printk(KERN_INFO PREFIX "Registering the System Domain Controller's HIL MLC.\n");
+	pr_info("Registering the System Domain Controller's HIL MLC\n");
 
 	hp_sdc_mlc_priv.emtestmode = 0;
 	hp_sdc_mlc_priv.trans.seq = hp_sdc_mlc_priv.tseq;
@@ -324,19 +327,19 @@ static int __init hp_sdc_mlc_init(void)
 	mlc->priv = &hp_sdc_mlc_priv;
 
 	if (hil_mlc_register(mlc)) {
-		printk(KERN_WARNING PREFIX "Failed to register MLC structure with hil_mlc\n");
+		pr_warning("Failed to register MLC structure with hil_mlc\n");
 		goto err0;
 	}
 
 	if (hp_sdc_request_hil_irq(&hp_sdc_mlc_isr)) {
-		printk(KERN_WARNING PREFIX "Request for raw HIL ISR hook denied\n");
+		pr_warning("Request for raw HIL ISR hook denied\n");
 		goto err1;
 	}
 	return 0;
  err1:
 	if (hil_mlc_unregister(mlc))
-		printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
-			"This is bad.  Could cause an oops.\n");
+		pr_err("Failed to unregister MLC structure with hil_mlc\n"
+		       "This is bad.  Could cause an oops\n");
  err0:
 	return -EBUSY;
 }
@@ -346,12 +349,12 @@ static void __exit hp_sdc_mlc_exit(void)
 	hil_mlc *mlc = &hp_sdc_mlc;
 
 	if (hp_sdc_release_hil_irq(&hp_sdc_mlc_isr))
-		printk(KERN_ERR PREFIX "Failed to release the raw HIL ISR hook.\n"
-			"This is bad.  Could cause an oops.\n");
+		pr_err("Failed to release the raw HIL ISR hook.\n"
+		       "This is bad.  Could cause an oops\n");
 
 	if (hil_mlc_unregister(mlc))
-		printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
-			"This is bad.  Could cause an oops.\n");
+		pr_err("Failed to unregister MLC structure with hil_mlc.\n"
+		       "This is bad.  Could cause an oops.\n");
 }
 
 module_init(hp_sdc_mlc_init);
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index ed7ad74..96903ab 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -741,7 +741,7 @@ static int __init i8042_pnp_init(void)
 #endif
 
 	if (i8042_nopnp) {
-		printk(KERN_INFO "i8042: PNP detection disabled\n");
+		pr_info("PNP detection disabled\n");
 		return 0;
 	}
 
@@ -758,7 +758,7 @@ static int __init i8042_pnp_init(void)
 #if defined(__ia64__)
 		return -ENODEV;
 #else
-		printk(KERN_INFO "PNP: No PS/2 controller found. Probing ports directly.\n");
+		pr_info("No PS/2 controller found. Probing ports directly.\n");
 		return 0;
 #endif
 	}
@@ -770,11 +770,13 @@ static int __init i8042_pnp_init(void)
 		snprintf(aux_irq_str, sizeof(aux_irq_str),
 			"%d", i8042_pnp_aux_irq);
 
-	printk(KERN_INFO "PNP: PS/2 Controller [%s%s%s] at %#x,%#x irq %s%s%s\n",
-		i8042_pnp_kbd_name, (i8042_pnp_kbd_devices && i8042_pnp_aux_devices) ? "," : "",
+	pr_info("PS/2 Controller [%s%s%s] at %#x,%#x irq %s%s%s\n",
+		i8042_pnp_kbd_name,
+		(i8042_pnp_kbd_devices && i8042_pnp_aux_devices) ? "," : "",
 		i8042_pnp_aux_name,
 		i8042_pnp_data_reg, i8042_pnp_command_reg,
-		kbd_irq_str, (i8042_pnp_kbd_devices && i8042_pnp_aux_devices) ? "," : "",
+		kbd_irq_str,
+		(i8042_pnp_kbd_devices && i8042_pnp_aux_devices) ? "," : "",
 		aux_irq_str);
 
 #if defined(__ia64__)
@@ -787,10 +789,9 @@ static int __init i8042_pnp_init(void)
 	if (((i8042_pnp_data_reg & ~0xf) == (i8042_data_reg & ~0xf) &&
 	      i8042_pnp_data_reg != i8042_data_reg) ||
 	    !i8042_pnp_data_reg) {
-		printk(KERN_WARNING
-			"PNP: PS/2 controller has invalid data port %#x; "
-			"using default %#x\n",
-			i8042_pnp_data_reg, i8042_data_reg);
+		pr_warning("PS/2 controller has invalid data port %#x; "
+			   "using default %#x\n",
+			   i8042_pnp_data_reg, i8042_data_reg);
 		i8042_pnp_data_reg = i8042_data_reg;
 		pnp_data_busted = true;
 	}
@@ -798,33 +799,29 @@ static int __init i8042_pnp_init(void)
 	if (((i8042_pnp_command_reg & ~0xf) == (i8042_command_reg & ~0xf) &&
 	      i8042_pnp_command_reg != i8042_command_reg) ||
 	    !i8042_pnp_command_reg) {
-		printk(KERN_WARNING
-			"PNP: PS/2 controller has invalid command port %#x; "
-			"using default %#x\n",
-			i8042_pnp_command_reg, i8042_command_reg);
+		pr_warning("PS/2 controller has invalid command port %#x; "
+			   "using default %#x\n",
+			   i8042_pnp_command_reg, i8042_command_reg);
 		i8042_pnp_command_reg = i8042_command_reg;
 		pnp_data_busted = true;
 	}
 
 	if (!i8042_nokbd && !i8042_pnp_kbd_irq) {
-		printk(KERN_WARNING
-			"PNP: PS/2 controller doesn't have KBD irq; "
-			"using default %d\n", i8042_kbd_irq);
+		pr_warning("PS/2 controller doesn't have KBD irq; "
+			   "using default %d\n", i8042_kbd_irq);
 		i8042_pnp_kbd_irq = i8042_kbd_irq;
 		pnp_data_busted = true;
 	}
 
 	if (!i8042_noaux && !i8042_pnp_aux_irq) {
 		if (!pnp_data_busted && i8042_pnp_kbd_irq) {
-			printk(KERN_WARNING
-				"PNP: PS/2 appears to have AUX port disabled, "
-				"if this is incorrect please boot with "
-				"i8042.nopnp\n");
+			pr_warning("PS/2 appears to have AUX port disabled, "
+				   "if this is incorrect please boot with "
+				   "i8042.nopnp\n");
 			i8042_noaux = true;
 		} else {
-			printk(KERN_WARNING
-				"PNP: PS/2 controller doesn't have AUX irq; "
-				"using default %d\n", i8042_aux_irq);
+			pr_warning("PS/2 controller doesn't have AUX irq; "
+				   "using default %d\n", i8042_aux_irq);
 			i8042_pnp_aux_irq = i8042_aux_irq;
 		}
 	}
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 258b98b..ae4bc8b 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -10,6 +10,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/module.h>
@@ -359,17 +361,15 @@ static void i8042_port_close(struct serio *serio)
 
 	i8042_ctr &= ~irq_bit;
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_WARNING
-			"i8042.c: Can't write CTR while closing %s port.\n",
-			port_name);
+		pr_warning("Can't write CTR while closing %s port\n",
+			   port_name);
 
 	udelay(50);
 
 	i8042_ctr &= ~disable_bit;
 	i8042_ctr |= irq_bit;
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_ERR "i8042.c: Can't reactivate %s port.\n",
-			port_name);
+		pr_err("Can't reactivate %s port\n", port_name);
 
 	/*
 	 * See if there is any data appeared while we were messing with
@@ -544,7 +544,7 @@ static int i8042_enable_kbd_port(void)
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
 		i8042_ctr &= ~I8042_CTR_KBDINT;
 		i8042_ctr |= I8042_CTR_KBDDIS;
-		printk(KERN_ERR "i8042.c: Failed to enable KBD port.\n");
+		pr_err("Failed to enable KBD port\n");
 		return -EIO;
 	}
 
@@ -563,7 +563,7 @@ static int i8042_enable_aux_port(void)
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
 		i8042_ctr &= ~I8042_CTR_AUXINT;
 		i8042_ctr |= I8042_CTR_AUXDIS;
-		printk(KERN_ERR "i8042.c: Failed to enable AUX port.\n");
+		pr_err("Failed to enable AUX port\n");
 		return -EIO;
 	}
 
@@ -645,7 +645,7 @@ static int __init i8042_check_mux(void)
 	if (i8042_set_mux_mode(true, &mux_version))
 		return -1;
 
-	printk(KERN_INFO "i8042.c: Detected active multiplexing controller, rev %d.%d.\n",
+	pr_info("Detected active multiplexing controller, rev %d.%d\n",
 		(mux_version >> 4) & 0xf, mux_version & 0xf);
 
 /*
@@ -655,7 +655,7 @@ static int __init i8042_check_mux(void)
 	i8042_ctr &= ~I8042_CTR_AUXINT;
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_ERR "i8042.c: Failed to disable AUX port, can't use MUX.\n");
+		pr_err("Failed to disable AUX port, can't use MUX\n");
 		return -EIO;
 	}
 
@@ -774,8 +774,8 @@ static int __init i8042_check_aux(void)
  */
 
 	if (i8042_toggle_aux(false)) {
-		printk(KERN_WARNING "Failed to disable AUX port, but continuing anyway... Is this a SiS?\n");
-		printk(KERN_WARNING "If AUX port is really absent please use the 'i8042.noaux' option.\n");
+		pr_warning("Failed to disable AUX port, but continuing anyway... Is this a SiS?\n");
+		pr_warning("If AUX port is really absent please use the 'i8042.noaux' option\n");
 	}
 
 	if (i8042_toggle_aux(true))
@@ -849,7 +849,7 @@ static int __init i8042_check_aux(void)
 static int i8042_controller_check(void)
 {
 	if (i8042_flush() == I8042_BUFFER_SIZE) {
-		printk(KERN_ERR "i8042.c: No controller found.\n");
+		pr_err("No controller found\n");
 		return -ENODEV;
 	}
 
@@ -868,15 +868,15 @@ static int i8042_controller_selftest(void)
 	do {
 
 		if (i8042_command(&param, I8042_CMD_CTL_TEST)) {
-			printk(KERN_ERR "i8042.c: i8042 controller self test timeout.\n");
+			pr_err("i8042 controller self test timeout\n");
 			return -ENODEV;
 		}
 
 		if (param == I8042_RET_CTL_TEST)
 			return 0;
 
-		printk(KERN_ERR "i8042.c: i8042 controller selftest failed. (%#x != %#x)\n",
-			param, I8042_RET_CTL_TEST);
+		pr_err("i8042 controller selftest failed. (%#x != %#x)\n",
+		       param, I8042_RET_CTL_TEST);
 		msleep(50);
 	} while (i++ < 5);
 
@@ -887,8 +887,7 @@ static int i8042_controller_selftest(void)
 	 * and user will still get a working keyboard. This is especially
 	 * important on netbooks. On other arches we trust hardware more.
 	 */
-	printk(KERN_INFO
-		"i8042: giving up on controller selftest, continuing anyway...\n");
+	pr_info("giving up on controller selftest, continuing anyway...\n");
 	return 0;
 #else
 	return -EIO;
@@ -913,8 +912,7 @@ static int i8042_controller_init(void)
 
 	do {
 		if (n >= 10) {
-			printk(KERN_ERR
-				"i8042.c: Unable to get stable CTR read.\n");
+			pr_err("Unable to get stable CTR read\n");
 			return -EIO;
 		}
 
@@ -922,8 +920,7 @@ static int i8042_controller_init(void)
 			udelay(50);
 
 		if (i8042_command(&ctr[n++ % 2], I8042_CMD_CTL_RCTR)) {
-			printk(KERN_ERR
-				"i8042.c: Can't read CTR while initializing i8042.\n");
+			pr_err("Can't read CTR while initializing i8042\n");
 			return -EIO;
 		}
 
@@ -947,7 +944,7 @@ static int i8042_controller_init(void)
 		if (i8042_unlock)
 			i8042_ctr |= I8042_CTR_IGNKEYLOCK;
 		else
-			printk(KERN_WARNING "i8042.c: Warning: Keylock active.\n");
+			pr_warning("Warning: Keylock active\n");
 	}
 	spin_unlock_irqrestore(&i8042_lock, flags);
 
@@ -974,7 +971,7 @@ static int i8042_controller_init(void)
  */
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_ERR "i8042.c: Can't write CTR while initializing i8042.\n");
+		pr_err("Can't write CTR while initializing i8042\n");
 		return -EIO;
 	}
 
@@ -1004,7 +1001,7 @@ static void i8042_controller_reset(void)
 	i8042_ctr &= ~(I8042_CTR_KBDINT | I8042_CTR_AUXINT);
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_WARNING "i8042.c: Can't write CTR while resetting.\n");
+		pr_warning("Can't write CTR while resetting\n");
 
 /*
  * Disable MUX mode if present.
@@ -1025,7 +1022,7 @@ static void i8042_controller_reset(void)
  */
 
 	if (i8042_command(&i8042_initial_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_WARNING "i8042.c: Can't restore CTR.\n");
+		pr_warning("Can't restore CTR\n");
 }
 
 
@@ -1083,9 +1080,7 @@ static void i8042_dritek_enable(void)
 
 	error = i8042_command(&param, 0x1059);
 	if (error)
-		printk(KERN_WARNING
-			"Failed to enable DRITEK extension: %d\n",
-			error);
+		pr_warning("Failed to enable DRITEK extension: %d\n", error);
 }
 #endif
 
@@ -1120,10 +1115,10 @@ static int i8042_controller_resume(bool force_reset)
 	i8042_ctr |= I8042_CTR_AUXDIS | I8042_CTR_KBDDIS;
 	i8042_ctr &= ~(I8042_CTR_AUXINT | I8042_CTR_KBDINT);
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_WARNING "i8042: Can't write CTR to resume, retrying...\n");
+		pr_warning("Can't write CTR to resume, retrying...\n");
 		msleep(50);
 		if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-			printk(KERN_ERR "i8042: CTR write retry failed\n");
+			pr_err("CTR write retry failed\n");
 			return -EIO;
 		}
 	}
@@ -1136,9 +1131,8 @@ static int i8042_controller_resume(bool force_reset)
 
 	if (i8042_mux_present) {
 		if (i8042_set_mux_mode(true, NULL) || i8042_enable_mux_ports())
-			printk(KERN_WARNING
-				"i8042: failed to resume active multiplexor, "
-				"mouse won't work.\n");
+			pr_warning("failed to resume active multiplexor, "
+				   "mouse won't work\n");
 	} else if (i8042_ports[I8042_AUX_PORT_NO].serio)
 		i8042_enable_aux_port();
 
@@ -1283,7 +1277,7 @@ static void __init i8042_register_ports(void)
 
 	for (i = 0; i < I8042_NUM_PORTS; i++) {
 		if (i8042_ports[i].serio) {
-			printk(KERN_INFO "serio: %s at %#lx,%#lx irq %d\n",
+			pr_info("%s at %#lx,%#lx irq %d\n",
 				i8042_ports[i].serio->name,
 				(unsigned long) I8042_DATA_REG,
 				(unsigned long) I8042_COMMAND_REG,
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index cbc1beb..ebbe7dc 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -89,15 +89,22 @@
 #ifdef DEBUG
 static unsigned long i8042_start_time;
 #define dbg_init() do { i8042_start_time = jiffies; } while (0)
-#define dbg(format, arg...) 							\
-	do { 									\
-		if (i8042_debug)						\
-			printk(KERN_DEBUG __FILE__ ": " format " [%d]\n" ,	\
-	 			## arg, (int) (jiffies - i8042_start_time));	\
-	} while (0)
+#define dbg(format, arg...)						\
+do {									\
+	if (i8042_debug)						\
+		printk(KERN_DEBUG pr_fmt(format " [%d]\n"),		\
+		       ##arg,						\
+		       (int)(jiffies - i8042_start_time));		\
+} while (0)
 #else
 #define dbg_init() do { } while (0)
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...)						\
+do {									\
+	if (0)								\
+		printk(KERN_DEBUG pr_fmt(format " [%d]\n"),		\
+		       ##arg,						\
+		       (int)(jiffies - i8042_start_time));		\
+} while (0)
 #endif
 
 #endif /* _I8042_H */
diff --git a/drivers/input/serio/maceps2.c b/drivers/input/serio/maceps2.c
index 558200e..8348e0c 100644
--- a/drivers/input/serio/maceps2.c
+++ b/drivers/input/serio/maceps2.c
@@ -7,6 +7,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/serio.h>
@@ -91,7 +94,7 @@ static int maceps2_open(struct serio *dev)
 	struct maceps2_data *data = (struct maceps2_data *)dev->port_data;
 
 	if (request_irq(data->irq, maceps2_interrupt, 0, "PS2 port", dev)) {
-		printk(KERN_ERR "Could not allocate PS/2 IRQ\n");
+		pr_err("Could not allocate PS/2 IRQ\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/input/serio/parkbd.c b/drivers/input/serio/parkbd.c
index 26b4593..e4155ae 100644
--- a/drivers/input/serio/parkbd.c
+++ b/drivers/input/serio/parkbd.c
@@ -44,6 +44,8 @@
  * with 300 mA power reqirement of a typical AT keyboard.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/parport.h>
 #include <linux/slab.h>
@@ -148,7 +150,7 @@ static int parkbd_getport(void)
 	pp = parport_find_number(parkbd_pp_no);
 
 	if (pp == NULL) {
-		printk(KERN_ERR "parkbd: no such parport\n");
+		pr_err("no such parport\n");
 		return -ENODEV;
 	}
 
@@ -201,8 +203,8 @@ static int __init parkbd_init(void)
 
 	serio_register_port(parkbd_port);
 
-	printk(KERN_INFO "serio: PARKBD %s adapter on %s\n",
-                        parkbd_mode ? "AT" : "XT", parkbd_dev->port->name);
+	pr_info("PARKBD %s adapter on %s\n",
+		parkbd_mode ? "AT" : "XT", parkbd_dev->port->name);
 
 	return 0;
 }
diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index 5eb84b3..0499d5a 100644
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/serio.h>
@@ -95,7 +97,7 @@ static int q40kbd_open(struct serio *port)
 	q40kbd_flush();
 
 	if (request_irq(Q40_IRQ_KEYBOARD, q40kbd_interrupt, 0, "q40kbd", NULL)) {
-		printk(KERN_ERR "q40kbd.c: Can't get irq %d.\n", Q40_IRQ_KEYBOARD);
+		pr_err("Can't get irq %d\n", Q40_IRQ_KEYBOARD);
 		return -EBUSY;
 	}
 
@@ -129,7 +131,7 @@ static int __devinit q40kbd_probe(struct platform_device *dev)
 	strlcpy(q40kbd_port->phys, "Q40", sizeof(q40kbd_port->phys));
 
 	serio_register_port(q40kbd_port);
-	printk(KERN_INFO "serio: Q40 kbd registered\n");
+	pr_info("Q40 kbd registered\n");
 
 	return 0;
 }
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 9da6fbc..e5f2920 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -27,6 +27,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
@@ -84,12 +86,12 @@ static int rpckbd_open(struct serio *port)
 	iomd_readb(IOMD_KARTRX);
 
 	if (request_irq(IRQ_KEYBOARDRX, rpckbd_rx, 0, "rpckbd", port) != 0) {
-		printk(KERN_ERR "rpckbd.c: Could not allocate keyboard receive IRQ\n");
+		pr_err("Could not allocate keyboard receive IRQ\n");
 		return -EBUSY;
 	}
 
 	if (request_irq(IRQ_KEYBOARDTX, rpckbd_tx, 0, "rpckbd", port) != 0) {
-		printk(KERN_ERR "rpckbd.c: Could not allocate keyboard transmit IRQ\n");
+		pr_err("Could not allocate keyboard transmit IRQ\n");
 		free_irq(IRQ_KEYBOARDRX, NULL);
 		return -EBUSY;
 	}
diff --git a/drivers/input/serio/sa1111ps2.c b/drivers/input/serio/sa1111ps2.c
index d55874e..7836323 100644
--- a/drivers/input/serio/sa1111ps2.c
+++ b/drivers/input/serio/sa1111ps2.c
@@ -7,6 +7,9 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
@@ -129,16 +132,16 @@ static int ps2_open(struct serio *io)
 	ret = request_irq(ps2if->dev->irq[0], ps2_rxint, 0,
 			  SA1111_DRIVER_NAME(ps2if->dev), ps2if);
 	if (ret) {
-		printk(KERN_ERR "sa1111ps2: could not allocate IRQ%d: %d\n",
-			ps2if->dev->irq[0], ret);
+		pr_err("could not allocate IRQ%d: %d\n",
+		       ps2if->dev->irq[0], ret);
 		return ret;
 	}
 
 	ret = request_irq(ps2if->dev->irq[1], ps2_txint, 0,
 			  SA1111_DRIVER_NAME(ps2if->dev), ps2if);
 	if (ret) {
-		printk(KERN_ERR "sa1111ps2: could not allocate IRQ%d: %d\n",
-			ps2if->dev->irq[1], ret);
+		pr_err("could not allocate IRQ%d: %d\n",
+		       ps2if->dev->irq[1], ret);
 		free_irq(ps2if->dev->irq[0], ps2if);
 		return ret;
 	}
@@ -204,19 +207,19 @@ static int __devinit ps2_test(struct ps2if *ps2if)
 
 	stat = ps2_test_one(ps2if, PS2CR_FKC);
 	if (stat != PS2STAT_KBD) {
-		printk("PS/2 interface test failed[1]: %02x\n", stat);
+		pr_info("PS/2 interface test failed[1]: %02x\n", stat);
 		ret = -ENODEV;
 	}
 
 	stat = ps2_test_one(ps2if, 0);
 	if (stat != (PS2STAT_KBC | PS2STAT_KBD)) {
-		printk("PS/2 interface test failed[2]: %02x\n", stat);
+		pr_info("PS/2 interface test failed[2]: %02x\n", stat);
 		ret = -ENODEV;
 	}
 
 	stat = ps2_test_one(ps2if, PS2CR_FKD);
 	if (stat != PS2STAT_KBC) {
-		printk("PS/2 interface test failed[3]: %02x\n", stat);
+		pr_info("PS/2 interface test failed[3]: %02x\n", stat);
 		ret = -ENODEV;
 	}
 
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 9986648..2db32a0 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -9,6 +9,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
@@ -276,7 +278,7 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 	int err;
 
 	if (!(serio_raw = kzalloc(sizeof(struct serio_raw), GFP_KERNEL))) {
-		printk(KERN_ERR "serio_raw.c: can't allocate memory for a device\n");
+		pr_err("can't allocate memory for a device\n");
 		return -ENOMEM;
 	}
 
@@ -308,12 +310,12 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 	}
 
 	if (err) {
-		printk(KERN_INFO "serio_raw: failed to register raw access device for %s\n",
+		pr_info("failed to register raw access device for %s\n",
 			serio->phys);
 		goto out_close;
 	}
 
-	printk(KERN_INFO "serio_raw: raw access enabled on %s (%s, minor %d)\n",
+	pr_info("raw access enabled on %s (%s, minor %d)\n",
 		serio->phys, serio_raw->name, serio_raw->dev.minor);
 	goto out;
 
@@ -334,7 +336,7 @@ static int serio_raw_reconnect(struct serio *serio)
 	struct serio_driver *drv = serio->drv;
 
 	if (!drv || !serio_raw) {
-		printk(KERN_DEBUG "serio_raw: reconnect request, but serio is disconnected, ignoring...\n");
+		printk(KERN_DEBUG pr_fmt("reconnect request, but serio is disconnected, ignoring...\n"));
 		return -1;
 	}
 
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 6d34511..5e6d379 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -13,6 +13,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -167,7 +169,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	serio->port_data = serport;
 
 	serio_register_port(serport->serio);
-	printk(KERN_INFO "serio: Serial port %s\n", tty_name(tty, name));
+	pr_info("Serial port %s\n", tty_name(tty, name));
 
 	wait_event_interruptible(serport->wait, test_bit(SERPORT_DEAD, &serport->flags));
 	serio_unregister_port(serport->serio);
@@ -237,7 +239,7 @@ static int __init serport_init(void)
 	int retval;
 	retval = tty_register_ldisc(N_MOUSE, &serport_ldisc);
 	if (retval)
-		printk(KERN_ERR "serport.c: Error registering line discipline.\n");
+		pr_err("Error registering line discipline\n");
 
 	return  retval;
 }
diff --git a/drivers/input/tablet/acecad.c b/drivers/input/tablet/acecad.c
index aea9a93..bf95597 100644
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -25,6 +25,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -272,8 +274,7 @@ static int __init usb_acecad_init(void)
 {
 	int result = usb_register(&usb_acecad_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
 	return result;
 }
 
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 51b80b0..c2965da5 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -70,6 +70,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -1927,9 +1929,8 @@ static int __init aiptek_init(void)
 {
 	int result = usb_register(&aiptek_driver);
 	if (result == 0) {
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_AUTHOR "\n");
+		pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
+		pr_info(DRIVER_AUTHOR "\n");
 	}
 	return result;
 }
diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index 8ea6afe..822941f 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -1035,7 +1035,7 @@ static int __init gtco_init(void)
 		return error;
 	}
 
-	printk("GTCO usb driver version: %s", GTCO_VERSION);
+	pr_info("GTCO usb driver version: %s\n", GTCO_VERSION);
 	return 0;
 }
 
diff --git a/drivers/input/tablet/kbtab.c b/drivers/input/tablet/kbtab.c
index 290f4e5..18a4878 100644
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -204,8 +206,7 @@ static int __init kbtab_init(void)
 	retval = usb_register(&kbtab_driver);
 	if (retval)
 		goto out;
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-	       DRIVER_DESC "\n");
+	pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
 out:
 	return retval;
 }
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 42ba369..0b888a0 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -11,6 +11,8 @@
  * (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "wacom_wac.h"
 #include "wacom.h"
 
@@ -343,7 +345,7 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 	if (usb_get_extra_descriptor(interface, HID_DEVICET_HID, &hid_desc)) {
 		if (usb_get_extra_descriptor(&interface->endpoint[0],
 				HID_DEVICET_REPORT, &hid_desc)) {
-			printk("wacom: can not retrieve extra class descriptor\n");
+			pr_info("can not retrieve extra class descriptor\n");
 			error = 1;
 			goto out;
 		}
@@ -610,8 +612,7 @@ static int __init wacom_init(void)
 
 	result = usb_register(&wacom_driver);
 	if (result == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
-		       DRIVER_DESC "\n");
+		pr_info(DRIVER_VERSION ":" DRIVER_DESC "\n");
 	return result;
 }
 
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index ce0b460..02cdf4a 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -12,6 +12,8 @@
  * (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "wacom_wac.h"
 #include "wacom.h"
 
@@ -51,7 +53,8 @@ static int wacom_penpartner_irq(struct wacom_wac *wacom)
 		break;
 
 	default:
-		printk(KERN_INFO "wacom_penpartner_irq: received unknown report #%d\n", data[0]);
+		pr_info("%s(): received unknown report #%d\n",
+			__func__, data[0]);
 		return 0;
         }
 
@@ -136,7 +139,8 @@ static int wacom_ptu_irq(struct wacom_wac *wacom)
 	struct input_dev *input = wacom->input;
 
 	if (data[0] != WACOM_REPORT_PENABLED) {
-		printk(KERN_INFO "wacom_ptu_irq: received unknown report #%d\n", data[0]);
+		pr_info("%s(): received unknown report #%d\n",
+			__func__, data[0]);
 		return 0;
 	}
 
diff --git a/drivers/input/touchscreen/gunze.c b/drivers/input/touchscreen/gunze.c
index a54f90e..064765c 100644
--- a/drivers/input/touchscreen/gunze.c
+++ b/drivers/input/touchscreen/gunze.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -64,7 +66,8 @@ static void gunze_process_packet(struct gunze* gunze)
 
 	if (gunze->idx != GUNZE_MAX_LENGTH || gunze->data[5] != ',' ||
 		(gunze->data[0] != 'T' && gunze->data[0] != 'R')) {
-		printk(KERN_WARNING "gunze.c: bad packet: >%.*s<\n", GUNZE_MAX_LENGTH, gunze->data);
+		pr_warning("bad packet: >%.*s<\n",
+			   GUNZE_MAX_LENGTH, gunze->data);
 		return;
 	}
 
diff --git a/drivers/input/touchscreen/h3600_ts_input.c b/drivers/input/touchscreen/h3600_ts_input.c
index b4d7f63..58a97f7 100644
--- a/drivers/input/touchscreen/h3600_ts_input.c
+++ b/drivers/input/touchscreen/h3600_ts_input.c
@@ -29,6 +29,8 @@
  * e-mail - mail your message to <jsimmons@transvirtual.com>.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -331,7 +333,7 @@ static irqreturn_t h3600ts_interrupt(struct serio *serio, unsigned char data,
 				h3600ts_process_packet(ts);
 			break;
 		default:
-			printk("Error3\n");
+			pr_info("Error3\n");
 			break;
 	}
 
@@ -397,14 +399,14 @@ static int h3600ts_connect(struct serio *serio, struct serio_driver *drv)
 
 	if (request_irq(IRQ_GPIO_BITSY_ACTION_BUTTON, action_button_handler,
 			IRQF_SHARED | IRQF_DISABLED, "h3600_action", &ts->dev)) {
-		printk(KERN_ERR "h3600ts.c: Could not allocate Action Button IRQ!\n");
+		pr_err("Could not allocate Action Button IRQ!\n");
 		err = -EBUSY;
 		goto fail2;
 	}
 
 	if (request_irq(IRQ_GPIO_BITSY_NPOWER_BUTTON, npower_button_handler,
 			IRQF_SHARED | IRQF_DISABLED, "h3600_suspend", &ts->dev)) {
-		printk(KERN_ERR "h3600ts.c: Could not allocate Power Button IRQ!\n");
+		pr_err("Could not allocate Power Button IRQ!\n");
 		err = -EBUSY;
 		goto fail3;
 	}
diff --git a/drivers/input/touchscreen/hp680_ts_input.c b/drivers/input/touchscreen/hp680_ts_input.c
index a89700e..b6a514b 100644
--- a/drivers/input/touchscreen/hp680_ts_input.c
+++ b/drivers/input/touchscreen/hp680_ts_input.c
@@ -94,8 +94,7 @@ static int __init hp680_ts_init(void)
 
 	if (request_irq(HP680_TS_IRQ, hp680_ts_interrupt,
 			IRQF_DISABLED, MODNAME, 0) < 0) {
-		printk(KERN_ERR "hp680_touchscreen.c: Can't allocate irq %d\n",
-		       HP680_TS_IRQ);
+		pr_err("Can't allocate irq %d\n", HP680_TS_IRQ);
 		err = -EBUSY;
 		goto fail1;
 	}
diff --git a/drivers/input/touchscreen/htcpen.c b/drivers/input/touchscreen/htcpen.c
index 62811de..4d18c0f 100644
--- a/drivers/input/touchscreen/htcpen.c
+++ b/drivers/input/touchscreen/htcpen.c
@@ -8,6 +8,8 @@
  * by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -114,26 +116,23 @@ static int __devinit htcpen_isa_probe(struct device *dev, unsigned int id)
 	int err = -EBUSY;
 
 	if (!request_region(HTCPEN_PORT_IRQ_CLEAR, 1, "htcpen")) {
-		printk(KERN_ERR "htcpen: unable to get IO region 0x%x\n",
-			HTCPEN_PORT_IRQ_CLEAR);
+		pr_err("unable to get IO region 0x%x\n", HTCPEN_PORT_IRQ_CLEAR);
 		goto request_region1_failed;
 	}
 
 	if (!request_region(HTCPEN_PORT_INIT, 1, "htcpen")) {
-		printk(KERN_ERR "htcpen: unable to get IO region 0x%x\n",
-			HTCPEN_PORT_INIT);
+		pr_err("unable to get IO region 0x%x\n", HTCPEN_PORT_INIT);
 		goto request_region2_failed;
 	}
 
 	if (!request_region(HTCPEN_PORT_INDEX, 2, "htcpen")) {
-		printk(KERN_ERR "htcpen: unable to get IO region 0x%x\n",
-			HTCPEN_PORT_INDEX);
+		pr_err("unable to get IO region 0x%x\n", HTCPEN_PORT_INDEX);
 		goto request_region3_failed;
 	}
 
 	htcpen_dev = input_allocate_device();
 	if (!htcpen_dev) {
-		printk(KERN_ERR "htcpen: can't allocate device\n");
+		pr_err("can't allocate device\n");
 		err = -ENOMEM;
 		goto input_alloc_failed;
 	}
@@ -152,7 +151,7 @@ static int __devinit htcpen_isa_probe(struct device *dev, unsigned int id)
 	err = request_irq(HTCPEN_IRQ, htcpen_interrupt, 0, "htcpen",
 			htcpen_dev);
 	if (err) {
-		printk(KERN_ERR "htcpen: irq busy\n");
+		pr_err("irq busy\n");
 		goto request_irq_failed;
 	}
 
diff --git a/drivers/input/touchscreen/inexio.c b/drivers/input/touchscreen/inexio.c
index 192ade0..441ff4c 100644
--- a/drivers/input/touchscreen/inexio.c
+++ b/drivers/input/touchscreen/inexio.c
@@ -17,6 +17,8 @@
  *   Copied mtouch.c and edited for iNexio protocol
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -87,7 +89,8 @@ static irqreturn_t inexio_interrupt(struct serio *serio,
 	if (INEXIO_RESPONSE_BEGIN_BYTE&pinexio->data[0])
 		inexio_process_data(pinexio);
 	else
-		printk(KERN_DEBUG "inexio.c: unknown/unsynchronized data from device, byte %x\n",pinexio->data[0]);
+		printk(KERN_DEBUG pr_fmt("unknown/unsynchronized data from device, byte %x\n"),
+		       pinexio->data[0]);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index 4b0a061..e0abada 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -13,6 +13,8 @@
  * HP Jornada 710/720/729 Touchscreen Driver
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/input.h>
@@ -130,7 +132,7 @@ static int __devinit jornada720_ts_probe(struct platform_device *pdev)
 			IRQF_DISABLED | IRQF_TRIGGER_RISING,
 			"HP7XX Touchscreen driver", pdev);
 	if (error) {
-		printk(KERN_INFO "HP7XX TS : Unable to acquire irq!\n");
+		pr_info("Unable to acquire irq!\n");
 		goto fail1;
 	}
 
diff --git a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscreen/mk712.c
index efd3aeb..7896dc1 100644
--- a/drivers/input/touchscreen/mk712.c
+++ b/drivers/input/touchscreen/mk712.c
@@ -35,6 +35,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -154,7 +156,7 @@ static int __init mk712_init(void)
 	int err;
 
 	if (!request_region(mk712_io, 8, "mk712")) {
-		printk(KERN_WARNING "mk712: unable to get IO region\n");
+		pr_warning("unable to get IO region\n");
 		return -ENODEV;
 	}
 
@@ -163,14 +165,14 @@ static int __init mk712_init(void)
 	if ((inw(mk712_io + MK712_X) & 0xf000) ||	/* Sanity check */
 	    (inw(mk712_io + MK712_Y) & 0xf000) ||
 	    (inw(mk712_io + MK712_STATUS) & 0xf333)) {
-		printk(KERN_WARNING "mk712: device not present\n");
+		pr_warning("device not present\n");
 		err = -ENODEV;
 		goto fail1;
 	}
 
 	mk712_dev = input_allocate_device();
 	if (!mk712_dev) {
-		printk(KERN_ERR "mk712: not enough memory\n");
+		pr_err("not enough memory\n");
 		err = -ENOMEM;
 		goto fail1;
 	}
@@ -191,7 +193,7 @@ static int __init mk712_init(void)
 	input_set_abs_params(mk712_dev, ABS_Y, 0, 0xfff, 88, 0);
 
 	if (request_irq(mk712_irq, mk712_interrupt, 0, "mk712", mk712_dev)) {
-		printk(KERN_WARNING "mk712: unable to get IRQ\n");
+		pr_warning("unable to get IRQ\n");
 		err = -EBUSY;
 		goto fail1;
 	}
diff --git a/drivers/input/touchscreen/mtouch.c b/drivers/input/touchscreen/mtouch.c
index 9077228..7e58b66 100644
--- a/drivers/input/touchscreen/mtouch.c
+++ b/drivers/input/touchscreen/mtouch.c
@@ -15,6 +15,8 @@
  *   Copied elo.c and edited for MicroTouch protocol
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -83,7 +85,7 @@ static void mtouch_process_response(struct mtouch *mtouch)
 		/* FIXME - process response */
 		mtouch->idx = 0;
 	} else if (MTOUCH_MAX_LENGTH == mtouch->idx) {
-		printk(KERN_ERR "mtouch.c: too many response bytes\n");
+		pr_err("too many response bytes\n");
 		mtouch->idx = 0;
 	}
 }
@@ -100,7 +102,8 @@ static irqreturn_t mtouch_interrupt(struct serio *serio,
 	else if (MTOUCH_RESPONSE_BEGIN_BYTE == mtouch->data[0])
 		mtouch_process_response(mtouch);
 	else
-		printk(KERN_DEBUG "mtouch.c: unknown/unsynchronized data from device, byte %x\n",mtouch->data[0]);
+		printk(KERN_DEBUG pr_fmt("unknown/unsynchronized data from device, byte %x\n"),
+		       mtouch->data[0]);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 028a536..7c0c5b2 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -18,6 +18,8 @@
  * been made separate from ucb1x00-core/ucb1x00-ts on Russell's request.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/completion.h>
@@ -321,7 +323,7 @@ static int ucb1400_ts_detect_irq(struct ucb1400_ts *ucb)
 						UCB_ADC_DAT_VALID)) {
 		cpu_relax();
 		if (time_after(jiffies, timeout)) {
-			printk(KERN_ERR "ucb1400: timed out in IRQ probe\n");
+			pr_err("timed out in IRQ probe\n");
 			probe_irq_off(mask);
 			return -ENODEV;
 		}
@@ -358,7 +360,7 @@ static int ucb1400_ts_probe(struct platform_device *dev)
 	if (ucb->irq < 0) {
 		error = ucb1400_ts_detect_irq(ucb);
 		if (error) {
-			printk(KERN_ERR "UCB1400: IRQ probe failed\n");
+			pr_err("IRQ probe failed\n");
 			goto err_free_devs;
 		}
 	}
@@ -368,11 +370,11 @@ static int ucb1400_ts_probe(struct platform_device *dev)
 	error = request_irq(ucb->irq, ucb1400_hard_irq, IRQF_TRIGGER_RISING,
 				"UCB1400", ucb);
 	if (error) {
-		printk(KERN_ERR "ucb1400: unable to grab irq%d: %d\n",
+		pr_err("unable to grab irq%d: %d\n",
 				ucb->irq, error);
 		goto err_free_devs;
 	}
-	printk(KERN_DEBUG "UCB1400: found IRQ %d\n", ucb->irq);
+	printk(KERN_DEBUG pr_fmt("found IRQ %d\n"), ucb->irq);
 
 	input_set_drvdata(ucb->ts_idev, ucb);
 
@@ -398,7 +400,7 @@ static int ucb1400_ts_probe(struct platform_device *dev)
 	x_res = ucb1400_ts_read_xres(ucb);
 	y_res = ucb1400_ts_read_yres(ucb);
 	ucb1400_adc_disable(ucb->ac97);
-	printk(KERN_DEBUG "UCB1400: x/y = %d/%d\n", x_res, y_res);
+	printk(KERN_DEBUG pr_fmt("x/y = %d/%d\n"), x_res, y_res);
 
 	input_set_abs_params(ucb->ts_idev, ABS_X, 0, x_res, 0, 0);
 	input_set_abs_params(ucb->ts_idev, ABS_Y, 0, y_res, 0, 0);
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index f45f80f..2df60cc 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -43,6 +43,8 @@
  *
  *****************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 //#define DEBUG
 
 #include <linux/kernel.h>
@@ -832,8 +834,8 @@ static int nexio_init(struct usbtouch_usb *usbtouch)
 		}
 	}
 
-	printk(KERN_INFO "Nexio device: %s, firmware version: %s\n",
-	       device_name, firmware_ver);
+	pr_info("Nexio device: %s, firmware version: %s\n",
+		device_name, firmware_ver);
 
 	kfree(firmware_ver);
 	kfree(device_name);
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


