Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2DDDLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 23:11:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61083 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab2DDDLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 23:11:10 -0400
Message-ID: <1333509064.15318.8.camel@phoenix>
Subject: [PATCH 2/2] Input: use module_serio_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@mail.ru>, Lars-Peter Clausen <lars@metafoo.de>,
        Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org
Date: Wed, 04 Apr 2012 11:11:04 +0800
In-Reply-To: <1333508882.15318.5.camel@phoenix>
References: <1333508882.15318.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/input/* to use module_serio_driver()
macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/joystick/magellan.c          |   17 +----------------
 drivers/input/joystick/spaceball.c         |   17 +----------------
 drivers/input/joystick/spaceorb.c          |   17 +----------------
 drivers/input/joystick/stinger.c           |   17 +----------------
 drivers/input/joystick/twidjoy.c           |   17 +----------------
 drivers/input/joystick/warrior.c           |   17 +----------------
 drivers/input/joystick/zhenhua.c           |   17 +----------------
 drivers/input/keyboard/hil_kbd.c           |   13 +------------
 drivers/input/keyboard/lkkbd.c             |   17 +----------------
 drivers/input/keyboard/newtonkbd.c         |   13 +------------
 drivers/input/keyboard/stowaway.c          |   13 +------------
 drivers/input/keyboard/sunkbd.c            |   17 +----------------
 drivers/input/keyboard/xtkbd.c             |   13 +------------
 drivers/input/mouse/sermouse.c             |   13 +------------
 drivers/input/mouse/vsxxxaa.c              |   14 +-------------
 drivers/input/serio/ps2mult.c              |   13 +------------
 drivers/input/serio/serio_raw.c            |   13 +------------
 drivers/input/touchscreen/dynapro.c        |   17 +----------------
 drivers/input/touchscreen/elo.c            |   17 +----------------
 drivers/input/touchscreen/fujitsu_ts.c     |   13 +------------
 drivers/input/touchscreen/gunze.c          |   17 +----------------
 drivers/input/touchscreen/h3600_ts_input.c |   17 +----------------
 drivers/input/touchscreen/hampshire.c      |   17 +----------------
 drivers/input/touchscreen/inexio.c         |   17 +----------------
 drivers/input/touchscreen/mtouch.c         |   17 +----------------
 drivers/input/touchscreen/penmount.c       |   17 +----------------
 drivers/input/touchscreen/touchit213.c     |   17 +----------------
 drivers/input/touchscreen/touchright.c     |   17 +----------------
 drivers/input/touchscreen/touchwin.c       |   17 +----------------
 drivers/input/touchscreen/tsc40.c          |   12 +-----------
 drivers/input/touchscreen/wacom_w8001.c    |   13 +------------
 31 files changed, 31 insertions(+), 452 deletions(-)

diff --git a/drivers/input/joystick/magellan.c b/drivers/input/joystick/magellan.c
index 40e4078..9fb153e 100644
--- a/drivers/input/joystick/magellan.c
+++ b/drivers/input/joystick/magellan.c
@@ -222,19 +222,4 @@ static struct serio_driver magellan_drv = {
 	.disconnect	= magellan_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init magellan_init(void)
-{
-	return serio_register_driver(&magellan_drv);
-}
-
-static void __exit magellan_exit(void)
-{
-	serio_unregister_driver(&magellan_drv);
-}
-
-module_init(magellan_init);
-module_exit(magellan_exit);
+module_serio_driver(magellan_drv);
diff --git a/drivers/input/joystick/spaceball.c b/drivers/input/joystick/spaceball.c
index 0cd9b29..80a7b27 100644
--- a/drivers/input/joystick/spaceball.c
+++ b/drivers/input/joystick/spaceball.c
@@ -296,19 +296,4 @@ static struct serio_driver spaceball_drv = {
 	.disconnect	= spaceball_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init spaceball_init(void)
-{
-	return serio_register_driver(&spaceball_drv);
-}
-
-static void __exit spaceball_exit(void)
-{
-	serio_unregister_driver(&spaceball_drv);
-}
-
-module_init(spaceball_init);
-module_exit(spaceball_exit);
+module_serio_driver(spaceball_drv);
diff --git a/drivers/input/joystick/spaceorb.c b/drivers/input/joystick/spaceorb.c
index a694bf8..a41f291 100644
--- a/drivers/input/joystick/spaceorb.c
+++ b/drivers/input/joystick/spaceorb.c
@@ -237,19 +237,4 @@ static struct serio_driver spaceorb_drv = {
 	.disconnect	= spaceorb_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init spaceorb_init(void)
-{
-	return serio_register_driver(&spaceorb_drv);
-}
-
-static void __exit spaceorb_exit(void)
-{
-	serio_unregister_driver(&spaceorb_drv);
-}
-
-module_init(spaceorb_init);
-module_exit(spaceorb_exit);
+module_serio_driver(spaceorb_drv);
diff --git a/drivers/input/joystick/stinger.c b/drivers/input/joystick/stinger.c
index e0db9f5..0f51a60 100644
--- a/drivers/input/joystick/stinger.c
+++ b/drivers/input/joystick/stinger.c
@@ -208,19 +208,4 @@ static struct serio_driver stinger_drv = {
 	.disconnect	= stinger_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init stinger_init(void)
-{
-	return serio_register_driver(&stinger_drv);
-}
-
-static void __exit stinger_exit(void)
-{
-	serio_unregister_driver(&stinger_drv);
-}
-
-module_init(stinger_init);
-module_exit(stinger_exit);
+module_serio_driver(stinger_drv);
diff --git a/drivers/input/joystick/twidjoy.c b/drivers/input/joystick/twidjoy.c
index 3f4ec73..2556a81 100644
--- a/drivers/input/joystick/twidjoy.c
+++ b/drivers/input/joystick/twidjoy.c
@@ -257,19 +257,4 @@ static struct serio_driver twidjoy_drv = {
 	.disconnect	= twidjoy_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init twidjoy_init(void)
-{
-	return serio_register_driver(&twidjoy_drv);
-}
-
-static void __exit twidjoy_exit(void)
-{
-	serio_unregister_driver(&twidjoy_drv);
-}
-
-module_init(twidjoy_init);
-module_exit(twidjoy_exit);
+module_serio_driver(twidjoy_drv);
diff --git a/drivers/input/joystick/warrior.c b/drivers/input/joystick/warrior.c
index f72c83e..23b3071 100644
--- a/drivers/input/joystick/warrior.c
+++ b/drivers/input/joystick/warrior.c
@@ -217,19 +217,4 @@ static struct serio_driver warrior_drv = {
 	.disconnect	= warrior_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init warrior_init(void)
-{
-	return serio_register_driver(&warrior_drv);
-}
-
-static void __exit warrior_exit(void)
-{
-	serio_unregister_driver(&warrior_drv);
-}
-
-module_init(warrior_init);
-module_exit(warrior_exit);
+module_serio_driver(warrior_drv);
diff --git a/drivers/input/joystick/zhenhua.c b/drivers/input/joystick/zhenhua.c
index b585312..c4de438 100644
--- a/drivers/input/joystick/zhenhua.c
+++ b/drivers/input/joystick/zhenhua.c
@@ -225,19 +225,4 @@ static struct serio_driver zhenhua_drv = {
 	.disconnect	= zhenhua_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init zhenhua_init(void)
-{
-	return serio_register_driver(&zhenhua_drv);
-}
-
-static void __exit zhenhua_exit(void)
-{
-	serio_unregister_driver(&zhenhua_drv);
-}
-
-module_init(zhenhua_init);
-module_exit(zhenhua_exit);
+module_serio_driver(zhenhua_drv);
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index fed31e0..589e3c2 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -583,15 +583,4 @@ static struct serio_driver hil_serio_drv = {
 	.interrupt	= hil_dev_interrupt
 };
 
-static int __init hil_dev_init(void)
-{
-	return serio_register_driver(&hil_serio_drv);
-}
-
-static void __exit hil_dev_exit(void)
-{
-	serio_unregister_driver(&hil_serio_drv);
-}
-
-module_init(hil_dev_init);
-module_exit(hil_dev_exit);
+module_serio_driver(hil_serio_drv);
diff --git a/drivers/input/keyboard/lkkbd.c b/drivers/input/keyboard/lkkbd.c
index fa9bb6d..fc0a63c 100644
--- a/drivers/input/keyboard/lkkbd.c
+++ b/drivers/input/keyboard/lkkbd.c
@@ -731,19 +731,4 @@ static struct serio_driver lkkbd_drv = {
 	.interrupt	= lkkbd_interrupt,
 };
 
-/*
- * The functions for insering/removing us as a module.
- */
-static int __init lkkbd_init(void)
-{
-	return serio_register_driver(&lkkbd_drv);
-}
-
-static void __exit lkkbd_exit(void)
-{
-	serio_unregister_driver(&lkkbd_drv);
-}
-
-module_init(lkkbd_init);
-module_exit(lkkbd_exit);
-
+module_serio_driver(lkkbd_drv);
diff --git a/drivers/input/keyboard/newtonkbd.c b/drivers/input/keyboard/newtonkbd.c
index 48d1cab..f971898 100644
--- a/drivers/input/keyboard/newtonkbd.c
+++ b/drivers/input/keyboard/newtonkbd.c
@@ -166,15 +166,4 @@ static struct serio_driver nkbd_drv = {
 	.disconnect	= nkbd_disconnect,
 };
 
