Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab2HYT5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:57:23 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:2649 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707Ab2HYT5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:57:15 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="153817992"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: kernel-janitors@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] fs/nfsd/nfs4idmap.c: adjust inconsistent IS_ERR and PTR_ERR
Date: Sat, 25 Aug 2012 21:57:04 +0200
Message-Id: <1345924629-16584-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Change the call to PTR_ERR to access the value just tested by IS_ERR.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
@@

(
if (IS_ERR(e)) { ... PTR_ERR(e) ... }
|
if (IS_ERR(e=e1)) { ... PTR_ERR(e) ... }
|
*if (IS_ERR(e))
 { ...
*  PTR_ERR(e1)
   ... }
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/nfsd/nfs4idmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index fdc91a6..11df4ac 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -478,7 +478,7 @@ nfsd_idmap_init(struct net *net)
 		goto destroy_idtoname_cache;
 	nn->nametoid_cache = cache_create_net(&nametoid_cache_template, net);
 	if (IS_ERR(nn->nametoid_cache)) {
-		rv = PTR_ERR(nn->idtoname_cache);
+		rv = PTR_ERR(nn->nametoid_cache);
 		goto unregister_idtoname_cache;
 	}
 	rv = cache_register_net(nn->nametoid_cache, net);

