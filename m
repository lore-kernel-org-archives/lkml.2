Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031738Ab2CITxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:53:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031689Ab2CITw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:52:57 -0500
Message-Id: <20120309190217.936204433@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Keng-Yu Lin <kengyu@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 37/68] ACPI / PM: Do not save/restore NVS on Asus K54C/K54HR
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keng-Yu Lin <kengyu@canonical.com>

commit 5a50a7c32d630d6cdb13d69afabb0cc81b2f379c upstream.

The models do not resume correctly without acpi_sleep=nonvs.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -428,6 +428,22 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_PRODUCT_NAME, "1000 Series"),
 		},
 	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Asus K54C",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "K54C"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Asus K54HR",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "K54HR"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */


