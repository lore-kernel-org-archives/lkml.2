Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab2IIXRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51439 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337Ab2IIXRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:00 -0400
Message-Id: <20120909224151.661635558@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:41:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jim Rees <rees@umich.edu>,
        Andy Adamson <andros@netapp.com>, Fred Isaman <iisaman@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 05/95] fix page number calculation bug for block layout decode buffer
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Rees <rees@umich.edu>

commit 10bd295a0b6488ebe634b72a11d8986bd3af3819 upstream.

Signed-off-by: Jim Rees <rees@umich.edu>
Suggested-by: Andy Adamson <andros@netapp.com>
Suggested-by: Fred Isaman <iisaman@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/blocklayout/blocklayout.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 9c94297..7f6a23f 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -38,6 +38,8 @@
 #include <linux/buffer_head.h>	/* various write calls */
 #include <linux/prefetch.h>
 
+#include "../pnfs.h"
+#include "../internal.h"
 #include "blocklayout.h"
 
 #define NFSDBG_FACILITY	NFSDBG_PNFS_LD
@@ -868,7 +870,7 @@ nfs4_blk_get_deviceinfo(struct nfs_server *server, const struct nfs_fh *fh,
 	 * GETDEVICEINFO's maxcount
 	 */
 	max_resp_sz = server->nfs_client->cl_session->fc_attrs.max_resp_sz;
-	max_pages = max_resp_sz >> PAGE_SHIFT;
+	max_pages = nfs_page_array_len(0, max_resp_sz);
 	dprintk("%s max_resp_sz %u max_pages %d\n",
 		__func__, max_resp_sz, max_pages);
 


