Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab0LHA7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:46 -0500
Received: from kroah.org ([198.145.64.141]:48576 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab0LHA7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:43 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005726.251090875@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jouni Malinen <j@w1.fi>, "John W. Linville" <linville@tuxdriver.com>
Subject: [049/289] mac80211: Fix signal strength average initialization for CQM events
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jouni Malinen <j@w1.fi>

commit 3ba06c6fbd651ed3377e584026d1c112b492cc8b upstream.

The ave_beacon_signal value uses 1/16 dB unit and as such, must be
initialized with the signal level of the first Beacon frame multiplied
by 16. This fixes an issue where the initial CQM events are reported
incorrectly with a burst of events while the running average
approaches the correct value after the incorrect initialization. This
could cause user space -based roaming decision process to get quite
confused at the moment when we would like to go through authentication
and DHCP.

Signed-off-by: Jouni Malinen <j@w1.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1540,7 +1540,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	ifmgd->last_beacon_signal = rx_status->signal;
 	if (ifmgd->flags & IEEE80211_STA_RESET_SIGNAL_AVE) {
 		ifmgd->flags &= ~IEEE80211_STA_RESET_SIGNAL_AVE;
-		ifmgd->ave_beacon_signal = rx_status->signal;
+		ifmgd->ave_beacon_signal = rx_status->signal * 16;
 		ifmgd->last_cqm_event_signal = 0;
 	} else {
 		ifmgd->ave_beacon_signal =


