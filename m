Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab2DFHDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:03:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50423 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2DFHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:03:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6671"; a="177115380"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] timer: Move debugobjects.h include to timer.c
Date: Fri,  6 Apr 2012 00:03:16 -0700
Message-Id: <1333695798-2917-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.rc3.3.g19a6c
In-Reply-To: <1333695798-2917-1-git-send-email-sboyd@codeaurora.org>
References: <1333695798-2917-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no usage of debugobjects structures in timer.h so move
the include to timer.c. This avoids an include file circular
dependency if timer.h includes debugobjects.h which includes
jump_label.h (in a later patch) which includes workqueue.h which
includes timer.h.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---

This should be good to apply regardless of the rest of this series.

 include/linux/timer.h |    1 -
 kernel/timer.c        |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 6abd913..d7848ab 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -4,7 +4,6 @@
 #include <linux/list.h>
 #include <linux/ktime.h>
 #include <linux/stddef.h>
-#include <linux/debugobjects.h>
 #include <linux/stringify.h>
 
 struct tvec_base;
diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..aa0841c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -40,6 +40,7 @@
 #include <linux/irq_work.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/debugobjects.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

