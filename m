Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab1FUTt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:49:26 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:48672 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab1FUTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:49:25 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jun 2011 15:49:24 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAEbyAE5bdWOb/2dsb2JhbABUp26Idb9phioEkWaHeYgP
X-IronPort-AV: E=Sophos;i="4.65,402,1304287200"; 
   d="scan'208";a="771395710"
From: Carlos Alberto Lopez Perez <clopez@igalia.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Daniel Oliveira Nascimento <don@syst.com.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86/platform: classmate-laptop: Add cmpc_keys support for new classmate laptops
Date: Tue, 21 Jun 2011 21:40:01 +0200
Message-Id: <1308685201-15541-1-git-send-email-clopez@igalia.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cmpc_keys ACPI driver from the classmate-laptop module fails to
recognize the device on the 4th generation of classmate laptops (Atom N450)
because the device ID is named "FNBT0000" (uppercase N) on this laptops.

MODALIAS=acpi:FNBT0000:

This patch makes the driver cmpc_keys recognize it:

input: cmpc_keys as /devices/LNXSYSTM:00/device:00/FNBT0000:00/input/input18

Signed-off-by: Carlos Alberto Lopez Perez <clopez@igalia.com>
---
 drivers/platform/x86/classmate-laptop.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 94f93b6..03896cd 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -40,6 +40,7 @@ struct cmpc_accel {
 #define CMPC_TABLET_HID		"TBLT0000"
 #define CMPC_IPML_HID	"IPML200"
 #define CMPC_KEYS_HID		"FnBT0000"
+#define CMPC_KEYS_4GEN_HID	"FNBT0000"
 
 /*
  * Generic input device code.
@@ -683,6 +684,7 @@ static int cmpc_keys_remove(struct acpi_device *acpi, int type)
 
 static const struct acpi_device_id cmpc_keys_device_ids[] = {
 	{CMPC_KEYS_HID, 0},
+	{CMPC_KEYS_4GEN_HID, 0},
 	{"", 0}
 };
 
@@ -754,6 +756,7 @@ static const struct acpi_device_id cmpc_device_ids[] = {
 	{CMPC_TABLET_HID, 0},
 	{CMPC_IPML_HID, 0},
 	{CMPC_KEYS_HID, 0},
+	{CMPC_KEYS_4GEN_HID, 0},
 	{"", 0}
 };
 
-- 
1.7.5.3

