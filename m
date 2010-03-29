Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0C2GOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:14:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60448 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab0C2GNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:13:44 -0400
Date: Mon, 29 Mar 2010 16:53:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: linux-next: build failure after merge of the slabh tree
Message-Id: <20100329165313.1e096e03.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

After merging the slabh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/mtd/sm_ftl.c: In function 'sm_create_sysfs_attributes':
drivers/mtd/sm_ftl.c:65: error: implicit declaration of function 'kmalloc'
drivers/mtd/sm_ftl.c:65: warning: initialization makes pointer from integer without a cast
drivers/mtd/sm_ftl.c:71: error: implicit declaration of function 'kzalloc'
drivers/mtd/sm_ftl.c:71: warning: assignment makes pointer from integer without a cast
drivers/mtd/sm_ftl.c:84: warning: assignment makes pointer from integer without a cast
drivers/mtd/sm_ftl.c:88: warning: assignment makes pointer from integer without a cast
drivers/mtd/sm_ftl.c: In function 'sm_delete_sysfs_attributes':
drivers/mtd/sm_ftl.c:107: error: implicit declaration of function 'kfree'
drivers/mtd/sm_ftl.c: In function 'sm_init_zone':
drivers/mtd/sm_ftl.c:757: warning: assignment makes pointer from integer without a cast
drivers/mtd/sm_ftl.c: In function 'sm_add_mtd':
drivers/mtd/sm_ftl.c:1123: warning: assignment makes pointer from integer without a cast
drivers/mtd/sm_ftl.c:1141: warning: assignment makes pointer from integer without a cast
drivers/mtd/sm_ftl.c:1147: warning: assignment makes pointer from integer without a cast
drivers/mtd/sm_ftl.c:1152: warning: assignment makes pointer from integer without a cast
drivers/mtd/sm_ftl.c:1161: warning: assignment makes pointer from integer without a cast

Caused by commit d103d3b3e8512312b5254950035366d4422a479a ("percpu: don't
implicitly include slab.h from percpu.h") from the slabh tree interacting
with commit 7d17c02a01a111f40986859f044c8c4cce8a4aa6 ("mtd: Add new
SmartMedia/xD FTL") from the mtd tree.

I applied the following merge fixup patch which should be applied to the
mtd tree (see Documentation/SubmitChecklist Rule #1 :-)).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Mar 2010 16:51:20 +1100
Subject: [PATCH] mtd: SmartMedia/xD FTL: use of kmalloc/kfree requires the include of slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mtd/sm_ftl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
index a9b4e34..4c21589 100644
--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -15,6 +15,7 @@
 #include <linux/freezer.h>
 #include <linux/sysfs.h>
 #include <linux/bitops.h>
+#include <linux/slab.h>
 #include <linux/mtd/nand_ecc.h>
 #include "nand/sm_common.h"
 #include "sm_ftl.h"
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
