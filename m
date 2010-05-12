Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab0ELPvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:51:36 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44141 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab0ELPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:51:31 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V7 9/9] ext3: Add get_fsid callback
Date: Wed, 12 May 2010 21:20:44 +0530
Message-Id: <1273679444-14903-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

