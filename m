Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab0GEMUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:20:30 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49118 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab0GEMSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:18:50 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCHv6 5/9] sysv: do not mark superblock dirty on mount
Date: Mon,  5 Jul 2010 15:15:03 +0300
Message-Id: <1278332107-11443-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
References: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 05 Jul 2010 12:18:43.0765 (UTC) FILETIME=[35DF8E50:01CB1C3C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

I did not find any docs about this file-system, and I have no possibility
to test my changes. Thus, this is untested.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/sysv/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 5a903da..0e44a62 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -347,7 +347,6 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		sb->s_flags |= MS_RDONLY;
 	if (sbi->s_truncate)
 		sb->s_root->d_op = &sysv_dentry_operations;
-	sb->s_dirt = 1;
 	return 1;
 }
 
-- 
1.7.0.1

