Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993091Ab2KOEME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:12:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:49431 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993074Ab2KOEL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 56/66] ipv6: send unsolicited neighbour advertisements to all-nodes
Date: Wed, 14 Nov 2012 20:11:01 -0800
Message-Id: <20121115040943.193386880@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 60713a0ca7fd6651b951cc1b4dbd528d1fc0281b ]

As documented in RFC4861 (Neighbor Discovery for IP version 6) 7.2.6.,
unsolicited neighbour advertisements should be sent to the all-nodes
multicast address.

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ndisc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -535,7 +535,7 @@ static void ndisc_send_unsol_na(struct n
 {
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifa;
-	struct in6_addr mcaddr;
+	struct in6_addr mcaddr = IN6ADDR_LINKLOCAL_ALLNODES_INIT;
 
 	idev = in6_dev_get(dev);
 	if (!idev)
@@ -543,7 +543,6 @@ static void ndisc_send_unsol_na(struct n
 
 	read_lock_bh(&idev->lock);
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
-		addrconf_addr_solict_mult(&ifa->addr, &mcaddr);
 		ndisc_send_na(dev, NULL, &mcaddr, &ifa->addr,
 			      /*router=*/ !!idev->cnf.forwarding,
 			      /*solicited=*/ false, /*override=*/ true,


