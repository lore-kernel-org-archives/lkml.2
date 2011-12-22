Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1LVGAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 01:00:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60604 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab1LVGAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 01:00:36 -0500
Message-ID: <1324533632.2621.35.camel@edumazet-laptop>
Subject: [PATCH] bridge: provide a mtu() method for fake_dst_ops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Boot <bootc@bootc.net>, David Miller <davem@davemloft.net>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Date: Thu, 22 Dec 2011 07:00:32 +0100
In-Reply-To: <1324528656.2621.19.camel@edumazet-laptop>
References: <4EF200BB.7000209@bootc.net>
	 <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EF2117F.6000803@bootc.net>
	 <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EF23BF2.4000601@bootc.net> <1324499332.2621.7.camel@edumazet-laptop>
	 <1324500775.2621.9.camel@edumazet-laptop> <4EF2568C.6040006@bootc.net>
	 <AEC29013-98F3-4A16-A88B-AD31C9E88EB8@bootc.net>
	 <1324528656.2621.19.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 618f9bc74a039da76 (net: Move mtu handling down to the protocol
depended handlers) forgot the bridge netfilter case, adding a NULL
dereference in ip_fragment().

Reported-by: Chris Boot <bootc@bootc.net>
CC: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/bridge/br_netfilter.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index d6ec372..08757dc 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -114,12 +114,18 @@ static struct neighbour *fake_neigh_lookup(const struct dst_entry *dst, const vo
 	return NULL;
 }
 
+static unsigned int fake_mtu(const struct dst_entry *dst)
+{
+	return dst->dev->mtu;
+}
+
 static struct dst_ops fake_dst_ops = {
 	.family =		AF_INET,
 	.protocol =		cpu_to_be16(ETH_P_IP),
 	.update_pmtu =		fake_update_pmtu,
 	.cow_metrics =		fake_cow_metrics,
 	.neigh_lookup =		fake_neigh_lookup,
+	.mtu =			fake_mtu,
 };
 
 /*


