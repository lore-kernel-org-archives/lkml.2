Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab2AMMn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:43:28 -0500
Received: from unicorn.mansr.com ([78.86.181.103]:43900 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab2AMMn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:43:27 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jan 2012 07:43:27 EST
From: Mans Rullgard <mans.rullgard@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linaro-dev@lists.linaro.org, patches@linaro.org,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Javi Merino <javi.merino@arm.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: pl330: fix null pointer dereference in pl330_chan_ctrl()
Date: Fri, 13 Jan 2012 12:36:31 +0000
Message-Id: <1326458191-23492-1-git-send-email-mans.rullgard@linaro.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the thrd->req_running field being accessed before thrd
is checked for null.  The error was introduced in abb959f.

Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>
---
 arch/arm/common/pl330.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/pl330.c b/arch/arm/common/pl330.c
index 8d8df74..67abef5 100644
--- a/arch/arm/common/pl330.c
+++ b/arch/arm/common/pl330.c
@@ -1496,12 +1496,13 @@ int pl330_chan_ctrl(void *ch_id, enum pl330_chan_op op)
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

