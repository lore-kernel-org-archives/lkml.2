Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2KCK7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 06:59:04 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:9242 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298Ab2KCK6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:53 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245673"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Joern Engel <joern@logfs.org>
Cc: kernel-janitors@vger.kernel.org,
        Prasad Joshi <prasadjoshi.linux@gmail.com>, logfs@logfs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] fs/logfs/gc.c: use WARN
Date: Sat,  3 Nov 2012 11:58:33 +0100
Message-Id: <1351940317-14812-13-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/logfs/gc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/logfs/gc.c b/fs/logfs/gc.c
index d4efb06..62dee03 100644
--- a/fs/logfs/gc.c
+++ b/fs/logfs/gc.c
@@ -55,9 +55,8 @@ static u8 root_distance(struct super_block *sb, gc_level_t __gc_level)
 		/* inode file data or indirect blocks */
 		return super->s_ifile_levels - (gc_level - 6);
 	default:
-		printk(KERN_ERR"LOGFS: segment of unknown level %x found\n",
+		WARN(1, KERN_ERR "LOGFS: segment of unknown level %x found\n",
 				gc_level);
-		WARN_ON(1);
 		return super->s_ifile_levels + super->s_iblock_levels;
 	}
 }
