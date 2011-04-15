Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1DOMiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 08:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab1DOMiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 08:38:02 -0400
Date: Fri, 15 Apr 2011 14:37:52 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Rob Landley <rlandley@parallels.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH] minor cleanup to net_namespace.c.
Message-ID: <20110415123751.GC2697@psychotron>
References: <4DA83971.7010903@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA83971.7010903@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fri, Apr 15, 2011 at 02:26:25PM CEST, rlandley@parallels.com wrote:
>From: Rob Landley <rlandley@parallels.com>
>
>Inline a small static function that's only ever called from one place.
>
>Signed-off-by: Rob Landley <rlandley@parallels.com>
>---
>
> net/core/net_namespace.c |   12 ++++--------
> 1 file changed, 4 insertions(+), 8 deletions(-)
>
>diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
>index 3f86026..1abb508 100644
>--- a/net/core/net_namespace.c
>+++ b/net/core/net_namespace.c
>@@ -216,11 +216,14 @@ static void net_free(struct net *net)
> 	kmem_cache_free(net_cachep, net);
> }
>
>-static struct net *net_create(void)
>+struct net *copy_net_ns(unsigned long flags, struct net *old_net)
> {
> 	struct net *net;
> 	int rv;
>
>+	if (!(flags & CLONE_NEWNET))
>+		return get_net(old_net);
>+
> 	net = net_alloc();
> 	if (!net)
> 		return ERR_PTR(-ENOMEM);
>@@ -239,13 +242,6 @@ static struct net *net_create(void)
> 	return net;
> }
>
>-struct net *copy_net_ns(unsigned long flags, struct net *old_net)
>-{
>-	if (!(flags & CLONE_NEWNET))
>-		return get_net(old_net);
>-	return net_create();
>-}
>-
> static DEFINE_SPINLOCK(cleanup_list_lock);
> static LIST_HEAD(cleanup_list);  /* Must hold cleanup_list_lock to touch */
>

Reviewed-by: Jiri Pirko <jpirko@redhat.com>

