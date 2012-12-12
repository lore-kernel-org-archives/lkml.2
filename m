Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2LLSXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:23:03 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46650 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:23:00 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 22/26] smp_processor_id: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:11 -0800
Message-Id: <8f9c39e312e8d32319af9037be12d758c84b0ca7.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/smp_processor_id.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 4c0d0e5..37e59c4 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -42,7 +42,7 @@ notrace unsigned int debug_smp_processor_id(void)
 	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
 			"code: %s/%d\n",
 			preempt_count() - 1, current->comm, current->pid);
-	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
+	printk("caller is %pSR\n", __builtin_return_address(0));
 	dump_stack();
 
 out_enable:
-- 
1.7.8.112.g3fd21

