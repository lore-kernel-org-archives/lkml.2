Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0INUXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:23:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab0INUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 15/15] vfs: make no_llseek the default
Date: Tue, 14 Sep 2010 22:22:43 +0200
Message-Id: <1284495763-7506-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:HDYrw6AODeLnNy0aaR+qiQBbyusdjpu0nu9tS8Ji9+4
 hqe4d9Gz5w9DeDh1HAfVm4ND91A6OJseYodZ+lN+adVEyHLuYt
 tla3aXXBcfw5gzyNC4qmTNIrlNeNAEawhNAo6Wmiw5QgGmttpt
 DceCcf7dmkpIyQmd5Sn+IlfcASj8zJJRIpZLfaPJumPtqRZVoz
 QJQUNWzOlnOdMozmbI49g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All file operations now have an explicit .llseek
operation pointer, so we can change the default
action for future code.

This makes changes the default from default_llseek
to no_llseek, which always returns -ESPIPE if
a user tries to seek on a file without a .llseek
operation.

The name of the default_llseek function remains
unchanged, if anyone thinks we should change it,
please speak up.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/read_write.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index fd09f61..e757ef2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -156,7 +156,6 @@ loff_t vfs_llseek(struct file *file, loff_t offset, int origin)
 
 	fn = no_llseek;
 	if (file->f_mode & FMODE_LSEEK) {
-		fn = default_llseek;
 		if (file->f_op && file->f_op->llseek)
 			fn = file->f_op->llseek;
 	}
-- 
1.7.1

