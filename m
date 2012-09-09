Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2IIXRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51513 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756397Ab2IIXRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:12 -0400
Message-Id: <20120909224156.699525222@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Doron Cohen <doronc@siano-ms.com>
Subject: [ 43/95] USB: smsusb: remove __devinit* from the struct usb_device_id table
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

commit d04dbd1c0ec17a13326c8f2279399c225836a79f upstream.

This structure needs to always stick around, even if CONFIG_HOTPLUG
is disabled, otherwise we can oops when trying to probe a device that
was added after the structure is thrown away.

Thanks to Fengguang Wu and Bjørn Mork for tracking this issue down.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Bjørn Mork <bjorn@mork.no>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Michael Krufky <mkrufky@linuxtv.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Doron Cohen <doronc@siano-ms.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/siano/smsusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/dvb/siano/smsusb.c
index 664e460..aac6222 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -481,7 +481,7 @@ static int smsusb_resume(struct usb_interface *intf)
 	return 0;
 }
 
-static const struct usb_device_id smsusb_id_table[] __devinitconst = {
+static const struct usb_device_id smsusb_id_table[] = {
 	{ USB_DEVICE(0x187f, 0x0010),
 		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
 	{ USB_DEVICE(0x187f, 0x0100),


