Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab0LHBvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:51:15 -0500
Received: from kroah.org ([198.145.64.141]:48629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab0LHA7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:51 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:27 2010
Message-Id: <20101208005727.137783951@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [058/289] mac80211: Fix ibss station got expired immediately
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit c8716d9dc13c7f6ee92f2bfc6cc3b723b417bff8 upstream.

Station addition in ieee80211_ibss_rx_queued_mgmt is not updating
sta->last_rx which is causing station expiry in ieee80211_ibss_work
path. So sta addition and deletion happens repeatedly.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ibss.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -435,6 +435,7 @@ struct sta_info *ieee80211_ibss_add_sta(
 	if (!sta)
 		return NULL;
 
+	sta->last_rx = jiffies;
 	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
 
 	/* make sure mandatory rates are always added */


