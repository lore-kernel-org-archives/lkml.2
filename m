Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0KHUl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:41:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab0KHUki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:40:38 -0500
From: Josef Bacik <josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
        cluster-devel@redhat.com
Subject: [PATCH 4/6] Ext4: fail if we try to use hole punch
Date: Mon,  8 Nov 2010 15:32:05 -0500
Message-Id: <1289248327-16308-4-git-send-email-josef@redhat.com>
In-Reply-To: <1289248327-16308-1-git-send-email-josef@redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ext4 doesn't have the ability to punch holes yet, so make sure we return
EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
be added later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ext4/extents.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0554c48..9bff6bd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3622,6 +3622,10 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	struct ext4_map_blocks map;
 	unsigned int credits, blkbits = inode->i_blkbits;
 
+	/* We only support the FALLOC_FL_KEEP_SIZE mode */
+	if (mode && (mode & FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
 	/*
 	 * currently supporting (pre)allocate mode for extent-based
 	 * files _only_
-- 
1.6.6.1

