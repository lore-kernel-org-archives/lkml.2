Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2HUIit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:38:49 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49664 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2HUIiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:38:46 -0400
MIME-Version: 1.0
Date: Tue, 21 Aug 2012 16:38:45 +0800
Message-ID: <CAPgLHd-05800cTo8f3mZA1nD47oer=rv0S-qYfQdj1VnApFWdw@mail.gmail.com>
Subject: [PATCH] staging: rtl8192e: using random_ether_addr() to generate
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
 drivers/staging/rtl8192e/rtllib_softmac.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index a21b4d9..49aecda 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/uaccess.h>
+#include <linux/etherdevice.h>
 #include "dot11d.h"
 
 short rtllib_is_54g(struct rtllib_network *net)
@@ -2619,13 +2620,7 @@ void rtllib_wake_all_queues(struct rtllib_device *ieee)
 inline void rtllib_randomize_cell(struct rtllib_device *ieee)
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

