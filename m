Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2E3Bku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:40:50 -0400
Received: from masquerade.micron.com ([137.201.242.130]:28595 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2E3Bks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:40:48 -0400
Message-ID: <4FC57A9D.7020003@micron.com>
Date: Tue, 29 May 2012 18:40:45 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 01/11] mtip32xx: fix clearing an incorrect register in mtip_init_port
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--7.592000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix clearing an incorrect register in mtip_init_port

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 00f9fc9..f9cf905 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -436,8 +436,7 @@ static void mtip_init_port(struct mtip_port *port)
 		writel(0xFFFFFFFF, port->completed[i]);
 
 	/* Clear any pending interrupts for this port */
-	writel(readl(port->dd->mmio + PORT_IRQ_STAT),
-					port->dd->mmio + PORT_IRQ_STAT);
+	writel(readl(port->mmio + PORT_IRQ_STAT), port->mmio + PORT_IRQ_STAT);
 
 	/* Clear any pending interrupts on the HBA. */
 	writel(readl(port->dd->mmio + HOST_IRQ_STAT),
-- 
1.7.1

