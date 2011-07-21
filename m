Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1GUVAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:00:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab1GUVAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:00:03 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mikew@google.com, tony.luck@intel.com
Subject: [PATCH V2 9/9] efivars: Introduce PSTORE_EFI_ATTRIBUTES
Date: Thu, 21 Jul 2011 16:58:00 -0400
Message-Id: <1311281880-28041-10-git-send-email-mjg@redhat.com>
In-Reply-To: <1311281880-28041-1-git-send-email-mjg@redhat.com>
References: <1311281880-28041-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Consolidate the attributes listed for pstore operations in one place,
PSTORE_EFI_ATTRIBUTES.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 563492e..eacb05e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -122,6 +122,10 @@ struct efivar_attribute {
 	ssize_t (*store)(struct efivar_entry *entry, const char *buf, size_t count);
 };
 
+#define PSTORE_EFI_ATTRIBUTES \
+	(EFI_VARIABLE_NON_VOLATILE | \
+	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
+	 EFI_VARIABLE_RUNTIME_ACCESS)
 
 #define EFIVAR_ATTR(_name, _mode, _show, _store) \
 struct efivar_attribute efivar_attr_##_name = { \
@@ -523,8 +527,9 @@ static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
 
 		/* found */
 		found = entry;
-		efivars->ops->set_variable(entry->var.VariableName, &entry->var.VendorGuid,
-					   EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+		efivars->ops->set_variable(entry->var.VariableName,
+					   &entry->var.VendorGuid,
+					   PSTORE_EFI_ATTRIBUTES,
 					   0, NULL);
 	}
 
@@ -534,8 +539,7 @@ static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	efivars->ops->set_variable(efi_name, &vendor,
-				   EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
 
 	spin_unlock(&efivars->lock);
-- 
1.7.6

