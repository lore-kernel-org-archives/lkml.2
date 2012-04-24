Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab2DXWhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:37:00 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195Ab2DXWg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:58 -0400
Message-Id: <20120424223247.107958413@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Subject: [ 60/62] ocfs2: ->rl_count endianness breakage
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 28748b325dc2d730ccc312830a91c4ae0c0d9379 upstream.

le16, not le32...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/refcounttree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1468,7 +1468,7 @@ static int ocfs2_divide_leaf_refcount_bl
 
 	trace_ocfs2_divide_leaf_refcount_block(
 		(unsigned long long)ref_leaf_bh->b_blocknr,
-		le32_to_cpu(rl->rl_count), le16_to_cpu(rl->rl_used));
+		le16_to_cpu(rl->rl_count), le16_to_cpu(rl->rl_used));
 
 	/*
 	 * XXX: Improvement later.


