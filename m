Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab2FOAGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:06:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45611 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab2FNX7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:51 -0400
Message-Id: <20120614235625.693489625@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 20/42] mac80211: fix error in station state transitions during reconfig
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

commit bd34ab62a3297bd7685da11b0cbe05ae4cd8b02c upstream.

As part of hardware reconfig mac80211 tries
to restore the station state to its values
before the hardware reconfig, but it only
goes to the last-state - 1. Fix this
off-by-one error.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1224,7 +1224,7 @@ int ieee80211_reconfig(struct ieee80211_
 			enum ieee80211_sta_state state;
 
 			for (state = IEEE80211_STA_NOTEXIST;
-			     state < sta->sta_state - 1; state++)
+			     state < sta->sta_state; state++)
 				WARN_ON(drv_sta_state(local, sta->sdata, sta,
 						      state, state + 1));
 		}


