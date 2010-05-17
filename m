Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0EQFek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:34:40 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:53361 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab0EQFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:34:16 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V8 9/9] ext3: Add get_fsid callback
Date: Mon, 17 May 2010 11:03:52 +0530
Message-Id: <1274074432-29695-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext3/super.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 1bee604..63c322e 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -734,6 +734,15 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 	return try_to_free_buffers(page);
 }
 
+static int ext3_get_fsid(struct super_block *sb, struct uuid *fsid)
+{
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	struct ext3_super_block *es = sbi->s_es;
+
+	memcpy(fsid->uuid, es->s_uuid, sizeof(fsid->uuid));
+	return 0;
+}
+
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t)==USRQUOTA?"user":"group")
 #define QTYPE2MOPT(on, t) ((t)==USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
@@ -791,6 +800,7 @@ static const struct super_operations ext3_sops = {
 	.quota_write	= ext3_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.get_fsid	= ext3_get_fsid,
 };
 
 static const struct export_operations ext3_export_ops = {
-- 
1.7.1.78.g212f0

