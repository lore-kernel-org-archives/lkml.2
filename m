Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab2JKKdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:33:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53483 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467Ab2JKKc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:32:27 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] efivarfs: efivarfs_fill_super() ensure we free our temporary name
Date: Thu, 11 Oct 2012 11:32:20 +0100
Message-Id: <1349951541-20498-5-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349951541-20498-1-git-send-email-apw@canonical.com>
References: <1349416496.810727.310563927016.1.gpush@pecola>
 <1349951541-20498-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_alloc_name() copies the passed name to new storage, once complete we
no longer need our name.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/firmware/efivars.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 79f3e4e..dcb34ae 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -992,6 +992,8 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 		inode = efivarfs_get_inode(efivarfs_sb, root->d_inode,
 					  S_IFREG | 0644, 0);
 		dentry = d_alloc_name(root, name);
+		/* copied by the above to local storage in the dentry. */
+		kfree(name);
 
 		efivars->ops->get_variable(entry->var.VariableName,
 					   &entry->var.VendorGuid,
-- 
1.7.9.5

