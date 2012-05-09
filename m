Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab2EIG0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:26:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38784 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755781Ab2EIFw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:57 -0400
Message-Id: <20120509055033.728056219@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 030/167] [PATCH] USB: sierra: avoid QMI/wwan interface on MC77xx
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 749541d19e70905e3971f2a08335a206a98e4d0c upstream.

These devices have a number of non serial interfaces as well.  Use
the existing "Direct IP" blacklist to prevent binding to interfaces
which are handled by other drivers.

We also extend the "Direct IP" blacklist with with interfaces only
seen in "QMI" mode, assuming that these devices use the same
interface numbers for serial interfaces both in "Direct IP" and in
"QMI" mode.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/sierra.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index fdd5aa2..8c8bf80 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -221,7 +221,7 @@ static const struct sierra_iface_info typeB_interface_list = {
 };
 
 /* 'blacklist' of interfaces not served by this driver */
-static const u8 direct_ip_non_serial_ifaces[] = { 7, 8, 9, 10, 11 };
+static const u8 direct_ip_non_serial_ifaces[] = { 7, 8, 9, 10, 11, 19, 20 };
 static const struct sierra_iface_info direct_ip_interface_blacklist = {
 	.infolen = ARRAY_SIZE(direct_ip_non_serial_ifaces),
 	.ifaceinfo = direct_ip_non_serial_ifaces,
@@ -289,7 +289,6 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U */
 	{ USB_DEVICE(0x1199, 0x6859) },	/* Sierra Wireless AirCard 885 E */
 	{ USB_DEVICE(0x1199, 0x685A) },	/* Sierra Wireless AirCard 885 E */
-	{ USB_DEVICE(0x1199, 0x68A2) }, /* Sierra Wireless MC7710 */
 	/* Sierra Wireless C885 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6880, 0xFF, 0xFF, 0xFF)},
 	/* Sierra Wireless C888, Air Card 501, USB 303, USB 304 */
@@ -299,6 +298,9 @@ static const struct usb_device_id id_table[] = {
 	/* Sierra Wireless HSPA Non-Composite Device */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6892, 0xFF, 0xFF, 0xFF)},
 	{ USB_DEVICE(0x1199, 0x6893) },	/* Sierra Wireless Device */
+	{ USB_DEVICE(0x1199, 0x68A2),   /* Sierra Wireless MC77xx in QMI mode */
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
 	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
-- 
1.7.10



