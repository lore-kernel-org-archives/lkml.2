Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0KEDK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:10:59 -0400
Received: from mail.perches.com ([173.55.12.10]:4199 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab0KEDJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:10 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 45/49] net/core/pktgen.c: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:09 -0700
Message-Id: <01a5bd0185f5d41ce510c1e15358044f6c3b9349.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/core/pktgen.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index fbce4b0..ccca6cd 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3706,13 +3706,12 @@ static int pktgen_add_device(struct pktgen_thread *t, const char *ifname)
 		return -ENOMEM;
 
 	strcpy(pkt_dev->odevname, ifname);
-	pkt_dev->flows = vmalloc_node(MAX_CFLOWS * sizeof(struct flow_state),
+	pkt_dev->flows = vzalloc_node(MAX_CFLOWS * sizeof(struct flow_state),
 				      node);
 	if (pkt_dev->flows == NULL) {
 		kfree(pkt_dev);
 		return -ENOMEM;
 	}
-	memset(pkt_dev->flows, 0, MAX_CFLOWS * sizeof(struct flow_state));
 
 	pkt_dev->removal_mark = 0;
 	pkt_dev->min_pkt_size = ETH_ZLEN;
-- 
1.7.3.1.g432b3.dirty

