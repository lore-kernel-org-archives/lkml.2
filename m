Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2KWCsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 21:48:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48455 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab2KWCsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 21:48:20 -0500
Message-ID: <50AEE3E9.8040805@gmail.com>
Date: Fri, 23 Nov 2012 10:48:09 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, benchan@chromium.org,
        syahn@gctsemi.com, devendra.aaru@gmail.com, pstew@chromium.org,
        devel@driverdev.osuosl.org, joe@perches.com
CC: Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] drivers: gdm72xx: remove last usage of NIPQUAD and NIP6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

commit cf4ca4874fc45 removed the definition of NIPQUAD and NIPQUAD_FMT,
and NIP6 also is out of date.

Because DEBUG_SDU is not defined in gdm_wimax.h, no error message when compiling
this code.

commit cf4ca4874fc45166198424384275f443a672d0b7
Author: Joe Perches <joe@perches.com>
Date:   Mon Aug 9 17:20:20 2010 -0700

    kernel.h: remove unused NIPQUAD and NIPQUAD_FMT
    There are no more uses of NIPQUAD or NIPQUAD_FMT.  Remove the definitions.

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 drivers/staging/gdm72xx/gdm_wimax.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 6cb8107..c0ec4d0 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -166,21 +166,13 @@ static void dump_eth_packet(const char *title, u8 *data, int len)
 		get_ip_protocol_name(ip_protocol),
 		get_port_name(port));
 
-	#if 1
 	if (!(data[0] == 0xff && data[1] == 0xff)) {
 		if (protocol == ETH_P_IP) {
-			printk(KERN_DEBUG "     src=%u.%u.%u.%u\n",
-				NIPQUAD(ih->saddr));
+			printk(KERN_DEBUG "     src=%pI4\n", &ih->saddr);
 		} else if (protocol == ETH_P_IPV6) {
-			#ifdef NIP6
-			printk(KERN_DEBUG "     src=%x:%x:%x:%x:%x:%x:%x:%x\n",
-				NIP6(ih->saddr));
-			#else
 			printk(KERN_DEBUG "     src=%pI6\n", &ih->saddr);
-			#endif
 		}
 	}
-	#endif
 
 	#if (DUMP_PACKET & DUMP_SDU_ALL)
 	printk_hex(data, len);
-- 
1.7.1

