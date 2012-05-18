Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946191Ab2ERXAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:00:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:40897 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab2ERXAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:00:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH] tile: fix compile failure on start_kernel in setup.c
Date: Fri, 18 May 2012 19:00:21 -0400
Message-Id: <1337382021-16108-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 293ef7b8288da79112276ddd53902aff75ce7494

    "tile: Use generic init_task"

deleted the file tile/kernel/init_task.c and moved the remaining
needed code to tile/kernel/setup.c -- but this code references
start_kernel and setup.c didn't include that, causing this fail:

arch/tile/kernel/setup.c:69:344: error: 'start_kernel' undeclared here (not in a function)

Adding the obvious include fixes it.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 8d91ae7..f74105b 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -26,6 +26,7 @@
 #include <linux/initrd.h>
 #include <linux/io.h>
 #include <linux/highmem.h>
+#include <linux/start_kernel.h>
 #include <linux/smp.h>
 #include <linux/timex.h>
 #include <linux/hugetlb.h>
-- 
1.7.9.1

