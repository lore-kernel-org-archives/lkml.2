Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab1DMPzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:55:10 -0400
Received: from kroah.org ([198.145.64.141]:54206 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab1DMPzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:43 2011
Message-Id: <20110413155143.696043145@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:50:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [07/74] mac80211: initialize sta->last_rx in sta_info_alloc
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 8bc8aecdc5e26cfda12dbd6867af4aa67836da6a upstream.

This field is used to determine the inactivity time. When in AP mode,
hostapd uses it for kicking out inactive clients after a while. Without this
patch, hostapd immediately deauthenticates a new client if it checks the
inactivity time before the client sends its first data frame.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/sta_info.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -276,6 +276,7 @@ struct sta_info *sta_info_alloc(struct i
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
 	sta->sdata = sdata;
+	sta->last_rx = jiffies;
 
 	sta->rate_ctrl = rate_control_get(local->rate_ctrl);
 	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl,


