Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab1E0UpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:45:20 -0400
Received: from mail.qboosh.pl ([217.73.31.61]:35477 "EHLO mail.qboosh.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab1E0UpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:45:17 -0400
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 16:45:17 EDT
Date: Fri, 27 May 2011 22:34:50 +0200
From: Jakub Bogusz <qboosh@pld-linux.org>
To: Miloslav Trmac <mitr@volny.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] wistron_btns: FS AMILO Pro 8210 support
Message-ID: <20110527203450.GQ3197@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="at6+YcpfzWZg/htY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

The attached patch adds Fujitsu-Siemens AMILO Pro 8210 support to
wistron_btns driver.

Functions are very similar to already supported AMILO Pro 3505, but 8210
has WIFI led.


-- 
Jakub Bogusz    http://qboosh.pl/

--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-wistron-amilo8210.patch"

--- linux-2.6.37/drivers/input/misc/wistron_btns.c.orig	2011-01-05 01:50:19.000000000 +0100
+++ linux-2.6.37/drivers/input/misc/wistron_btns.c	2011-02-19 07:51:36.000000000 +0100
@@ -278,6 +278,16 @@
 	{ KE_END,       0 }
 };
 
+static struct key_entry keymap_fs_amilo_pro_v8210[] __initdata = {
+	{ KE_KEY,       0x01, {KEY_HELP} },          /* Fn+F1 */
+	{ KE_KEY,       0x06, {KEY_DISPLAYTOGGLE} }, /* Fn+F4 */
+	{ KE_BLUETOOTH, 0x30 },                      /* Fn+F10 */
+	{ KE_KEY,       0x31, {KEY_MAIL} },          /* mail button */
+	{ KE_KEY,       0x36, {KEY_WWW} },           /* www button */
+	{ KE_WIFI,      0x78 },                      /* satelite dish button */
+	{ KE_END,       FE_WIFI_LED }
+};
+
 static struct key_entry keymap_fujitsu_n3510[] __initdata = {
 	{ KE_KEY, 0x11, {KEY_PROG1} },
 	{ KE_KEY, 0x12, {KEY_PROG2} },
@@ -655,6 +665,15 @@
 		.driver_data = keymap_fs_amilo_pro_v3505
 	},
 	{
+		/* Fujitsu-Siemens Amilo Pro Edition V8210 */
+		.callback = dmi_matched,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro Series V8210"),
+		},
+		.driver_data = keymap_fs_amilo_pro_v8210
+	},
+	{
 		/* Fujitsu-Siemens Amilo M7400 */
 		.callback = dmi_matched,
 		.matches = {

--at6+YcpfzWZg/htY--
