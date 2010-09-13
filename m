Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0IMChx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 22:37:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47339 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab0IMChv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 22:37:51 -0400
Date: Mon, 13 Sep 2010 12:37:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Changli Gao <xiaosuo@gmail.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the tip tree with the net tree
Message-Id: <20100913123745.e4a4df44.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in net/core/dev.c
between commit 05532121da0728eaedac2a0a5c3cecad3a95d765 ("net: 802.1q:
make vlan_hwaccel_do_receive() return void") from the net tree and commit
cf66ba58b5cb8b1526e9dd2fb96ff8db048d4d44 ("netdev: Add tracepoints to
netdev layer") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/core/dev.c
index fc2dc93,2308cce..0000000
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@@ -2847,8 -2835,9 +2854,9 @@@ static int __netif_receive_skb(struct s
  	if (!netdev_tstamp_prequeue)
  		net_timestamp_check(skb);
  
+ 	trace_netif_receive_skb(skb);
 -	if (vlan_tx_tag_present(skb) && vlan_hwaccel_do_receive(skb))
 -		return NET_RX_SUCCESS;
 +	if (vlan_tx_tag_present(skb))
 +		vlan_hwaccel_do_receive(skb);
  
  	/* if we've gotten here through NAPI, check netpoll */
  	if (netpoll_receive_skb(skb))
