Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2JSDzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:55:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57455 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751028Ab2JSDzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:55:35 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next] pktgen: Use ipv6_addr_any
Date: Thu, 18 Oct 2012 20:55:31 -0700
Message-Id: <408090aa33c0ebcd8d02ce1d14b3dca590fbae62.1350618840.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard test for a non-zero ipv6 address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/core/pktgen.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index d1dc14c..1d1c216 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2427,11 +2427,7 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		}
 	} else {		/* IPV6 * */
 
-		if (pkt_dev->min_in6_daddr.s6_addr32[0] == 0 &&
-		    pkt_dev->min_in6_daddr.s6_addr32[1] == 0 &&
-		    pkt_dev->min_in6_daddr.s6_addr32[2] == 0 &&
-		    pkt_dev->min_in6_daddr.s6_addr32[3] == 0) ;
-		else {
+		if (!ipv6_addr_any(&pkt_dev->min_in6_daddr)) {
 			int i;
 
 			/* Only random destinations yet */
-- 
1.8.0.rc2.dirty

