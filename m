Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032478Ab2CSSZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:25:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45410 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030328Ab2CSSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:25:33 -0400
Date: Mon, 19 Mar 2012 13:25:21 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Santiago Garcia Mantinan <manty@debian.org>
Cc: linux-kernel@vger.kernel.org, Matthias Urlichs <smurf@smurf.noris.de>,
        linux-usb@vger.kernel.org, Dirk De Schepper <ddeschepper@nvtl.com>,
        digidietze@draisberghof.de
Subject: [RFC/PATCH] USB: option: handle Novatel 3G modem 1410:7001 out of
 the box again
Message-ID: <20120319182521.GC13707@burratino>
References: <20120319102154.GA16536@www.manty.net>
 <20120319150801.GC11180@burratino>
 <20120319171659.GA27498@www.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319171659.GA27498@www.manty.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santiago Garcia Mantinan <manty@debian.org>
Date: Mon, 19 Mar 2012 18:17:00 +0100

Since commit c7aa8f44b4d1 ("USB: option: fix incorrect novatel
entries"), the Novatel Mifi 2372 (USB id 1410:7001) is not recognized
by the option driver.  That commit removed that id from the list of
supported ids for no obvious reason --- perhaps it was just lost in
the shuffle.

Addresses http://bugs.debian.org/664605 and
          https://bugs.launchpad.net/bugs/750362

Signed-off-by: Santiago Garcia Mantinan <manty@debian.org>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: <stable@vger.kernel.org> # >= 2.6.36
---
Santiago Garcia Mantinan wrote:

> here it goes with full paths on the patch ...

Great.  Here is the same with a commit message and all. ;-)  linux-usb
folks, what do you think?

 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index f9b11fb8e25c..4021f4d303bb 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -708,6 +708,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_HIGHSPEED) },
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED3) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED4) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED5) },
-- 
1.7.10.rc1

