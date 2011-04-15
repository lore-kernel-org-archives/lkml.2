Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab1DOM0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 08:26:36 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47436 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1DOM0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 08:26:34 -0400
Message-ID: <4DA83971.7010903@parallels.com>
Date: Fri, 15 Apr 2011 07:26:25 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <jpirko@redhat.com>, <eric.dumazet@gmail.com>
Subject: [PATCH] minor cleanup to net_namespace.c.
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.54.86.190]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>

Inline a small static function that's only ever called from one place.

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

 net/core/net_namespace.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3f86026..1abb508 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -216,11 +216,14 @@ static void net_free(struct net *net)
 	kmem_cache_free(net_cachep, net);
 }

-static struct net *net_create(void)
+struct net *copy_net_ns(unsigned long flags, struct net *old_net)
 {
 	struct net *net;
 	int rv;

+	if (!(flags & CLONE_NEWNET))
+		return get_net(old_net);
+
 	net = net_alloc();
 	if (!net)
 		return ERR_PTR(-ENOMEM);
@@ -239,13 +242,6 @@ static struct net *net_create(void)
 	return net;
 }

-struct net *copy_net_ns(unsigned long flags, struct net *old_net)
-{
-	if (!(flags & CLONE_NEWNET))
-		return get_net(old_net);
-	return net_create();
-}
-
 static DEFINE_SPINLOCK(cleanup_list_lock);
 static LIST_HEAD(cleanup_list);  /* Must hold cleanup_list_lock to touch */

