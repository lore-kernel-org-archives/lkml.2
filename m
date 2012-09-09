Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2IIXRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51422 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756171Ab2IIXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:57 -0400
Message-Id: <20120909224151.530365445@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:41:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 04/95] NFSv4.1 fix page number calculation bug for filelayout decode
 buffers
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Adamson <andros@netapp.com>

commit e5265a0c587423bbd21a6b39a572cecff16b9346 upstream.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4filelayoutdev.c |    2 +-
 fs/nfs/pnfs.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4filelayoutdev.c
+++ b/fs/nfs/nfs4filelayoutdev.c
@@ -721,7 +721,7 @@ get_device_info(struct inode *inode, str
 	 * GETDEVICEINFO's maxcount
 	 */
 	max_resp_sz = server->nfs_client->cl_session->fc_attrs.max_resp_sz;
-	max_pages = max_resp_sz >> PAGE_SHIFT;
+	max_pages = nfs_page_array_len(0, max_resp_sz);
 	dprintk("%s inode %p max_resp_sz %u max_pages %d\n",
 		__func__, inode, max_resp_sz, max_pages);
 
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -588,7 +588,7 @@ send_layoutget(struct pnfs_layout_hdr *l
 
 	/* allocate pages for xdr post processing */
 	max_resp_sz = server->nfs_client->cl_session->fc_attrs.max_resp_sz;
-	max_pages = max_resp_sz >> PAGE_SHIFT;
+	max_pages = nfs_page_array_len(0, max_resp_sz);
 
 	pages = kcalloc(max_pages, sizeof(struct page *), gfp_flags);
 	if (!pages)


