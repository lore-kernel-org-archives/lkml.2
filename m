Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1CHDKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 22:10:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49150 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1CHDKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 22:10:02 -0500
Date: Tue, 8 Mar 2011 14:09:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kravkov <dmitry@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Vladislav Zolotarov <vladz@broadcom.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20110308140957.8a894312.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/bnx2x/bnx2x_cmn.c between commit
e3835b99333eb3ac7222f6fc0af5cae46074ac49 ("bnx2x: (NPAR) prevent HW
access in D3 state") from the net-current tree and commit
6e30dd4e3935ddb4e7dd27d5be7a6e5504e64a27 (bnx2x: Proper
netdev->ndo_set_rx_mode() implementation"") from the net tree.

Just overlapping additions (I think).  I have fixed it up (see below) and
can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/bnx2x/bnx2x_cmn.c
index a71b329,b01b622..0000000
--- a/drivers/net/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/bnx2x/bnx2x_cmn.c
@@@ -1481,11 -1489,15 +1506,20 @@@ int bnx2x_nic_load(struct bnx2x *bp, in
  
  	bnx2x_set_eth_mac(bp, 1);
  
 +	if (bp->pending_max) {
 +		bnx2x_update_max_mf_config(bp, bp->pending_max);
 +		bp->pending_max = 0;
 +	}
 +
+ 	/* Clear MC configuration */
+ 	if (CHIP_IS_E1(bp))
+ 		bnx2x_invalidate_e1_mc_list(bp);
+ 	else
+ 		bnx2x_invalidate_e1h_mc_list(bp);
+ 
+ 	/* Clear UC lists configuration */
+ 	bnx2x_invalidate_uc_list(bp);
+ 
  	if (bp->port.pmf)
  		bnx2x_initial_phy_init(bp, load_mode);
  
