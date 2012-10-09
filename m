Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2JIFtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 01:49:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60200 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2JIFtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 01:49:08 -0400
Message-ID: <5073BABF.8090206@gmail.com>
Date: Tue, 09 Oct 2012 13:48:47 +0800
From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: jack@suse.cz
CC: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        serge.hallyn@canonical.com, containers@lists.linux-foundation.org
Subject: [PATCH] ext3: fix return values on parse_options() failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

parse_options() in ext3 should return 0 when parse the mount options fails.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 fs/ext3/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 17ae5c8..ebf8312 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1001,7 +1001,7 @@ static int parse_options (char *options, struct super_block *sb,
 			uid = make_kuid(current_user_ns(), option);
 			if (!uid_valid(uid)) {
 				ext3_msg(sb, KERN_ERR, "Invalid uid value %d", option);
-				return -1;
+				return 0;

 			}
 			sbi->s_resuid = uid;
@@ -1012,7 +1012,7 @@ static int parse_options (char *options, struct super_block *sb,
 			gid = make_kgid(current_user_ns(), option);
 			if (!gid_valid(gid)) {
 				ext3_msg(sb, KERN_ERR, "Invalid gid value %d", option);
-				return -1;
+				return 0;
 			}
 			sbi->s_resgid = gid;
 			break;
-- 1.7.1
