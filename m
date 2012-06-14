Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2FNX6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:58:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab2FNX6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:06 -0400
Message-Id: <20120614235644.921166164@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Autif Khan <autif.mlist@gmail.com>,
        Tom Cassidy <tomas.cassidy@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/20] net: sierra_net: device IDs for Aircard 320U++
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit dd03cff23d694cfb0fdae80cb618e7ced05ea696 upstream.

Adding device IDs for Aircard 320U and two other devices
found in the out-of-tree version of this driver.

Cc: linux@sierrawireless.com
Cc: Autif Khan <autif.mlist@gmail.com>
Cc: Tom Cassidy <tomas.cassidy@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/sierra_net.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -943,7 +943,7 @@ struct sk_buff *sierra_net_tx_fixup(stru
 }
 
 static const u8 sierra_net_ifnum_list[] = { 7, 10, 11 };
-static const struct sierra_net_info_data sierra_net_info_data_68A3 = {
+static const struct sierra_net_info_data sierra_net_info_data_direct_ip = {
 	.rx_urb_size = 8 * 1024,
 	.whitelist = {
 		.infolen = ARRAY_SIZE(sierra_net_ifnum_list),
@@ -951,7 +951,7 @@ static const struct sierra_net_info_data
 	}
 };
 
-static const struct driver_info sierra_net_info_68A3 = {
+static const struct driver_info sierra_net_info_direct_ip = {
 	.description = "Sierra Wireless USB-to-WWAN Modem",
 	.flags = FLAG_WWAN | FLAG_SEND_ZLP,
 	.bind = sierra_net_bind,
@@ -959,12 +959,18 @@ static const struct driver_info sierra_n
 	.status = sierra_net_status,
 	.rx_fixup = sierra_net_rx_fixup,
 	.tx_fixup = sierra_net_tx_fixup,
-	.data = (unsigned long)&sierra_net_info_data_68A3,
+	.data = (unsigned long)&sierra_net_info_data_direct_ip,
 };
 
 static const struct usb_device_id products[] = {
 	{USB_DEVICE(0x1199, 0x68A3), /* Sierra Wireless USB-to-WWAN modem */
-	.driver_info = (unsigned long) &sierra_net_info_68A3},
+	.driver_info = (unsigned long) &sierra_net_info_direct_ip},
+	{USB_DEVICE(0x0F3D, 0x68A3), /* AT&T Direct IP modem */
+	.driver_info = (unsigned long) &sierra_net_info_direct_ip},
+	{USB_DEVICE(0x1199, 0x68AA), /* Sierra Wireless Direct IP LTE modem */
+	.driver_info = (unsigned long) &sierra_net_info_direct_ip},
+	{USB_DEVICE(0x0F3D, 0x68AA), /* AT&T Direct IP LTE modem */
+	.driver_info = (unsigned long) &sierra_net_info_direct_ip},
 
 	{}, /* last item */
 };


