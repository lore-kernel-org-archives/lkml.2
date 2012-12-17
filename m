Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2LQW2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:28:48 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:9442 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2LQW2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:28:46 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1355783315!12605739!5
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] HID: Use module_hid_driver macro
Date: Mon, 17 Dec 2012 15:28:26 -0700
User-Agent: KMail/1.9.9
CC: <jkosina@suse.cz>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201212171528.26445.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new module_hid_driver macro in all HID drivers that have
a simple register/unregister init/exit.

This also converts the hid drivers that test for a failure of
hid_register_driver() and report the failure. Using module_hid_driver
in those drivers removes the failure message.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-a4tech.c       | 13 +------------
 drivers/hid/hid-apple.c        | 19 +------------------
 drivers/hid/hid-aureal.c       | 13 +------------
 drivers/hid/hid-axff.c         | 14 +-------------
 drivers/hid/hid-belkin.c       | 13 +------------
 drivers/hid/hid-cherry.c       | 13 +------------
 drivers/hid/hid-chicony.c      | 13 +------------
 drivers/hid/hid-cypress.c      | 13 +------------
 drivers/hid/hid-dr.c           | 13 +------------
 drivers/hid/hid-elecom.c       | 13 +------------
 drivers/hid/hid-emsff.c        | 13 +------------
 drivers/hid/hid-ezkey.c        | 13 +------------
 drivers/hid/hid-gaff.c         | 13 +------------
 drivers/hid/hid-generic.c      | 14 +-------------
 drivers/hid/hid-gyration.c     | 13 +------------
 drivers/hid/hid-holtek-kbd.c   | 13 +------------
 drivers/hid/hid-holtekff.c     | 15 +--------------
 drivers/hid/hid-icade.c        | 19 +------------------
 drivers/hid/hid-kensington.c   | 13 +------------
 drivers/hid/hid-keytouch.c     | 13 +------------
 drivers/hid/hid-kye.c          | 13 +------------
 drivers/hid/hid-lcpower.c      | 13 +------------
 drivers/hid/hid-lenovo-tpkbd.c | 14 +-------------
 drivers/hid/hid-lg.c           | 13 +------------
 drivers/hid/hid-magicmouse.c   | 19 +------------------
 drivers/hid/hid-microsoft.c    | 13 +------------
 drivers/hid/hid-monterey.c     | 13 +------------
 drivers/hid/hid-multitouch.c   | 14 +-------------
 drivers/hid/hid-ntrig.c        | 13 +------------
 drivers/hid/hid-ortek.c        | 13 +------------
 drivers/hid/hid-petalynx.c     | 13 +------------
 drivers/hid/hid-picolcd_core.c | 13 +------------
 drivers/hid/hid-pl.c           | 13 +------------
 drivers/hid/hid-primax.c       | 13 +------------
 drivers/hid/hid-prodikeys.c    | 19 +------------------
 drivers/hid/hid-ps3remote.c    | 13 +------------
 drivers/hid/hid-roccat-lua.c   | 14 +-------------
 drivers/hid/hid-saitek.c       | 13 +------------
 drivers/hid/hid-samsung.c      | 13 +------------
 drivers/hid/hid-sensor-hub.c   | 14 +-------------
 drivers/hid/hid-sjoy.c         | 13 +------------
 drivers/hid/hid-sony.c         | 13 +------------
 drivers/hid/hid-speedlink.c    | 13 +------------
 drivers/hid/hid-sunplus.c      | 13 +------------
 drivers/hid/hid-tivo.c         | 13 +------------
 drivers/hid/hid-tmff.c         | 13 +------------
 drivers/hid/hid-topseed.c      | 13 +------------
 drivers/hid/hid-twinhan.c      | 13 +------------
 drivers/hid/hid-uclogic.c      | 13 +------------
 drivers/hid/hid-wacom.c        | 18 +-----------------
 drivers/hid/hid-waltop.c       | 13 +------------
 drivers/hid/hid-wiimote-core.c | 19 +------------------
 drivers/hid/hid-zpff.c         | 13 +------------
 drivers/hid/hid-zydacron.c     | 13 +------------
 54 files changed, 54 insertions(+), 691 deletions(-)

diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 0a23988..7c5507e 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -146,17 +146,6 @@ static struct hid_driver a4_driver = {
 	.probe = a4_probe,
 	.remove = a4_remove,
 };
+module_hid_driver(a4_driver);
 
