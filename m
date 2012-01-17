Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2AQNZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:25:36 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:43625 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab2AQNWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:15 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 08:22:13 EST
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 21/50] ACPICA: Update for larger ACPI 5 FADT size
Date: Tue, 17 Jan 2012 07:21:13 -0500
Message-id: <ecafe6faa294697305453b5a6af7760b94622787.1326802229.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

FADT is now larger than 256 bytes, so all FADT offsets must be
changed from 8 bits to 16 bits.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/tbfadt.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index 1e1a7de..ff1f7f0 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -63,14 +63,15 @@ static void acpi_tb_setup_fadt_registers(void);
 
 typedef struct acpi_fadt_info {
 	char *name;
-	u8 address64;
-	u8 address32;
-	u8 length;
+	u16 address64;
+	u16 address32;
+	u16 length;
 	u8 default_length;
 	u8 type;
 
 } acpi_fadt_info;
 
+#define ACPI_FADT_OPTIONAL          0
 #define ACPI_FADT_REQUIRED          1
 #define ACPI_FADT_SEPARATE_LENGTH   2
 
@@ -87,7 +88,7 @@ static struct acpi_fadt_info fadt_info_table[] = {
 	 ACPI_FADT_OFFSET(pm1b_event_block),
 	 ACPI_FADT_OFFSET(pm1_event_length),
 	 ACPI_PM1_REGISTER_WIDTH * 2,	/* Enable + Status register */
-	 0},
+	 ACPI_FADT_OPTIONAL},
 
 	{"Pm1aControlBlock",
 	 ACPI_FADT_OFFSET(xpm1a_control_block),
@@ -101,7 +102,7 @@ static struct acpi_fadt_info fadt_info_table[] = {
 	 ACPI_FADT_OFFSET(pm1b_control_block),
 	 ACPI_FADT_OFFSET(pm1_control_length),
 	 ACPI_PM1_REGISTER_WIDTH,
-	 0},
+	 ACPI_FADT_OPTIONAL},
 
 	{"Pm2ControlBlock",
 	 ACPI_FADT_OFFSET(xpm2_control_block),
@@ -139,7 +140,7 @@ static struct acpi_fadt_info fadt_info_table[] = {
 
 typedef struct acpi_fadt_pm_info {
 	struct acpi_generic_address *target;
-	u8 source;
+	u16 source;
 	u8 register_num;
 
 } acpi_fadt_pm_info;
-- 
1.7.9.rc1

