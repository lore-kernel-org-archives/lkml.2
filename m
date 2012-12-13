Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2LMODh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:03:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab2LMODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 045/241] ixgbe: PTP get_ts_info missing software support
Date: Thu, 13 Dec 2012 11:56:50 -0200
Message-Id: <1355407206-17100-46-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

commit 50f8d35de8ba4af311ea1176c534e8b73bb198e5 upstream.

This patch corrects the ethtool get_ts_info functon which did not state that
software timestamping was supported, even though it is.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Stephen Ko <stephen.s.ko@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 9b20170..79eb257 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2706,6 +2706,9 @@ static int ixgbe_get_ts_info(struct net_device *dev,
 	case ixgbe_mac_X540:
 	case ixgbe_mac_82599EB:
 		info->so_timestamping =
+			SOF_TIMESTAMPING_TX_SOFTWARE |
+			SOF_TIMESTAMPING_RX_SOFTWARE |
+			SOF_TIMESTAMPING_SOFTWARE |
 			SOF_TIMESTAMPING_TX_HARDWARE |
 			SOF_TIMESTAMPING_RX_HARDWARE |
 			SOF_TIMESTAMPING_RAW_HARDWARE;
-- 
1.7.9.5

