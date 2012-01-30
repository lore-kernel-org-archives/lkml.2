Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2A3Nen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:34:43 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:48198 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051Ab2A3Nem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:34:42 -0500
From: Maxime Coquelin <maxime.coquelin@stericsson.com>
To: <linux-mm@kvack.org>, <linaro-mm-sig@lists.linaro.org>,
        Mel Gorman <mel@csn.ul.ie>, Ankita Garg <ankita@in.ibm.com>
Cc: <linux-kernel@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        <linus.walleij@stericsson.com>, <andrea.gallo@stericsson.com>,
        <vincent.guittot@stericsson.com>, <philippe.langlais@stericsson.com>,
        <loic.pallardy@stericsson.com>
Subject: [RFCv1 4/6] PASR: Call PASR initialization
Date: Mon, 30 Jan 2012 14:33:54 +0100
Message-ID: <1327930436-10263-5-git-send-email-maxime.coquelin@stericsson.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1327930436-10263-1-git-send-email-maxime.coquelin@stericsson.com>
References: <1327930436-10263-1-git-send-email-maxime.coquelin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
---
 init/main.c             |    8 ++++++++
 1 file changed, 8 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index 9fd91c3..5e0aeb7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -69,6 +69,7 @@
 #include <linux/slab.h>
 #include <linux/perf_event.h>
 #include <linux/boottime.h>
+#include <linux/pasr.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -487,6 +488,9 @@ asmlinkage void __init start_kernel(void)
 	page_address_init();
 	printk(KERN_NOTICE "%s", linux_banner);
 	setup_arch(&command_line);
+#ifdef CONFIG_PASR
+	early_pasr_setup();
+#endif
 	mm_init_owner(&init_mm, &init_task);
 	mm_init_cpumask(&init_mm);
 	setup_command_line(command_line);
@@ -555,6 +559,10 @@ asmlinkage void __init start_kernel(void)
 
 	kmem_cache_init_late();
 
+#ifdef CONFIG_PASR
+	late_pasr_setup();
+#endif
+
 	/*
 	 * HACK ALERT! This is early. We're enabling the console before
 	 * we've done PCI setups etc, and console_init() must be aware of
-- 
1.7.8

