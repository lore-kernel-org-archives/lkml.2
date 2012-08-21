Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2HUIjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:39:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50760 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2HUIjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:39:05 -0400
MIME-Version: 1.0
Date: Tue, 21 Aug 2012 16:39:04 +0800
Message-ID: <CAPgLHd-v4Ny8a=y+oqw2GCTai4teb6=vcKn9Arts-1AM2Wa3OQ@mail.gmail.com>
Subject: [PATCH] Staging: rtl8192u: using random_ether_addr() to generate
 random MAC
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using random_ether_addr() to generate a random Ethernet
address (MAC) that is not multicast and has the local
assigned bit set. Not need to duplicating its implementation.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index f6ff8cf..a9dc4a2 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/etherdevice.h>
 #include <asm/uaccess.h>
 #include "dot11d.h"
 
@@ -2286,13 +2287,7 @@ void ieee80211_stop_queue(struct ieee80211_device *ieee)
 inline void ieee80211_randomize_cell(struct ieee80211_device *ieee)
 {
 
-	get_random_bytes(ieee->current_network.bssid, ETH_ALEN);
-
-	/* an IBSS cell address must have the two less significant
-	 * bits of the first byte = 2
-	 */
-	ieee->current_network.bssid[0] &= ~0x01;
-	ieee->current_network.bssid[0] |= 0x02;
+	random_ether_addr(ieee->current_network.bssid);
 }
 
 /* called in user context only */

