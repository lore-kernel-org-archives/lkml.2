Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0LIWbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:31:50 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14002 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0LIWbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:31:49 -0500
Date: Thu, 9 Dec 2010 23:25:09 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: coda@cs.cmu.edu
cc: codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org,
        "Peter J. Braam" <braam@maths.ox.ac.uk>,
        Michael Callahan <callahan@maths.ox.ac.uk>,
        Peter Braam <braam@cs.cmu.edu>, trivial@kernel.org
Subject: [PATCH] coda: kill redundant cast in coda_alloc_inode()
Message-ID: <alpine.LNX.2.00.1012092322201.25880@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kmem_cache_alloc() returns a void pointer which there is no need to cast.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 5ea57c8..1a49c17 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -45,7 +45,7 @@ static struct kmem_cache * coda_inode_cachep;
 static struct inode *coda_alloc_inode(struct super_block *sb)
 {
 	struct coda_inode_info *ei;
-	ei = (struct coda_inode_info *)kmem_cache_alloc(coda_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(coda_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	memset(&ei->c_fid, 0, sizeof(struct CodaFid));



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