-static int __init nkbd_init(void)
-{
-	return serio_register_driver(&nkbd_drv);
-}
-
-static void __exit nkbd_exit(void)
-{
-	serio_unregister_driver(&nkbd_drv);
-}
-
-module_init(nkbd_init);
-module_exit(nkbd_exit);
+module_serio_driver(nkbd_drv);
diff --git a/drivers/input/keyboard/stowaway.c b/drivers/input/keyboard/stowaway.c
index 7437219..cc612c5 100644
--- a/drivers/input/keyboard/stowaway.c
+++ b/drivers/input/keyboard/stowaway.c
@@ -170,15 +170,4 @@ static struct serio_driver skbd_drv = {
 	.disconnect	= skbd_disconnect,
 };
 
-static int __init skbd_init(void)
-{
-	return serio_register_driver(&skbd_drv);
-}
-
-static void __exit skbd_exit(void)
-{
-	serio_unregister_driver(&skbd_drv);
-}
-
-module_init(skbd_init);
-module_exit(skbd_exit);
+module_serio_driver(skbd_drv);
diff --git a/drivers/input/keyboard/sunkbd.c b/drivers/input/keyboard/sunkbd.c
index a99a04b..5f836b1 100644
--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -369,19 +369,4 @@ static struct serio_driver sunkbd_drv = {
 	.disconnect	= sunkbd_disconnect,
 };
 
