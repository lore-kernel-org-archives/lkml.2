Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966070Ab0GPQPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:15:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45293 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965991Ab0GPQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ocUHkOj6CAifCP8uWxHkVGus1PCaZpfjriINH9KZ8bKatIKyV08UsrdcMncuaxm0XL
         2uZkqfhPvCm5tXLAB4Wl85wXmf7KcZ2es1chZY4Q/MCpGI3nuOObp4pfpU1HdTFN0Iux
         gFe0aZw4pVefPFu14NR0tiEFVTE9fsjTsHZl8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, Jeff Layton <jlayton@redhat.com>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Joe Perches <joe@perches.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] fs: cifs: check kmalloc() result
Date: Fri, 16 Jul 2010 20:15:25 +0400
Message-Id: <1279296925-25147-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kmalloc() fails exit with -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/cifs/readdir.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index daf1753..d5e591f 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -847,6 +847,11 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
 
 		tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
+		if (tmp_buf == NULL) {
+			rc = -ENOMEM;
+			break;
+		}
+
 		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
 			if (current_entry == NULL) {
 				/* evaluate whether this case is an error */
-- 
1.7.0.4

