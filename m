Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab2FTUKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:10:06 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:52960 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab2FTUKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:10:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 6/6] mn10300: Use "#elif defined(CONFIG_*)" instead of "#elif CONFIG_*"
Date: Wed, 20 Jun 2012 22:09:50 +0200
Message-Id: <1340222990-20796-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
References: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/mn10300/kernel/irq.c:173:7: warning: "CONFIG_MN10300_TTYSM1_TIMER9" is not defined [-Wundef]
arch/mn10300/kernel/irq.c:175:7: warning: "CONFIG_MN10300_TTYSM1_TIMER3" is not defined [-Wundef]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/mn10300/kernel/irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 2381df8..35932a8 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -170,9 +170,9 @@ mn10300_cpupic_setaffinity(struct irq_data *d, const struct cpumask *mask,
 	case SC1TXIRQ:
 #ifdef CONFIG_MN10300_TTYSM1_TIMER12
 	case TM12IRQ:
-#elif CONFIG_MN10300_TTYSM1_TIMER9
+#elif defined(CONFIG_MN10300_TTYSM1_TIMER9)
 	case TM9IRQ:
-#elif CONFIG_MN10300_TTYSM1_TIMER3
+#elif defined(CONFIG_MN10300_TTYSM1_TIMER3)
 	case TM3IRQ:
 #endif /* CONFIG_MN10300_TTYSM1_TIMER12 */
 #endif /* CONFIG_MN10300_TTYSM1 */
-- 
1.7.0.4

