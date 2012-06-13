Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2FMLhC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:37:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:16557 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab2FMLgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:36:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157039740"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] hfsplus: remove useless check
Date: Wed, 13 Jun 2012 14:37:50 +0300
Message-Id: <1339587471-2713-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
References: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
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

