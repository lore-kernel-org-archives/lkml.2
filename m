Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1LVWUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 17:20:07 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47961 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1LVWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 17:20:05 -0500
X-Originating-IP: 217.70.178.132
X-Originating-IP: 86.186.9.152
From: Andrzej Prochyra <andrzej@prochyra.name>
To: mjg@redhat.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Platform: samsung-laptop: add DMI information for Samsung N150 Plus
Date: Thu, 22 Dec 2011 22:19:59 +0000
Message-ID: <87ty4ss0z4.fsf@prochyra.name>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrzej Prochyra <andrzej@prochyra.name>

Adds DMI information for Samsung N150 Plus which identifies itself as
"N150P" so that the driver loads and the 'acpi_backlight=vendor'
parameter does not need to be used in order for backlight control to
work.

Signed-off-by: Andrzej Prochyra <andrzej@prochyra.name>
---
 drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 09e26bf..e3a496a 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -780,6 +780,16 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		},
 		.callback = dmi_check_cb,
 	},
+	{
+		.ident = "N150P",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
+			DMI_MATCH(DMI_BOARD_NAME, "N150P"),
+		},
+		.callback = dmi_check_cb,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
-- 
1.7.4.1

