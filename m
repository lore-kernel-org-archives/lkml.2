Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2DFHEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:04:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50423 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2DFHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:03:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6671"; a="177115381"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC/PATCH 2/3] init: Initialize jump_labels before early parameters
Date: Fri,  6 Apr 2012 00:03:17 -0700
Message-Id: <1333695798-2917-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.rc3.3.g19a6c
In-Reply-To: <1333695798-2917-1-git-send-email-sboyd@codeaurora.org>
References: <1333695798-2917-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to use jump_labels in the debug_objects code so that when
debug_objects aren't enabled by default we can skip debug_object
code. Move the jump_label initialization before the early
parameter parsing so that debug_objects code can enable and
disable itself according to kernel command line parameters.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---

This also opens the window to using static keys for pr_debug().
I tried and wound up in circular dependency hell.

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index ff49a6d..39a3092 100644
--- a/init/main.c
+++ b/init/main.c
@@ -502,14 +502,14 @@ asmlinkage void __init start_kernel(void)
 	build_all_zonelists(NULL);
 	page_alloc_init();
 
+	jump_label_init();
+
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
 
-	jump_label_init();
-
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

