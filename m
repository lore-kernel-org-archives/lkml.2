Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2HZBAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:00:32 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37169 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab2HZBAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:00:30 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:00:30 +0800
Message-ID: <CAPgLHd_FznPhj4xWhp_1KnHn6vr0=cpaZ57dy7XkL784cfmWPQ@mail.gmail.com>
Subject: [PATCH] Staging: rtl8192u: use is_broadcast_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_broadcast_ether_addr() instead of directly use
memcmp() to determine if the ethernet address is broadcast
address.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)


Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index f6ff8cf..02dd80d 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -20,6 +20,8 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
+#include <linux/etherdevice.h>
+
 #include "dot11d.h"
 
 u8 rsn_authen_cipher_suite[16][4] = {
@@ -2969,9 +2971,7 @@ static int ieee80211_wpa_set_encryption(struct ieee80211_device *ieee,
 			       param->u.crypt.key_len);
 		return -EINVAL;
 	}
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+	if (is_broadcast_ether_addr(param->sta_addr)) {
 		if (param->u.crypt.idx >= WEP_KEYS)
 			return -EINVAL;
 		crypt = &ieee->crypt[param->u.crypt.idx];

