Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab1C3VQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:16:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:44838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965264Ab1C3VJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727134056"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: nbd@openwrt.org, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [249/275] mac80211: initialize sta->last_rx in sta_info_alloc
Message-Id: <20110330210815.D6A6B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/sta_info.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/net/mac80211/sta_info.c
===================================================================
--- linux-2.6.35.y.orig/net/mac80211/sta_info.c	2011-03-29 22:50:12.118948325 -0700
+++ linux-2.6.35.y/net/mac80211/sta_info.c	2011-03-29 23:03:03.467211454 -0700
@@ -239,6 +239,7 @@
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
 	sta->sdata = sdata;
+	sta->last_rx = jiffies;
 
 	if (sta_prepare_rate_control(local, sta, gfp)) {
 		kfree(sta);
