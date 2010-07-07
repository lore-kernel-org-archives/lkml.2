Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0GGVmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:42:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab0GGVkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org
Subject: [PATCH 13/18] ima: use generic_file_llseek for securityfs
Date: Wed,  7 Jul 2010 23:40:15 +0200
Message-Id: <1278538820-1392-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:u/jl3OR8dk/fkaNLXhwwSWit42I0rjZpWo2r11TtB32
 FOW5zd9PGC7QbzncTzzqwb9pxZTC9cV5OI8TfxoXx9sItRpnKZ
 OjYkh+4batN/QDqjcdLV0PjV9LaFImWXsXuoQ2KmDqUt5uqb+U
 u4Pel8IZHoQU02BOLNJ2Q614olTvV1b+Y1+mO70TU17xO3pbll
 h9IBNbxdQA32gZDoRX/Xg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default for llseek will change to no_llseek,
so securityfs users need to add explicit .llseek
assignments. Since we're dealing with regular
files from a VFS perspective, use generic_file_llseek.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org
---
 security/integrity/ima/ima_fs.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 8fe736a..ef21b96 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -45,7 +45,8 @@ static ssize_t ima_show_htable_violations(struct file *filp,
 }
 
 static const struct file_operations ima_htable_violations_ops = {
-	.read = ima_show_htable_violations
+	.read = ima_show_htable_violations,
+	.llseek = generic_file_llseek,
 };
 
 static ssize_t ima_show_measurements_count(struct file *filp,
@@ -57,7 +58,8 @@ static ssize_t ima_show_measurements_count(struct file *filp,
 }
 
 static const struct file_operations ima_measurements_count_ops = {
-	.read = ima_show_measurements_count
+	.read = ima_show_measurements_count,
+	.llseek = generic_file_llseek,
 };
 
 /* returns pointer to hlist_node */
@@ -319,7 +321,8 @@ static int ima_release_policy(struct inode *inode, struct file *file)
 static const struct file_operations ima_measure_policy_ops = {
 	.open = ima_open_policy,
 	.write = ima_write_policy,
-	.release = ima_release_policy
+	.release = ima_release_policy,
+	.llseek = generic_file_llseek,
 };
 
 int __init ima_fs_init(void)
-- 
1.7.1

