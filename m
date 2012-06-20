Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2FTSYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:24:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab2FTSYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:05 -0400
Message-Id: <20120620173025.662447538@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Boot <bootc@bootc.net>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        Nix <nix@esperi.org.uk>, Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 55/61] e1000e: Disable ASPM L1 on 82574
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Boot <bootc@bootc.net>

commit d4a4206ebbaf48b55803a7eb34e330530d83a889 upstream.

ASPM on the 82574 causes trouble. Currently the driver disables L0s for
this NIC but only disables L1 if the MTU is >1500. This patch simply
causes L1 to be disabled regardless of the MTU setting.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
Cc: Nix <nix@esperi.org.uk>
Link: https://lkml.org/lkml/2012/3/19/362
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/82571.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -2061,8 +2061,9 @@ const struct e1000_info e1000_82574_info
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


