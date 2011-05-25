Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1EYDUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:20:14 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:39965 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1EYDUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:20:10 -0400
Date: Wed, 25 May 2011 04:18:12 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] Squashfs: add sanity checks to xattr reading at mount time
Message-ID: <4ddc74f4.zl8nlUVgLr60n43H%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These checks add sanity checking of the mount-time xattr structures.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/xattr_id.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
index 51a7bd0..f60fb3c 100644
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -76,6 +76,17 @@ __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 start,
 	*xattr_table_start = le64_to_cpu(id_table->xattr_table_start);
 	*xattr_ids = le32_to_cpu(id_table->xattr_ids);
 	kfree(id_table);
+
+	/* Sanity check values */
+
+	/* there is always at least one xattr id */
+	if (*xattr_ids == 0)
+		return ERR_PTR(-EINVAL);
+
+	/* xattr_table should be less than start */
+	if (*xattr_table_start >= start)
+		return ERR_PTR(-EINVAL);
+
 	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
 
 	TRACE("In read_xattr_index_table, length %d\n", len);
-- 
1.7.1

