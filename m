Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab1IAW4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:56:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634Ab1IAW42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:56:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Sep  1 15:53:31 2011
Message-Id: <20110901225331.334955255@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 01 Sep 2011 15:50:09 -0700
From: gregkh@suse.de
To: Matthew Garrett <mjg@redhat.com>, Greg KH <greg@kroah.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jason Stubbs <jasonbstubbs@gmail.com>
Subject: [patch 7/8] Platform: Samsung laptop DMI info for NC210/NC110
In-Reply-To: <20110901225401.GA26870@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Stubbs <jasonbstubbs@gmail.com>

This patch just adds the DMI info for the samsung laptop driver to work with
the NC210/NC110. It needs the brightness quirk patch for proper support.

Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/samsung-laptop.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -755,6 +755,15 @@ static struct dmi_system_id __initdata s
 		},
 		.callback = dmi_check_cb,
 	},
+	{
+		.ident = "NC210/NC110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "NC210/NC110"),
+			DMI_MATCH(DMI_BOARD_NAME, "NC210/NC110"),
+		},
+		.callback = dmi_check_cb,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);


