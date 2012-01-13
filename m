Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab2AMTrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:47:31 -0500
Received: from unicorn.mansr.com ([78.86.181.103]:52232 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758910Ab2AMTra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:47:30 -0500
From: Mans Rullgard <mans.rullgard@linaro.org>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jaswinder.singh@linaro.org>, linux-kernel@vger.kernel.org,
        Boojin Kim <boojin.kim@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] ARM: pl330: fix null pointer dereference in pl330_chan_ctrl()
Date: Fri, 13 Jan 2012 19:46:22 +0000
Message-Id: <1326483982-13610-1-git-send-email-mans.rullgard@linaro.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <4F103620.8070504@arm.com>
References: <4F103620.8070504@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the thrd->req_running field being accessed before thrd
is checked for null.  The error was introduced in abb959f.

Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>
---
 drivers/dma/pl330.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 3a6e042..cb3e597 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1568,12 +1568,13 @@ static int pl330_chan_ctrl(void *ch_id, enum pl330_chan_op op)
 	struct pl330_thread *thrd = ch_id;
 	struct pl330_dmac *pl330;
 	unsigned long flags;
-	int ret = 0, active = thrd->req_running;
+	int ret = 0, active;
 
 	if (!thrd || thrd->free || thrd->dmac->state == DYING)
 		return -EINVAL;
 
 	pl330 = thrd->dmac;
+	active = thrd->req_running;
 
 	spin_lock_irqsave(&pl330->lock, flags);
 
-- 
1.7.8.3

