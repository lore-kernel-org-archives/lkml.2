Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965Ab0GAVNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:13:44 -0400
Received: from kroah.org ([198.145.64.141]:33767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869Ab0GAVM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:56 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:47 2010
Message-Id: <20100701174247.874004412@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [017/200] rtl8180: fix tx status reporting
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit d989ff7cf8d14f1b523f63ba0bf2ec1a9b7c25bc upstream.

When reporting Tx status, indicate that only one rate was used.
Otherwise, the rate is frozen at rate index 0 (i.e. 1Mb/s).

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -188,6 +188,7 @@ static void rtl8180_handle_tx(struct iee
 			info->flags |= IEEE80211_TX_STAT_ACK;
 
 		info->status.rates[0].count = (flags & 0xFF) + 1;
+		info->status.rates[1].idx = -1;
 
 		ieee80211_tx_status_irqsafe(dev, skb);
 		if (ring->entries - skb_queue_len(&ring->queue) == 2)


