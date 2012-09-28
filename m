Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423191Ab2I1VF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:05:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57624 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423173Ab2I1VFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:05:51 -0400
X-Sasl-enc: RA485BOUwCpvIgcVcKxU8pWVvfeKRZ4jlAkN/9OQh+kh 1348866350
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Boot <bootc@bootc.net>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        Nix <nix@esperi.org.uk>, Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: [ 121/127] e1000e: Disable ASPM L1 on 82574
Date: Fri, 28 Sep 2012 13:34:54 -0700
Message-Id: <20120928203100.063568215@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/e1000e/82571.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -2088,7 +2088,8 @@ struct e1000_info e1000_82574_info = {
 				  | FLAG_HAS_AMT
 				  | FLAG_HAS_CTRLEXT_ON_LOAD,
 	.flags2			  = FLAG2_CHECK_PHY_HANG
-				  | FLAG2_DISABLE_ASPM_L0S,
+				  | FLAG2_DISABLE_ASPM_L0S
+				  | FLAG2_DISABLE_ASPM_L1,
 	.pba			= 32,
 	.max_hw_frame_size	= DEFAULT_JUMBO,
 	.get_variants		= e1000_get_variants_82571,


