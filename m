Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1BPBnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:43:33 -0500
Received: from kroah.org ([198.145.64.141]:38864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab1BPATb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:30 2011
Message-Id: <20110216001430.730992875@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Don Fry <donald.h.fry@intel.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [056/272] iwlagn: Re-enable RF_KILL interrupt when down
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Don Fry <donald.h.fry@intel.com>

commit 3dd823e6b86407aed1a025041d8f1df77e43a9c8 upstream.

With commit 554d1d027b19265c4aa3f718b3126d2b86e09a08 only one RF_KILL
interrupt will be seen by the driver when the interface is down.

Re-enable the interrupt when it occurs to see all transitions.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1319,6 +1319,9 @@ static void iwl_irq_tasklet_legacy(struc
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
@@ -1533,6 +1536,9 @@ static void iwl_irq_tasklet(struct iwl_p
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv);
 }
 
 /* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */


