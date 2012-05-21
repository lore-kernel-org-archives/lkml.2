Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2EUTBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:01:36 -0400
Received: from nm34-vm4.bullet.mail.bf1.yahoo.com ([72.30.239.76]:45728 "HELO
	nm34-vm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754466Ab2EUTBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:01:33 -0400
X-Yahoo-Newman-Id: 927231.77884.bm@smtp211.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: x7_5nLsVM1muyegib8cGBVx5iRJUGy_GnI.ylNkPX.sOwzv
 lMT9fNH3lG51_LVoLZwuaOfiX6D1A3GpX4Qb7N.kazQS84OljqmaXwnQ9Cky
 WUsHGPbuL_IF2TyC68sbhs0cgHJumX_7a1.cQO6t2OMuIfQ0JbfTj5U6jXu3
 0myJwbM26XKNJrbPkgFqBmiWo.hQE8RdP4.YVp6F4VVV3MWUHGF18kprLTs7
 H2Ma94K1YEDU4_kBBUMKlsBE5ie6RZmJNUKFl46s_U9EPgwM7yHxuI7oQLQu
 7Zk62tT1DF5PZ9pLOBRM4me7pXROYGjaG_F_eQW.ctVZPcOdFaXALGUwYh.Y
 47vzvBSRBvssUiU2slZgR79cNTC_zL_ErsXt0.Gf2hKpdaLMrmGcMg2C58Bd
 ivDDmgh11TpCVnIZ4uyJYr9TNj8q83QJ60MojvLTnSXPGDbJ3bua.sPSecOr
 DznrlAHb6QHms4OBU7UOa0.9JxXLsysA3i5v.WkfCAKLrim3djYkJjT2tvs7
 xQwY-
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: davem@davemloft.net, edumazet@google.com, loke.chetan@gmail.com,
        herbert@gondor.hengli.com.au
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH 4/4]net:ipv6:fixed space issues relating to >= and !=
Date: Tue, 22 May 2012 00:35:01 +0530
Message-Id: <1337627101-3386-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed space issues related to >= and != operators
in net/ipv6/mcast.c found by cheackpatch.pl tool

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/ipv6/mcast.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 541893d..9de31b3 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -427,7 +427,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	}
 	if (rv == 0)		/* address already there is an error */
 		goto done;
-	for (j = psl->sl_count-1; j>=i; j--)
+	for (j = psl->sl_count-1; j >= i; j--)
 		psl->sl_addr[j+1] = psl->sl_addr[j];
 	psl->sl_addr[i] = *source;
 	psl->sl_count++;
@@ -987,7 +987,7 @@ int ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 						psf->sf_count[MCAST_EXCLUDE] !=
 						mc->mca_sfcount[MCAST_EXCLUDE];
 				else
-					rv = mc->mca_sfcount[MCAST_EXCLUDE] !=0;
+					rv = mc->mca_sfcount[MCAST_EXCLUDE] != 0;
 				spin_unlock_bh(&mc->mca_lock);
 			} else
 				rv = 1; /* don't filter unspecified source */
-- 
1.7.10

