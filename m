Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1FHHBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:01:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63341 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1FHHA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rfZeHSuSua/nhc9iUJ2XXsBHzmOQlgjeTuKAmCwYKIK+3wP7W+xi20Luv4tOvKGYuO
         B9WR5faKC0iIT9OBkjU4STjV1bTxxl3DS3asVJqpi1K3nt6J3+NytNpGxbyNm9HN9gsW
         2h3vrzGlL3f2cr0KSKmIYMaib7EQR4WO1o/co=
From: Connor Hansen <cmdkhh@gmail.com>
To: petr@vandrovec.name
Cc: npiggin@kernel.dk, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Connor Hansen <cmdkhh@gmail.com>
Subject: [PATCH] fs/ncpfs/dir.c unused variable sb
Date: Wed,  8 Jun 2011 00:00:37 -0700
Message-Id: <1307516437-27496-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

during randconfig testing,

fs/ncpfs/dir.c: in function ncp_hash_dentry:
fs/nspfs/dir.c:128:23: warning: unused variable sb

pass dentry->d_sb instead of first creating an
unnecessary pointer to it.

Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
---
 fs/ncpfs/dir.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 9c51f62..a8d42af 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -125,12 +125,11 @@ ncp_hash_dentry(const struct dentry *dentry, const struct inode *inode,
 		struct qstr *this)
 {
 	if (!ncp_case_sensitive(inode)) {
-		struct super_block *sb = dentry->d_sb;
 		struct nls_table *t;
 		unsigned long hash;
 		int i;
 
-		t = NCP_IO_TABLE(sb);
+		t = NCP_IO_TABLE(dentry->d_sb);
 		hash = init_name_hash();
 		for (i=0; i<this->len ; i++)
 			hash = partial_name_hash(ncp_tolower(t, this->name[i]),
-- 
1.7.4.4

