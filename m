Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0IQNfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:35:50 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:33086 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753558Ab0IQNft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:35:49 -0400
Message-ID: <4C936EC9.20007@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:36:09 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: hid: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------070200040706080002050407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070200040706080002050407
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...

--------------070200040706080002050407
Content-Type: text/plain;
 name="mods-hid.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-hid.patch"

Fix lost HID modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/drivers/hid/hid-core.c	2010-09-17 12:30:32.000000000 +0300
+++ b/drivers/hid/hid-core.c	2010-09-17 12:38:45.972722957 +0300
@@ -1960,6 +1960,9 @@ static void __exit hid_exit(void)
 	bus_unregister(&hid_bus_type);
 }
 
+
+MODULE_DEVICE_TABLE(hid, hid_hiddev_list);
+
 module_init(hid_init);
 module_exit(hid_exit);
 
--- linux-2.6.36-rc4-git3/net/bluetooth/hidp/core.c	2010-08-02 01:11:14.000000000 +0300
+++ b/net/bluetooth/hidp/core.c	2010-09-17 12:39:07.372942338 +0300
@@ -1045,6 +1045,9 @@ static void __exit hidp_exit(void)
 	hid_unregister_driver(&hidp_driver);
 }
 
+
+MODULE_DEVICE_TABLE(hid, hidp_table);
+
 module_init(hidp_init);
 module_exit(hidp_exit);
 

--------------070200040706080002050407--
