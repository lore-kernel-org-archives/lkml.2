Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab2DFGfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:35:21 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44919 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2DFGfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:35:19 -0400
Message-ID: <4F7E8E99.3080306@gmail.com>
Date: Fri, 06 Apr 2012 14:35:05 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4 RESEND] Btrfs: remove the useless assignment to *entry
 in function tree_insert of file extent_io.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tree_insert, var *entry is used in the loop only, and is useless
out of the loop. Remove the useless assignment after the loop.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8d904dd..7b679e2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -186,7 +186,6 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
 			return parent;
 	}
 
-	entry = rb_entry(node, struct tree_entry, rb_node);
 	rb_link_node(node, parent, p);
 	rb_insert_color(node, root);
 	return NULL;
-- 
1.7.1

