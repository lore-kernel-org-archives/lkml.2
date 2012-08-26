Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2HZAwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 20:52:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44268 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2HZAwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 20:52:49 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 08:52:48 +0800
Message-ID: <CAPgLHd_hFSVnpy=jp8E=eZ1uhwoKxz7i4k0mCSiqRehBhayxWw@mail.gmail.com>
Subject: [PATCH] staging: wlags49_h2: use is_broadcast_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
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

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/wlags49_h2/wl_wext.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 7ff0a10..ae8dac0 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -62,6 +62,7 @@
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
+#include <linux/etherdevice.h>
 #include <asm/uaccess.h>
 
 #include <debug.h>
@@ -173,7 +174,7 @@ static int hermes_clear_tkip_keys(ltv_t *ltv, u16 key_idx, u8 *addr)
 
 	switch (key_idx) {
 	case 0:
-		if (memcmp(addr, "\xff\xff\xff\xff\xff\xff", ETH_ALEN) != 0) {
+		if (!is_broadcast_ether_addr(addr)) {
 			ltv->len = 7;
 			ltv->typ = CFG_REMOVE_TKIP_MAPPED_KEY;
 			memcpy(&ltv->u.u8[0], addr, ETH_ALEN);