-static int __init a4_init(void)
-{
-	return hid_register_driver(&a4_driver);
-}
-
-static void __exit a4_exit(void)
-{
-	hid_unregister_driver(&a4_driver);
-}
-
-module_init(a4_init);
-module_exit(a4_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index d0f7662..320a958 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -555,23 +555,6 @@ static struct hid_driver apple_driver = {
 	.input_mapping = apple_input_mapping,
 	.input_mapped = apple_input_mapped,
 };
+module_hid_driver(apple_driver);
 
-static int __init apple_init(void)
-{
-	int ret;
-
-	ret = hid_register_driver(&apple_driver);
-	if (ret)
-		pr_err("can't register apple driver\n");
-
-	return ret;
-}
-
-static void __exit apple_exit(void)
-{
-	hid_unregister_driver(&apple_driver);
-}
-
-module_init(apple_init);
-module_exit(apple_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-aureal.c b/drivers/hid/hid-aureal.c
index 7968187..340ba9d 100644
--- a/drivers/hid/hid-aureal.c
+++ b/drivers/hid/hid-aureal.c
@@ -37,17 +37,6 @@ static struct hid_driver aureal_driver = {
 	.id_table = aureal_devices,
 	.report_fixup = aureal_report_fixup,
 };
+module_hid_driver(aureal_driver);
 
-static int __init aureal_init(void)
-{
-	return hid_register_driver(&aureal_driver);
-}
-
-static void __exit aureal_exit(void)
-{
-	hid_unregister_driver(&aureal_driver);
-}
-
-module_init(aureal_init);
-module_exit(aureal_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-axff.c b/drivers/hid/hid-axff.c
index 5be858d..62f0cee 100644
--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -192,19 +192,7 @@ static struct hid_driver ax_driver = {
 	.probe		= ax_probe,
 	.remove		= ax_remove,
 };
-
-static int __init ax_init(void)
-{
-	return hid_register_driver(&ax_driver);
-}
-
-static void __exit ax_exit(void)
-{
-	hid_unregister_driver(&ax_driver);
-}
-
-module_init(ax_init);
-module_exit(ax_exit);
+module_hid_driver(ax_driver);
 
 MODULE_AUTHOR("Sergei Kolzun");
 MODULE_DESCRIPTION("Force feedback support for ACRUX game controllers");
diff --git a/drivers/hid/hid-belkin.c b/drivers/hid/hid-belkin.c
index a1a5a12..cc4cf13 100644
--- a/drivers/hid/hid-belkin.c
+++ b/drivers/hid/hid-belkin.c
@@ -86,17 +86,6 @@ static struct hid_driver belkin_driver = {
 	.input_mapping = belkin_input_mapping,
 	.probe = belkin_probe,
 };
+module_hid_driver(belkin_driver);
 
-static int __init belkin_init(void)
-{
-	return hid_register_driver(&belkin_driver);
-}
-
-static void __exit belkin_exit(void)
-{
-	hid_unregister_driver(&belkin_driver);
-}
-
-module_init(belkin_init);
-module_exit(belkin_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index af034d3..1bdcccc 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -69,17 +69,6 @@ static struct hid_driver ch_driver = {
 	.report_fixup = ch_report_fixup,
 	.input_mapping = ch_input_mapping,
 };
+module_hid_driver(ch_driver);
 
-static int __init ch_init(void)
-{
-	return hid_register_driver(&ch_driver);
-}
-
-static void __exit ch_exit(void)
-{
-	hid_unregister_driver(&ch_driver);
-}
-
-module_init(ch_init);
-module_exit(ch_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-chicony.c b/drivers/hid/hid-chicony.c
index a2abb8e..b613d5a 100644
--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -70,17 +70,6 @@ static struct hid_driver ch_driver = {
 	.id_table = ch_devices,
 	.input_mapping = ch_input_mapping,
 };
+module_hid_driver(ch_driver);
 
-static int __init ch_init(void)
-{
-	return hid_register_driver(&ch_driver);
-}
-
-static void __exit ch_exit(void)
-{
-	hid_unregister_driver(&ch_driver);
-}
-
-module_init(ch_init);
-module_exit(ch_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-cypress.c b/drivers/hid/hid-cypress.c
index 3e159a5..c4ef3bc 100644
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -144,17 +144,6 @@ static struct hid_driver cp_driver = {
 	.event = cp_event,
 	.probe = cp_probe,
 };
+module_hid_driver(cp_driver);
 
-static int __init cp_init(void)
-{
-	return hid_register_driver(&cp_driver);
-}
-
-static void __exit cp_exit(void)
-{
-	hid_unregister_driver(&cp_driver);
-}
-
-module_init(cp_init);
-module_exit(cp_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-dr.c b/drivers/hid/hid-dr.c
index e832f44..0fe8f65 100644
--- a/drivers/hid/hid-dr.c
+++ b/drivers/hid/hid-dr.c
@@ -297,17 +297,6 @@ static struct hid_driver dr_driver = {
 	.report_fixup = dr_report_fixup,
 	.probe = dr_probe,
 };
+module_hid_driver(dr_driver);
 
-static int __init dr_init(void)
-{
-	return hid_register_driver(&dr_driver);
-}
-
-static void __exit dr_exit(void)
-{
-	hid_unregister_driver(&dr_driver);
-}
-
-module_init(dr_init);
-module_exit(dr_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index 79d0c61..d0bd13b 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -41,17 +41,6 @@ static struct hid_driver elecom_driver = {
 	.id_table = elecom_devices,
 	.report_fixup = elecom_report_fixup
 };
+module_hid_driver(elecom_driver);
 
-static int __init elecom_init(void)
-{
-	return hid_register_driver(&elecom_driver);
-}
-
-static void __exit elecom_exit(void)
-{
-	hid_unregister_driver(&elecom_driver);
-}
-
-module_init(elecom_init);
-module_exit(elecom_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
index 2630d48..2e093ab 100644
--- a/drivers/hid/hid-emsff.c
+++ b/drivers/hid/hid-emsff.c
@@ -150,18 +150,7 @@ static struct hid_driver ems_driver = {
 	.id_table = ems_devices,
 	.probe = ems_probe,
 };
+module_hid_driver(ems_driver);
 
-static int ems_init(void)
-{
-	return hid_register_driver(&ems_driver);
-}
-
-static void ems_exit(void)
-{
-	hid_unregister_driver(&ems_driver);
-}
-
-module_init(ems_init);
-module_exit(ems_exit);
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/hid/hid-ezkey.c b/drivers/hid/hid-ezkey.c
index 6540af2..212ac6b 100644
--- a/drivers/hid/hid-ezkey.c
+++ b/drivers/hid/hid-ezkey.c
@@ -76,17 +76,6 @@ static struct hid_driver ez_driver = {
 	.input_mapping = ez_input_mapping,
 	.event = ez_event,
 };
+module_hid_driver(ez_driver);
 
-static int __init ez_init(void)
-{
-	return hid_register_driver(&ez_driver);
-}
-
-static void __exit ez_exit(void)
-{
-	hid_unregister_driver(&ez_driver);
-}
-
-module_init(ez_init);
-module_exit(ez_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-gaff.c b/drivers/hid/hid-gaff.c
index f1e1bcf..04d2e6a 100644
--- a/drivers/hid/hid-gaff.c
+++ b/drivers/hid/hid-gaff.c
@@ -176,17 +176,6 @@ static struct hid_driver ga_driver = {
 	.id_table = ga_devices,
 	.probe = ga_probe,
 };
+module_hid_driver(ga_driver);
 
-static int __init ga_init(void)
-{
-	return hid_register_driver(&ga_driver);
-}
-
-static void __exit ga_exit(void)
-{
-	hid_unregister_driver(&ga_driver);
-}
-
-module_init(ga_init);
-module_exit(ga_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-generic.c b/drivers/hid/hid-generic.c
index a8b3148..e288a4a 100644
--- a/drivers/hid/hid-generic.c
+++ b/drivers/hid/hid-generic.c
@@ -34,19 +34,7 @@ static struct hid_driver hid_generic = {
 	.name = "hid-generic",
 	.id_table = hid_table,
 };
-
-static int __init hid_init(void)
-{
-	return hid_register_driver(&hid_generic);
-}
-
-static void __exit hid_exit(void)
-{
-	hid_unregister_driver(&hid_generic);
-}
-
-module_init(hid_init);
-module_exit(hid_exit);
+module_hid_driver(hid_generic);
 
 MODULE_AUTHOR("Henrik Rydberg");
 MODULE_DESCRIPTION("HID generic driver");
diff --git a/drivers/hid/hid-gyration.c b/drivers/hid/hid-gyration.c
index 4442c30..288d61c 100644
--- a/drivers/hid/hid-gyration.c
+++ b/drivers/hid/hid-gyration.c
@@ -88,17 +88,6 @@ static struct hid_driver gyration_driver = {
 	.input_mapping = gyration_input_mapping,
 	.event = gyration_event,
 };
+module_hid_driver(gyration_driver);
 
-static int __init gyration_init(void)
-{
-	return hid_register_driver(&gyration_driver);
-}
-
-static void __exit gyration_exit(void)
-{
-	hid_unregister_driver(&gyration_driver);
-}
-
-module_init(gyration_init);
-module_exit(gyration_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-holtek-kbd.c b/drivers/hid/hid-holtek-kbd.c
index e0a5d17..6e1a4a4 100644
--- a/drivers/hid/hid-holtek-kbd.c
+++ b/drivers/hid/hid-holtek-kbd.c
@@ -167,17 +167,6 @@ static struct hid_driver holtek_kbd_driver = {
 	.report_fixup = holtek_kbd_report_fixup,
 	.probe = holtek_kbd_probe
 };
+module_hid_driver(holtek_kbd_driver);
 
-static int __init holtek_kbd_init(void)
-{
-	return hid_register_driver(&holtek_kbd_driver);
-}
-
-static void __exit holtek_kbd_exit(void)
-{
-	hid_unregister_driver(&holtek_kbd_driver);
-}
-
-module_exit(holtek_kbd_exit);
-module_init(holtek_kbd_init);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-holtekff.c b/drivers/hid/hid-holtekff.c
index ff295e6..f34d118 100644
--- a/drivers/hid/hid-holtekff.c
+++ b/drivers/hid/hid-holtekff.c
@@ -224,17 +224,4 @@ static struct hid_driver holtek_driver = {
 	.id_table = holtek_devices,
 	.probe = holtek_probe,
 };
-
-static int __init holtek_init(void)
-{
-	return hid_register_driver(&holtek_driver);
-}
-
-static void __exit holtek_exit(void)
-{
-	hid_unregister_driver(&holtek_driver);
-}
-
-module_init(holtek_init);
-module_exit(holtek_exit);
-
+module_hid_driver(holtek_driver);
diff --git a/drivers/hid/hid-icade.c b/drivers/hid/hid-icade.c
index 1d6565e..09dcc04 100644
--- a/drivers/hid/hid-icade.c
+++ b/drivers/hid/hid-icade.c
@@ -235,25 +235,8 @@ static struct hid_driver icade_driver = {
 	.input_mapped = icade_input_mapped,
 	.input_mapping = icade_input_mapping,
 };
+module_hid_driver(icade_driver);
 
-static int __init icade_init(void)
-{
-	int ret;
-
-	ret = hid_register_driver(&icade_driver);
-	if (ret)
-		pr_err("can't register icade driver\n");
-
-	return ret;
-}
-
-static void __exit icade_exit(void)
-{
-	hid_unregister_driver(&icade_driver);
-}
-
-module_init(icade_init);
-module_exit(icade_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bastien Nocera <hadess@hadess.net>");
 MODULE_DESCRIPTION("ION iCade input driver");
diff --git a/drivers/hid/hid-kensington.c b/drivers/hid/hid-kensington.c
index a5b4016..fe9a99d 100644
--- a/drivers/hid/hid-kensington.c
+++ b/drivers/hid/hid-kensington.c
@@ -47,17 +47,6 @@ static struct hid_driver ks_driver = {
 	.id_table = ks_devices,
 	.input_mapping = ks_input_mapping,
 };
+module_hid_driver(ks_driver);
 
-static int __init ks_init(void)
-{
-	return hid_register_driver(&ks_driver);
-}
-
-static void __exit ks_exit(void)
-{
-	hid_unregister_driver(&ks_driver);
-}
-
-module_init(ks_init);
-module_exit(ks_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-keytouch.c b/drivers/hid/hid-keytouch.c
index 07cd825..3074671 100644
--- a/drivers/hid/hid-keytouch.c
+++ b/drivers/hid/hid-keytouch.c
@@ -49,18 +49,7 @@ static struct hid_driver keytouch_driver = {
 	.id_table = keytouch_devices,
 	.report_fixup = keytouch_report_fixup,
 };
+module_hid_driver(keytouch_driver);
 
-static int __init keytouch_init(void)
-{
-	return hid_register_driver(&keytouch_driver);
-}
-
-static void __exit keytouch_exit(void)
-{
-	hid_unregister_driver(&keytouch_driver);
-}
-
-module_init(keytouch_init);
-module_exit(keytouch_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jiri Kosina");
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index b4f0d82..ef72dae 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -419,17 +419,6 @@ static struct hid_driver kye_driver = {
 	.probe = kye_probe,
 	.report_fixup = kye_report_fixup,
 };
+module_hid_driver(kye_driver);
 
-static int __init kye_init(void)
-{
-	return hid_register_driver(&kye_driver);
-}
-
-static void __exit kye_exit(void)
-{
-	hid_unregister_driver(&kye_driver);
-}
-
-module_init(kye_init);
-module_exit(kye_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-lcpower.c b/drivers/hid/hid-lcpower.c
index 22bc14a..6424cfd 100644
--- a/drivers/hid/hid-lcpower.c
+++ b/drivers/hid/hid-lcpower.c
@@ -54,17 +54,6 @@ static struct hid_driver ts_driver = {
 	.id_table = ts_devices,
 	.input_mapping = ts_input_mapping,
 };
+module_hid_driver(ts_driver);
 
-static int __init ts_init(void)
-{
-	return hid_register_driver(&ts_driver);
-}
-
-static void __exit ts_exit(void)
-{
-	hid_unregister_driver(&ts_driver);
-}
-
-module_init(ts_init);
-module_exit(ts_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index cea016e..956c3b1 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -468,18 +468,6 @@ static struct hid_driver tpkbd_driver = {
 	.probe = tpkbd_probe,
 	.remove = tpkbd_remove,
 };
-
-static int __init tpkbd_init(void)
-{
-	return hid_register_driver(&tpkbd_driver);
-}
-
-static void __exit tpkbd_exit(void)
-{
-	hid_unregister_driver(&tpkbd_driver);
-}
-
-module_init(tpkbd_init);
-module_exit(tpkbd_exit);
+module_hid_driver(tpkbd_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index a2f8e88..e3dc73b 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -503,17 +503,6 @@ static struct hid_driver lg_driver = {
 	.probe = lg_probe,
 	.remove = lg_remove,
 };
+module_hid_driver(lg_driver);
 
-static int __init lg_init(void)
-{
-	return hid_register_driver(&lg_driver);
-}
-
-static void __exit lg_exit(void)
-{
-	hid_unregister_driver(&lg_driver);
-}
-
-module_init(lg_init);
-module_exit(lg_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 25ddf3e..f7f113ba 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -569,23 +569,6 @@ static struct hid_driver magicmouse_driver = {
 	.raw_event = magicmouse_raw_event,
 	.input_mapping = magicmouse_input_mapping,
 };
+module_hid_driver(magicmouse_driver);
 
-static int __init magicmouse_init(void)
-{
-	int ret;
-
-	ret = hid_register_driver(&magicmouse_driver);
-	if (ret)
-		pr_err("can't register magicmouse driver\n");
-
-	return ret;
-}
-
-static void __exit magicmouse_exit(void)
-{
-	hid_unregister_driver(&magicmouse_driver);
-}
-
-module_init(magicmouse_init);
-module_exit(magicmouse_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 6fcd466..29d27f6 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -221,17 +221,6 @@ static struct hid_driver ms_driver = {
 	.event = ms_event,
 	.probe = ms_probe,
 };
+module_hid_driver(ms_driver);
 
-static int __init ms_init(void)
-{
-	return hid_register_driver(&ms_driver);
-}
-
-static void __exit ms_exit(void)
-{
-	hid_unregister_driver(&ms_driver);
-}
-
-module_init(ms_init);
-module_exit(ms_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index cd3643e..9e14c00 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -63,17 +63,6 @@ static struct hid_driver mr_driver = {
 	.report_fixup = mr_report_fixup,
 	.input_mapping = mr_input_mapping,
 };
+module_hid_driver(mr_driver);
 
-static int __init mr_init(void)
-{
-	return hid_register_driver(&mr_driver);
-}
-
-static void __exit mr_exit(void)
-{
-	hid_unregister_driver(&mr_driver);
-}
-
-module_init(mr_init);
-module_exit(mr_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 61543c0..46d8136 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1198,16 +1198,4 @@ static struct hid_driver mt_driver = {
 	.resume = mt_resume,
 #endif
 };
-
-static int __init mt_init(void)
-{
-	return hid_register_driver(&mt_driver);
-}
-
-static void __exit mt_exit(void)
-{
-	hid_unregister_driver(&mt_driver);
-}
-
-module_init(mt_init);
-module_exit(mt_exit);
+module_hid_driver(mt_driver);
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 86a969f..2ffc0e3 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -1026,17 +1026,6 @@ static struct hid_driver ntrig_driver = {
 	.usage_table = ntrig_grabbed_usages,
 	.event = ntrig_event,
 };
+module_hid_driver(ntrig_driver);
 
-static int __init ntrig_init(void)
-{
-	return hid_register_driver(&ntrig_driver);
-}
-
-static void __exit ntrig_exit(void)
-{
-	hid_unregister_driver(&ntrig_driver);
-}
-
-module_init(ntrig_init);
-module_exit(ntrig_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-ortek.c b/drivers/hid/hid-ortek.c
index 0ffa1d2..6620f15 100644
--- a/drivers/hid/hid-ortek.c
+++ b/drivers/hid/hid-ortek.c
@@ -50,17 +50,6 @@ static struct hid_driver ortek_driver = {
 	.id_table = ortek_devices,
 	.report_fixup = ortek_report_fixup
 };
+module_hid_driver(ortek_driver);
 
-static int __init ortek_init(void)
-{
-	return hid_register_driver(&ortek_driver);
-}
-
-static void __exit ortek_exit(void)
-{
-	hid_unregister_driver(&ortek_driver);
-}
-
-module_init(ortek_init);
-module_exit(ortek_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index 4c521de..736b250 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -103,17 +103,6 @@ static struct hid_driver pl_driver = {
 	.input_mapping = pl_input_mapping,
 	.probe = pl_probe,
 };
+module_hid_driver(pl_driver);
 
-static int __init pl_init(void)
-{
-	return hid_register_driver(&pl_driver);
-}
-
-static void __exit pl_exit(void)
-{
-	hid_unregister_driver(&pl_driver);
-}
-
-module_init(pl_init);
-module_exit(pl_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 86df26e..31cd93f 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -672,18 +672,7 @@ static struct hid_driver picolcd_driver = {
 	.reset_resume =  picolcd_reset_resume,
 #endif
 };
+module_hid_driver(picolcd_driver);
 
-static int __init picolcd_init(void)
-{
-	return hid_register_driver(&picolcd_driver);
-}
-
-static void __exit picolcd_exit(void)
-{
-	hid_unregister_driver(&picolcd_driver);
-}
-
-module_init(picolcd_init);
-module_exit(picolcd_exit);
 MODULE_DESCRIPTION("Minibox graphics PicoLCD Driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 47ed74c4..123977e 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -216,17 +216,6 @@ static struct hid_driver pl_driver = {
 	.id_table = pl_devices,
 	.probe = pl_probe,
 };
+module_hid_driver(pl_driver);
 
-static int __init pl_init(void)
-{
-	return hid_register_driver(&pl_driver);
-}
-
-static void __exit pl_exit(void)
-{
-	hid_unregister_driver(&pl_driver);
-}
-
-module_init(pl_init);
-module_exit(pl_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-primax.c b/drivers/hid/hid-primax.c
index c15adb0..3a1c3c4 100644
--- a/drivers/hid/hid-primax.c
+++ b/drivers/hid/hid-primax.c
@@ -75,18 +75,7 @@ static struct hid_driver px_driver = {
 	.id_table = px_devices,
 	.raw_event = px_raw_event,
 };
+module_hid_driver(px_driver);
 
-static int __init px_init(void)
-{
-	return hid_register_driver(&px_driver);
-}
-
-static void __exit px_exit(void)
-{
-	hid_unregister_driver(&px_driver);
-}
-
-module_init(px_init);
-module_exit(px_exit);
 MODULE_AUTHOR("Terry Lambert <tlambert@google.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index ec8ca33..4e1c4bc 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -889,23 +889,6 @@ static struct hid_driver pk_driver = {
 	.probe = pk_probe,
 	.remove = pk_remove,
 };
+module_hid_driver(pk_driver);
 
-static int pk_init(void)
-{
-	int ret;
-
-	ret = hid_register_driver(&pk_driver);
-	if (ret)
-		pr_err("can't register prodikeys driver\n");
-
-	return ret;
-}
-
-static void pk_exit(void)
-{
-	hid_unregister_driver(&pk_driver);
-}
-
-module_init(pk_init);
-module_exit(pk_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-ps3remote.c b/drivers/hid/hid-ps3remote.c
index 03811e5..f1239d3 100644
--- a/drivers/hid/hid-ps3remote.c
+++ b/drivers/hid/hid-ps3remote.c
@@ -198,18 +198,7 @@ static struct hid_driver ps3remote_driver = {
 	.report_fixup  = ps3remote_fixup,
 	.input_mapping = ps3remote_mapping,
 };
+module_hid_driver(ps3remote_driver);
 
-static int __init ps3remote_init(void)
-{
-	return hid_register_driver(&ps3remote_driver);
-}
-
-static void __exit ps3remote_exit(void)
-{
-	hid_unregister_driver(&ps3remote_driver);
-}
-
-module_init(ps3remote_init);
-module_exit(ps3remote_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Dillow <dave@thedillows.org>, Antonio Ospite <ospite@studenti.unina.it>");
diff --git a/drivers/hid/hid-roccat-lua.c b/drivers/hid/hid-roccat-lua.c
index 5084fb4..6adc0fa 100644
--- a/drivers/hid/hid-roccat-lua.c
+++ b/drivers/hid/hid-roccat-lua.c
@@ -208,19 +208,7 @@ static struct hid_driver lua_driver = {
 		.probe = lua_probe,
 		.remove = lua_remove
 };
-
-static int __init lua_init(void)
-{
-	return hid_register_driver(&lua_driver);
-}
-
-static void __exit lua_exit(void)
-{
-	hid_unregister_driver(&lua_driver);
-}
-
-module_init(lua_init);
-module_exit(lua_exit);
+module_hid_driver(lua_driver);
 
 MODULE_AUTHOR("Stefan Achatz");
 MODULE_DESCRIPTION("USB Roccat Lua driver");
diff --git a/drivers/hid/hid-saitek.c b/drivers/hid/hid-saitek.c
index 45aea77..37961c7 100644
--- a/drivers/hid/hid-saitek.c
+++ b/drivers/hid/hid-saitek.c
@@ -54,17 +54,6 @@ static struct hid_driver saitek_driver = {
 	.id_table = saitek_devices,
 	.report_fixup = saitek_report_fixup
 };
+module_hid_driver(saitek_driver);
 
-static int __init saitek_init(void)
-{
-	return hid_register_driver(&saitek_driver);
-}
-
-static void __exit saitek_exit(void)
-{
-	hid_unregister_driver(&saitek_driver);
-}
-
-module_init(saitek_init);
-module_exit(saitek_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
index a5821d3..7cbb067 100644
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -196,17 +196,6 @@ static struct hid_driver samsung_driver = {
 	.input_mapping = samsung_input_mapping,
 	.probe = samsung_probe,
 };
+module_hid_driver(samsung_driver);
 
-static int __init samsung_init(void)
-{
-	return hid_register_driver(&samsung_driver);
-}
-
-static void __exit samsung_exit(void)
-{
-	hid_unregister_driver(&samsung_driver);
-}
-
-module_init(samsung_init);
-module_exit(samsung_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 0bc58bd..4179f5e 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -627,19 +627,7 @@ static struct hid_driver sensor_hub_driver = {
 	.reset_resume =  sensor_hub_reset_resume,
 #endif
 };
-
-static int __init sensor_hub_init(void)
-{
-	return hid_register_driver(&sensor_hub_driver);
-}
-
-static void __exit sensor_hub_exit(void)
-{
-	hid_unregister_driver(&sensor_hub_driver);
-}
-
-module_init(sensor_hub_init);
-module_exit(sensor_hub_exit);
+module_hid_driver(sensor_hub_driver);
 
 MODULE_DESCRIPTION("HID Sensor Hub driver");
 MODULE_AUTHOR("Srinivas Pandruvada <srinivas.pandruvada@intel.com>");
diff --git a/drivers/hid/hid-sjoy.c b/drivers/hid/hid-sjoy.c
index 42257ac..28f7740 100644
--- a/drivers/hid/hid-sjoy.c
+++ b/drivers/hid/hid-sjoy.c
@@ -177,19 +177,8 @@ static struct hid_driver sjoy_driver = {
 	.id_table = sjoy_devices,
 	.probe = sjoy_probe,
 };
+module_hid_driver(sjoy_driver);
 
-static int __init sjoy_init(void)
-{
-	return hid_register_driver(&sjoy_driver);
-}
-
-static void __exit sjoy_exit(void)
-{
-	hid_unregister_driver(&sjoy_driver);
-}
-
-module_init(sjoy_init);
-module_exit(sjoy_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jussi Kivilinna");
 
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 7f33ebf..23fc762 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -229,17 +229,6 @@ static struct hid_driver sony_driver = {
 	.report_fixup = sony_report_fixup,
 	.raw_event = sony_raw_event
 };
+module_hid_driver(sony_driver);
 
-static int __init sony_init(void)
-{
-	return hid_register_driver(&sony_driver);
-}
-
-static void __exit sony_exit(void)
-{
-	hid_unregister_driver(&sony_driver);
-}
-
-module_init(sony_init);
-module_exit(sony_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-speedlink.c b/drivers/hid/hid-speedlink.c
index 6020137..e94371a 100644
--- a/drivers/hid/hid-speedlink.c
+++ b/drivers/hid/hid-speedlink.c
@@ -73,17 +73,6 @@ static struct hid_driver speedlink_driver = {
 	.input_mapping = speedlink_input_mapping,
 	.event = speedlink_event,
 };
+module_hid_driver(speedlink_driver);
 
-static int __init speedlink_init(void)
-{
-	return hid_register_driver(&speedlink_driver);
-}
-
-static void __exit speedlink_exit(void)
-{
-	hid_unregister_driver(&speedlink_driver);
-}
-
-module_init(speedlink_init);
-module_exit(speedlink_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index 45b4b06..87fc91e 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -63,17 +63,6 @@ static struct hid_driver sp_driver = {
 	.report_fixup = sp_report_fixup,
 	.input_mapping = sp_input_mapping,
 };
+module_hid_driver(sp_driver);
 
-static int __init sp_init(void)
-{
-	return hid_register_driver(&sp_driver);
-}
-
-static void __exit sp_exit(void)
-{
-	hid_unregister_driver(&sp_driver);
-}
-
-module_init(sp_init);
-module_exit(sp_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-tivo.c b/drivers/hid/hid-tivo.c
index 9f85f82..d790d8d 100644
--- a/drivers/hid/hid-tivo.c
+++ b/drivers/hid/hid-tivo.c
@@ -73,18 +73,7 @@ static struct hid_driver tivo_driver = {
 	.id_table = tivo_devices,
 	.input_mapping = tivo_input_mapping,
 };
+module_hid_driver(tivo_driver);
 
-static int __init tivo_init(void)
-{
-	return hid_register_driver(&tivo_driver);
-}
-
-static void __exit tivo_exit(void)
-{
-	hid_unregister_driver(&tivo_driver);
-}
-
-module_init(tivo_init);
-module_exit(tivo_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
index 83a933b..e4fcf3f 100644
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -261,17 +261,6 @@ static struct hid_driver tm_driver = {
 	.id_table = tm_devices,
 	.probe = tm_probe,
 };
+module_hid_driver(tm_driver);
 
-static int __init tm_init(void)
-{
-	return hid_register_driver(&tm_driver);
-}
-
-static void __exit tm_exit(void)
-{
-	hid_unregister_driver(&tm_driver);
-}
-
-module_init(tm_init);
-module_exit(tm_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-topseed.c b/drivers/hid/hid-topseed.c
index 613ff7b..8a5b843 100644
--- a/drivers/hid/hid-topseed.c
+++ b/drivers/hid/hid-topseed.c
@@ -76,17 +76,6 @@ static struct hid_driver ts_driver = {
 	.id_table = ts_devices,
 	.input_mapping = ts_input_mapping,
 };
+module_hid_driver(ts_driver);
 
-static int __init ts_init(void)
-{
-	return hid_register_driver(&ts_driver);
-}
-
-static void __exit ts_exit(void)
-{
-	hid_unregister_driver(&ts_driver);
-}
-
-module_init(ts_init);
-module_exit(ts_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-twinhan.c b/drivers/hid/hid-twinhan.c
index f23456b..c08c364 100644
--- a/drivers/hid/hid-twinhan.c
+++ b/drivers/hid/hid-twinhan.c
@@ -131,17 +131,6 @@ static struct hid_driver twinhan_driver = {
 	.id_table = twinhan_devices,
 	.input_mapping = twinhan_input_mapping,
 };
+module_hid_driver(twinhan_driver);
 
-static int __init twinhan_init(void)
-{
-	return hid_register_driver(&twinhan_driver);
-}
-
-static void __exit twinhan_exit(void)
-{
-	hid_unregister_driver(&twinhan_driver);
-}
-
-module_init(twinhan_init);
-module_exit(twinhan_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-uclogic.c b/drivers/hid/hid-uclogic.c
index 2e56a1f..fb8b516 100644
--- a/drivers/hid/hid-uclogic.c
+++ b/drivers/hid/hid-uclogic.c
@@ -650,17 +650,6 @@ static struct hid_driver uclogic_driver = {
 	.id_table = uclogic_devices,
 	.report_fixup = uclogic_report_fixup,
 };
+module_hid_driver(uclogic_driver);
 
-static int __init uclogic_init(void)
-{
-	return hid_register_driver(&uclogic_driver);
-}
-
-static void __exit uclogic_exit(void)
-{
-	hid_unregister_driver(&uclogic_driver);
-}
-
-module_init(uclogic_init);
-module_exit(uclogic_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 2f60da9..a4a8bb0 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -953,23 +953,7 @@ static struct hid_driver wacom_driver = {
 	.raw_event = wacom_raw_event,
 	.input_mapped = wacom_input_mapped,
 };
+module_hid_driver(wacom_driver);
 
-static int __init wacom_init(void)
-{
-	int ret;
-
-	ret = hid_register_driver(&wacom_driver);
-	if (ret)
-		pr_err("can't register wacom driver\n");
-	return ret;
-}
-
-static void __exit wacom_exit(void)
-{
-	hid_unregister_driver(&wacom_driver);
-}
-
-module_init(wacom_init);
-module_exit(wacom_exit);
 MODULE_DESCRIPTION("Driver for Wacom Graphire Bluetooth and Wacom Intuos4 WL");
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-waltop.c b/drivers/hid/hid-waltop.c
index bb536ab..059931d 100644
--- a/drivers/hid/hid-waltop.c
+++ b/drivers/hid/hid-waltop.c
@@ -779,17 +779,6 @@ static struct hid_driver waltop_driver = {
 	.report_fixup = waltop_report_fixup,
 	.raw_event = waltop_raw_event,
 };
+module_hid_driver(waltop_driver);
 
-static int __init waltop_init(void)
-{
-	return hid_register_driver(&waltop_driver);
-}
-
-static void __exit waltop_exit(void)
-{
-	hid_unregister_driver(&waltop_driver);
-}
-
-module_init(waltop_init);
-module_exit(waltop_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-wiimote-core.c b/drivers/hid/hid-wiimote-core.c
index 84e2fbe..0fb8ab9 100644
--- a/drivers/hid/hid-wiimote-core.c
+++ b/drivers/hid/hid-wiimote-core.c
@@ -1294,25 +1294,8 @@ static struct hid_driver wiimote_hid_driver = {
 	.remove = wiimote_hid_remove,
 	.raw_event = wiimote_hid_event,
 };
+module_hid_driver(wiimote_hid_driver);
 
-static int __init wiimote_init(void)
-{
-	int ret;
-
-	ret = hid_register_driver(&wiimote_hid_driver);
-	if (ret)
-		pr_err("Can't register wiimote hid driver\n");
-
-	return ret;
-}
-
-static void __exit wiimote_exit(void)
-{
-	hid_unregister_driver(&wiimote_hid_driver);
-}
-
-module_init(wiimote_init);
-module_exit(wiimote_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Herrmann <dh.herrmann@gmail.com>");
 MODULE_DESCRIPTION(WIIMOTE_NAME " Device Driver");
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index f6ba81d..af66452 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -152,17 +152,6 @@ static struct hid_driver zp_driver = {
 	.id_table = zp_devices,
 	.probe = zp_probe,
 };
+module_hid_driver(zp_driver);
 
-static int __init zp_init(void)
-{
-	return hid_register_driver(&zp_driver);
-}
-
-static void __exit zp_exit(void)
-{
-	hid_unregister_driver(&zp_driver);
-}
-
-module_init(zp_init);
-module_exit(zp_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index 1ad85f2..e4cddec 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -219,17 +219,6 @@ static struct hid_driver zc_driver = {
 	.probe = zc_probe,
 	.remove = zc_remove,
 };
+module_hid_driver(zc_driver);
 
-static int __init zc_init(void)
-{
-	return hid_register_driver(&zc_driver);
-}
-
-static void __exit zc_exit(void)
-{
-	hid_unregister_driver(&zc_driver);
-}
-
-module_init(zc_init);
-module_exit(zc_exit);
 MODULE_LICENSE("GPL");
-- 
1.8.0.2

