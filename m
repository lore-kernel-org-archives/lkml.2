Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2KNFxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:53:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55295 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756426Ab2KNFvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:11 -0500
Message-Id: <20121114053937.769633291@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:01 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antonio Quartulli <ordex@autistici.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 28/82] mac80211: fix SSID copy on IBSS JOIN
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5f3620f..bf87c70 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1108,7 +1108,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
 	sdata->u.ibss.ibss_join_req = jiffies;
 
-	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
+	memcpy(sdata->u.ibss.ssid, params->ssid, params->ssid_len);
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
 	mutex_unlock(&sdata->u.ibss.mtx);


