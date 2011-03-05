Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359Ab1CEBS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:18:29 -0500
Received: from kroah.org ([198.145.64.141]:50147 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760227Ab1CEA76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:59:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:35 2011
Message-Id: <20110305005635.755333874@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        rvossen@broadcom.com, Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
Subject: [12/73] staging: brcm80211: remove assert to avoid panic since 2.6.37 kernel
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arend van Spriel <arend@broadcom.com>

commit d062d44a8386c82c06e483f0c0d1124ba3cab2c8 upstream

The driver assumed it would receive skb packets from MAC80211 which
are not cloned. To guard this assumption an assert was placed in
the transmit routine. As of kernel 2.6.37 it turns out MAC80211 does
pass skb packets that are cloned. The assert is also not needed as
it does not lead to a failure state in our driver when the packet is
cloned. Therefore the assert can safely be removed.

> commit f8a0a781488ec7288d1049e5d2022850aa98f7b6
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Sat Dec 18 19:30:50 2010 +0100
>
>     mac80211: fix potentially redundant skb data copying
>
>     When an skb is shared, it needs to be duplicated, along with its data
>     If the skb does not have enough headroom, using skb_copy might cause t
>     buffer to be copied twice (once by skb_copy and once by pskb_expand_he
>     Fix this by using skb_clone initially and letting ieee80211_skb_resize
>     out the rest.
>
>     Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>

Acked-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/brcm80211/sys/wlc_mac80211.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -5336,7 +5336,6 @@ wlc_sendpkt_mac80211(wlc_info_t *wlc, vo
 	fifo = prio2fifo[prio];
 
 	ASSERT((uint) PKTHEADROOM(sdu) >= TXOFF);
-	ASSERT(!PKTSHARED(sdu));
 	ASSERT(!PKTNEXT(sdu));
 	ASSERT(!PKTLINK(sdu));
 	ASSERT(fifo < NFIFO);


