Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2KVVc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:32:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:49636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab2KVSkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 05/83] mac80211: dont send null data packet when not associated
Date: Wed, 21 Nov 2012 16:41:27 -0800
Message-Id: <20121122004212.988444025@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 20f544eea03db4b498942558b882d463ce575c3e upstream.

On resume or firmware recovery, mac80211 sends a null
data packet to see if the AP is still around and hasn't
disconnected us. However, it always does this even if
it wasn't even connected before, leading to a warning
in the new channel context code. Fix this by checking
that it's associated.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/util.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1434,6 +1434,8 @@ int ieee80211_reconfig(struct ieee80211_
 		list_for_each_entry(sdata, &local->interfaces, list) {
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
+			if (!sdata->u.mgd.associated)
+				continue;
 
 			ieee80211_send_nullfunc(local, sdata, 0);
 		}


