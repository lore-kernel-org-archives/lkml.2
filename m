Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab1FUUSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:18:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1FUUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:18:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=cqNN02VBjb6DWNhgddCY7fqzuMVDBwC8RgiHyeJLiCndfghneP0dC85OF5EO35GSW
	MVT+wvr1Mja83qvkSLtCA==
From: Mike Waychison <mikew@google.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, Matt_Domsch@dell.com,
        Mike Waychison <mikew@google.com>
Subject: [PATCH 4/4] efivars: Introduce PSTORE_EFI_ATTRIBUTES
Date: Tue, 21 Jun 2011 13:18:32 -0700
Message-Id: <1308687512-11649-4-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
References: <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the attributes listed for pstore operations in one place,
PSTORE_EFI_ATTRIBUTES.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index f424b10..739994b8 100644
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
@@ -522,8 +526,9 @@ static u64 efi_pstore_write(enum pstore_type_id type, int part, size_t size,
 
 		/* found */
 		found = entry;
-		efivars->ops->set_variable(entry->var.VariableName, &entry->var.VendorGuid,
-					   EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+		efivars->ops->set_variable(entry->var.VariableName,
+					   &entry->var.VendorGuid,
+					   PSTORE_EFI_ATTRIBUTES,
 					   0, NULL);
 	}
 
@@ -533,8 +538,7 @@ static u64 efi_pstore_write(enum pstore_type_id type, int part, size_t size,
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	efivars->ops->set_variable(efi_name, &vendor,
-				   EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
 
 	spin_unlock(&efivars->lock);
-- 
1.7.3.1

