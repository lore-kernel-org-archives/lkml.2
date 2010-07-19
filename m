Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966578Ab0GSTN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:13:28 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42623 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966542Ab0GSTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:13:24 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V17 11/12] ext3: Copy fs UUID to superblock.
Date: Tue, 20 Jul 2010 00:42:06 +0530
Message-Id: <1279566727-16598-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.rc3.43.g24e7a
In-Reply-To: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File system UUID is made available to application
via  /proc/<pid>/mountinfo

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext3/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 6c953bb..1596795 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1931,6 +1931,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	sb->s_qcop = &ext3_qctl_operations;
 	sb->dq_op = &ext3_quota_operations;
 #endif
+	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
 	mutex_init(&sbi->s_resize_lock);
-- 
1.7.2.rc3.43.g24e7a

