Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab2IIXR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51465 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756349Ab2IIXRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:06 -0400
Message-Id: <20120909224156.967285532@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 45/95] USB: p54usb: remove __devinit* from the struct usb_device_id table
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

commit b9c4167cbbafddac3462134013bc15e63e4c53ef upstream.

This structure needs to always stick around, even if CONFIG_HOTPLUG
is disabled, otherwise we can oops when trying to probe a device that
was added after the structure is thrown away.

Thanks to Fengguang Wu and Bjørn Mork for tracking this issue down.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Bjørn Mork <bjorn@mork.no>
CC: Christian Lamparter <chunkeey@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/p54/p54usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 7f207b6..effb044 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -42,7 +42,7 @@ MODULE_FIRMWARE("isl3887usb");
  * whenever you add a new device.
  */
 
-static struct usb_device_id p54u_table[] __devinitdata = {
+static struct usb_device_id p54u_table[] = {
 	/* Version 1 devices (pci chip + net2280) */
 	{USB_DEVICE(0x0411, 0x0050)},	/* Buffalo WLI2-USB2-G54 */
 	{USB_DEVICE(0x045e, 0x00c2)},	/* Microsoft MN-710 */


