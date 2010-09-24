Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab0IXQ7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:59:01 -0400
Received: from kroah.org ([198.145.64.141]:46080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553Ab0IXQ2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:16 2010
Message-Id: <20100924162616.212389023@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [15/80] l2tp: test for ethernet header in l2tp_eth_dev_recv()
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit bfc960a8eec023a170a80697fe65157cd4f44f81 ]

close https://bugzilla.kernel.org/show_bug.cgi?id=16529

Before calling dev_forward_skb(), we should make sure skb head contains
at least an ethernet header, even if length included in upper layer said
so. Use pskb_may_pull() to make sure this ethernet header is present in
skb head.

Reported-by: Thomas Heil <heil@terminal-consulting.de>
Reported-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/l2tp/l2tp_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -132,7 +132,7 @@ static void l2tp_eth_dev_recv(struct l2t
 		printk("\n");
 	}
 
-	if (data_len < ETH_HLEN)
+	if (!pskb_may_pull(skb, sizeof(ETH_HLEN)))
 		goto error;
 
 	secpath_reset(skb);


