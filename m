Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab1IVJEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:04:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38518 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1IVJEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:04:37 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 33/55] infiniband: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:59:00 +0800
Message-Id: <1316681962-8217-34-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/infiniband/hw/ehca/ehca_eq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/infiniband/hw/ehca/ehca_eq.c
index d9b1bb4..818d721 100644
--- a/drivers/infiniband/hw/ehca/ehca_eq.c
+++ b/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -125,7 +125,7 @@ int ehca_create_eq(struct ehca_shca *shca,
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
 
 		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
-					  IRQF_DISABLED, "ehca_eq",
+					  0, "ehca_eq",
 					  (void *)shca);
 		if (ret < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
@@ -133,7 +133,7 @@ int ehca_create_eq(struct ehca_shca *shca,
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);
 
 		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
-					  IRQF_DISABLED, "ehca_neq",
+					  0, "ehca_neq",
 					  (void *)shca);
 		if (ret < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
-- 
1.7.4.1

