Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2FQSXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:23:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50308 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758303Ab2FQSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:49 -0400
Message-Id: <20120617175946.829354534@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 39/69] iwlwifi: disable the buggy chain extension feature in HW
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit d012d04e4d6312ea157b6cf19e9689af934f5aa7 upstream.

This feature has been reported to be buggy and enabled by
default. We therefore need to disable it manually.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -228,6 +228,7 @@
 #define SCD_TXFACT		(SCD_BASE + 0x10)
 #define SCD_ACTIVE		(SCD_BASE + 0x14)
 #define SCD_QUEUECHAIN_SEL	(SCD_BASE + 0xe8)
+#define SCD_CHAINEXT_EN		(SCD_BASE + 0x244)
 #define SCD_AGGR_SEL		(SCD_BASE + 0x248)
 #define SCD_INTERRUPT_MASK	(SCD_BASE + 0x108)
 
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -868,6 +868,11 @@
 	iwl_write_prph(bus(trans), SCD_DRAM_BASE_ADDR,
 		       trans_pcie->scd_bc_tbls.dma >> 10);
 
+	/* The chain extension of the SCD doesn't work well. This feature is
+	 * enabled by default by the HW, so we need to disable it manually.
+	 */
+	iwl_write_prph(trans, SCD_CHAINEXT_EN, 0);
+
 	/* Enable DMA channel */
 	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
 		iwl_write_direct32(bus(trans), FH_TCSR_CHNL_TX_CONFIG_REG(chan),


