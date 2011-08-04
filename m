Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1HDINW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:13:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:41894 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1HDINO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:13:14 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/serial/ucc_uart.c: Fix compiler warning
Date: Thu,  4 Aug 2011 03:13:10 -0500
Message-Id: <1312445590-2559-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/serial/ucc_uart.c: In function 'qe2cpu_addr':
drivers/tty/serial/ucc_uart.c:238:2: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/tty/serial/ucc_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index c327218..9af9f08 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -235,7 +235,7 @@ static inline void *qe2cpu_addr(dma_addr_t addr, struct uart_qe_port *qe_port)
 		return qe_port->bd_virt + (addr - qe_port->bd_dma_addr);
 
 	/* something nasty happened */
-	printk(KERN_ERR "%s: addr=%x\n", __func__, addr);
+	printk(KERN_ERR "%s: addr=%llx\n", __func__, (u64)addr);
 	BUG();
 	return NULL;
 }
-- 
1.5.6.5

