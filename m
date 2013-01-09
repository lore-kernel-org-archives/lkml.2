Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab3AIVcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:32:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:42376 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933394Ab3AIUiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yanchuan Nian <ycnian@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 046/123] nfs: fix wrong object type in lockowner_slab
Date: Wed,  9 Jan 2013 12:34:45 -0800
Message-Id: <20130109201504.468908397@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanchuan Nian <ycnian@gmail.com>

commit 3c40794b2dd0f355ef4e6bf8d85af5dcd7da7ece upstream.

The object type in the cache of lockowner_slab is wrong, and it is
better to fix it.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


