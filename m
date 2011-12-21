Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1LUTYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:24:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1LUTYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:24:25 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] reiserfs: Fix quota mount option parsing
Date: Wed, 21 Dec 2011 20:23:55 +0100
Message-Id: <1324495436-11203-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1324495436-11203-1-git-send-email-jack@suse.cz>
References: <1324495436-11203-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When jqfmt mount option is not specified on remount, we mistakenly clear
s_jquota_fmt value stored in superblock. Fix the problem.

CC: reiserfs-devel@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 14363b9..f9eaa4a 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1164,7 +1164,8 @@ static void handle_quota_files(struct super_block *s, char **qf_names,
 			kfree(REISERFS_SB(s)->s_qf_names[i]);
 		REISERFS_SB(s)->s_qf_names[i] = qf_names[i];
 	}
-	REISERFS_SB(s)->s_jquota_fmt = *qfmt;
+	if (*qfmt)
+		REISERFS_SB(s)->s_jquota_fmt = *qfmt;
 }
 #endif
 
-- 
1.7.1

