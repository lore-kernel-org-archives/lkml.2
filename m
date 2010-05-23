Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0EWJ34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:29:56 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34030 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0EWJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:28:42 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V12 06/11] ext4: Copy fs UUID to superblock
Date: Sun, 23 May 2010 14:58:19 +0530
Message-Id: <1274606904-27023-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.226.g770c5
In-Reply-To: <1274606904-27023-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1274606904-27023-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables userspace application to find the file system
UUID using sys_name_to_handle_at syscall

Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14d22c..02ba21b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2828,6 +2828,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_qcop = &ext4_qctl_operations;
 	sb->dq_op = &ext4_quota_operations;
 #endif
+	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
+
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
 	mutex_init(&sbi->s_resize_lock);
-- 
1.7.1.226.g770c5