-/*
- * The functions for insering/removing us as a module.
- */
-
-static int __init sunkbd_init(void)
-{
-	return serio_register_driver(&sunkbd_drv);
-}
-
-static void __exit sunkbd_exit(void)
-{
-	serio_unregister_driver(&sunkbd_drv);
-}
-
-module_init(sunkbd_init);
-module_exit(sunkbd_exit);
+module_serio_driver(sunkbd_drv);
diff --git a/drivers/input/keyboard/xtkbd.c b/drivers/input/keyboard/xtkbd.c
index 37b01d7..d050d9d 100644
--- a/drivers/input/keyboard/xtkbd.c
+++ b/drivers/input/keyboard/xtkbd.c
@@ -169,15 +169,4 @@ static struct serio_driver xtkbd_drv = {
 	.disconnect	= xtkbd_disconnect,
 };
 
-static int __init xtkbd_init(void)
-{
-	return serio_register_driver(&xtkbd_drv);
-}
-
-static void __exit xtkbd_exit(void)
-{
-	serio_unregister_driver(&xtkbd_drv);
-}
-
-module_init(xtkbd_init);
-module_exit(xtkbd_exit);
+module_serio_driver(xtkbd_drv);
diff --git a/drivers/input/mouse/sermouse.c b/drivers/input/mouse/sermouse.c
index 17ff137b..d5928fd 100644
--- a/drivers/input/mouse/sermouse.c
+++ b/drivers/input/mouse/sermouse.c
@@ -355,15 +355,4 @@ static struct serio_driver sermouse_drv = {
 	.disconnect	= sermouse_disconnect,
 };
 
