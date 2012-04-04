Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2DDDeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 23:34:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57182 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab2DDDd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 23:33:59 -0400
Message-ID: <1333510434.15318.12.camel@phoenix>
Subject: [PATCH 2/2] Input: use module_gameport_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@mail.ru>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-input@vger.kernel.org
Date: Wed, 04 Apr 2012 11:33:54 +0800
In-Reply-To: <1333510350.15318.10.camel@phoenix>
References: <1333510350.15318.10.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/input/* to use
module_gameport_driver() macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/joystick/a3d.c        |   13 +------------
 drivers/input/joystick/adi.c        |   17 +----------------
 drivers/input/joystick/cobra.c      |   13 +------------
 drivers/input/joystick/gf2k.c       |   13 +------------
 drivers/input/joystick/grip.c       |   13 +------------
 drivers/input/joystick/grip_mp.c    |   13 +------------
 drivers/input/joystick/guillemot.c  |   13 +------------
 drivers/input/joystick/interact.c   |   13 +------------
 drivers/input/joystick/joydump.c    |   13 +------------
 drivers/input/joystick/sidewinder.c |   13 +------------
 drivers/input/joystick/tmdc.c       |   13 +------------
 11 files changed, 11 insertions(+), 136 deletions(-)

diff --git a/drivers/input/joystick/a3d.c b/drivers/input/joystick/a3d.c
index 1639ab2..85bc8dc 100644
--- a/drivers/input/joystick/a3d.c
+++ b/drivers/input/joystick/a3d.c
@@ -413,15 +413,4 @@ static struct gameport_driver a3d_drv = {
 	.disconnect	= a3d_disconnect,
 };
 
-static int __init a3d_init(void)
-{
-	return gameport_register_driver(&a3d_drv);
-}
-
-static void __exit a3d_exit(void)
-{
-	gameport_unregister_driver(&a3d_drv);
-}
-
-module_init(a3d_init);
-module_exit(a3d_exit);
+module_gameport_driver(a3d_drv);
diff --git a/drivers/input/joystick/adi.c b/drivers/input/joystick/adi.c
index b992fbf..0cbfd2d 100644
--- a/drivers/input/joystick/adi.c
+++ b/drivers/input/joystick/adi.c
@@ -557,10 +557,6 @@ static void adi_disconnect(struct gameport *gameport)
 	kfree(port);
 }
 
-/*
- * The gameport device structure.
- */
-
 static struct gameport_driver adi_drv = {
 	.driver		= {
 		.name	= "adi",
@@ -570,15 +566,4 @@ static struct gameport_driver adi_drv = {
 	.disconnect	= adi_disconnect,
 };
 
-static int __init adi_init(void)
-{
-	return gameport_register_driver(&adi_drv);
-}
-
-static void __exit adi_exit(void)
-{
-	gameport_unregister_driver(&adi_drv);
-}
-
-module_init(adi_init);
-module_exit(adi_exit);
+module_gameport_driver(adi_drv);
diff --git a/drivers/input/joystick/cobra.c b/drivers/input/joystick/cobra.c
index 3497b87..65367e4 100644
--- a/drivers/input/joystick/cobra.c
+++ b/drivers/input/joystick/cobra.c
@@ -261,15 +261,4 @@ static struct gameport_driver cobra_drv = {
 	.disconnect	= cobra_disconnect,
 };
 
-static int __init cobra_init(void)
-{
-	return gameport_register_driver(&cobra_drv);
-}
-
-static void __exit cobra_exit(void)
-{
-	gameport_unregister_driver(&cobra_drv);
-}
-
-module_init(cobra_init);
-module_exit(cobra_exit);
+module_gameport_driver(cobra_drv);
diff --git a/drivers/input/joystick/gf2k.c b/drivers/input/joystick/gf2k.c
index 0536b1b..ab1cf28 100644
--- a/drivers/input/joystick/gf2k.c
+++ b/drivers/input/joystick/gf2k.c
@@ -373,15 +373,4 @@ static struct gameport_driver gf2k_drv = {
 	.disconnect	= gf2k_disconnect,
 };
 
-static int __init gf2k_init(void)
-{
-	return gameport_register_driver(&gf2k_drv);
-}
-
-static void __exit gf2k_exit(void)
-{
-	gameport_unregister_driver(&gf2k_drv);
-}
-
-module_init(gf2k_init);
-module_exit(gf2k_exit);
+module_gameport_driver(gf2k_drv);
diff --git a/drivers/input/joystick/grip.c b/drivers/input/joystick/grip.c
index fc55899..9e1beff 100644
--- a/drivers/input/joystick/grip.c
+++ b/drivers/input/joystick/grip.c
@@ -424,15 +424,4 @@ static struct gameport_driver grip_drv = {
 	.disconnect	= grip_disconnect,
 };
 
-static int __init grip_init(void)
-{
-	return gameport_register_driver(&grip_drv);
-}
-
-static void __exit grip_exit(void)
-{
-	gameport_unregister_driver(&grip_drv);
-}
-
-module_init(grip_init);
-module_exit(grip_exit);
+module_gameport_driver(grip_drv);
diff --git a/drivers/input/joystick/grip_mp.c b/drivers/input/joystick/grip_mp.c
index 2d47baf..c0f9c7b 100644
--- a/drivers/input/joystick/grip_mp.c
+++ b/drivers/input/joystick/grip_mp.c
@@ -687,15 +687,4 @@ static struct gameport_driver grip_drv = {
 	.disconnect	= grip_disconnect,
 };
 
-static int __init grip_init(void)
-{
-	return gameport_register_driver(&grip_drv);
-}
-
-static void __exit grip_exit(void)
-{
-	gameport_unregister_driver(&grip_drv);
-}
-
-module_init(grip_init);
-module_exit(grip_exit);
+module_gameport_driver(grip_drv);
diff --git a/drivers/input/joystick/guillemot.c b/drivers/input/joystick/guillemot.c
index 4058d4b..55196f7 100644
--- a/drivers/input/joystick/guillemot.c
+++ b/drivers/input/joystick/guillemot.c
@@ -281,15 +281,4 @@ static struct gameport_driver guillemot_drv = {
 	.disconnect	= guillemot_disconnect,
 };
 
-static int __init guillemot_init(void)
-{
-	return gameport_register_driver(&guillemot_drv);
-}
-
-static void __exit guillemot_exit(void)
-{
-	gameport_unregister_driver(&guillemot_drv);
-}
-
-module_init(guillemot_init);
-module_exit(guillemot_exit);
+module_gameport_driver(guillemot_drv);
diff --git a/drivers/input/joystick/interact.c b/drivers/input/joystick/interact.c
index 16fb19d..88c2262 100644
--- a/drivers/input/joystick/interact.c
+++ b/drivers/input/joystick/interact.c
@@ -311,15 +311,4 @@ static struct gameport_driver interact_drv = {
 	.disconnect	= interact_disconnect,
 };
 
-static int __init interact_init(void)
-{
-	return gameport_register_driver(&interact_drv);
-}
-
-static void __exit interact_exit(void)
-{
-	gameport_unregister_driver(&interact_drv);
-}
-
-module_init(interact_init);
-module_exit(interact_exit);
+module_gameport_driver(interact_drv);
diff --git a/drivers/input/joystick/joydump.c b/drivers/input/joystick/joydump.c
index cd894a0..7eb878b 100644
--- a/drivers/input/joystick/joydump.c
+++ b/drivers/input/joystick/joydump.c
@@ -159,15 +159,4 @@ static struct gameport_driver joydump_drv = {
 	.disconnect	= joydump_disconnect,
 };
 
-static int __init joydump_init(void)
-{
-	return gameport_register_driver(&joydump_drv);
-}
-
-static void __exit joydump_exit(void)
-{
-	gameport_unregister_driver(&joydump_drv);
-}
-
-module_init(joydump_init);
-module_exit(joydump_exit);
+module_gameport_driver(joydump_drv);
diff --git a/drivers/input/joystick/sidewinder.c b/drivers/input/joystick/sidewinder.c
index b8d8611..04c69af 100644
--- a/drivers/input/joystick/sidewinder.c
+++ b/drivers/input/joystick/sidewinder.c
@@ -820,15 +820,4 @@ static struct gameport_driver sw_drv = {
 	.disconnect	= sw_disconnect,
 };
 
-static int __init sw_init(void)
-{
-	return gameport_register_driver(&sw_drv);
-}
-
-static void __exit sw_exit(void)
-{
-	gameport_unregister_driver(&sw_drv);
-}
-
-module_init(sw_init);
-module_exit(sw_exit);
+module_gameport_driver(sw_drv);
diff --git a/drivers/input/joystick/tmdc.c b/drivers/input/joystick/tmdc.c
index d6c6098..5ef9bcd 100644
--- a/drivers/input/joystick/tmdc.c
+++ b/drivers/input/joystick/tmdc.c
@@ -436,15 +436,4 @@ static struct gameport_driver tmdc_drv = {
 	.disconnect	= tmdc_disconnect,
 };
 
-static int __init tmdc_init(void)
-{
-	return gameport_register_driver(&tmdc_drv);
-}
-
-static void __exit tmdc_exit(void)
-{
-	gameport_unregister_driver(&tmdc_drv);
-}
-
-module_init(tmdc_init);
-module_exit(tmdc_exit);
+module_gameport_driver(tmdc_drv);
-- 
1.7.5.4



