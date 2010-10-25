Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0JYAJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:09:48 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:46108 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab0JYAJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:09:46 -0400
Message-ID: <4CC4C9AE.5050402@lougher.demon.co.uk>
Date: Mon, 25 Oct 2010 01:05:02 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] Squashfs: fix use of __le64 annotated variable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes a sparse with endian checking warning.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/xattr.c |    9 +++++----
  1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/xattr.c b/fs/squashfs/xattr.c
index 652b854..3876c36 100644
--- a/fs/squashfs/xattr.c
+++ b/fs/squashfs/xattr.c
@@ -158,17 +158,18 @@ static int squashfs_xattr_get(struct inode *inode, int name_index,
  					strncmp(target, name, name_size) == 0) {
  			/* found xattr */
  			if (type & SQUASHFS_XATTR_VALUE_OOL) {
-				__le64 xattr;
+				__le64 xattr_val;
+				u64 xattr;
  				/* val is a reference to the real location */
  				err = squashfs_read_metadata(sb, &val, &start,
  						&offset, sizeof(val));
  				if (err < 0)
  					goto failed;
-				err = squashfs_read_metadata(sb, &xattr, &start,
-					 &offset, sizeof(xattr));
+				err = squashfs_read_metadata(sb, &xattr_val,
+					&start, &offset, sizeof(xattr_val));
  				if (err < 0)
  					goto failed;
-				xattr = le64_to_cpu(xattr);
+				xattr = le64_to_cpu(xattr_val);
  				start = SQUASHFS_XATTR_BLK(xattr) +
  							msblk->xattr_table;
  				offset = SQUASHFS_XATTR_OFFSET(xattr);
-- 
1.6.3.3

