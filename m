Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2CLAua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:50:30 -0400
Received: from 1wt.eu ([62.212.114.60]:63103 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab2CLAsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:51 -0400
Message-Id: <20120312002046.282831520@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:20:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 08/12] mac80211: zero initialize count field in ieee80211_tx_rate
In-Reply-To: <feb44625a10a45049eddf27890e95d54@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

commit 8617b093d0031837a7be9b32bc674580cfb5f6b5 upstream.

rate control algorithms concludes the rate as invalid
with rate[i].idx < -1 , while they do also check for rate[i].count is
non-zero. it would be safer to zero initialize the 'count' field.
recently we had a ath9k rate control crash where the ath9k rate control
in ath_tx_status assumed to check only for rate[i].count being non-zero
in one instance and ended up in using invalid rate index for
'connection monitoring NULL func frames' which eventually lead to the crash.
thanks to Pavel Roskin for fixing it and finding the root cause.
https://bugzilla.redhat.com/show_bug.cgi?id=768639

Cc: stable@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index ad64f4d..f9b8e81 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -344,7 +344,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		info->control.rates[i].idx = -1;
 		info->control.rates[i].flags = 0;
-		info->control.rates[i].count = 1;
+		info->control.rates[i].count = 0;
 	}
 
 	if (sdata->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)


