Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab2JJXYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:24:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35353 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757610Ab2JJWyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:54:11 -0400
X-Sasl-enc: fegBwNrm9MsTPB3VgIkI0pXj2RoEz05/7iZfgHH0WLBz 1349909650
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 030/133] xfrm: fix a read lock imbalance in make_blackhole
Date: Thu, 11 Oct 2012 07:50:56 +0900
Message-Id: <20121010224859.898209604@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 433a19548061bb5457b6ab77ed7ea58ca6e43ddb ]

if xfrm_policy_get_afinfo returns 0, it has already released the read
lock, xfrm_policy_put_afinfo should not be called again.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_policy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1763,7 +1763,7 @@ static struct dst_entry *make_blackhole(
 
 	if (!afinfo) {
 		dst_release(dst_orig);
-		ret = ERR_PTR(-EINVAL);
+		return ERR_PTR(-EINVAL);
 	} else {
 		ret = afinfo->blackhole_route(net, dst_orig);
 	}


