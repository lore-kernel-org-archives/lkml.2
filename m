Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1FTC41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 22:56:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50795 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1FTC4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 22:56:24 -0400
Date: Mon, 20 Jun 2011 12:56:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Schillstrom <hans.schillstrom@ericsson.com>,
        Simon Horman <horms@verge.net.au>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20110620125616.e319c55c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/netfilter/ipvs/ip_vs_core.c between commit 8f4e0a18682d ("IPVS netns
exit causes crash in conntrack") from the net-current tree and commit
503cf15a5ecc ("IPVS: rename of netns init and cleanup functions") from
the net tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/netfilter/ipvs/ip_vs_core.c
index 24c28d2,2200bae..0000000
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@@ -1945,8 -1945,7 +1945,8 @@@ static void __net_exit __ip_vs_dev_clea
  {
  	EnterFunction(2);
  	net_ipvs(net)->enable = 0;	/* Disable packet reception */
 +	smp_wmb();
- 	__ip_vs_sync_cleanup(net);
+ 	ip_vs_sync_net_cleanup(net);
  	LeaveFunction(2);
  }
  
