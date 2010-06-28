Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab0F1J6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:58:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59752 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0F1J6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ONpErAGRhYZwlFEEaEKm/BtAVinSzJMfFhYkUhVkaNovCEniqRSUrX7uM/diVyeEAL
         nctFlrvHsdAKzzHInarl+/zXmXClbDqCzrRuB2AGOkOfeigigCffqIvEJe2hmRJT6hUk
         nSDt6JlZ+ZY5fdYTzmXS//8ToVF2JI3XWccMo=
From: Renzo Dani <arons7@gmail.com>
To: adams.xu@azwave.com.cn
Cc: arons7@gmail.com, mchehab@infradead.org, rdunlap@xenotime.net,
       o.endriss@gmx.de, awalls@radix.net, crope@iki.fi, manu@linuxtv.org,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: [PATCH 1/1] Added Technisat Skystar USB HD CI
Date: Mon, 28 Jun 2010 11:57:35 +0200
Message-Id: <1277719055-14585-1-git-send-email-arons7@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Renzo Dani <arons7@gmail.com>


Signed-off-by: Renzo Dani <arons7@gmail.com>
---
 Documentation/dvb/get_dvb_firmware |   19 ++++++++++++++++++-
 drivers/media/dvb/dvb-usb/az6027.c |   14 ++++++++++++--
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 239cbdb..c203e94 100644
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -26,7 +26,7 @@ use IO::Handle;
 		"dec3000s", "vp7041", "dibusb", "nxt2002", "nxt2004",
 		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
-		"af9015", "ngene");
+		"af9015", "ngene", "az6027");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -567,6 +567,23 @@ sub ngene {
     "$file1, $file2";
 }
 
+sub az6027{
+    my $file = "AZ6027_Linux_Driver.tar.gz";
+	my $url = "http://linux.terratec.de/files/$file";
+    my $firmware = "dvb-usb-az6027-03.fw";
+
+	wgetfile($file, $url);
+
+	#untar
+    if( system("tar xzvf $file")){
+		die "failed to untar firmware";
+	}
+	if( system("rm -rf AZ6027_Linux_Driver; rm $file")){
+		die ("unable to remove unnecessary files");
+    }
+
+    $firmware;
+}
 # ---------------------------------------------------------------
 # Utilities
 
diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index d7290b2..891ae04 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -1103,13 +1103,23 @@ static struct dvb_usb_device_properties az6027_properties = {
 	.rc_query         = az6027_rc_query,
 	.i2c_algo         = &az6027_i2c_algo,
 
-	.num_device_descs = 1,
+	.num_device_descs = 2,
 	.devices = {
 		{
 			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
 			.cold_ids = { &az6027_usb_table[0], NULL },
 			.warm_ids = { NULL },
 		},
+		{
+		    .name = " Terratec DVB 2 CI",
+			.cold_ids = { &az6027_usb_table[1], NULL },
+			.warm_ids = { NULL },
+		},
+		{
+		    .name = "TechniSat SkyStar USB 2 HD CI (AZ6027)",
+			.cold_ids = { &az6027_usb_table[2], NULL },
+			.warm_ids = { NULL },
+		},
 		{ NULL },
 	}
 };
@@ -1118,7 +1128,7 @@ static struct dvb_usb_device_properties az6027_properties = {
 static struct usb_driver az6027_usb_driver = {
 	.name		= "dvb_usb_az6027",
 	.probe 		= az6027_usb_probe,
-	.disconnect 	= az6027_usb_disconnect,
+	.disconnect	= az6027_usb_disconnect,
 	.id_table 	= az6027_usb_table,
 };
 
-- 
1.7.1

