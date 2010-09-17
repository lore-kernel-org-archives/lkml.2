Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab0IQNgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:36:48 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:44446 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752125Ab0IQNgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:36:47 -0400
Message-ID: <4C936EEF.70508@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:36:47 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: dio: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------040602060700000706000604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040602060700000706000604
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...


--------------040602060700000706000604
Content-Type: text/plain;
 name="mods-dio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-dio.patch"

Fix lost DIO modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/drivers/serial/8250_hp300.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/serial/8250_hp300.c	2010-09-17 12:38:57.712780474 +0300
@@ -320,6 +320,11 @@ static void __exit hp300_8250_exit(void)
 #endif
 }
 
+
+#ifdef CONFIG_DIO
+MODULE_DEVICE_TABLE(dio, hpdca_dio_tbl);
+#endif
+
 module_init(hp300_8250_init);
 module_exit(hp300_8250_exit);
 MODULE_DESCRIPTION("HP DCA/APCI serial driver");
--- linux-2.6.36-rc4-git3/drivers/video/hpfb.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/video/hpfb.c	2010-09-17 12:39:05.182624032 +0300
@@ -411,6 +411,9 @@ void __exit hpfb_cleanup_module(void)
 	dio_unregister_driver(&hpfb_driver);
 }
 
+
+MODULE_DEVICE_TABLE(dio, hpfb_dio_tbl);
+
 module_init(hpfb_init);
 module_exit(hpfb_cleanup_module);
 
--- linux-2.6.36-rc4-git3/drivers/net/hplance.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/net/hplance.c	2010-09-17 12:38:54.454135462 +0300
@@ -236,6 +236,9 @@ static void __exit hplance_cleanup_modul
         dio_unregister_driver(&hplance_driver);
 }
 
+
+MODULE_DEVICE_TABLE(dio, hplance_dio_tbl);
+
 module_init(hplance_init_module);
 module_exit(hplance_cleanup_module);
 

--------------040602060700000706000604--
