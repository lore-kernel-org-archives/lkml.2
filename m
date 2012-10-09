Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2JIFo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 01:44:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51446 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2JIFo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 01:44:57 -0400
Message-ID: <5073B9C4.9070009@gmail.com>
Date: Tue, 09 Oct 2012 13:44:36 +0800
From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: jack@suse.cz
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        serge.hallyn@canonical.com, containers@lists.linux-foundation.org
Subject: [PATCH] ext2: fix return values on parse_options() failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

parse_options() in ext2 should return 0 when parse the mount options fails.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 fs/ext2/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 6c205d0..fa04d02 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -469,7 +469,7 @@ static int parse_options(char *options, struct super_block *sb)
 			uid = make_kuid(current_user_ns(), option);
 			if (!uid_valid(uid)) {
 				ext2_msg(sb, KERN_ERR, "Invalid uid value %d", option);
-				return -1;
+				return 0;

 			}
 			sbi->s_resuid = uid;
@@ -480,7 +480,7 @@ static int parse_options(char *options, struct super_block *sb)
 			gid = make_kgid(current_user_ns(), option);
 			if (!gid_valid(gid)) {
 				ext2_msg(sb, KERN_ERR, "Invalid gid value %d", option);
-				return -1;
+				return 0;
 			}
 			sbi->s_resgid = gid;
 			break;
-- 1.7.1
