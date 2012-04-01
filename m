Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2DACOB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 22:14:01 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42472 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2DACN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 22:13:58 -0400
Message-ID: <4F77B9D5.2030608@gmail.com>
Date: Sun, 01 Apr 2012 10:13:41 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/extent_io.c: remove the useless assignment to entry
 in tree_insert
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tree_insert, entry is used in the loop only, and is useless
out of the loop. Remove the useless assignment after the loop.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9ed9d2c..6099261 100644
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

