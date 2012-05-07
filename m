Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2EGQ4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:56:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:19926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab2EGQ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:56:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="137865884"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/4] jffs2: remove lock_super
Date: Mon,  7 May 2012 19:56:50 +0300
Message-Id: <1336409813-6365-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336409813-6365-1-git-send-email-dedekind1@gmail.com>
References: <1336409813-6365-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We do not need 'lock_super()'/'unlock_super()' in JFFS2 - kill them.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/jffs2/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index f9916f3..3422a2d 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -67,15 +67,12 @@ static void jffs2_write_super(struct super_block *sb)
 {
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 
-	lock_super(sb);
 	sb->s_dirt = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		jffs2_dbg(1, "%s()\n", __func__);
 		jffs2_flush_wbuf_gc(c, 0);
 	}
-
-	unlock_super(sb);
 }
 
 static const char *jffs2_compr_name(unsigned int compr)
-- 
1.7.7.6

