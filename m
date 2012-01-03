Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2ACWkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:40:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab2ACWkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:40:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:24 2012
Message-Id: <20120103223324.136039165@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [37/75] iwlwifi: do not set the sequence control bit is not needed
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 123877b80ed62c3b897c53357b622574c023b642 upstream.

Check the IEEE80211_TX_CTL_ASSIGN_SEQ flag from mac80211, then decide how to
set the TX_CMD_FLG_SEQ_CTL_MSK bit. Setting the wrong bit in BAR frame whill
make the firmware to increment the sequence number which is incorrect and
cause unknown behavior.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -166,7 +166,10 @@ static void iwlagn_tx_cmd_build_basic(st
 		tx_cmd->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
-		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+		else
+			tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
 	iwlagn_tx_cmd_protection(priv, info, fc, &tx_flags);


