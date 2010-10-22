Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab0JVTXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:23:15 -0400
Received: from kroah.org ([198.145.64.141]:33955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759214Ab0JVSz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:59 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:28 2010
Message-Id: <20101022185228.673013906@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>
Subject: [015/103] ACPI: invoke DSDT corruption workaround on all Toshiba Satellite
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <len.brown@intel.com>

commit 100cf87788c0e9104f6fb1b0ff5f72f73fbbbea3 upstream.

Our list of Toshiba Satellite models that require this workaround
is growing -- so invoke the workaround for the entire product line.

https://bugzilla.kernel.org/show_bug.cgi?id=14679

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/bus.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -80,23 +80,15 @@ static int set_copy_dsdt(const struct dm
 
 static struct dmi_system_id dsdt_dmi_table[] __initdata = {
 	/*
-	 * Insyde BIOS on some TOSHIBA machines corrupt the DSDT.
+	 * Invoke DSDT corruption work-around on all Toshiba Satellite.
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=14679
 	 */
 	{
 	 .callback = set_copy_dsdt,
-	 .ident = "TOSHIBA Satellite A505",
+	 .ident = "TOSHIBA Satellite",
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Satellite A505"),
-		},
-	},
-	{
-	 .callback = set_copy_dsdt,
-	 .ident = "TOSHIBA Satellite L505D",
-	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Satellite L505D"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Satellite"),
 		},
 	},
 	{}


