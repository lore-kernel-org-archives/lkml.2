Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2FOAHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:07:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab2FNX7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:37 -0400
Message-Id: <20120614235625.344806126@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sebastian Kemper <sebastian_ml@gmx.net>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 16/42] iwlwifi: disable WoWLAN if !CONFIG_PM_SLEEP
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit fcb6ff5e2cb83e1de10631f6621f45ca3401bf61 upstream.

If CONFIG_PM_SLEEP is disabled, then iwlwifi doesn't
support suspend/resume handlers and thus mac80211
(correctly) refuses advertising WoWLAN. Disable
WoWLAN in the driver in this case.

Reported-by: Sebastian Kemper <sebastian_ml@gmx.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -196,6 +196,7 @@ int iwlagn_mac_setup_register(struct iwl
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
+#ifdef CONFIG_PM_SLEEP
 	if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
 	    trans(priv)->ops->wowlan_suspend &&
 	    device_can_wakeup(trans(priv)->dev)) {
@@ -214,6 +215,7 @@ int iwlagn_mac_setup_register(struct iwl
 		hw->wiphy->wowlan.pattern_max_len =
 					IWLAGN_WOWLAN_MAX_PATTERN_LEN;
 	}
+#endif
 
 	if (iwlagn_mod_params.power_save)
 		hw->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;


