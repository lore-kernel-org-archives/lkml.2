Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab2AWXwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:52:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab2AWXvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:51:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:30 2012
Message-Id: <20120123234030.439037983@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:40:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [88/90] iwlagn: check for SMPS mode
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit b2ccccdca46273c7b321ecf5041c362cd950da20 upstream.

Check and report WARN only when its invalid

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=42621
https://bugzilla.redhat.com/show_bug.cgi?id=766071

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2023,6 +2023,7 @@ static int iwl_get_idle_rx_chain_count(s
 	case IEEE80211_SMPS_STATIC:
 	case IEEE80211_SMPS_DYNAMIC:
 		return IWL_NUM_IDLE_CHAINS_SINGLE;
+	case IEEE80211_SMPS_AUTOMATIC:
 	case IEEE80211_SMPS_OFF:
 		return active_cnt;
 	default:
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -442,6 +442,9 @@ int iwlagn_mac_config(struct ieee80211_h
 
 	mutex_lock(&priv->mutex);
 
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		goto out;
+
 	if (unlikely(test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 		goto out;


