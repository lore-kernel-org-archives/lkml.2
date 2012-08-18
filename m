Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2HRRcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:32:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:8308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab2HRRac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182354051"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 24/31] sections: Fix section conflicts in drivers/platform/x86
Date: Sat, 18 Aug 2012 10:30:15 -0700
Message-Id: <1345311022-26328-25-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/platform/x86/amilo-rfkill.c   |    2 +-
 drivers/platform/x86/fujitsu-tablet.c |   10 +++++-----
 drivers/platform/x86/thinkpad_acpi.c  |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/amilo-rfkill.c b/drivers/platform/x86/amilo-rfkill.c
index a514bf6..1deca7f 100644
--- a/drivers/platform/x86/amilo-rfkill.c
+++ b/drivers/platform/x86/amilo-rfkill.c
@@ -74,7 +74,7 @@ static const struct rfkill_ops amilo_m7440_rfkill_ops = {
 	.set_block = amilo_m7440_rfkill_set_block
 };
 
-static const struct dmi_system_id __devinitdata amilo_rfkill_id_table[] = {
+static const struct dmi_system_id __devinitconst amilo_rfkill_id_table[] = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
diff --git a/drivers/platform/x86/fujitsu-tablet.c b/drivers/platform/x86/fujitsu-tablet.c
index 7acae3f..f774845 100644
--- a/drivers/platform/x86/fujitsu-tablet.c
+++ b/drivers/platform/x86/fujitsu-tablet.c
@@ -52,7 +52,7 @@ struct fujitsu_config {
 	unsigned int quirks;
 };
 
-static unsigned short keymap_Lifebook_Tseries[KEYMAP_LEN] __initconst = {
+static unsigned short keymap_Lifebook_Tseries[KEYMAP_LEN] __initdata = {
 	KEY_RESERVED,
 	KEY_RESERVED,
 	KEY_RESERVED,
@@ -71,7 +71,7 @@ static unsigned short keymap_Lifebook_Tseries[KEYMAP_LEN] __initconst = {
 	KEY_LEFTALT
 };
 
-static unsigned short keymap_Lifebook_U810[KEYMAP_LEN] __initconst = {
+static unsigned short keymap_Lifebook_U810[KEYMAP_LEN] __initdata = {
 	KEY_RESERVED,
 	KEY_RESERVED,
 	KEY_RESERVED,
@@ -90,7 +90,7 @@ static unsigned short keymap_Lifebook_U810[KEYMAP_LEN] __initconst = {
 	KEY_LEFTALT
 };
 
-static unsigned short keymap_Stylistic_Tseries[KEYMAP_LEN] __initconst = {
+static unsigned short keymap_Stylistic_Tseries[KEYMAP_LEN] __initdata = {
 	KEY_RESERVED,
 	KEY_RESERVED,
 	KEY_RESERVED,
@@ -109,7 +109,7 @@ static unsigned short keymap_Stylistic_Tseries[KEYMAP_LEN] __initconst = {
 	KEY_LEFTALT
 };
 
-static unsigned short keymap_Stylistic_ST5xxx[KEYMAP_LEN] __initconst = {
+static unsigned short keymap_Stylistic_ST5xxx[KEYMAP_LEN] __initdata = {
 	KEY_RESERVED,
 	KEY_RESERVED,
 	KEY_RESERVED,
@@ -299,7 +299,7 @@ static int __devinit fujitsu_dmi_stylistic(const struct dmi_system_id *dmi)
 	return 1;
 }
 
-static struct dmi_system_id dmi_ids[] __initconst = {
+static const struct dmi_system_id dmi_ids[] __initconst = {
 	{
 		.callback = fujitsu_dmi_lifebook,
 		.ident = "Fujitsu Siemens P/T Series",
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index f28f36c..b5528ce 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -522,7 +522,7 @@ static acpi_handle ec_handle;
 
 #define TPACPI_HANDLE(object, parent, paths...)			\
 	static acpi_handle  object##_handle;			\
-	static const acpi_handle *object##_parent __initdata =	\
+	static const acpi_handle * const object##_parent __initconst =	\
 						&parent##_handle; \
 	static char *object##_paths[] __initdata = { paths }
 
-- 
1.7.7.6

