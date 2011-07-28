Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab1G1XqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:46:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:62194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab1G1Xoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552563"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: tgraf@infradead.org, davem@davemloft.net, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [50/50] ipv6: add special mode forwarding=2 to send RS while
Message-Id: <20110728234455.326842403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Graf <tgraf@infradead.org>

[ upstream commit c3bccac2fa76f1619dfe4fb7b9bee69de7f066d8 ]
 configured as router

Similar to accepting router advertisement, the IPv6 stack does not send router
solicitations if forwarding is enabled.

This patch enables this behavior to be overruled by setting forwarding to the
special value 2.

Signed-off-by: Thomas Graf <tgraf@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/net/ipv6/addrconf.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv6/addrconf.c
+++ linux-2.6.35.y/net/ipv6/addrconf.c
@@ -2960,7 +2960,8 @@ static void addrconf_dad_completed(struc
 	   start sending router solicitations.
 	 */
 
-	if (ifp->idev->cnf.forwarding == 0 &&
+	if ((ifp->idev->cnf.forwarding == 0 ||
+	     ifp->idev->cnf.forwarding == 2) &&
 	    ifp->idev->cnf.rtr_solicits > 0 &&
 	    (dev->flags&IFF_LOOPBACK) == 0 &&
 	    (ipv6_addr_type(&ifp->addr) & IPV6_ADDR_LINKLOCAL)) {
