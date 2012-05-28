Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2E1D3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52252 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160Ab2E1D3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:42 -0400
Message-Id: <20120528031217.633639836@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <peng_tao@emc.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 107/117] NFS4: fix compile warnings in nfs4proc.c
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <bergwolf@gmail.com>

commit de040beccd52bb5fcac90031505384d037b1111c upstream.

compile in nfs-for-3.3 branch shows following warnings. Fix it here.

fs/nfs/nfs4proc.c: In function ‘__nfs4_get_acl_uncached’:
fs/nfs/nfs4proc.c:3589: warning: format ‘%ld’ expects type ‘long int’, but argument 4 has type ‘size_t’
fs/nfs/nfs4proc.c:3589: warning: format ‘%ld’ expects type ‘long int’, but argument 6 has type ‘size_t’

Signed-off-by: Peng Tao <peng_tao@emc.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 75366dc..f0c849c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3587,7 +3587,7 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bu
 		res.acl_flags |= NFS4_ACL_LEN_REQUEST;
 	resp_buf = page_address(pages[0]);
 
-	dprintk("%s  buf %p buflen %ld npages %d args.acl_len %ld\n",
+	dprintk("%s  buf %p buflen %zu npages %d args.acl_len %zu\n",
 		__func__, buf, buflen, npages, args.acl_len);
 	ret = nfs4_call_sync(NFS_SERVER(inode)->client, NFS_SERVER(inode),
 			     &msg, &args.seq_args, &res.seq_res, 0);


