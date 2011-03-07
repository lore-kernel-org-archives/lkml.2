Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1CGX1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:27:12 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60537 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab1CGX1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:27:09 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Subject: [PATCH] thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.
Date: Mon,  7 Mar 2011 17:26:47 -0600
Message-Id: <1299540407-3779-2-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299540407-3779-1-git-send-email-manoj.iyer@canonical.com>
References: <1299540407-3779-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newer Lenovo ThinkPads have HKEY HID of LEN0068 instead
of IBM0068. Added new HID so that thinkpad_acpi module will
auto load on these newer Lenovo ThinkPads.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index eb99223..125d891 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -128,7 +128,8 @@ enum {
 };
 
 /* ACPI HIDs */
-#define TPACPI_ACPI_HKEY_HID		"IBM0068"
+#define TPACPI_ACPI_IBM_HKEY_HID	"IBM0068"
+#define TPACPI_ACPI_LENOVO_HKEY_HID	"LEN0068"
 #define TPACPI_ACPI_EC_HID		"PNP0C09"
 
 /* Input IDs */
@@ -3879,7 +3880,8 @@ errexit:
 }
 
 static const struct acpi_device_id ibm_htk_device_ids[] = {
-	{TPACPI_ACPI_HKEY_HID, 0},
+	{TPACPI_ACPI_IBM_HKEY_HID, 0},
+	{TPACPI_ACPI_LENOVO_HKEY_HID, 0},
 	{"", 0},
 };
 
-- 
1.7.1

