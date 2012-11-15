Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993039Ab2KOEg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:36:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:48975 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992958Ab2KOELV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Antonio Quartulli <ordex@autistici.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 26/66] mac80211: fix SSID copy on IBSS JOIN
Date: Wed, 14 Nov 2012 20:10:31 -0800
Message-Id: <20121115040940.898562942@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1074,7 +1074,7 @@ int ieee80211_ibss_join(struct ieee80211
 	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
 	sdata->u.ibss.ibss_join_req = jiffies;
 
-	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
+	memcpy(sdata->u.ibss.ssid, params->ssid, params->ssid_len);
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
 	mutex_unlock(&sdata->u.ibss.mtx);


