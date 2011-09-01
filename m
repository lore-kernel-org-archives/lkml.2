Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1IAW4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:56:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab1IAW4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:56:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Sep  1 15:53:30 2011
Message-Id: <20110901225330.889550640@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 01 Sep 2011 15:50:05 -0700
From: gregkh@suse.de
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        greg@kroah.com, Smelov Andrey <xor29a@bk.ru>,
        stable <stable@kernel.org>
Subject: [patch 3/8] Platform: samsung_laptop: samsung backlight for R528/R728
In-Reply-To: <20110901225401.GA26870@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


patch works for me, but I need to add "acpi_backlight=vendor" to kernel
params

Signed-off-by: Smelov Andrey <xor29a@bk.ru>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/platform/x86/samsung-laptop.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -704,6 +704,15 @@ static struct dmi_system_id __initdata s
 		},
 		.callback = dmi_check_cb,
 	},
+	{
+		.ident = "R528/R728",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "R528/R728"),
+			DMI_MATCH(DMI_BOARD_NAME, "R528/R728"),
+		},
+		.callback = dmi_check_cb,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);


