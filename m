Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab1LOH2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:28:08 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:42383 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1LOH2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:28:06 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] eeepc-laptop: log unknown keys
Date: Thu, 15 Dec 2011 08:27:32 +0100
Message-Id: <1323934059-1221-3-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
References: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index ea44abd..6deb0d7 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1251,6 +1251,14 @@ static void eeepc_input_exit(struct eeepc_laptop *eeepc)
 /*
  * ACPI driver
  */
+static void eeepc_input_notify(struct eeepc_laptop *eeepc, int event)
+{
+	if (!eeepc->inputdev)
+		return ;
+	if (!sparse_keymap_report_event(eeepc->inputdev, event, 1, true))
+		pr_info("Unknown key %x pressed\n", event);
+}
+
 static void eeepc_acpi_notify(struct acpi_device *device, u32 event)
 {
 	struct eeepc_laptop *eeepc = acpi_driver_data(device);
@@ -1287,12 +1295,11 @@ static void eeepc_acpi_notify(struct acpi_device *device, u32 event)
 				* event will be desired value (or else ignored)
 				*/
 			}
-			sparse_keymap_report_event(eeepc->inputdev, event,
-						   1, true);
+			eeepc_input_notify(eeepc, event);
 		}
 	} else {
 		/* Everything else is a bona-fide keypress event */
-		sparse_keymap_report_event(eeepc->inputdev, event, 1, true);
+		eeepc_input_notify(eeepc, event);
 	}
 }
 
-- 
1.7.5.4

