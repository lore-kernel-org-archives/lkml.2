Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab2ILXli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:41:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab2ILXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:41:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 78/85] Input: i8042 - add Gigabyte T1005 series netbooks to noloop table
Date: Wed, 12 Sep 2012 16:37:01 -0700
Message-Id: <20120912233549.862991117@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 7b125b94ca16b7e618c6241cb02c4c8060cea5e3 upstream.

They all define their chassis type as "Other" and therefore are not
categorized as "laptops" by the driver, which tries to perform AUX IRQ
delivery test which fails and causes touchpad not working.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42620
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -177,6 +177,20 @@ static const struct dmi_system_id __init
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


