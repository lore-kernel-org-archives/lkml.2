Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1KZUTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:19:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab1KZUT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:19:27 -0500
From: NeilBrown <neilb@suse.de>
To: Felipe Balbi <balbi@ti.com>
Date: Sun, 27 Nov 2011 07:17:41 +1100
Subject: [PATCH 1/4] twl4030-irq: Base interrupt must be one-shot
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>
Message-ID: <20111126201741.16080.12574.stgit@notabene.brown>
In-Reply-To: <20111126201334.16080.85045.stgit@notabene.brown>
References: <20111126201334.16080.85045.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the interrupt source is only cleared by the threaded interrupt
service routine, we need to make the base interrupt IRQF_ONESHOT.
Without this, the first interrupt from the TWL4030 cause the CPU to
enter an infinite loop trying to handle to interrupt but never
clearing it.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/mfd/twl4030-irq.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index f062c8c..3d3d6ed 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -733,8 +733,9 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 	}
 
 	/* install an irq handler to demultiplex the TWL4030 interrupt */
-	status = request_threaded_irq(irq_num, NULL, handle_twl4030_pih, 0,
-					"TWL4030-PIH", NULL);
+	status = request_threaded_irq(irq_num, NULL, handle_twl4030_pih,
+				      IRQF_ONESHOT,
+				      "TWL4030-PIH", NULL);
 	if (status < 0) {
 		pr_err("twl4030: could not claim irq%d: %d\n", irq_num, status);
 		goto fail_rqirq;


