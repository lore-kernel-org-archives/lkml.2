Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2EIGUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:20:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38955 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756279Ab2EIFxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:21 -0400
Message-Id: <20120509055042.499406402@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Fred Isaman <iisaman@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 092/167] [PATCH] NFS: put open context on error in nfs_flush_multi
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

commit 8ccd271f7a3a846ce6f85ead0760d9d12994a611 upstream.

Signed-off-by: Fred Isaman <iisaman@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 9b8d4d4..c074623 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1019,7 +1019,7 @@ out_bad:
 	while (!list_empty(res)) {
 		data = list_entry(res->next, struct nfs_write_data, list);
 		list_del(&data->list);
-		nfs_writedata_free(data);
+		nfs_writedata_release(data);
 	}
 	nfs_redirty_request(req);
 	return -ENOMEM;
-- 
1.7.10



