Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2IQAuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33301 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890Ab2IQAtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:20 -0400
Message-Id: <20120917003627.191711467@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 007/135] Input: i8042 - add Gigabyte T1005 series netbooks to noloop table
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 7b125b94ca16b7e618c6241cb02c4c8060cea5e3 upstream.

They all define their chassis type as "Other" and therefore are not
categorized as "laptops" by the driver, which tries to perform AUX IRQ
delivery test which fails and causes touchpad not working.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42620
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/serio/i8042-x86ia64io.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 5ec774d..6918773 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -177,6 +177,20 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
 		},
 	},
 	{
+		/* Gigabyte T1005 - defines wrong chassis type ("Other") */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T1005"),
+		},
+	},
+	{
+		/* Gigabyte T1005M/P - defines wrong chassis type ("Other") */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T1005M/P"),
+		},
+	},
+	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),


