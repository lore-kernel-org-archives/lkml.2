Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab0HXW6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:58:36 -0400
Received: from kroah.org ([198.145.64.141]:40320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab0HXW60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:26 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:14 2010
Message-Id: <20100824224213.968424169@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Victor van den Elzen <victor.vde@gmail.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [22/91] platform/x86: move rfkill for Dell Mini 1012 to compal-laptop
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Victor van den Elzen <victor.vde@gmail.com>

commit c3f755e3842108c1cffe570fe9802239810352b6 upstream.

Like others in the Mini series, the Dell Mini 1012 does not support
the smbios hook required by dell-laptop.

Signed-off-by: Victor van den Elzen <victor.vde@gmail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/compal-laptop.c |    9 +++++++++
 drivers/platform/x86/dell-laptop.c   |    7 +++++++
 2 files changed, 16 insertions(+)

--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -259,6 +259,14 @@ static struct dmi_system_id __initdata c
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
@@ -375,5 +383,6 @@ MODULE_ALIAS("dmi:*:rnIFT00:rvrIFT00:*")
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron910:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1010:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1011:*");
+MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1012:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1110:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1210:*");
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -116,6 +116,13 @@ static struct dmi_system_id __devinitdat
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


