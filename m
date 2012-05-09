Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2EIG13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:27:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38748 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752Ab2EIFw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:57 -0400
Message-Id: <20120509055037.592967114@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 056/167] [PATCH 3/4] ocfs2: ->rl_count endianness breakage
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 28748b325dc2d730ccc312830a91c4ae0c0d9379 upstream.

le16, not le32...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/refcounttree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index bc90ebc..9f32d7c 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1468,7 +1468,7 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
 
 	trace_ocfs2_divide_leaf_refcount_block(
 		(unsigned long long)ref_leaf_bh->b_blocknr,
-		le32_to_cpu(rl->rl_count), le16_to_cpu(rl->rl_used));
+		le16_to_cpu(rl->rl_count), le16_to_cpu(rl->rl_used));
 
 	/*
 	 * XXX: Improvement later.
-- 
1.7.10



