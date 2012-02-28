Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2B1BG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:06:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2B1BGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.136.8 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010208.003446779@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Li Wei <lw@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 24/73] ipv4: fix for ip_options_rcv_srr() daddr update.
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Li Wei <lw@cn.fujitsu.com>

[ Upstream commit b12f62efb8ec0b9523bdb6c2d412c07193086de9 ]

When opt->srr_is_hit is set skb_rtable(skb) has been updated for
'nexthop' and iph->daddr should always equals to skb_rtable->rt_dst
holds, We need update iph->daddr either.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_options.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -640,6 +640,7 @@ int ip_options_rcv_srr(struct sk_buff *s
 	}
 	if (srrptr <= srrspace) {
 		opt->srr_is_hit = 1;
+		iph->daddr = nexthop;
 		opt->is_changed = 1;
 	}
 	return 0;


