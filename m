Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0ELPv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:51:26 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33770 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab0ELPvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:51:20 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V7 6/9] ext4: Add get_fsid callback
Date: Wed, 12 May 2010 21:20:41 +0530
Message-Id: <1273679444-14903-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14d22c..fc7d464 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1049,6 +1049,19 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 	return try_to_free_buffers(page);
 }
 
+static int ext4_get_fsid(struct super_block *sb, struct uuid *fsid)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
+
+	memcpy(fsid->uuid, es->s_uuid, sizeof(fsid->uuid));
+	/*
+	 * We may want to make sure we return error if the s_uuid is not
+	 * exactly unique
+	 */
+	return 0;
+}
+
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
 #define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
@@ -1109,6 +1122,7 @@ static const struct super_operations ext4_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.get_fsid	= ext4_get_fsid,
 };
 
 static const struct super_operations ext4_nojournal_sops = {
@@ -1128,6 +1142,7 @@ static const struct super_operations ext4_nojournal_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.get_fsid	= ext4_get_fsid,
 };
 
 static const struct export_operations ext4_export_ops = {
-- 
1.7.1.78.g212f0

