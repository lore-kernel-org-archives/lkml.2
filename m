Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2FYPPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:15:42 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:60552 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752361Ab2FYPPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:15:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGl/6E9bdWOb/2dsb2JhbABEtiyBB4IZAQUnUhBRVwYTiA+4SpE1A5UukAGCYQ
X-IronPort-AV: E=Sophos;i="4.77,472,1336341600"; 
   d="scan'208";a="932086481"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Staging: ipack/devices/ipoctal: remove unneeded lock in IRQ handler
Date: Mon, 25 Jun 2012 17:15:47 +0200
Message-Id: <1340637347-14303-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340637347-14303-1-git-send-email-siglesias@igalia.com>
References: <1340637347-14303-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the rest of the code, the data is protected with spin_lock_irqsave().

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index b11126d..ec7b2f9 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -299,7 +299,7 @@ static int ipoctal_irq_handler(void *arg)
 				ipoctal->nb_bytes[channel] = 0;
 				continue;
 			}
-			spin_lock(&ipoctal->lock[channel]);
+
 			value = ipoctal->tty_port[channel].xmit_buf[*pointer_write];
 			ipoctal_write_io_reg(ipoctal,
 					     &ipoctal->chan_regs[channel].u.w.thr,
@@ -309,7 +309,6 @@ static int ipoctal_irq_handler(void *arg)
 			(*pointer_write)++;
 			*pointer_write = *pointer_write % PAGE_SIZE;
 			ipoctal->nb_bytes[channel]--;
-			spin_unlock(&ipoctal->lock[channel]);
 
 			if ((ipoctal->nb_bytes[channel] == 0) &&
 			    (waitqueue_active(&ipoctal->queue[channel]))) {
-- 
1.7.10

