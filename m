Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0HRRHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:07:55 -0400
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:47014 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0HRRHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:07:52 -0400
X-MXL-Hash: 4c6c13683f0656f9-318d0695d20704754499b87caa809164a613e43d
X-MXL-Hash: 4c6c136276b0b0c8-b70ba54eed215df79ff47f257a550511cbeea9e4
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] iforce: simplify Kconfig depends
Date: Wed, 18 Aug 2010 10:06:26 -0700
User-Agent: KMail/1.9.9
CC: <linux-input@vger.kernel.org>, <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201008181006.26891.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010073001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.69]
X-AnalysisOut: [v=1.0 c=1 a=XLNWzD5YKggA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=TYbMNos9eHUa9bm6/o8foQ==:17 a=i00gxMtYAAAA:8 a=pGL]
X-AnalysisOut: [kceISAAAA:8 a=_y17fJiv0vX0ZqiV1OUA:9 a=hIfqF_4EheyXgI0n0g1]
X-AnalysisOut: [nvrC4Ax0A:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=MSl-tDqO]
X-AnalysisOut: [z04A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The depends on for JOYSTICK_IFORCE is already handled in drivers/input/Kconfig and
drivers/input/joystick/Kconfig.

Remove the depends on JOYSTICK_IFORCE for the *_USB and *_232 connections
by wrapping them in an if/endif block. The second depends on check is still needed
to prevent the iforce driver from being built-in while the connection is a module.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

---

Should the connection depends on be changed to a select similar to the other
joystick drivers?

diff --git a/drivers/input/joystick/iforce/Kconfig b/drivers/input/joystick/iforce/Kconfig
index 8fde22a..d5fa68d 100644
--- a/drivers/input/joystick/iforce/Kconfig
+++ b/drivers/input/joystick/iforce/Kconfig
@@ -3,7 +3,6 @@
 #
 config JOYSTICK_IFORCE
 	tristate "I-Force devices"
-	depends on INPUT && INPUT_JOYSTICK
 	help
 	  Say Y here if you have an I-Force joystick or steering wheel
 
@@ -12,16 +11,18 @@ config JOYSTICK_IFORCE
 	  To compile this driver as a module, choose M here: the
 	  module will be called iforce.
 
+if JOYSTICK_IFORCE
+
 config JOYSTICK_IFORCE_USB
 	bool "I-Force USB joysticks and wheels"
-	depends on JOYSTICK_IFORCE && (JOYSTICK_IFORCE=m || USB=y) && USB
+	depends on (JOYSTICK_IFORCE=m || USB=y) && USB
 	help
 	  Say Y here if you have an I-Force joystick or steering wheel
 	  connected to your USB port.
 
 config JOYSTICK_IFORCE_232
 	bool "I-Force Serial joysticks and wheels"
-	depends on JOYSTICK_IFORCE && (JOYSTICK_IFORCE=m || SERIO=y) && SERIO
+	depends on (JOYSTICK_IFORCE=m || SERIO=y) && SERIO
 	help
 	  Say Y here if you have an I-Force joystick or steering wheel
 	  connected to your serial (COM) port.
@@ -30,3 +31,4 @@ config JOYSTICK_IFORCE_232
 	  <file:Documentation/input/joystick.txt>
 	  and <file:Documentation/input/ff.txt>.
 
+endif
