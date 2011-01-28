Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1A1WZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:25:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1A1WZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:25:46 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: davem@davemloft.net
Cc: Stefan Weil <weil@mail.berlios.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>, Jiri Pirko <jpirko@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] enc28j60: Fix reading of transmit status vector
Date: Fri, 28 Jan 2011 23:25:19 +0100
Message-Id: <1296253519-7580-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:XAiRgpaBmloJqve2fk3qTQnc/6lgRqdyW29+ZYtixus
 rcTZq4slGFMu7g80nRnztmEvjC93PjapNvGkCROeG7WUxniQMO
 KCizbXc8pHDTAC4Wsvea7FC7CP8yB58+iRR0psWzlCF6pdqZ/f
 FzUfarh0F9+R1JUaE9keK8GTRLh1+HtqCGABrInZaLad3THi3O
 ORA8Q6kzwnjmjDgkWFhR6lSeaJjjvQeeuiT6U3vpxA60cvIqgI
 ab00b4W+NXDfK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error was reported by cppcheck:
drivers/net/enc28j60.c:815: error: Using sizeof for array given as function argument returns the size of pointer.

The original code reads 4 or 8 bytes instead of TSV_SIZE (= 100) bytes.
I just fixed the code, but did not run any tests.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jiri Pirko <jpirko@redhat.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/net/enc28j60.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/enc28j60.c b/drivers/net/enc28j60.c
index 112c5aa..907b05a 100644
--- a/drivers/net/enc28j60.c
+++ b/drivers/net/enc28j60.c
@@ -812,7 +812,7 @@ static void enc28j60_read_tsv(struct enc28j60_net *priv, u8 tsv[TSV_SIZE])
 	if (netif_msg_hw(priv))
 		printk(KERN_DEBUG DRV_NAME ": reading TSV at addr:0x%04x\n",
 			 endptr + 1);
-	enc28j60_mem_read(priv, endptr + 1, sizeof(tsv), tsv);
+	enc28j60_mem_read(priv, endptr + 1, TSV_SIZE, tsv);
 }
 
 static void enc28j60_dump_tsv(struct enc28j60_net *priv, const char *msg,
-- 
1.7.2.3

