Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2FNX7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:59:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2FNX7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:47 -0400
Message-Id: <20120614235625.609881878@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 19/42] iwlwifi: disable the buggy chain extension feature in HW
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit d012d04e4d6312ea157b6cf19e9689af934f5aa7 upstream.

This feature has been reported to be buggy and enabled by
default. We therefore need to disable it manually.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-prph.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -224,6 +224,7 @@
 #define SCD_TXFACT		(SCD_BASE + 0x10)
 #define SCD_ACTIVE		(SCD_BASE + 0x14)
 #define SCD_QUEUECHAIN_SEL	(SCD_BASE + 0xe8)
+#define SCD_CHAINEXT_EN		(SCD_BASE + 0x244)
 #define SCD_AGGR_SEL		(SCD_BASE + 0x248)
 #define SCD_INTERRUPT_MASK	(SCD_BASE + 0x108)
 
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1128,6 +1128,11 @@ static void iwl_tx_start(struct iwl_tran
 	iwl_write_prph(trans, SCD_DRAM_BASE_ADDR,
 		       trans_pcie->scd_bc_tbls.dma >> 10);
 
+	/* The chain extension of the SCD doesn't work well. This feature is
+	 * enabled by default by the HW, so we need to disable it manually.
+	 */
+	iwl_write_prph(trans, SCD_CHAINEXT_EN, 0);
+
 	/* Enable DMA channel */
 	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
 		iwl_write_direct32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(chan),


