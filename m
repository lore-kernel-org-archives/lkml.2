Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0JAIDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 04:03:07 -0400
Received: from cmx.wol.de ([193.158.62.4]:38050 "EHLO cmx.wol.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab0JAIDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 04:03:04 -0400
Subject: [PATCH] Fix capi devicenames v2
From: "Marc - A. Dahlhaus" <mad@wol.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        isdn@linux-pingi.de
In-Reply-To: <AANLkTimRa9VsOgSkcdrg=41pskEbMhNL4D9SXeV3dztG@mail.gmail.com>
References: <4CA391B3.1030806@wol.de>
	 <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
	 <1285843077.748.32.camel@marc>
	 <AANLkTi=d+5uDVK9RHguSmwFhKLVUPXvzo=G3s=NKKDW3@mail.gmail.com>
	 <20100930122928.19e5ee84@lxorguk.ukuu.org.uk>
	 <1285851024.748.97.camel@marc>
	 <AANLkTimRa9VsOgSkcdrg=41pskEbMhNL4D9SXeV3dztG@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-KS7k0NCfTrFH3zLFrxug"
Date: Fri, 01 Oct 2010 10:02:53 +0200
Message-Id: <1285920173.13411.34.camel@marc>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KS7k0NCfTrFH3zLFrxug
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Specification in devices.txt about capi devices is out of date as the capifs
layout for capi tty devices was never added to it.

Recent udev versions can't produce working device nodes because of a typo in
the device_create call for the capi control device.

Due to this the wrong node name of the control device "capi" collides with
the "capi" directory under which the now deprecated capifs was mounted and
created the capi tty device nodes.

This also changes the capi tty device names passed to udev to the capifs
layout which isn't mentioned in the specs.

Signed-off-by: Marc - Andre Dahlhaus <mad@wol.de>

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

--=-KS7k0NCfTrFH3zLFrxug
Content-Disposition: attachment; filename="capi-name.patch"
Content-Type: text/x-patch; name="capi-name.patch"; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

Specification in devices.txt about capi devices is out of date as the capifs
layout for capi tty devices was never added to it.

Recent udev versions can't produce working device nodes because of a typo in
the device_create call for the capi control device.

Due to this the wrong node name of the control device "capi" collides with
the "capi" directory under which the now deprecated capifs was mounted and
created the capi tty device nodes.

This also changes the capi tty device names passed to udev to the capifs
layout which isn't mentioned in the specs.

Signed-off-by: Marc - Andre Dahlhaus <mad@wol.de>

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

--=-KS7k0NCfTrFH3zLFrxug--

