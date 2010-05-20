Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab0ETVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:09:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26034 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0ETVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:09:51 -0400
Date: Thu, 20 May 2010 14:08:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, InKi Dae <inki.dae@samsung.com>,
       Richard Purdie <rpurdie@rpsys.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -mmotm] backlight: fix s6e63m0 kconfig
Message-Id: <20100520140829.11233713.randy.dunlap@oracle.com>
In-Reply-To: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BF5A4F0.010D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig file dependency and help text.
Move the driver's Kconfig symbol inside the LCD_CLASS_DEVICE block.

When CONFIG_BACKLIGHT_CLASS_DEVICE is not enabled:
ERROR: "backlight_device_register" [drivers/video/backlight/s6e63m0.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: InKi Dae  <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
Looks like several backlight/LCD drivers have this kind of relationship.

 drivers/video/backlight/Kconfig |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- mmotm-2010-0519-1612.orig/drivers/video/backlight/Kconfig
+++ mmotm-2010-0519-1612/drivers/video/backlight/Kconfig
@@ -101,14 +101,16 @@ config LCD_HP700
 	  If you have an HP Jornada 700 series handheld (710/720/728)
 	  say Y to enable LCD control driver.
 
-endif # LCD_CLASS_DEVICE
-
 config LCD_S6E63M0
 	tristate "S6E63M0 AMOLED LCD Driver"
-	depends on LCD_CLASS_DEVICE && SPI
+	depends on SPI && BACKLIGHT_CLASS_DEVICE
 	default n
 	help
-	  If you have an S6E63M0 LCD Panel say Y to enable LCD control driver
+	  If you have an S6E63M0 LCD Panel, say Y to enable its
+	  LCD control driver.
+
+endif # LCD_CLASS_DEVICE
+
 #
 # Backlight
 #
