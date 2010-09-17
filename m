Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0IQN3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:29:13 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:36218 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752298Ab0IQN3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:29:12 -0400
Message-ID: <4C936D48.8040403@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:29:44 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: pnp: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------030301040606030403070901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030301040606030403070901
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...





--------------030301040606030403070901
Content-Type: text/plain;
 name="mods-pnp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-pnp.patch"

Fix lost PNP modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/drivers/ide/ide-pnp.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/ide/ide-pnp.c	2010-09-17 12:38:47.960703237 +0300
@@ -105,6 +105,9 @@ static void __exit pnpide_exit(void)
 	pnp_unregister_driver(&idepnp_driver);
 }
 
+
+MODULE_DEVICE_TABLE(pnp, idepnp_devices);
+
 module_init(pnpide_init);
 module_exit(pnpide_exit);
 
--- linux-2.6.36-rc4-git3/drivers/watchdog/sc1200wdt.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/watchdog/sc1200wdt.c	2010-09-17 12:39:07.012117913 +0300
@@ -473,6 +473,11 @@ static void __exit sc1200wdt_exit(void)
 	release_region(io, io_len);
 }
 
+
+#ifdef CONFIG_PNP
+MODULE_DEVICE_TABLE(pnp, scl200wdt_pnp_devices);
+#endif
+
 module_init(sc1200wdt_init);
 module_exit(sc1200wdt_exit);
 
--- linux-2.6.36-rc4-git3/drivers/staging/comedi/drivers/c6xdigio.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/comedi/drivers/c6xdigio.c	2010-09-17 12:38:58.863004604 +0300
@@ -527,6 +527,11 @@ static void __exit driver_c6xdigio_clean
 	comedi_driver_unregister(&driver_c6xdigio);
 }
 
+
+#ifdef CONFIG_PNP
+MODULE_DEVICE_TABLE(pnp, c6xdigio_pnp_tbl);
+#endif
+
 module_init(driver_c6xdigio_init_module);
 module_exit(driver_c6xdigio_cleanup_module);
 

--------------030301040606030403070901--
