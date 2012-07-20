Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2GTMpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:45:23 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:40065
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791Ab2GTMpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:45:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <galak@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH] powerpc/smp: Do not disable IPI interrupts during suspend
Date: Fri, 20 Jul 2012 20:47:01 +0800
Message-ID: <1342788421-27648-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend, all interrupts including IPI will be disabled. In this case,
the suspend process will hang in SMP. To prevent this, pass the flag
IRQF_NO_SUSPEND when requesting IPI irq.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 arch/powerpc/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index fecb038..d26bbf8 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -171,7 +171,7 @@ int smp_request_message_ipi(int virq, int msg)
 	}
 #endif
 	err = request_irq(virq, smp_ipi_action[msg],
-			  IRQF_PERCPU | IRQF_NO_THREAD,
+			  IRQF_PERCPU | IRQF_NO_THREAD | IRQF_NO_SUSPEND,
 			  smp_ipi_name[msg], 0);
 	WARN(err < 0, "unable to request_irq %d for %s (rc %d)\n",
 		virq, smp_ipi_name[msg], err);
-- 
1.6.4.1


