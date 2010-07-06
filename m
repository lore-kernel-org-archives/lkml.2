Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0GFKXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:23:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47399 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab0GFKXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IUh5s3UjGo5x4/JBM7Nonq0+aO4ajdYfGOZBllfF79F2GEIVo0uJMqE1jJgqR2aAWk
         soUu8oLW1BD+cUd88XzBERRCN18TIaNph4Y1B6/wD+fTu6HsclTKhjo3SQhf98Eclp6y
         tlK4Qfz4827TK/UKhLpU32DkayMPR+kV/iG9c=
From: Renzo Dani <arons7@gmail.com>
To: mchehab@infradead.org
Cc: arons7@gmail.com, rdunlap@xenotime.net, o.endriss@gmx.de, awalls@radix.net,
       crope@iki.fi, manu@linuxtv.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 2/2] Retrieve firmware for az6027
Date: Tue,  6 Jul 2010 12:23:33 +0200
Message-Id: <1278411813-6464-1-git-send-email-arons7@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Renzo Dani <arons7@gmail.com>


Signed-off-by: Renzo Dani <arons7@gmail.com>
---
 Documentation/dvb/get_dvb_firmware |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 239cbdb..9ea94dc 100644
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
+    my $url = "http://linux.terratec.de/files/$file";
+    my $firmware = "dvb-usb-az6027-03.fw";
+
+    wgetfile($file, $url);
+
+    #untar
+    if( system("tar xzvf $file $firmware")){
+        die "failed to untar firmware";
+    }
+    if( system("rm $file")){
+        die ("unable to remove unnecessary files");
+    }
+
+    $firmware;
+}
 # ---------------------------------------------------------------
 # Utilities
 
-- 
1.7.1

