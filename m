Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1IUJb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:31:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56827 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1IUJb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:31:56 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        sparclinux@vger.kernel.org
Subject: [PATCH 18/57] sparc: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:19 +0800
Message-Id: <1316597339-29861-19-git-send-email-yong.zhang0@gmail.com>
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
 arch/sparc/include/asm/floppy_64.h |    2 +-
 arch/sparc/kernel/ldc.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/include/asm/floppy_64.h b/arch/sparc/include/asm/floppy_64.h
index bcef1f5..7f27d2e 100644
--- a/arch/sparc/include/asm/floppy_64.h
+++ b/arch/sparc/include/asm/floppy_64.h
@@ -258,7 +258,7 @@ static int sun_fd_request_irq(void)
 		once = 1;
 
 		error = request_irq(FLOPPY_IRQ, sparc_floppy_irq,
-				    IRQF_DISABLED, "floppy", NULL);
+				    0, "floppy", NULL);
 
 		return ((error == 0) ? 0 : -1);
 	}
diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index 435e406..b96cd54 100644
--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -1251,13 +1251,13 @@ int ldc_bind(struct ldc_channel *lp, const char *name)
 	snprintf(lp->tx_irq_name, LDC_IRQ_NAME_MAX, "%s TX", name);
 
 	err = request_irq(lp->cfg.rx_irq, ldc_rx,
-			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED,
+			  IRQF_SAMPLE_RANDOM,
 			  lp->rx_irq_name, lp);
 	if (err)
 		return err;
 
 	err = request_irq(lp->cfg.tx_irq, ldc_tx,
-			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED,
+			  IRQF_SAMPLE_RANDOM,
 			  lp->tx_irq_name, lp);
 	if (err) {
 		free_irq(lp->cfg.rx_irq, lp);
-- 
1.7.4.1

