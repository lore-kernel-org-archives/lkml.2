Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2LBNAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 08:00:11 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59509 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2LBNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 08:00:10 -0500
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 08:00:09 -0500
Message-ID: <CAPgLHd9vUfwYfd71n17QfSinsQQb5KD1T0KRC7ASq+CEqE_6hA@mail.gmail.com>
Subject: [PATCH] powerpc/windfarm: use for_each_node_by_type() macro
From: Wei Yongjun <weiyj.lk@gmail.com>
To: benh@kernel.crashing.org
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use for_each_node_by_type() macro instead of open coding it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/macintosh/windfarm_rm31.c  | 2 +-
 drivers/macintosh/windfarm_pm72.c  | 2 +-
 drivers/macintosh/windfarm_pm112.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/macintosh/windfarm_rm31.c b/drivers/macintosh/windfarm_rm31.c
index 3eca6d4..4190b27 100644
--- a/drivers/macintosh/windfarm_rm31.c
+++ b/drivers/macintosh/windfarm_rm31.c
@@ -696,7 +696,7 @@ static int __init wf_rm31_init(void)
 
 	/* Count the number of CPU cores */
 	nr_chips = 0;
-	for (cpu = NULL; (cpu = of_find_node_by_type(cpu, "cpu")) != NULL; )
+	for_each_node_by_type(cpu, "cpu")
 		++nr_chips;
 	if (nr_chips > NR_CHIPS)
 		nr_chips = NR_CHIPS;

diff --git a/drivers/macintosh/windfarm_pm72.c b/drivers/macintosh/windfarm_pm72.c
index 84ac913..73f5e24 100644
--- a/drivers/macintosh/windfarm_pm72.c
+++ b/drivers/macintosh/windfarm_pm72.c
@@ -804,7 +804,7 @@ static int __init wf_pm72_init(void)
 
 	/* Count the number of CPU cores */
 	nr_chips = 0;
-	for (cpu = NULL; (cpu = of_find_node_by_type(cpu, "cpu")) != NULL; )
+	for_each_node_by_type(cpu, "cpu")
 		++nr_chips;
 	if (nr_chips > NR_CHIPS)
 		nr_chips = NR_CHIPS;

diff --git a/drivers/macintosh/windfarm_pm112.c b/drivers/macintosh/windfarm_pm112.c
index e0ee807..b479b82 100644
--- a/drivers/macintosh/windfarm_pm112.c
+++ b/drivers/macintosh/windfarm_pm112.c
@@ -681,7 +681,7 @@ static int __init wf_pm112_init(void)
 
 	/* Count the number of CPU cores */
 	nr_cores = 0;
-	for (cpu = NULL; (cpu = of_find_node_by_type(cpu, "cpu")) != NULL; )
+	for_each_node_by_type(cpu, "cpu")
 		++nr_cores;
 
 	printk(KERN_INFO "windfarm: initializing for dual-core desktop G5\n");

