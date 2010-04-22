Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab0DVUbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:31:20 -0400
Received: from kroah.org ([198.145.64.141]:59458 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903Ab0DVT7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:46 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:06 2010
Message-Id: <20100422195406.456187481@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: [017/139] iwlwifi: fix regulatory
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit f6c8f1523a2de3b84340e45913cbcee8bee74570 upstream.

Commit "cfg80211: convert bools into flags" mistakenly modified iwlwifi's
regulatory settings instead of just converting it. Fix this.

This fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2172

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2461,7 +2461,7 @@ static int iwl_setup_mac(struct iwl_priv
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY |
+	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
 
 	/*
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3903,7 +3903,7 @@ static int iwl3945_setup_mac(struct iwl_
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY |
+	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX_3945;


