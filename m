Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2LRWOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:14:18 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:49464 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2LRWOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:14:16 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 17:14:15 EST
From: Cong Ding <dinggnu@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] ipv6: addrconf.c: remove unnecessary "if"
Date: Tue, 18 Dec 2012 23:08:56 +0100
Message-Id: <1355868536-1622-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the value of err is always negative if it goes to errout, so we don't need to
check the value of err.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 net/ipv6/addrconf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6fca01f..408cac4a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -534,8 +534,7 @@ void inet6_netconf_notify_devconf(struct net *net, int type, int ifindex,
 	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_NETCONF, NULL, GFP_ATOMIC);
 	return;
 errout:
-	if (err < 0)
-		rtnl_set_sk_err(net, RTNLGRP_IPV6_NETCONF, err);
+	rtnl_set_sk_err(net, RTNLGRP_IPV6_NETCONF, err);
 }
 
 static const struct nla_policy devconf_ipv6_policy[NETCONFA_MAX+1] = {
-- 
1.7.10.4

