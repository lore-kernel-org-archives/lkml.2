Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0C2Heh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:34:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1218 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab0C2Hed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:34:33 -0400
From: Joe Perches <joe@perches.com>
To: devel@driverdev.osuosl.org
Cc: Simon Horman <horms@verge.net.au>, Jason Baldus <jason.baldus@gmail.com>,
       Greg KH <gregkh@suse.de>, Scott Smedley <ss@aao.gov.au>,
       Harley Sweeten <hsweeten@visionengravers.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers/staging/dt3155/allocator: sparse cleanups
Date: Mon, 29 Mar 2010 00:34:29 -0700
Message-Id: <a7e5b3c3028eb94b9300605f3822b28bb187a43e.1269847733.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269847733.git.joe@perches.com>
References: <20100329032301.GC27607@verge.net.au> <cover.1269847733.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make prototypes match implementation
Use gfp_t flags not int prio

Still a couple of sparse warnings left

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/dt3155/allocator.c |   15 ++++++++-------
 drivers/staging/dt3155/allocator.h |    4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dt3155/allocator.c b/drivers/staging/dt3155/allocator.c
index c74234c..217ddaa 100644
--- a/drivers/staging/dt3155/allocator.c
+++ b/drivers/staging/dt3155/allocator.c
@@ -58,6 +58,8 @@
 
 #include <asm/page.h>
 
+#include "allocator.h"
+
 /*#define ALL_DEBUG*/
 #define ALL_MSG "allocator: "
 
@@ -83,9 +85,9 @@
 /*#define PDEBUGG(fmt, args...) printk( KERN_DEBUG ALL_MSG fmt, ## args)*/
 
 
-int allocator_himem = 1; /* 0 = probe, pos. = megs, neg. = disable   */
-int allocator_step = 1;  /* This is the step size in MB              */
-int allocator_probe = 1; /* This is a flag -- 1=probe, 0=don't probe */
+static int allocator_himem = 1; /* 0 = probe, pos. = megs, neg. = disable   */
+static int allocator_step = 1;  /* This is the step size in MB              */
+static int allocator_probe = 1; /* This is a flag -- 1=probe, 0=don't probe */
 
 static unsigned long allocator_buffer;		/* physical address */
 static unsigned long allocator_buffer_size;	/* kilobytes */
@@ -101,8 +103,7 @@ struct allocator_struct {
 	struct allocator_struct *next;
 };
 
-struct allocator_struct *allocator_list;
-
+static struct allocator_struct *allocator_list;
 
 #ifdef ALL_DEBUG
 static int dump_list(void)
@@ -124,7 +125,7 @@ static int dump_list(void)
  * be used straight ahead for DMA, but needs remapping for program use).
  */
 
-unsigned long allocator_allocate_dma(unsigned long kilobytes, int prio)
+unsigned long allocator_allocate_dma(unsigned long kilobytes, gfp_t flags)
 {
 	struct allocator_struct *ptr = allocator_list, *newptr;
 	unsigned long bytes = kilobytes << 10;
@@ -147,7 +148,7 @@ unsigned long allocator_allocate_dma(unsigned long kilobytes, int prio)
 		PDEBUG("alloc failed\n");
 		return 0; /* end of list */
 	}
-	newptr = kmalloc(sizeof(struct allocator_struct), prio);
+	newptr = kmalloc(sizeof(struct allocator_struct), flags);
 	if (!newptr)
 		return 0;
 
diff --git a/drivers/staging/dt3155/allocator.h b/drivers/staging/dt3155/allocator.h
index bdf3268..425b70f 100644
--- a/drivers/staging/dt3155/allocator.h
+++ b/drivers/staging/dt3155/allocator.h
@@ -22,7 +22,7 @@
  *
  */
 
-void allocator_free_dma(unsigned long address);
-unsigned long allocator_allocate_dma(unsigned long kilobytes, int priority);
+int allocator_free_dma(unsigned long address);
+unsigned long allocator_allocate_dma(unsigned long kilobytes, gfp_t flags);
 int allocator_init(u32 *);
 void allocator_cleanup(void);
-- 
1.7.0.14.g7e948

