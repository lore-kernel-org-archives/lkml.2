Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0IQN0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:26:06 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:57400 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754213Ab0IQN0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:26:04 -0400
Message-ID: <4C936CAA.3070505@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:27:06 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: usb: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------050308020500030809030909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050308020500030809030909
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...



--------------050308020500030809030909
Content-Type: text/plain;
 name="mods-usb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-usb.patch"

Fix lost USB modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>


--- linux-2.6.36-rc4-git3/drivers/staging/tm6000/tm6000-cards.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/tm6000/tm6000-cards.c	2010-09-17 12:39:02.282665813 +0300
@@ -979,6 +979,9 @@ static void __exit tm6000_module_exit(vo
 	usb_deregister(&tm6000_usb_driver);
 }
 
+
+MODULE_DEVICE_TABLE(usb, tm6000_id_table);
+
 module_init(tm6000_module_init);
 module_exit(tm6000_module_exit);
 
--- linux-2.6.36-rc4-git3/drivers/staging/lirc/lirc_sasem.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/lirc/lirc_sasem.c	2010-09-17 12:39:02.647259613 +0300
@@ -929,5 +929,8 @@ static void __exit sasem_exit(void)
 }
 
 
+
+MODULE_DEVICE_TABLE(usb, sasem_usb_id_table);
+
 module_init(sasem_init);
 module_exit(sasem_exit);
--- linux-2.6.36-rc4-git3/drivers/usb/atm/xusbatm.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/usb/atm/xusbatm.c	2010-09-17 12:39:03.203891509 +0300
@@ -217,6 +217,9 @@ static int __init xusbatm_init(void)
 
 	return usb_register(&xusbatm_usb_driver);
 }
+
+MODULE_DEVICE_TABLE(usb, xusbatm_usb_ids);
+
 module_init(xusbatm_init);
 
 static void __exit xusbatm_exit(void)

--------------050308020500030809030909--
