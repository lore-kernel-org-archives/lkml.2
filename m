Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2JKCL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:11:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51578 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331Ab2JKCLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:11:18 -0400
X-Sasl-enc: Kl+MD1idrBuvjypC4OKehpNso1E0OtPeqAPJ29FahKLq 1349921477
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 13/84] xfrm: fix a read lock imbalance in make_blackhole
Date: Thu, 11 Oct 2012 11:02:57 +0900
Message-Id: <20121011015419.446890109@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1759,7 +1759,7 @@ static struct dst_entry *make_blackhole(
 
 	if (!afinfo) {
 		dst_release(dst_orig);
-		ret = ERR_PTR(-EINVAL);
+		return ERR_PTR(-EINVAL);
 	} else {
 		ret = afinfo->blackhole_route(net, dst_orig);
 	}


