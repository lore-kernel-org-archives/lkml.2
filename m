Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784Ab0FPVvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:51:08 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:44277 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab0FPVvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:51:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/1] FS: attr, check ATTR_SIZE in ia_valid not ia_mode
Date: Wed, 16 Jun 2010 23:50:21 +0200
Message-Id: <1276725021-9057-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug introduced by commit "check ATTR_SIZE contraints in
inode_change_ok" which added a size check, but checks the size even if
ATTR_SIZE is not in attr->ia_valid because it tests the bit in
attr->ia_mode.

Test properly against ia_valid.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/attr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 6959666..7ca4181 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -34,7 +34,7 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
 	 * First check size constraints.  These can't be overriden using
 	 * ATTR_FORCE.
 	 */
-	if (attr->ia_mode & ATTR_SIZE) {
+	if (ia_valid & ATTR_SIZE) {
 		int error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
-- 
1.7.1


