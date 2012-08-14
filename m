Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2HNXeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:34:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:55625 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2HNXeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:34:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] irqdesc: delete now orphaned references to timer_rand_state
Date: Tue, 14 Aug 2012 19:32:31 -0400
Message-Id: <1344987151-21326-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit c5857ccf293 ("random: remove rand_initialize_irq()")
the timer_rand_state was removed from struct irq_desc.  Hence
we can also remove the forward declaration of it and the kernel
doc information now too.

Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/irqdesc.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 9a323d1..0ba014c 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -10,12 +10,10 @@
 
 struct irq_affinity_notify;
 struct proc_dir_entry;
-struct timer_rand_state;
 struct module;
 /**
  * struct irq_desc - interrupt descriptor
  * @irq_data:		per irq and chip data passed down to chip functions
- * @timer_rand_state:	pointer to timer rand state struct
  * @kstat_irqs:		irq stats per cpu
  * @handle_irq:		highlevel irq-events handler
  * @preflow_handler:	handler called before the flow handler (currently used by sparc)
-- 
1.7.11.1

