Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab1BPBu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:50:28 -0500
Received: from kroah.org ([198.145.64.141]:48964 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278Ab1BPBuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:59 2011
Message-Id: <20110216014659.289170400@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Don Fry <donald.h.fry@intel.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [050/115] iwlagn: Re-enable RF_KILL interrupt when down
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1044,6 +1044,9 @@ static void iwl_irq_tasklet_legacy(struc
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
@@ -1245,6 +1248,9 @@ static void iwl_irq_tasklet(struct iwl_p
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 


