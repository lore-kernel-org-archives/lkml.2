Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab1I1Wy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:54:27 -0400
Received: from mta21.charter.net ([216.33.127.81]:53608 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab1I1WyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:54:18 -0400
X-Authority-Analysis: v=1.1 cv=6DnK9SlspjQUafU6MzYmZAt1wpB1MUaNH28Mo/Kfxqk=
 c=1 sm=1 a=5sNWC5IPD1MA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=bQGSju9SlZelt66lsl0A:9 a=6-vhtJTMLOjaaoOPM4gA:7
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Gregory.Dietsche@cuw.edu
To: wey-yi.w.guy@intel.com
Cc: ilw@linux.intel.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] iwlagn: iwl-agn-rs: remove unnecessary null check for sta and lq_sta
Date: Wed, 28 Sep 2011 17:54:04 -0500
Message-Id: <1317250444-2248-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

both sta and lq_sta are guaranteed to be not null in the
calling function so we don't need to check them here.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 3789ff4..e5ea33b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2269,9 +2269,6 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
 
-	if (!sta || !lq_sta)
-		return;
-
 	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
-- 
1.7.6.4

