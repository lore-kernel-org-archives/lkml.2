Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1GKOlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:41:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39235 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1GKOlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:41:42 -0400
Subject: [PATCH] Input: synaptics - make dmi_check_system return
 immediately when a match is found
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 22:41:36 +0800
Message-ID: <1310395296.2415.7.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only care about if there is any successful match from the table
or no match at all, make the dmi_matched callback return 1 then
dmi_check_system will return immediately if we have a successful match.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/mouse/synaptics.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index e06e045..09e7e0e 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -801,6 +801,11 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 	return 0;
 }
 
+static int __init dmi_matched(const struct dmi_system_id *dmi)
+{
+	return 1;
+}
+
 static bool impaired_toshiba_kbc;
 
 static const struct dmi_system_id __initconst toshiba_dmi_table[] = {
@@ -811,6 +816,7 @@ static const struct dmi_system_id __initconst toshiba_dmi_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite"),
 		},
+		.callback = dmi_matched,
 	},
 	{
 		/* Toshiba Dynabook */
@@ -818,6 +824,7 @@ static const struct dmi_system_id __initconst toshiba_dmi_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "dynabook"),
 		},
+		.callback = dmi_matched,
 	},
 	{
 		/* Toshiba Portege M300 */
@@ -825,7 +832,7 @@ static const struct dmi_system_id __initconst toshiba_dmi_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M300"),
 		},
-
+		.callback = dmi_matched,
 	},
 	{
 		/* Toshiba Portege M300 */
@@ -834,7 +841,7 @@ static const struct dmi_system_id __initconst toshiba_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Portable PC"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Version 1.0"),
 		},
-
+		.callback = dmi_matched,
 	},
 #endif
 	{ }
@@ -850,6 +857,7 @@ static const struct dmi_system_id __initconst olpc_dmi_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
 		},
+		.callback = dmi_matched,
 	},
 #endif
 	{ }
-- 
1.7.4.1



