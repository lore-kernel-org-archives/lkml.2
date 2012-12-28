Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2L1T3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:29:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55609 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932301Ab2L1TTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:37 -0500
Message-Id: <20121228190339.653645685@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yanchuan Nian <ycnian@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 046/173] nfs: fix wrong object type in lockowner_slab
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanchuan Nian <ycnian@gmail.com>

commit 3c40794b2dd0f355ef4e6bf8d85af5dcd7da7ece upstream.

The object type in the cache of lockowner_slab is wrong, and it is
better to fix it.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 620ff81..fba2996 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2340,7 +2340,7 @@ nfsd4_init_slabs(void)
 	if (openowner_slab == NULL)
 		goto out_nomem;
 	lockowner_slab = kmem_cache_create("nfsd4_lockowners",
-			sizeof(struct nfs4_openowner), 0, 0, NULL);
+			sizeof(struct nfs4_lockowner), 0, 0, NULL);
 	if (lockowner_slab == NULL)
 		goto out_nomem;
 	file_slab = kmem_cache_create("nfsd4_files",


