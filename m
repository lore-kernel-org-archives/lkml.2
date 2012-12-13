Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2LMPK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:10:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43986 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2LMOBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:21 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antonio Quartulli <ordex@autistici.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 010/241] mac80211: fix SSID copy on IBSS JOIN
Date: Thu, 13 Dec 2012 11:56:15 -0200
Message-Id: <1355407206-17100-11-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <ordex@autistici.org>

commit badecb001a310408d3473b1fc2ed5aefd0bc92a9 upstream.

The 'ssid' field of the cfg80211_ibss_params is a u8 pointer and
its length is likely to be less than IEEE80211_MAX_SSID_LEN most
of the time.

This patch fixes the ssid copy in ieee80211_ibss_join() by using
the SSID length to prevent it from reading beyond the string.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
[rewrapped commit message, small rewording]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 33d9d0c..ebf6425 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1111,7 +1111,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
 	sdata->u.ibss.ibss_join_req = jiffies;
 
-	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
+	memcpy(sdata->u.ibss.ssid, params->ssid, params->ssid_len);
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
 	mutex_unlock(&sdata->u.ibss.mtx);
-- 
1.7.9.5

