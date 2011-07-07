Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1GGWjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:39:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63332 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1GGWjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 18:39:43 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 4/4] staging: et131x: et1310_mac.c: ConfigMacStatRegs() add missing regs to be zeroed
Date: Thu,  7 Jul 2011 23:38:58 +0100
Message-Id: <1310078338-25896-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310078338-25896-1-git-send-email-mark.einon@gmail.com>
References: <1310078338-25896-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment at the top of the function states 'we need to initialize all the macstat registers to zero', but not all macstat registers are zeroed. Zero the missing registers.
Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index dc3e062..656be4b 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -387,21 +387,54 @@ void ConfigMacStatRegs(struct et131x_adapter *etdev)
 	/* Next we need to initialize all the macstat registers to zero on
 	 * the device.
 	 */
+	writel(0, &macstat->txrx_0_64_byte_frames);
+	writel(0, &macstat->txrx_65_127_byte_frames);
+	writel(0, &macstat->txrx_128_255_byte_frames);
+	writel(0, &macstat->txrx_256_511_byte_frames);
+	writel(0, &macstat->txrx_512_1023_byte_frames);
+	writel(0, &macstat->txrx_1024_1518_byte_frames);
+	writel(0, &macstat->txrx_1519_1522_gvln_frames);
+
+	writel(0, &macstat->rx_bytes);
+	writel(0, &macstat->rx_packets);
 	writel(0, &macstat->rx_fcs_errs);
+	writel(0, &macstat->rx_multicast_packets);
+	writel(0, &macstat->rx_broadcast_packets);
+	writel(0, &macstat->rx_control_frames);
+	writel(0, &macstat->rx_pause_frames);
+	writel(0, &macstat->rx_unknown_opcodes);
 	writel(0, &macstat->rx_align_errs);
 	writel(0, &macstat->rx_frame_len_errs);
 	writel(0, &macstat->rx_code_errs);
-	writel(0, &macstat->rx_drops);
+	writel(0, &macstat->rx_carrier_sense_errs);
+	writel(0, &macstat->rx_undersize_packets);
 	writel(0, &macstat->rx_oversize_packets);
 	writel(0, &macstat->rx_fragment_packets);
+	writel(0, &macstat->rx_jabbers);
+	writel(0, &macstat->rx_drops);
 
+	writel(0, &macstat->tx_bytes);
+	writel(0, &macstat->tx_packets);
+	writel(0, &macstat->tx_multicast_packets);
+	writel(0, &macstat->tx_broadcast_packets);
+	writel(0, &macstat->tx_pause_frames);
 	writel(0, &macstat->tx_deferred);
+	writel(0, &macstat->tx_excessive_deferred);
 	writel(0, &macstat->tx_single_collisions);
 	writel(0, &macstat->tx_multiple_collisions);
 	writel(0, &macstat->tx_late_collisions);
+	writel(0, &macstat->tx_excessive_collisions);
 	writel(0, &macstat->tx_total_collisions);
+	writel(0, &macstat->tx_pause_honored_frames);
+	writel(0, &macstat->tx_drops);
+	writel(0, &macstat->tx_jabbers);
+	writel(0, &macstat->tx_fcs_errs);
+	writel(0, &macstat->tx_control_frames);
 	writel(0, &macstat->tx_oversize_frames);
 	writel(0, &macstat->tx_undersize_frames);
+	writel(0, &macstat->tx_fragments);
+	writel(0, &macstat->carry_reg1);
+	writel(0, &macstat->carry_reg2);
 
 	/* Unmask any counters that we want to track the overflow of.
 	 * Initially this will be all counters.  It may become clear later
-- 
1.7.4.4

