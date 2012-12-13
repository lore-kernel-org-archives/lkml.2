Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab2LMOJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:09:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2LMOJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 142/241] iwlwifi: fix the basic CCK rates calculation
Date: Thu, 13 Dec 2012 11:58:27 -0200
Message-Id: <1355407206-17100-143-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 5edd0b946a0afeb1d0364a3654328b046fb818a2 upstream.

Fix a copy paste error in iwl_calc_basic_rates which leads
to a wrong calculation of CCK basic rates.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ herton: adjust file name, code is in iwl-agn-rxon.c ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 0a3aa7c..beaf5fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -1019,12 +1019,12 @@ static void iwl_calc_basic_rates(struct iwl_priv *priv,
 	 * As a consequence, it's not as complicated as it sounds, just add
 	 * any lower rates to the ACK rate bitmap.
 	 */
-	if (IWL_RATE_11M_INDEX < lowest_present_ofdm)
-		ofdm |= IWL_RATE_11M_MASK >> IWL_FIRST_CCK_RATE;
-	if (IWL_RATE_5M_INDEX < lowest_present_ofdm)
-		ofdm |= IWL_RATE_5M_MASK >> IWL_FIRST_CCK_RATE;
-	if (IWL_RATE_2M_INDEX < lowest_present_ofdm)
-		ofdm |= IWL_RATE_2M_MASK >> IWL_FIRST_CCK_RATE;
+	if (IWL_RATE_11M_INDEX < lowest_present_cck)
+		cck |= IWL_RATE_11M_MASK >> IWL_FIRST_CCK_RATE;
+	if (IWL_RATE_5M_INDEX < lowest_present_cck)
+		cck |= IWL_RATE_5M_MASK >> IWL_FIRST_CCK_RATE;
+	if (IWL_RATE_2M_INDEX < lowest_present_cck)
+		cck |= IWL_RATE_2M_MASK >> IWL_FIRST_CCK_RATE;
 	/* 1M already there or needed so always add */
 	cck |= IWL_RATE_1M_MASK >> IWL_FIRST_CCK_RATE;
 
-- 
1.7.9.5

