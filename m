Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2HFFEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 01:04:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2HFFEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 01:04:11 -0400
Date: Sun, 5 Aug 2012 22:04:08 -0700
From: Michel Lespinasse <walken@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20120806050408.GA12131@google.com>
References: <20120806134318.8af35d047e255fd25398210b@canb.auug.org.au>
 <CANN689GqydNH0-gisSfUPtGKAHVajzZ4KQCTKoJ7J76dJ8zVbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689GqydNH0-gisSfUPtGKAHVajzZ4KQCTKoJ7J76dJ8zVbg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfs2 calls RB_EMPTY_NODE() to check if nodes are not on an rbtree.
The corresponding initialization function is RB_CLEAR_NODE().
rb_init_node() was never clearly defined and is going away.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 fs/gfs2/rgrp.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index eaa4188..675e7cc 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -487,7 +487,7 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 	if (!res)
 		error = -ENOMEM;
 
-	rb_init_node(&res->rs_node);
+	RB_CLEAR_NODE(&res->rs_node);
 
 	down_write(&ip->i_rw_mutex);
 	if (ip->i_res)
@@ -520,7 +520,7 @@ static void __rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
 	rgd = rs->rs_rbm.rgd;
 	trace_gfs2_rs(ip, rs, TRACE_RS_TREEDEL);
 	rb_erase(&rs->rs_node, &rgd->rd_rstree);
-	rb_init_node(&rs->rs_node);
+	RB_CLEAR_NODE(&rs->rs_node);
 	BUG_ON(!rgd->rd_rs_cnt);
 	rgd->rd_rs_cnt--;
 
-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
