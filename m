Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab0EEUsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:48:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:60513 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab0EEUsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,335,1270450800"; 
   d="scan'208";a="273764761"
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [PATCH linux-next] irq: Clear CPU mask in affinity_hint when none is
	provided
To: tglx@linutronix.de, davem@davemloft.net, arjan@linux.jf.intel.com,
       bhutchings@solarflare.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 05 May 2010 13:56:42 -0700
Message-ID: <20100505205638.5426.87189.stgit@ppwaskie-hc2.jf.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an interrupt is disabled and torn down, the CPU mask
returned through affinity_hint right now is all CPUs.  Also, for
drivers that don't provide an affinity_hint mask, this can be
misleading.  There should be no hint at all, meaning an empty
CPU mask.

Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---

 kernel/irq/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index e1e7408..9ffa24d 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -45,7 +45,7 @@ static int irq_affinity_hint_proc_show(struct seq_file *m, void *v)
 	if (desc->affinity_hint)
 		cpumask_copy(mask, desc->affinity_hint);
 	else
-		cpumask_setall(mask);
+		cpumask_clear(mask);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	seq_cpumask(m, mask);