-static int __init sermouse_init(void)
-{
-	return serio_register_driver(&sermouse_drv);
-}
-
-static void __exit sermouse_exit(void)
-{
-	serio_unregister_driver(&sermouse_drv);
-}
-
-module_init(sermouse_init);
-module_exit(sermouse_exit);
+module_serio_driver(sermouse_drv);
diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
index eb9a3cf..e900d46 100644
--- a/drivers/input/mouse/vsxxxaa.c
+++ b/drivers/input/mouse/vsxxxaa.c
@@ -548,16 +548,4 @@ static struct serio_driver vsxxxaa_drv = {
 	.disconnect	= vsxxxaa_disconnect,
 };
 
-static int __init vsxxxaa_init(void)
-{
-	return serio_register_driver(&vsxxxaa_drv);
-}
-
-static void __exit vsxxxaa_exit(void)
-{
-	serio_unregister_driver(&vsxxxaa_drv);
-}
-
-module_init(vsxxxaa_init);
-module_exit(vsxxxaa_exit);
-
+module_serio_driver(vsxxxaa_drv);
diff --git a/drivers/input/serio/ps2mult.c b/drivers/input/serio/ps2mult.c
index 15aa81c..a76fb64 100644
--- a/drivers/input/serio/ps2mult.c
+++ b/drivers/input/serio/ps2mult.c
@@ -304,15 +304,4 @@ static struct serio_driver ps2mult_drv = {
 	.reconnect	= ps2mult_reconnect,
 };
 
-static int __init ps2mult_init(void)
-{
-	return serio_register_driver(&ps2mult_drv);
-}
-
-static void __exit ps2mult_exit(void)
-{
-	serio_unregister_driver(&ps2mult_drv);
-}
-
-module_init(ps2mult_init);
-module_exit(ps2mult_exit);
+module_serio_driver(ps2mult_drv);
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 4494233..948fd5a 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -432,15 +432,4 @@ static struct serio_driver serio_raw_drv = {
 	.manual_bind	= true,
 };
 
