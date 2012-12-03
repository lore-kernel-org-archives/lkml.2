Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab2LCOiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:38:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44007 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932480Ab2LCOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:37:05 -0500
Message-Id: <20121203143150.959329440@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:11 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/89] ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT)  forgot to set return value
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit d4596bad2a713fcd0def492b1960e6d899d5baa8 ]

Cc: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ipv6_sockglue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 26cb08c..b204df8 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -798,6 +798,7 @@ pref_skip_coa:
 		if (val < 0 || val > 255)
 			goto e_inval;
 		np->min_hopcount = val;
+		retv = 0;
 		break;
 	case IPV6_DONTFRAG:
 		np->dontfrag = valbool;


