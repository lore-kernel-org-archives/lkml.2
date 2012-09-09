Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2IIXQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51144 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab2IIXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:01 -0400
Message-Id: <20120909224203.419624475@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Phillip Lougher <phillip@squashfs.org.uk>
Subject: [ 94/95] Squashfs: fix mount time sanity check for corrupted superblock
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

commit cc37f75a9ffbbfcb1c3297534f293c8284e3c5a6 upstream.

A Squashfs filesystem containing nothing but an empty directory,
although unusual and ultimately pointless, is still valid.

The directory_table >= next_table sanity check rejects these
filesystems as invalid because the directory_table is empty and
equal to next_table.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/squashfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


