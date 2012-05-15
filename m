Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab2EOMEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:04:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:46326 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2EOMEj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 15 May 2012 08:04:39 -0400
Message-Id: <4FB262940200007800083CAC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 15 May 2012 13:05:08 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <Matt_Domsch@Dell.com>, <matt.fleming@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] efivars: remove stray exports
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

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/firmware/efivars.c |   13 ++++++-------
 include/linux/efi.h        |    5 -----
 2 files changed, 6 insertions(+), 12 deletions(-)

--- 3.4-rc7/drivers/firmware/efivars.c
+++ 3.4-rc7-efivars/drivers/firmware/efivars.c
@@ -1039,7 +1039,7 @@ efivar_create_sysfs_entry(struct efivars
 	return 0;
 }
 
-static int
+static int __init
 create_efivars_bin_attributes(struct efivars *efivars)
 {
 	struct bin_attribute *attr;
@@ -1098,7 +1098,7 @@ out_free:
 	return error;
 }
 
-void unregister_efivars(struct efivars *efivars)
+static void unregister_efivars(struct efivars *efivars)
 {
 	struct efivar_entry *entry, *n;
 
@@ -1116,11 +1116,11 @@ void unregister_efivars(struct efivars *
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
@@ -1192,7 +1192,6 @@ out:
 
 	return error;
 }
-EXPORT_SYMBOL_GPL(register_efivars);
 
 static struct efivars __efivars;
 static struct efivar_operations ops;
--- 3.4-rc7/include/linux/efi.h
+++ 3.4-rc7-efivars/include/linux/efi.h
@@ -655,11 +655,6 @@ struct efivars {
 	struct pstore_info efi_pstore_info;
 };
 
-int register_efivars(struct efivars *efivars,
-		     const struct efivar_operations *ops,
-		     struct kobject *parent_kobj);
-void unregister_efivars(struct efivars *efivars);
-
 #endif /* CONFIG_EFI_VARS */
 
 #endif /* _LINUX_EFI_H */



