Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab1I1XJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:09:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab1I1Wpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:41 2011
Message-Id: <20110928220141.531091944@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Don Fry <donald.h.fry@intel.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [154/244] iwlagn: workaround bug crashing some APs
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Don Fry <donald.h.fry@intel.com>

commit 2249b011432ca3dcce112f0f71e0f531b4bb9347 upstream.

This patch reverts commit 9b7688328422b88a7a15dc0dc123ad9ab1a6e22d which
was introduced in 2.6.38-rc1.  It works around a problem where the iwlagn
driver stimulates a bug crashing (requiring power cycle to recover) some
APs under heavy traffic.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
SIgned-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2440,7 +2440,12 @@ static int iwl_mac_setup_register(struct
 		    IEEE80211_HW_SPECTRUM_MGMT |
 		    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
+	/*
+	 * Including the following line will crash some AP's.  This
+	 * workaround removes the stimulus which causes the crash until
+	 * the AP software can be fixed.
 	hw->max_tx_aggregation_subframes = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
+	 */
 
 	hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;


