Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2HSDDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:03:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:14941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab2HSC5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422076"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 56/74] lto, workaround: Add workaround for missing LTO symbols in igb
Date: Sat, 18 Aug 2012 19:56:52 -0700
Message-Id: <1345345030-22211-57-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The gcc 4.7 LTO with -fno-toplevel-reorder sometimes drops data
variables. These show up as undefined symbols at link time.
As a workaround just make a few where it happened visible for now.

There isl nothing wrong with this driver, just a toolchain problem.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index ba994fb..86b985a 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -2254,7 +2254,8 @@ out:
 	return ret_val;
 }
 
-static struct e1000_mac_operations e1000_mac_ops_82575 = {
+/* Workaround for LTO bug */
+__visible struct e1000_mac_operations e1000_mac_ops_82575 = {
 	.init_hw              = igb_init_hw_82575,
 	.check_for_link       = igb_check_for_link_82575,
 	.rar_set              = igb_rar_set,
@@ -2262,13 +2263,13 @@ static struct e1000_mac_operations e1000_mac_ops_82575 = {
 	.get_speed_and_duplex = igb_get_speed_and_duplex_copper,
 };
 
-static struct e1000_phy_operations e1000_phy_ops_82575 = {
+__visible struct e1000_phy_operations e1000_phy_ops_82575 = {
 	.acquire              = igb_acquire_phy_82575,
 	.get_cfg_done         = igb_get_cfg_done_82575,
 	.release              = igb_release_phy_82575,
 };
 
-static struct e1000_nvm_operations e1000_nvm_ops_82575 = {
+__visible struct e1000_nvm_operations e1000_nvm_ops_82575 = {
 	.acquire              = igb_acquire_nvm_82575,
 	.read                 = igb_read_nvm_eerd,
 	.release              = igb_release_nvm_82575,
-- 
1.7.7.6

