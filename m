Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2GASQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46952 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964Ab2GASQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:31 -0400
Message-Id: <20120701172008.676559904@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Boot <bootc@bootc.net>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        Nix <nix@esperi.org.uk>, Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 14/48] e1000e: Disable ASPM L1 on 82574
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

commit id d4a4206ebbaf48b55803a7eb34e330530d83a889

ASPM on the 82574 causes trouble. Currently the driver disables L0s for
this NIC but only disables L1 if the MTU is >1500. This patch simply
causes L1 to be disabled regardless of the MTU setting.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
Cc: Nix <nix@esperi.org.uk>
Link: https://lkml.org/lkml/2012/3/19/362
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
[Jeff Kirsher: Backport to 3.2-3.4 kernels]
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/e1000e/82571.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethernet/intel/e1000e/82571.c
index a3e65fd..e556fc3 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -2080,8 +2080,9 @@ const struct e1000_info e1000_82574_info = {
 				  | FLAG_HAS_SMART_POWER_DOWN
 				  | FLAG_HAS_AMT
 				  | FLAG_HAS_CTRLEXT_ON_LOAD,
-	.flags2			  = FLAG2_CHECK_PHY_HANG
+	.flags2			= FLAG2_CHECK_PHY_HANG
 				  | FLAG2_DISABLE_ASPM_L0S
+				  | FLAG2_DISABLE_ASPM_L1
 				  | FLAG2_NO_DISABLE_RX,
 	.pba			= 32,
 	.max_hw_frame_size	= DEFAULT_JUMBO,


