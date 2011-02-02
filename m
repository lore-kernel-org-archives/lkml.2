Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1BBAny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:46559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1BBAnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028367"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [46/139] tcp: Increase TCP_MAXSEG socket option minimum.
Message-Id: <20110202004401.EE00A3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 7a1abd08d52fdeddb3e9a5a33f2f15cc6a5674d2 ]

As noted by Steve Chen, since commit
f5fff5dc8a7a3f395b0525c02ba92c95d42b7390 ("tcp: advertise MSS
requested by user") we can end up with a situation where
tcp_select_initial_window() does a divide by a zero (or
even negative) mss value.

The problem is that sometimes we effectively subtract
TCPOLEN_TSTAMP_ALIGNED and/or TCPOLEN_MD5SIG_ALIGNED from the mss.

Fix this by increasing the minimum from 8 to 64.

Reported-by: Steve Chen <schen@mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/ipv4/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/net/ipv4/tcp.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/tcp.c
+++ linux-2.6.35.y/net/ipv4/tcp.c
@@ -2235,7 +2235,7 @@ static int do_tcp_setsockopt(struct sock
 		/* Values greater than interface MTU won't take effect. However
 		 * at the point when this call is done we typically don't yet
 		 * know which interface is going to be used */
-		if (val < 8 || val > MAX_TCP_WINDOW) {
+		if (val < 64 || val > MAX_TCP_WINDOW) {
 			err = -EINVAL;
 			break;
 		}
