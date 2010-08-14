Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0HNXUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 19:20:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55459 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab0HNXUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 19:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GUYh6uuTtOKWjUE5FBL60yiGz8aNI5VTUdhBB8iWR9n7uioWxt4bPha9jYyEh1k9Kf
         cUTycYlSTNIrCVSz5yZE9hTRqfPDthNzNyh+oISj0c7O/GDtiO/O2lWRxeojrl/PJb5f
         Iqa44zsGV18QcmtGA8a4jhty5huuG94yOK68I=
Date: Sun, 15 Aug 2010 01:19:33 +0200
From: Victor van den Elzen <victor.vde@gmail.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Mario Limonciello <superm1@ubuntu.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] platform/x86: move rfkill for Dell Mini 1012 to
 compal-laptop
Message-ID: <20100814231933.GA4404@archmini>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like others in the Mini series, the Dell Mini 1012 does not support
the smbios hook required by dell-laptop.

Signed-off-by: Victor van den Elzen <victor.vde@gmail.com>
Cc: stable <stable@kernel.org>
---
 drivers/platform/x86/compal-laptop.c |    9 +++++++++
 drivers/platform/x86/dell-laptop.c   |    7 +++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 71ff154..90111d7 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -259,6 +259,14 @@ static struct dmi_system_id __initdata compal_dmi_table[] = {
 		.callback = dmi_check_cb
 	},
 	{
+		.ident = "Dell Mini 1012",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
 		.ident = "Dell Inspiron 11z",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
@@ -375,5 +383,6 @@ MODULE_ALIAS("dmi:*:rnIFT00:rvrIFT00:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron910:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1010:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1011:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1012:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1110:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1210:*");
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 661e3ac..6110601 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -116,6 +116,13 @@ static struct dmi_system_id __devinitdata dell_blacklist[] = {
 		},
 	},
 	{
+		.ident = "Dell Mini 1012",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
+		},
+	},
+	{
 		.ident = "Dell Inspiron 11z",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
--
1.7.2.1

