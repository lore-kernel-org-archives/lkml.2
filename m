Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0LLXpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44703 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab0LLXpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:24 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: rmanoharan@atheros.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [24/223] mac80211: Fix ibss station got expired immediately
Message-Id: <20101212234520.1F545B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit c8716d9dc13c7f6ee92f2bfc6cc3b723b417bff8 upstream.

Station addition in ieee80211_ibss_rx_queued_mgmt is not updating
sta->last_rx which is causing station expiry in ieee80211_ibss_work
path. So sta addition and deletion happens repeatedly.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/ibss.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/net/mac80211/ibss.c
===================================================================
--- linux.orig/net/mac80211/ibss.c
+++ linux/net/mac80211/ibss.c
@@ -427,6 +427,7 @@ struct sta_info *ieee80211_ibss_add_sta(
 	if (!sta)
 		return NULL;
 
+	sta->last_rx = jiffies;
 	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
 
 	/* make sure mandatory rates are always added */
