Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1G2FKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 01:10:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49652 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1G2FKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 01:10:40 -0400
Date: Fri, 29 Jul 2011 15:10:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729151035.f8b69d6fa6aadffb7999abfa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

kernel/jump_label.c: In function '__jump_label_mod_text_reserved':
kernel/jump_label.c:171:2: error: implicit declaration of function '__module_text_address'
kernel/jump_label.c:171:6: warning: assignment makes pointer from integer without a cast
kernel/jump_label.c:175:2: warning: comparison between pointer and integer
kernel/jump_label.c:177:39: error: dereferencing pointer to incomplete type
kernel/jump_label.c:178:8: error: dereferencing pointer to incomplete type
kernel/jump_label.c:178:28: error: dereferencing pointer to incomplete type
kernel/jump_label.c: In function '__jump_label_mod_update':
kernel/jump_label.c:190:10: error: dereferencing pointer to incomplete type
kernel/jump_label.c:190:28: error: dereferencing pointer to incomplete type
kernel/jump_label.c: In function 'jump_label_apply_nops':
kernel/jump_label.c:206:37: error: dereferencing pointer to incomplete type
kernel/jump_label.c:207:49: error: dereferencing pointer to incomplete type
kernel/jump_label.c: In function 'jump_label_add_module':
kernel/jump_label.c:220:37: error: dereferencing pointer to incomplete type
kernel/jump_label.c:221:49: error: dereferencing pointer to incomplete type
kernel/jump_label.c:238:3: error: implicit declaration of function '__module_address'
kernel/jump_label.c:238:35: warning: comparison between pointer and integer
kernel/jump_label.c: In function 'jump_label_del_module':
kernel/jump_label.c:264:37: error: dereferencing pointer to incomplete type
kernel/jump_label.c:265:49: error: dereferencing pointer to incomplete type
kernel/jump_label.c:276:35: warning: comparison between pointer and integer
kernel/jump_label.c: In function 'jump_label_invalidate_module_init':
kernel/jump_label.c:296:37: error: dereferencing pointer to incomplete type
kernel/jump_label.c:297:49: error: dereferencing pointer to incomplete type
kernel/jump_label.c:301:3: error: implicit declaration of function 'within_module_init'
kernel/jump_label.c: In function 'jump_label_module_notify':
kernel/jump_label.c:314:7: error: 'MODULE_STATE_COMING' undeclared (first use in this function)
kernel/jump_label.c:314:7: note: each undeclared identifier is reported only once for each function it appears in
kernel/jump_label.c:321:7: error: 'MODULE_STATE_GOING' undeclared (first use in this function)
kernel/jump_label.c:326:7: error: 'MODULE_STATE_LIVE' undeclared (first use in this function)
kernel/jump_label.c: In function 'jump_label_init_module':
kernel/jump_label.c:343:2: error: implicit declaration of function 'register_module_notifier'
kernel/jump_label.c: In function 'jump_label_update':
kernel/jump_label.c:381:23: warning: initialization makes pointer from integer without a cast
kernel/jump_label.c:386:13: error: dereferencing pointer to incomplete type
kernel/jump_label.c:386:33: error: dereferencing pointer to incomplete type
kernel/jump_label.c: In function '__jump_label_mod_text_reserved':
kernel/jump_label.c:180:1: warning: control reaches end of non-void function

Caused by commit d03b684f1773 ("kernel: Map most files to use export.h
instead of module.h").

I have added this commit for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 15:03:54 +1000
Subject: [PATCH] Partial revert of commit d03b684f1773

"kernel: Map most files to use export.h instead of module.h"

This file need module.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/jump_label.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index d636f85..a8ce450 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -7,7 +7,7 @@
  */
 #include <linux/memory.h>
 #include <linux/uaccess.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
