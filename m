Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3ACMV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:21:56 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53372 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab3ACMU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:20:29 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH -v2 24/26] net/core: remove duplicate statements by do-while loop
Date: Thu,  3 Jan 2013 21:19:20 +0900
Message-Id: <1357215562-6288-25-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate statements by using do-while loop instead of while loop.

- A;
- while (e) {
+ do {
	A;
- }
+ } while (e);

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---

No change from v1

 net/core/pktgen.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index d23ec86..48a3a29 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2379,18 +2379,15 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 				__be32 s;
 				if (pkt_dev->flags & F_IPDST_RND) {
 
-					t = prandom_u32() % (imx - imn) + imn;
-					s = htonl(t);
-
-					while (ipv4_is_loopback(s) ||
-					       ipv4_is_multicast(s) ||
-					       ipv4_is_lbcast(s) ||
-					       ipv4_is_zeronet(s) ||
-					       ipv4_is_local_multicast(s)) {
+					do {
 						t = prandom_u32() %
 							(imx - imn) + imn;
 						s = htonl(t);
-					}
+					} while (ipv4_is_loopback(s) ||
+						ipv4_is_multicast(s) ||
+						ipv4_is_lbcast(s) ||
+						ipv4_is_zeronet(s) ||
+						ipv4_is_local_multicast(s));
 					pkt_dev->cur_daddr = s;
 				} else {
 					t = ntohl(pkt_dev->cur_daddr);
-- 
1.7.11.7

