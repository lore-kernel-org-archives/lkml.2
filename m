Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433Ab2CITrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:47:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030544Ab2CITrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:16 -0500
Message-Id: <20120309190205.000511575@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pavel Roskin <proski@gnu.org>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 33/95] mac80211: zero initialize count field in ieee80211_tx_rate
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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

Cc: Pavel Roskin <proski@gnu.org>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -344,7 +344,7 @@ void rate_control_get_rate(struct ieee80
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		info->control.rates[i].idx = -1;
 		info->control.rates[i].flags = 0;
-		info->control.rates[i].count = 1;
+		info->control.rates[i].count = 0;
 	}
 
 	if (sdata->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)


