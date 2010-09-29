Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab0I2Tpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:45:34 -0400
Received: from cmx.wol.de ([193.158.62.4]:43507 "EHLO cmx.wol.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab0I2Tpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:45:33 -0400
X-Greylist: delayed 1466 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2010 15:45:32 EDT
Message-ID: <4CA391B3.1030806@wol.de>
Date: Wed, 29 Sep 2010 21:21:23 +0200
From: "Marc - A. Dahlhaus" <mad@wol.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix capi devicenames
Content-Type: multipart/mixed;
 boundary="------------040502020506020202080209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040502020506020202080209
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

capi device names should get changed to what userspace expects.
Without this change recent udev versions can't produce working device
nodes as the capi control device node name "capi" collides with the
"capi" directory under which userspace expects to get the application
device nodes. This also fixes the Documentation.

Signed-off-by: Marc - Andre Dahlhaus <mad@wol.de>

--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -1248,10 +1248,10 @@ Your cooperation is appreciated.

  68 char	CAPI 2.0 interface
 		  0 = /dev/capi20	Control device
-		  1 = /dev/capi20.00	First CAPI 2.0 application
-		  2 = /dev/capi20.01	Second CAPI 2.0 application
+		  1 = /dev/capi/0	First CAPI 2.0 application
+		  2 = /dev/capi/1	Second CAPI 2.0 application
 		    ...
-		 20 = /dev/capi20.19	19th CAPI 2.0 application
+		 20 = /dev/capi/19	19th CAPI 2.0 application

 		ISDN CAPI 2.0 driver for use with CAPI 2.0
 		applications; currently supports the AVM B1 card.
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1363,7 +1363,7 @@ static int __init capinc_tty_init(void)
 	}
 	drv->owner = THIS_MODULE;
 	drv->driver_name = "capi_nc";
-	drv->name = "capi";
+	drv->name = "capi/";
 	drv->major = 0;
 	drv->minor_start = 0;
 	drv->type = TTY_DRIVER_TYPE_SERIAL;
@@ -1509,7 +1509,7 @@ static int __init capi_init(void)
 		return PTR_ERR(capi_class);
 	}

-	device_create(capi_class, NULL, MKDEV(capi_major, 0), NULL, "capi");
+	device_create(capi_class, NULL, MKDEV(capi_major, 0), NULL, "capi20");

 	if (capinc_tty_init() < 0) {
 		device_destroy(capi_class, MKDEV(capi_major, 0));

--------------040502020506020202080209
Content-Type: text/plain;
 name="capi-name.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="capi-name.patch"

capi device names should get changed to what userspace expects.
Without this change recent udev versions can't produce working device
nodes as the capi control device node name "capi" collides with the
"capi" directory under which userspace expects to get the application
device nodes. This also fixes the Documentation.

Signed-off-by: Marc - Andre Dahlhaus <mad@wol.de>

--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -1248,10 +1248,10 @@ Your cooperation is appreciated.
 
  68 char	CAPI 2.0 interface
 		  0 = /dev/capi20	Control device
-		  1 = /dev/capi20.00	First CAPI 2.0 application
-		  2 = /dev/capi20.01	Second CAPI 2.0 application
+		  1 = /dev/capi/0	First CAPI 2.0 application
+		  2 = /dev/capi/1	Second CAPI 2.0 application
 		    ...
-		 20 = /dev/capi20.19	19th CAPI 2.0 application
+		 20 = /dev/capi/19	19th CAPI 2.0 application
 
 		ISDN CAPI 2.0 driver for use with CAPI 2.0
 		applications; currently supports the AVM B1 card.
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1363,7 +1363,7 @@ static int __init capinc_tty_init(void)
 	}
 	drv->owner = THIS_MODULE;
 	drv->driver_name = "capi_nc";
-	drv->name = "capi";
+	drv->name = "capi/";
 	drv->major = 0;
 	drv->minor_start = 0;
 	drv->type = TTY_DRIVER_TYPE_SERIAL;
@@ -1509,7 +1509,7 @@ static int __init capi_init(void)
 		return PTR_ERR(capi_class);
 	}
 
-	device_create(capi_class, NULL, MKDEV(capi_major, 0), NULL, "capi");
+	device_create(capi_class, NULL, MKDEV(capi_major, 0), NULL, "capi20");
 
 	if (capinc_tty_init() < 0) {
 		device_destroy(capi_class, MKDEV(capi_major, 0));

--------------040502020506020202080209--
