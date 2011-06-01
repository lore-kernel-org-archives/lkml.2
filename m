Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162238Ab1FAISd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:18:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162209Ab1FAISW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:22 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:11 2011
Message-Id: <20110601081110.897963542@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:07 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [037/165] mac80211: use wake_queue to restart trasmit
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1073
Lines: 33

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 470ab2a23b453518ac86937572b4531d8925ca55 upstream.

netif_tx_start_all_queues is used to allow the upper layer
to transmit frames but it does not restart transmission.
To restart the trasmission use netif_tx_wake_all_queues.
Not doing so, sometimes stalls the transmission and the
application has to be restarted to proceed further.

This issue was originally found while sending udp traffic
in higer bandwidth in open environment without bgscan.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -789,7 +789,7 @@ void ieee80211_dynamic_ps_enable_work(st
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
-	netif_tx_start_all_queues(sdata->dev);
+	netif_tx_wake_all_queues(sdata->dev);
 }
 
 void ieee80211_dynamic_ps_timer(unsigned long data)


