Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab2GLO0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:26:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:10781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161124Ab2GLOY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121595880"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 3/4] hfsplus: remove useless check
Date: Thu, 12 Jul 2012 17:26:30 +0300
Message-Id: <1342103191-17406-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342103191-17406-1-git-send-email-dedekind1@gmail.com>
References: <1342103191-17406-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This check is useless because we always have 'sb->s_fs_info' to be non-NULL.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfsplus/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 9e9c2788..f4f3d54 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -240,9 +240,6 @@ static void hfsplus_put_super(struct super_block *sb)
 
 	dprint(DBG_SUPER, "hfsplus_put_super\n");
 
-	if (!sb->s_fs_info)
-		return;
-
 	if (!(sb->s_flags & MS_RDONLY) && sbi->s_vhdr) {
 		struct hfsplus_vh *vhdr = sbi->s_vhdr;
 
-- 
1.7.7.6

