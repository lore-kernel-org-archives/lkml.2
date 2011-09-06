Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1IFTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:09:26 -0400
Received: from mxout1.idt.com ([157.165.5.25]:41014 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab1IFTJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:09:22 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>, Chul Kim <chul.kim@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH] RapidIO, rionet: Fix ethernet address macros for LE platforms
Date: Tue,  6 Sep 2011 15:07:39 -0400
Message-Id: <1315336059-16156-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify Ethernet addess macros to be compatible with BE/LE platforms
(applicable to kernel versions starting from 2.6.39).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
---
 drivers/net/rionet.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 3bb1311..7145714 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -88,8 +88,8 @@ static struct rio_dev **rionet_active;
 #define dev_rionet_capable(dev) \
 	is_rionet_capable(dev->src_ops, dev->dst_ops)
 
-#define RIONET_MAC_MATCH(x)	(*(u32 *)x == 0x00010001)
-#define RIONET_GET_DESTID(x)	(*(u16 *)(x + 4))
+#define RIONET_MAC_MATCH(x)	(!memcmp((x), "\00\01\00\01", 4))
+#define RIONET_GET_DESTID(x)	((*((u8 *)x + 4) << 8) | *((u8 *)x + 5))
 
 static int rionet_rx_clean(struct net_device *ndev)
 {
-- 
1.7.6

