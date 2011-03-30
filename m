Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215Ab1C3Vdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:33:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:47856 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964966Ab1C3VIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735819"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: donald.c.skidmore@intel.com, stephen.s.ko@intel.com,
        jeffrey.t.kirsher@intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [176/275] ixgbe: fix for 82599 erratum on Header Splitting
Message-Id: <20110330210659.0B3C93E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Don Skidmore <donald.c.skidmore@intel.com>

commit a124339ad28389093ed15eca990d39c51c5736cc upstream.

We have found a hardware erratum on 82599 hardware that can lead to
unpredictable behavior when Header Splitting mode is enabled.  So
we are no longer enabling this feature on affected hardware.

Please see the 82599 Specification Update for more information.

Signed-off-by: Don Skidmore <donald.c.skidmore@intel.com>
Tested-by: Stephen Ko <stephen.s.ko@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/ixgbe/ixgbe_main.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.35.y/drivers/net/ixgbe/ixgbe_main.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/ixgbe/ixgbe_main.c	2011-03-29 22:50:53.271895324 -0700
+++ linux-2.6.35.y/drivers/net/ixgbe/ixgbe_main.c	2011-03-29 23:03:01.901251523 -0700
@@ -2658,6 +2658,10 @@
 	if (!adapter->num_vfs)
 		adapter->flags |= IXGBE_FLAG_RX_PS_ENABLED;
 
+	/* Disable packet split due to 82599 erratum #45 */
+	if (hw->mac.type == ixgbe_mac_82599EB)
+		adapter->flags &= ~IXGBE_FLAG_RX_PS_ENABLED;
+
 	/* Set the RX buffer length according to the mode */
 	if (adapter->flags & IXGBE_FLAG_RX_PS_ENABLED) {
 		rx_buf_len = IXGBE_RX_HDR_SIZE;
