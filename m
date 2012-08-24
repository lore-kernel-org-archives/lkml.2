Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2HXF3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 01:29:13 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51736 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2HXF3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 01:29:10 -0400
MIME-Version: 1.0
Date: Fri, 24 Aug 2012 13:29:09 +0800
Message-ID: <CAPgLHd8CQw+Px-AMOKuk8Ji-FuBuaM=FCpa+apggPwJx=+B33w@mail.gmail.com>
Subject: [PATCH v2] staging: r8712u: rtl871x_mlme.c: use is_zero_ether_addr()
 instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_zero_ether_addr() instead of directly use
memcmp() to determine if the ethernet address is
all zeros.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8712/rtl871x_mlme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index dc7adc1..c51ad9e 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -28,6 +28,8 @@
 
 #define _RTL871X_MLME_C_
 
+#include <linux/etherdevice.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "recv_osdep.h"
@@ -146,9 +148,8 @@ static struct wlan_network *_r8712_find_network(struct  __queue *scanned_queue,
 	unsigned long irqL;
 	struct list_head *phead, *plist;
 	struct wlan_network *pnetwork = NULL;
-	u8 zero_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
 
-	if (!memcmp(zero_addr, addr, ETH_ALEN))
+	if (is_zero_ether_addr(addr))
 		return NULL;
 	spin_lock_irqsave(&scanned_queue->lock, irqL);
 	phead = get_list_head(scanned_queue);


