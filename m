Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0C2GNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:13:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60420 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0C2GNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:13:36 -0400
Date: Mon, 29 Mar 2010 16:02:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IlJpY2hhcmQgUsO2amZvcnMi?= 
	<richard.rojfors@pelagicore.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: linux-next: build failure after merge of the slabh tree
Message-Id: <20100329160251.702d2c60.sfr@canb.auug.org.au>
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

drivers/dma/timb_dma.c: In function 'td_alloc_init_desc':
drivers/dma/timb_dma.c:381: error: implicit declaration of function 'kzalloc'
drivers/dma/timb_dma.c:381: warning: assignment makes pointer from integer without a cast
drivers/dma/timb_dma.c:389: warning: assignment makes pointer from integer without a cast
drivers/dma/timb_dma.c:410: error: implicit declaration of function 'kfree'
drivers/dma/timb_dma.c: In function 'td_probe':
drivers/dma/timb_dma.c:710: warning: assignment makes pointer from integer without a cast

Caused by commit d103d3b3e8512312b5254950035366d4422a479a ("percpu: don't
implicitly include slab.h from percpu.h") from the slabh tree interacting
with commit de5d4453c5b224eefd02b6a141ed411a76d458af ("dma: Add
timb-dma") from the async_tx tree.

I applied the following merge fixup patch which should be applied to the
async_tx tree (see Documentation/SubmitChecklist Rule #1 :-)).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Mar 2010 15:54:40 +1100
Subject: [PATCH] async_tx: use of kzalloc/kfree requires the include of slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/dma/timb_dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index e20d5c1..44b346d 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -27,6 +27,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 
 #include <linux/timb_dma.h>
 
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
