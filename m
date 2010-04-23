Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0DWCTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:19:10 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:33297 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058Ab0DWCTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:19:08 -0400
Message-ID: <4BD10360.8020104@lougher.demon.co.uk>
Date: Fri, 23 Apr 2010 03:18:08 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/4] squashfs: fix warn_on when root inode is corrupted
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix warn_on triggered by mounting a fsfuzzer corrupted file system, where
the root inode has been corrupted.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/super.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 3550aec..07ceeb8 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -275,7 +275,8 @@ allocate_root:

  	err = squashfs_read_inode(root, root_inode);
  	if (err) {
-		iget_failed(root);
+		make_bad_inode(root);
+		iput(root);
  		goto failed_mount;
  	}
  	insert_inode_hash(root);
-- 
1.6.3.3

