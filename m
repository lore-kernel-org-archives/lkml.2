Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0KRB4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:56:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab0KRB4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:56:19 -0500
From: Josef Bacik <josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, joel.becker@oracle.com, jack@suse.cz
Subject: [PATCH 5/6] Btrfs: fail if we try to use hole punch
Date: Wed, 17 Nov 2010 20:46:19 -0500
Message-Id: <1290044780-2902-6-git-send-email-josef@redhat.com>
In-Reply-To: <1290044780-2902-1-git-send-email-josef@redhat.com>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btrfs doesn't have the ability to punch holes yet, so make sure we return
EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
be added later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78877d7..6f08892 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6936,6 +6936,10 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	alloc_start = offset & ~mask;
 	alloc_end =  (offset + len + mask) & ~mask;
 
+	/* We only support the FALLOC_FL_KEEP_SIZE mode */
+	if (mode && (mode != FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
 	/*
 	 * wait for ordered IO before we have any locks.  We'll loop again
 	 * below with the locks held.
-- 
1.6.6.1

