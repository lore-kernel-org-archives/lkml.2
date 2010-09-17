Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0IQN2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:28:30 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:36210 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752159Ab0IQN23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:28:29 -0400
Message-ID: <4C936D20.90307@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:29:04 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: serio: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------030806060205060500090003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030806060205060500090003
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...




--------------030806060205060500090003
Content-Type: text/plain;
 name="mods-serio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-serio.patch"

Fix lost SERIO modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/drivers/input/keyboard/hil_kbd.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/input/keyboard/hil_kbd.c	2010-09-17 12:38:48.312731282 +0300
@@ -591,5 +591,8 @@ static void __exit hil_dev_exit(void)
 	serio_unregister_driver(&hil_serio_drv);
 }
 
+
+MODULE_DEVICE_TABLE(serio, hil_dev_ids);
+
 module_init(hil_dev_init);
 module_exit(hil_dev_exit);
--- linux-2.6.36-rc4-git3/drivers/input/serio/hil_mlc.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/input/serio/hil_mlc.c	2010-09-17 12:38:49.262714119 +0300
@@ -1010,5 +1010,8 @@ static void __exit hil_mlc_exit(void)
 	tasklet_kill(&hil_mlcs_tasklet);
 }
 
+
+MODULE_DEVICE_TABLE(serio, hil_mlc_serio_id);
+
 module_init(hil_mlc_init);
 module_exit(hil_mlc_exit);

--------------030806060205060500090003--
