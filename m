Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0IQNgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:36:49 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:44447 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752298Ab0IQNgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:36:47 -0400
Message-ID: <4C936F10.8080807@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:37:20 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: ccw: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------060307060507030303010507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060307060507030303010507
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...



--------------060307060507030303010507
Content-Type: text/plain;
 name="mods-ccw.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-ccw.patch"

Fix lost CCW modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/drivers/s390/char/con3215.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/s390/char/con3215.c	2010-09-17 12:38:57.342909394 +0300
@@ -1163,5 +1163,8 @@ static void __exit tty3215_exit(void)
 	ccw_driver_unregister(&raw3215_ccw_driver);
 }
 
+
+MODULE_DEVICE_TABLE(ccw, raw3215_id);
+
 module_init(tty3215_init);
 module_exit(tty3215_exit);
--- linux-2.6.36-rc4-git3/drivers/s390/char/raw3270.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/s390/char/raw3270.c	2010-09-17 12:38:57.387632242 +0300
@@ -1430,6 +1430,9 @@ raw3270_exit(void)
 
 MODULE_LICENSE("GPL");
 
+
+MODULE_DEVICE_TABLE(ccw, raw3270_id);
+
 module_init(raw3270_init);
 module_exit(raw3270_exit);
 

--------------060307060507030303010507--
