Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1BOXTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:19:39 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:42917 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab1BOXTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:19:37 -0500
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH 1/5] bridge: Fix IPv6 multicast snooping by storing correct protocol type
Date: Wed, 16 Feb 2011 00:19:17 +0100
Message-Id: <1297811961-19249-2-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
References: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1+WggO++B7meg70JT7bl1wj8JvYTtWA2mE8EdRO
	OLvZIjelDtdSQCHK7YMsiC25/seKIXJ2Tbf/uMCqqjBQq/OPE1
	3nGOBgJ0JgcOifDlxZtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The protocol type for IPv6 entries in the hash table for multicast
bridge snooping is falsely set to ETH_P_IP, marking it as an IPv4
address, instead of setting it to ETH_P_IPV6, which results in negative
look-ups in the hash table later.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_multicast.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index f701a21..135d929 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -785,7 +785,7 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 		return 0;
 
 	ipv6_addr_copy(&br_group.u.ip6, group);
-	br_group.proto = htons(ETH_P_IP);
+	br_group.proto = htons(ETH_P_IPV6);
 
 	return br_multicast_add_group(br, port, &br_group);
 }
-- 
1.7.2.3

