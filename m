Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab2KCLBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:01:32 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:9242 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab2KCK6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245670"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: kernel-janitors@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/16] fs/ext4/indirect.c: use WARN
Date: Sat,  3 Nov 2012 11:58:30 +0100
Message-Id: <1351940317-14812-10-git-send-email-Julia.Lawall@lip6.fr>
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
 fs/ext4/indirect.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 792e388..0cdd20f 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -354,9 +354,8 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 			 * for the first direct block
 			 */
 			new_blocks[index] = current_block;
-			printk(KERN_INFO "%s returned more blocks than "
+			WARN(1, KERN_INFO "%s returned more blocks than "
 						"requested\n", __func__);
-			WARN_ON(1);
 			break;
 		}
 	}

