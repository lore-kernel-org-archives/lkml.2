Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447Ab2CTOol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:44:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:13019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329Ab2CTOlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:41:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141907373"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Ted Tso <tytso@mit.edu>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 3/9] ext4: remove useless s_dirt assignment
Date: Tue, 20 Mar 2012 16:41:23 +0200
Message-Id: <1332254489-2300-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Clean-up ext4 a tiny bit by removing useless s_dirt assignment in
'ext4_fill_super()' because a bit later we anyway call 'ext4_setup_super()'
which writes the superblock to the media unconditionally.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c1f5111..d280bb6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3415,7 +3415,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #else
 		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
 #endif
-		sb->s_dirt = 1;
 	}
 
 	/* Handle clustersize */
-- 
1.7.7.6

