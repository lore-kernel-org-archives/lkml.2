Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1ITQTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:19:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab1ITQTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:19:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Sep 20 09:17:36 2011
Message-Id: <20110920161736.220520523@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 20 Sep 2011 09:16:15 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        greg@kroah.com, Raul Gutierrez Segales <rgs@collabora.co.uk>
Subject: [patch 8/8] Platform: fix samsung-laptop DMI identification for N220 model
In-Reply-To: <20110920161743.GA32737@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raul Gutierrez Segales <rgs@collabora.co.uk>

This is a follow-up for commit 78a7539b, which didn't cover the
Samsung N220 laptop. With this backlight brightness works nicely
on the N220 netbook.

Signed-off-by: Raul Gutierrez Segales <rgs@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -663,6 +663,16 @@ static struct dmi_system_id __initdata s
 		.callback = dmi_check_cb,
 	},
 	{
+		.ident = "N220",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N220"),
+			DMI_MATCH(DMI_BOARD_NAME, "N220"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{
 		.ident = "N150/N210/N220/N230",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,


