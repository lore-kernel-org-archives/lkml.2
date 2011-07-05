Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1GEHpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 03:45:42 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:5562 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1GEHpm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Tue, 5 Jul 2011 03:45:42 -0400
Message-Id: <4E12DD41020000780004C1C9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 05 Jul 2011 08:45:37 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <Matt_Domsch@Dell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] efivars: remove stray exports
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no in-tree consumer, and the way they are currently prototyped
it doesn't look like they're really usable from anywhere but the base
EFI implementation.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/firmware/efivars.c |   13 ++++++-------
 include/linux/efi.h        |    5 -----
 2 files changed, 6 insertions(+), 12 deletions(-)

--- 3.0-rc6/drivers/firmware/efivars.c
+++ 3.0-rc6-EFI-vars/drivers/firmware/efivars.c
@@ -625,7 +625,7 @@ efivar_create_sysfs_entry(struct efivars
 	return 0;
 }
 
-static int
+static int __init
 create_efivars_bin_attributes(struct efivars *efivars)
 {
 	struct bin_attribute *attr;
@@ -684,7 +684,7 @@ out_free:
 	return error;
 }
 
-void unregister_efivars(struct efivars *efivars)
+static void unregister_efivars(struct efivars *efivars)
 {
 	struct efivar_entry *entry, *n;
 
@@ -702,11 +702,11 @@ void unregister_efivars(struct efivars *
 	kfree(efivars->del_var);
 	kset_unregister(efivars->kset);
 }
-EXPORT_SYMBOL_GPL(unregister_efivars);
 
-int register_efivars(struct efivars *efivars,
-		     const struct efivar_operations *ops,
-		     struct kobject *parent_kobj)
+static int __init
+register_efivars(struct efivars *efivars,
+		 const struct efivar_operations *ops,
+		 struct kobject *parent_kobj)
 {
 	efi_status_t status = EFI_NOT_FOUND;
 	efi_guid_t vendor_guid;
@@ -768,7 +768,6 @@ out:
 
 	return error;
 }
-EXPORT_SYMBOL_GPL(register_efivars);
 
 static struct efivars __efivars;
 static struct efivar_operations ops;
--- 3.0-rc6/include/linux/efi.h
+++ 3.0-rc6-EFI-vars/include/linux/efi.h
@@ -428,11 +428,6 @@ struct efivars {
 	const struct efivar_operations *ops;
 };
 
-int register_efivars(struct efivars *efivars,
-		     const struct efivar_operations *ops,
-		     struct kobject *parent_kobj);
-void unregister_efivars(struct efivars *efivars);
-
 #endif /* CONFIG_EFI_VARS */
 
 #endif /* _LINUX_EFI_H */



