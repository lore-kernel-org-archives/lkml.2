Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748Ab0JSD6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:58:47 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933558Ab0JSD4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSFDIU+
Message-Id: <20101019034659.174550793@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:51 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 35/35] fs: icache document more lock orders
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-more-lock-doc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some more documentation of (existing) lock orders

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -51,7 +51,9 @@
  *   inode_list_lglock
  *   zone->inode_lru_lock
  *   wb->b_lock
+ *     sb_lock (pin_sb_for_writeback)
  *   inode_hash_bucket lock
+ *   dentry->d_lock (alias management)
  */
 /*
  * This is needed for the following functions:


