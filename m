Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab0I1TiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:38:06 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44756 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793Ab0I1TiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:38:02 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V20 12/12] ext4: Copy fs UUID to superblock
Date: Wed, 29 Sep 2010 01:06:50 +0530
Message-Id: <1285702610-32733-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285702610-32733-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1285702610-32733-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File system UUID is made available to application
via  /proc/<pid>/mountinfo

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2614774..b46a78c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2941,6 +2941,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_qcop = &ext4_qctl_operations;
 	sb->dq_op = &ext4_quota_operations;
 #endif
+	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
+
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
 	mutex_init(&sbi->s_resize_lock);
-- 
1.7.0.4

