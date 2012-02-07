Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab2BGPxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:53:35 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:28520 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2BGPxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:53:34 -0500
Subject: [PATCH] NFS: fix nfs4_find_client_sessionid() arguments list
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Tue, 07 Feb 2012 19:53:19 +0400
Message-ID: <20120207155309.30133.18889.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not compilable in case of CONFIG_NFS_V4_1 is not set.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 fs/nfs/client.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index f0dacad..5b9d201 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1266,7 +1266,7 @@ nfs4_find_client_sessionid(struct net *net, const struct sockaddr *addr,
 #else /* CONFIG_NFS_V4_1 */
 
 struct nfs_client *
-nfs4_find_client_sessionid(const struct sockaddr *addr,
+nfs4_find_client_sessionid(struct net *net, const struct sockaddr *addr,
 			   struct nfs4_sessionid *sid)
 {
 	return NULL;

