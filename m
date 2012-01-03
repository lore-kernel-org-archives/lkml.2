Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2ACWqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:46:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab2ACWmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:42:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:27 2012
Message-Id: <20120103223326.959500062@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [70/75] ipv6: Check dest prefix length on original route not copied one in rt6_alloc_cow().
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit bb3c36863e8001fc21a88bebfdead4da4c23e848 ]

After commit 8e2ec639173f325977818c45011ee176ef2b11f6 ("ipv6: don't
use inetpeer to store metrics for routes.") the test in rt6_alloc_cow()
for setting the ANYCAST flag is now wrong.

'rt' will always now have a plen of 128, because it is set explicitly
to 128 by ip6_rt_copy.

So to restore the semantics of the test, check the destination prefix
length of 'ort'.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -725,7 +725,7 @@ static struct rt6_info *rt6_alloc_cow(co
 		int attempts = !in_softirq();
 
 		if (!(rt->rt6i_flags&RTF_GATEWAY)) {
-			if (rt->rt6i_dst.plen != 128 &&
+			if (ort->rt6i_dst.plen != 128 &&
 			    ipv6_addr_equal(&ort->rt6i_dst.addr, daddr))
 				rt->rt6i_flags |= RTF_ANYCAST;
 			ipv6_addr_copy(&rt->rt6i_gateway, daddr);


