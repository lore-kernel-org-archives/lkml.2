Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1IUJdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:33:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57864 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1IUJdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:33:02 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com, Tejun Heo <tj@kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Jens Axboe <jaxboe@fusionio.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 27/57] cdrom: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:28 +0800
Message-Id: <1316597339-29861-28-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/cdrom/gdrom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 3ceaf00..88ae54a 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -562,11 +562,11 @@ static int __devinit gdrom_set_interrupt_handlers(void)
 	int err;
 
 	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt,
-		IRQF_DISABLED, "gdrom_command", &gd);
+		0, "gdrom_command", &gd);
 	if (err)
 		return err;
 	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt,
-		IRQF_DISABLED, "gdrom_dma", &gd);
+		0, "gdrom_dma", &gd);
 	if (err)
 		free_irq(HW_EVENT_GDROM_CMD, &gd);
 	return err;
-- 
1.7.4.1

