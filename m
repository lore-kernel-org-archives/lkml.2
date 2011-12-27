Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1L0OJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:09:12 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:53253 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1L0OJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:09:10 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: [PATCH -next] debugfs: add missing #ifdef HAS_IOMEM
Date: Tue, 27 Dec 2011 15:08:28 +0100
Message-Id: <1324994908-4288-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.7.3
x-cbid: 11122714-4966-0000-0000-000000FF8CB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"debugfs: add tools to printk 32-bit registers" adds new functions which rely
on IOMEM functionality which is not present on all architectures and therefore
result in compile errors:

fs/debugfs/file.c: In function 'debugfs_print_regs32':
fs/debugfs/file.c:561:7: error: implicit declaration of function 'readl' [-Werror=implicit-function-declaration]

Add an #ifdef CONFIG_HAS_IOMEM to fix this

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Alessandro Rubini <rubini@gnudd.com>
---
 fs/debugfs/file.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 989f07f..ea62afa 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -528,6 +528,8 @@ struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_blob);
 
+#ifdef CONFIG_HAS_IOMEM
+
 /*
  * The regset32 stuff is used to print 32-bit registers using the
  * seq_file utilities. We offer printing a register set in an already-opened
@@ -616,3 +618,5 @@ struct dentry *debugfs_create_regset32(const char *name, mode_t mode,
 	return debugfs_create_file(name, mode, parent, regset, &fops_regset32);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_regset32);
+
+#endif /* CONFIG_HAS_IOMEM */
-- 
1.7.7.3

