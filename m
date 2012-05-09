Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab2EIGCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:02:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38962 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756295Ab2EIFxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:42 -0400
Message-Id: <20120509055042.362330034@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Fred Isaman <iisaman@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 091/167] [PATCH] NFS: put open context on error in nfs_pagein_multi
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fred Isaman <iisaman@netapp.com>

commit 73fb7bc7c57d971b11f2e00536ac2d3e316e0609 upstream.

Signed-off-by: Fred Isaman <iisaman@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/read.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 9a0e8ef..0a4be28 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -322,7 +322,7 @@ out_bad:
 	while (!list_empty(res)) {
 		data = list_entry(res->next, struct nfs_read_data, list);
 		list_del(&data->list);
-		nfs_readdata_free(data);
+		nfs_readdata_release(data);
 	}
 	nfs_readpage_release(req);
 	return -ENOMEM;
-- 
1.7.10



