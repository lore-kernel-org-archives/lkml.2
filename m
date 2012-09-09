Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2IIXRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51429 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768Ab2IIXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:57 -0400
Message-Id: <20120909224157.364717074@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Pavel Machek <pavel@ucw.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>,
        Devendra Naga <devendra.aaru@gmail.com>
Subject: [ 48/95] USB: winbond: remove __devinit* from the struct usb_device_id table
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 43a34695d9cd79c6659f09da6d3b0624f3dd169f upstream.

This structure needs to always stick around, even if CONFIG_HOTPLUG
is disabled, otherwise we can oops when trying to probe a device that
was added after the structure is thrown away.

Thanks to Fengguang Wu and Bjørn Mork for tracking this issue down.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Bjørn Mork <bjorn@mork.no>
CC: Pavel Machek <pavel@ucw.cz>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "John W. Linville" <linville@tuxdriver.com>
CC: Eliad Peller <eliad@wizery.com>
CC: Devendra Naga <devendra.aaru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/winbond/wbusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index ef36054..0ca857a 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -25,7 +25,7 @@ MODULE_DESCRIPTION("IS89C35 802.11bg WLAN USB Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");
 
-static const struct usb_device_id wb35_table[] __devinitconst = {
+static const struct usb_device_id wb35_table[] = {
 	{ USB_DEVICE(0x0416, 0x0035) },
 	{ USB_DEVICE(0x18E8, 0x6201) },
 	{ USB_DEVICE(0x18E8, 0x6206) },


