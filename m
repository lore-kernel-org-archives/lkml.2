Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1BOXTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:19:50 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:43752 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab1BOXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:19:45 -0500
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH 3/5] bridge: Add missing ntohs()s for MLDv2 report parsing
Date: Wed, 16 Feb 2011 00:19:19 +0100
Message-Id: <1297811961-19249-4-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
References: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19HjgTAaw6luqbNc/2+AlZ9fus8ELKdGhYO2Lq5
	X/T7ZGCxyIMCKYPrQELTW/PkCJsFfW8gDwp2fvQ5UUXPqanuWD
	hm287JtQfgK0MTsVqDrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nsrcs number is 2 Byte wide, therefore we need to call ntohs()
before using it.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_multicast.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 45dcf10..e8fdaab 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1021,11 +1021,12 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 
 		if (!pskb_may_pull(skb,
 				   len + sizeof(*grec) +
-				   sizeof(struct in6_addr) * (*nsrcs)))
+				   sizeof(struct in6_addr) * ntohs(*nsrcs)))
 			return -EINVAL;
 
 		grec = (struct mld2_grec *)(skb->data + len);
-		len += sizeof(*grec) + sizeof(struct in6_addr) * (*nsrcs);
+		len += sizeof(*grec) +
+		       sizeof(struct in6_addr) * ntohs(*nsrcs);
 
 		/* We treat these as MLDv1 reports for now. */
 		switch (grec->grec_type) {
-- 
1.7.2.3

