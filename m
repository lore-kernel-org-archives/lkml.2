Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab2FTSbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:31:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44755 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2FTSXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:46 -0400
Message-Id: <20120620173025.751840203@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Boot <bootc@bootc.net>,
        Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 56/61] e1000e: Remove special case for 82573/82574 ASPM L1 disablement
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/netdev.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5293,14 +5293,6 @@ static int e1000_change_mtu(struct net_d
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


