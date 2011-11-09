Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248Ab1KJDXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:23:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235Ab1KJDX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:23:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:07 2011
Message-Id: <20111109212707.651471054@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Smelov Andrey <xor29a@bk.ru>,
        Matthew Garrett <mjg@redhat.com>
Subject: [072/262] Platform: samsung_laptop: samsung backlight for R528/R728
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Smelov Andrey <xor29a@bk.ru>

commit 093ed561648d43263c009ea88abab21a31cd4f1d upstream.

patch works for me, but I need to add "acpi_backlight=vendor" to kernel
params

Signed-off-by: Smelov Andrey <xor29a@bk.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Matthew Garrett <mjg@redhat.com>

---
 drivers/platform/x86/samsung-laptop.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -694,6 +694,15 @@ static struct dmi_system_id __initdata s
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


