Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0JOLDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:03:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62707 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0JOLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CMbEZPe/me6i4diQ1bp2/HEe7NMw7fci0iJcfyLxzYZD1zJgDBJqSjl8KuVBcK8fgR
         3X+pcWE3opOpc+QyVFgviU5r8wjXQyT1vxz9QACNGDy2GHOZ6GvwHczn1xYdV4D9xP+b
         HjWUOXSRgVK1Czau9eAEzx1MFUmgTW9AHxAAY=
From: Namhyung Kim <namhyung@gmail.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext3: Remove misplaced BUFFER_TRACE() in ext3_truncate()
Date: Fri, 15 Oct 2010 20:03:02 +0900
Message-Id: <1287140582-5925-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5e0faf4..90a9c3d 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2530,7 +2530,6 @@ void ext3_truncate(struct inode *inode)
 			 */
 		} else {
 			/* Shared branch grows from an indirect block */
-			BUFFER_TRACE(partial->bh, "get_write_access");
 			ext3_free_branches(handle, inode, partial->bh,
 					partial->p,
 					partial->p+1, (chain+n-1) - partial);
-- 
1.7.0.4

