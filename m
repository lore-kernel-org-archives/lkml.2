Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0IQNZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:25:50 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:57392 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753854Ab0IQNZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:25:49 -0400
Message-ID: <4C936C6C.7060807@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:26:04 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: xenbus: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------010305090203020004000403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010305090203020004000403
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...


--------------010305090203020004000403
Content-Type: text/plain;
 name="mods-xenbus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-xenbus.patch"

Fix lost XENBUS modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/drivers/block/xen-blkfront.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/block/xen-blkfront.c	2010-09-17 12:38:42.342470778 +0300
@@ -1306,6 +1306,9 @@ static int __init xlblk_init(void)
 
 	return xenbus_register_frontend(&blkfront);
 }
+
+MODULE_DEVICE_TABLE(xenbus, blkfront_ids);
+
 module_init(xlblk_init);
 
 
--- linux-2.6.36-rc4-git3/drivers/input/xen-kbdfront.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/input/xen-kbdfront.c	2010-09-17 12:38:49.836217742 +0300
@@ -354,6 +354,9 @@ static void __exit xenkbd_cleanup(void)
 	xenbus_unregister_driver(&xenkbd_driver);
 }
 
+
+MODULE_DEVICE_TABLE(xenbus, xenkbd_ids);
+
 module_init(xenkbd_init);
 module_exit(xenkbd_cleanup);
 
--- linux-2.6.36-rc4-git3/drivers/net/xen-netfront.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/net/xen-netfront.c	2010-09-17 12:38:56.182883859 +0300
@@ -1816,6 +1816,9 @@ static int __init netif_init(void)
 
 	return xenbus_register_frontend(&netfront_driver);
 }
+
+MODULE_DEVICE_TABLE(xenbus, netfront_ids);
+
 module_init(netif_init);
 
 
--- linux-2.6.36-rc4-git3/drivers/video/xen-fbfront.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/video/xen-fbfront.c	2010-09-17 12:39:06.532811597 +0300
@@ -699,6 +699,9 @@ static void __exit xenfb_cleanup(void)
 	xenbus_unregister_driver(&xenfb_driver);
 }
 
+
+MODULE_DEVICE_TABLE(xenbus, xenfb_ids);
+
 module_init(xenfb_init);
 module_exit(xenfb_cleanup);
 

--------------010305090203020004000403--
