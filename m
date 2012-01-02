Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2ABXxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 18:53:18 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:45899 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab2ABXxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 18:53:16 -0500
Date: Mon, 02 Jan 2012 23:53:00 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH] Squashfs: fix mount time sanity check for corrupted
 superblock
Message-ID: <4f02435c.KriZjDqB1gbu6Lro%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A Squashfs filesystem containing nothing but an empty directory,
although unusual and ultimately pointless, is still valid.

The directory_table >= next_table sanity check rejects these
filesystems as invalid because the directory_table is empty and
equal to next_table.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 2da1715..4619247 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -290,7 +290,7 @@ handle_fragments:
 
 check_directory_table:
 	/* Sanity check directory_table */
-	if (msblk->directory_table >= next_table) {
+	if (msblk->directory_table > next_table) {
 		err = -EINVAL;
 		goto failed_mount;
 	}
-- 
1.7.5.4

