Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab2IIXR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51461 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756183Ab2IIXRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:05 -0400
Message-Id: <20120909224151.399876153@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:41:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 03/95] NFS: Use kcalloc() when allocating arrays
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 7d9dea915fe333357912bce2d624ee848dfbd890 upstream.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/blocklayout/extents.c |    2 +-
 fs/nfs/pnfs.c                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/blocklayout/extents.c b/fs/nfs/blocklayout/extents.c
index 1abac09..1f9a603 100644
--- a/fs/nfs/blocklayout/extents.c
+++ b/fs/nfs/blocklayout/extents.c
@@ -147,7 +147,7 @@ static int _preload_range(struct pnfs_inval_markings *marks,
 	count = (int)(end - start) / (int)tree->mtt_step_size;
 
 	/* Pre-malloc what memory we might need */
-	storage = kmalloc(sizeof(*storage) * count, GFP_NOFS);
+	storage = kcalloc(count, sizeof(*storage), GFP_NOFS);
 	if (!storage)
 		return -ENOMEM;
 	for (i = 0; i < count; i++) {
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 17149a4..9292787 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -590,7 +590,7 @@ send_layoutget(struct pnfs_layout_hdr *lo,
 	max_resp_sz = server->nfs_client->cl_session->fc_attrs.max_resp_sz;
 	max_pages = max_resp_sz >> PAGE_SHIFT;
 
-	pages = kzalloc(max_pages * sizeof(struct page *), gfp_flags);
+	pages = kcalloc(max_pages, sizeof(struct page *), gfp_flags);
 	if (!pages)
 		goto out_err_free;
 


