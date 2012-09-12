Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2ILKiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:38:55 -0400
Received: from mail.x86-64.org ([217.9.48.20]:53298 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044Ab2ILKix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:38:53 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] plist: Make plist test announcements KERN_DEBUG
Date: Wed, 12 Sep 2012 12:38:50 +0200
Message-Id: <1347446330-6378-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

They show up in dmesg

[    4.041094] start plist test
[    4.045804] end plist test

without a lot of meaning so hide them behind debug loglevel.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 lib/plist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/plist.c b/lib/plist.c
index 6ab0e521c48b..1ebc95f7a46f 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -175,7 +175,7 @@ static int  __init plist_test(void)
 	int nr_expect = 0, i, loop;
 	unsigned int r = local_clock();
 
-	printk(KERN_INFO "start plist test\n");
+	pr_debug("start plist test\n");
 	plist_head_init(&test_head);
 	for (i = 0; i < ARRAY_SIZE(test_node); i++)
 		plist_node_init(test_node + i, 0);
@@ -203,7 +203,7 @@ static int  __init plist_test(void)
 		plist_test_check(nr_expect);
 	}
 
-	printk(KERN_INFO "end plist test\n");
+	pr_debug("end plist test\n");
 	return 0;
 }
 
-- 
1.7.11.rc1

