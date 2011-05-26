Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1EZStS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:49:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:43284 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab1EZStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:49:15 -0400
Date: Thu, 26 May 2011 20:49:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] irq fix for ...
Message-ID: <alpine.LFD.2.02.1105262048340.3078@ionos>
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

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

Thanks,

	tglx

------------------>
Yinghai Lu (1):
      irq: Remove smp_affinity_list when unregister irq proc


 kernel/irq/proc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 64e3df6..4bd4faa 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -352,6 +352,7 @@ void unregister_irq_proc(unsigned int irq, struct irq_desc *desc)
 #ifdef CONFIG_SMP
 	remove_proc_entry("smp_affinity", desc->dir);
 	remove_proc_entry("affinity_hint", desc->dir);
+	remove_proc_entry("smp_affinity_list", desc->dir);
 	remove_proc_entry("node", desc->dir);
 #endif
 	remove_proc_entry("spurious", desc->dir);
