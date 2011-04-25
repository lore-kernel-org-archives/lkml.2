Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1DYUnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:43:16 -0400
Received: from 1wt.eu ([62.212.114.60]:34360 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab1DYUYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:53 -0400
Message-Id: <20110425200238.079072344@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 117/173] mac80211: initialize sta->last_rx in sta_info_alloc
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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


