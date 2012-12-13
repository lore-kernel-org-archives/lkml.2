Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab2LMONf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:13:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab2LMON2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:28 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 205/241] ipv6: send unsolicited neighbour advertisements to all-nodes
Date: Thu, 13 Dec 2012 11:59:30 -0200
Message-Id: <1355407206-17100-206-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 60713a0ca7fd6651b951cc1b4dbd528d1fc0281b upstream.

As documented in RFC4861 (Neighbor Discovery for IP version 6) 7.2.6.,
unsolicited neighbour advertisements should be sent to the all-nodes
multicast address.

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv6/ndisc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 54f62d3..35bfebc 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -580,7 +580,7 @@ static void ndisc_send_unsol_na(struct net_device *dev)
 {
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifa;
-	struct in6_addr mcaddr;
+	struct in6_addr mcaddr = IN6ADDR_LINKLOCAL_ALLNODES_INIT;
 
 	idev = in6_dev_get(dev);
 	if (!idev)
@@ -588,7 +588,6 @@ static void ndisc_send_unsol_na(struct net_device *dev)
 
 	read_lock_bh(&idev->lock);
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
-		addrconf_addr_solict_mult(&ifa->addr, &mcaddr);
 		ndisc_send_na(dev, NULL, &mcaddr, &ifa->addr,
 			      /*router=*/ !!idev->cnf.forwarding,
 			      /*solicited=*/ false, /*override=*/ true,
-- 
1.7.9.5

