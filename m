Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2EIFx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38903 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756172Ab2EIFxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:14 -0400
Message-Id: <20120509055039.001819942@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "RongQing.Li" <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 066/167] [PATCH 06/26] ipv6: fix array index in ip6_mc_add_src()
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "RongQing.Li" <roy.qing.li@gmail.com>

[ Upstream commit 78d50217baf36093ab320f95bae0d6452daec85c ]

Convert array index from the loop bound to the loop index.

And remove the void type conversion to ip6_mc_del1_src() return
code, seem it is unnecessary, since ip6_mc_del1_src() does not
use __must_check similar attribute, no compiler will report the
warning when it is removed.

v2: enrich the commit header

Signed-off-by: RongQing.Li <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/mcast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 2257366..f2d74ea 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2054,7 +2054,7 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 		if (!delta)
 			pmc->mca_sfcount[sfmode]--;
 		for (j=0; j<i; j++)
-			(void) ip6_mc_del1_src(pmc, sfmode, &psfsrc[i]);
+			ip6_mc_del1_src(pmc, sfmode, &psfsrc[j]);
 	} else if (isexclude != (pmc->mca_sfcount[MCAST_EXCLUDE] != 0)) {
 		struct ip6_sf_list *psf;
 
-- 
1.7.10



