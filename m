Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2DYXcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 19:32:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35987 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2DYXcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 19:32:41 -0400
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH][TRIVIAL] mfd: twl6030: Add intermediate cast to uintptr_t before casting to pointer.
Date: Thu, 26 Apr 2012 00:32:30 +0100
Message-Id: <1335396750-18950-1-git-send-email-krzysztof.wilczynski@linux.com>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to address the following warning during compilation time:

  drivers/mfd/twl6030-irq.c: In function ‘twl6030_init_irq’:
  drivers/mfd/twl6030-irq.c:398: warning: cast to pointer from integer of different size
  drivers/mfd/twl6030-irq.c:415: warning: cast to pointer from integer of different size

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
---
 drivers/mfd/twl6030-irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index b76902f..ddaed2d 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -395,7 +395,7 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 	for (i = irq_base; i < irq_end; i++) {
 		irq_set_chip_and_handler(i, &twl6030_irq_chip,
 					 handle_simple_irq);
-		irq_set_chip_data(i, (void *)irq_num);
+		irq_set_chip_data(i, (void *)(uintptr_t)irq_num);
 		activate_irq(i);
 	}
 
@@ -412,7 +412,7 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 		goto fail_irq;
 	}
 
-	task = kthread_run(twl6030_irq_thread, (void *)irq_num, "twl6030-irq");
+	task = kthread_run(twl6030_irq_thread, (void *)(uintptr_t)irq_num, "twl6030-irq");
 	if (IS_ERR(task)) {
 		dev_err(dev, "could not create irq %d thread!\n", irq_num);
 		status = PTR_ERR(task);
-- 
1.7.7.1