-static int __init serio_raw_init(void)
-{
-	return serio_register_driver(&serio_raw_drv);
-}
-
-static void __exit serio_raw_exit(void)
-{
-	serio_unregister_driver(&serio_raw_drv);
-}
-
-module_init(serio_raw_init);
-module_exit(serio_raw_exit);
+module_serio_driver(serio_raw_drv);
diff --git a/drivers/input/touchscreen/dynapro.c b/drivers/input/touchscreen/dynapro.c
index 4553539..1809677 100644
--- a/drivers/input/touchscreen/dynapro.c
+++ b/drivers/input/touchscreen/dynapro.c
@@ -188,19 +188,4 @@ static struct serio_driver dynapro_drv = {
 	.disconnect	= dynapro_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init dynapro_init(void)
-{
-	return serio_register_driver(&dynapro_drv);
-}
-
-static void __exit dynapro_exit(void)
-{
-	serio_unregister_driver(&dynapro_drv);
-}
-
-module_init(dynapro_init);
-module_exit(dynapro_exit);
+module_serio_driver(dynapro_drv);
diff --git a/drivers/input/touchscreen/elo.c b/drivers/input/touchscreen/elo.c
index 486d31b..957423d 100644
--- a/drivers/input/touchscreen/elo.c
+++ b/drivers/input/touchscreen/elo.c
@@ -405,19 +405,4 @@ static struct serio_driver elo_drv = {
 	.disconnect	= elo_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init elo_init(void)
-{
-	return serio_register_driver(&elo_drv);
-}
-
-static void __exit elo_exit(void)
-{
-	serio_unregister_driver(&elo_drv);
-}
-
-module_init(elo_init);
-module_exit(elo_exit);
+module_serio_driver(elo_drv);
diff --git a/drivers/input/touchscreen/fujitsu_ts.c b/drivers/input/touchscreen/fujitsu_ts.c
index 80b2180..10794dd 100644
--- a/drivers/input/touchscreen/fujitsu_ts.c
+++ b/drivers/input/touchscreen/fujitsu_ts.c
@@ -175,15 +175,4 @@ static struct serio_driver fujitsu_drv = {
 	.disconnect	= fujitsu_disconnect,
 };
 
-static int __init fujitsu_init(void)
-{
-	return serio_register_driver(&fujitsu_drv);
-}
-
-static void __exit fujitsu_exit(void)
-{
-	serio_unregister_driver(&fujitsu_drv);
-}
-
-module_init(fujitsu_init);
-module_exit(fujitsu_exit);
+module_serio_driver(fujitsu_drv);
diff --git a/drivers/input/touchscreen/gunze.c b/drivers/input/touchscreen/gunze.c
index a54f90e..41c7176 100644
--- a/drivers/input/touchscreen/gunze.c
+++ b/drivers/input/touchscreen/gunze.c
@@ -186,19 +186,4 @@ static struct serio_driver gunze_drv = {
 	.disconnect	= gunze_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init gunze_init(void)
-{
-	return serio_register_driver(&gunze_drv);
-}
-
-static void __exit gunze_exit(void)
-{
-	serio_unregister_driver(&gunze_drv);
-}
-
-module_init(gunze_init);
-module_exit(gunze_exit);
+module_serio_driver(gunze_drv);
diff --git a/drivers/input/touchscreen/h3600_ts_input.c b/drivers/input/touchscreen/h3600_ts_input.c
index 6107e56..b9e8686 100644
--- a/drivers/input/touchscreen/h3600_ts_input.c
+++ b/drivers/input/touchscreen/h3600_ts_input.c
@@ -476,19 +476,4 @@ static struct serio_driver h3600ts_drv = {
 	.disconnect	= h3600ts_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init h3600ts_init(void)
-{
-	return serio_register_driver(&h3600ts_drv);
-}
-
-static void __exit h3600ts_exit(void)
-{
-	serio_unregister_driver(&h3600ts_drv);
-}
-
-module_init(h3600ts_init);
-module_exit(h3600ts_exit);
+module_serio_driver(h3600ts_drv);
diff --git a/drivers/input/touchscreen/hampshire.c b/drivers/input/touchscreen/hampshire.c
index 2da6cc3..0cc47ea 100644
--- a/drivers/input/touchscreen/hampshire.c
+++ b/drivers/input/touchscreen/hampshire.c
@@ -187,19 +187,4 @@ static struct serio_driver hampshire_drv = {
 	.disconnect	= hampshire_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init hampshire_init(void)
-{
-	return serio_register_driver(&hampshire_drv);
-}
-
-static void __exit hampshire_exit(void)
-{
-	serio_unregister_driver(&hampshire_drv);
-}
-
-module_init(hampshire_init);
-module_exit(hampshire_exit);
+module_serio_driver(hampshire_drv);
diff --git a/drivers/input/touchscreen/inexio.c b/drivers/input/touchscreen/inexio.c
index 192ade0..a29c99c 100644
--- a/drivers/input/touchscreen/inexio.c
+++ b/drivers/input/touchscreen/inexio.c
@@ -189,19 +189,4 @@ static struct serio_driver inexio_drv = {
 	.disconnect	= inexio_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init inexio_init(void)
-{
-	return serio_register_driver(&inexio_drv);
-}
-
-static void __exit inexio_exit(void)
-{
-	serio_unregister_driver(&inexio_drv);
-}
-
-module_init(inexio_init);
-module_exit(inexio_exit);
+module_serio_driver(inexio_drv);
diff --git a/drivers/input/touchscreen/mtouch.c b/drivers/input/touchscreen/mtouch.c
index 9077228..eb66b7c 100644
--- a/drivers/input/touchscreen/mtouch.c
+++ b/drivers/input/touchscreen/mtouch.c
@@ -202,19 +202,4 @@ static struct serio_driver mtouch_drv = {
 	.disconnect	= mtouch_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init mtouch_init(void)
-{
-	return serio_register_driver(&mtouch_drv);
-}
-
-static void __exit mtouch_exit(void)
-{
-	serio_unregister_driver(&mtouch_drv);
-}
-
-module_init(mtouch_init);
-module_exit(mtouch_exit);
+module_serio_driver(mtouch_drv);
diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index 4c012fb..4ccde45 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -317,19 +317,4 @@ static struct serio_driver pm_drv = {
 	.disconnect	= pm_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init pm_init(void)
-{
-	return serio_register_driver(&pm_drv);
-}
-
-static void __exit pm_exit(void)
-{
-	serio_unregister_driver(&pm_drv);
-}
-
-module_init(pm_init);
-module_exit(pm_exit);
+module_serio_driver(pm_drv);
diff --git a/drivers/input/touchscreen/touchit213.c b/drivers/input/touchscreen/touchit213.c
index d1297ba..5f29e5b 100644
--- a/drivers/input/touchscreen/touchit213.c
+++ b/drivers/input/touchscreen/touchit213.c
@@ -216,19 +216,4 @@ static struct serio_driver touchit213_drv = {
 	.disconnect	= touchit213_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init touchit213_init(void)
-{
-	return serio_register_driver(&touchit213_drv);
-}
-
-static void __exit touchit213_exit(void)
-{
-	serio_unregister_driver(&touchit213_drv);
-}
-
-module_init(touchit213_init);
-module_exit(touchit213_exit);
+module_serio_driver(touchit213_drv);
diff --git a/drivers/input/touchscreen/touchright.c b/drivers/input/touchscreen/touchright.c
index 3a5c142..8a2887d 100644
--- a/drivers/input/touchscreen/touchright.c
+++ b/drivers/input/touchscreen/touchright.c
@@ -176,19 +176,4 @@ static struct serio_driver tr_drv = {
 	.disconnect	= tr_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init tr_init(void)
-{
-	return serio_register_driver(&tr_drv);
-}
-
-static void __exit tr_exit(void)
-{
-	serio_unregister_driver(&tr_drv);
-}
-
-module_init(tr_init);
-module_exit(tr_exit);
+module_serio_driver(tr_drv);
diff --git a/drivers/input/touchscreen/touchwin.c b/drivers/input/touchscreen/touchwin.c
index 763a656..588cdcb 100644
--- a/drivers/input/touchscreen/touchwin.c
+++ b/drivers/input/touchscreen/touchwin.c
@@ -183,19 +183,4 @@ static struct serio_driver tw_drv = {
 	.disconnect	= tw_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
-static int __init tw_init(void)
-{
-	return serio_register_driver(&tw_drv);
-}
-
-static void __exit tw_exit(void)
-{
-	serio_unregister_driver(&tw_drv);
-}
-
-module_init(tw_init);
-module_exit(tw_exit);
+module_serio_driver(tw_drv);
diff --git a/drivers/input/touchscreen/tsc40.c b/drivers/input/touchscreen/tsc40.c
index 29d5ed4..63209aa 100644
--- a/drivers/input/touchscreen/tsc40.c
+++ b/drivers/input/touchscreen/tsc40.c
@@ -167,17 +167,7 @@ static struct serio_driver tsc_drv = {
 	.disconnect     = tsc_disconnect,
 };
 
-static int __init tsc_ser_init(void)
-{
-	return serio_register_driver(&tsc_drv);
-}
-module_init(tsc_ser_init);
-
-static void __exit tsc_exit(void)
-{
-	serio_unregister_driver(&tsc_drv);
-}
-module_exit(tsc_exit);
+module_serio_driver(tsc_drv);
 
 MODULE_AUTHOR("Sebastian Andrzej Siewior <bigeasy@linutronix.de>");
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index 1569a39..8f9ad2f 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -594,15 +594,4 @@ static struct serio_driver w8001_drv = {
 	.disconnect	= w8001_disconnect,
 };
 
-static int __init w8001_init(void)
-{
-	return serio_register_driver(&w8001_drv);
-}
-
-static void __exit w8001_exit(void)
-{
-	serio_unregister_driver(&w8001_drv);
-}
-
-module_init(w8001_init);
-module_exit(w8001_exit);
+module_serio_driver(w8001_drv);
-- 
1.7.5.4



