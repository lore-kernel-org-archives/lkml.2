Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1ITKPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 06:15:51 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36727 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab1ITKOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 06:14:25 -0400
Subject: [PATCH v4 5/8] SUNRPC: cleanup service destruction
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, davem@davemloft.net
Date: Tue, 20 Sep 2011 14:14:11 +0400
Message-ID: <20110920101411.9861.22514.stgit@localhost6.localdomain6>
In-Reply-To: <20110920101031.9861.18444.stgit@localhost6.localdomain6>
References: <20110920101031.9861.18444.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

svc_unregister() call have to be removed from svc_destroy() since it will be
called in sv_shutdown callback.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 net/sunrpc/svc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 918edc3..407462f 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -530,7 +530,6 @@ svc_destroy(struct svc_serv *serv)
 	if (svc_serv_is_pooled(serv))
 		svc_pool_map_put();
 
-	svc_unregister(serv);
 	kfree(serv->sv_pools);
 	kfree(serv);
 }

