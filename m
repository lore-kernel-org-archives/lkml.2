Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1K1OSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:18:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:58562 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1K1OSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:18:03 -0500
Date: Mon, 28 Nov 2011 15:18:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] genirq fixes for 3.2
Message-ID: <alpine.LFD.2.02.1111281514350.2735@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

Thanks,

	tglx

------------------>
Marc Zyngier (1):
      genirq: Don't allow per cpu interrupts to be suspended


 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 67ce837..0e2b179 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1596,7 +1596,7 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		return -ENOMEM;
 
 	action->handler = handler;
-	action->flags = IRQF_PERCPU;
+	action->flags = IRQF_PERCPU | IRQF_NO_SUSPEND;
 	action->name = devname;
 	action->percpu_dev_id = dev_id;
 
