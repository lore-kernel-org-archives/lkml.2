Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2GAS0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:26:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46936 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903Ab2GASQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:27 -0400
Message-Id: <20120701172008.810233261@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Boot <bootc@bootc.net>,
        Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 15/48] e1000e: Remove special case for 82573/82574 ASPM  L1 disablement
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Boot <bootc@bootc.net>

commit 59aed95263bdd0e2b48eb9be5a94346d2d4abf90 upstream.

For the 82573, ASPM L1 gets disabled wholesale so this special-case code
is not required. For the 82574 the previous patch does the same as for
the 82573, disabling L1 on the adapter. Thus, this code is no longer
required and can be removed.

Signed-off-by: Chris Boot <bootc@bootc.net>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index ab4505c..9c4576e 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5272,14 +5272,6 @@ static int e1000_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EINVAL;
 	}
 
-	/* 82573 Errata 17 */
-	if (((adapter->hw.mac.type == e1000_82573) ||
-	     (adapter->hw.mac.type == e1000_82574)) &&
-	    (max_frame > ETH_FRAME_LEN + ETH_FCS_LEN)) {
-		adapter->flags2 |= FLAG2_DISABLE_ASPM_L1;
-		e1000e_disable_aspm(adapter->pdev, PCIE_LINK_STATE_L1);
-	}
-
 	while (test_and_set_bit(__E1000_RESETTING, &adapter->state))
 		usleep_range(1000, 2000);
 	/* e1000e_down -> e1000e_reset dependent on max_frame_size & mtu */


