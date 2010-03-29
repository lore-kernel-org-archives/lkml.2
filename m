Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0C2GNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:13:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60453 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0C2GNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:13:47 -0400
Date: Mon, 29 Mar 2010 17:07:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
Subject: linux-next: build failure after merge of the slabh tree
Message-Id: <20100329170727.7a7b9a6d.sfr@canb.auug.org.au>
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

drivers/vbus/bus-proxy.c: In function 'vbus_driver_ioq_release':
drivers/vbus/bus-proxy.c:192: error: implicit declaration of function 'kfree'
drivers/vbus/bus-proxy.c: In function 'vbus_driver_ioq_alloc':
drivers/vbus/bus-proxy.c:210: error: implicit declaration of function 'kzalloc'
drivers/vbus/bus-proxy.c:210: warning: assignment makes pointer from integer without a cast
drivers/vbus/bus-proxy.c:214: warning: assignment makes pointer from integer without a cast

Caused by commit d103d3b3e8512312b5254950035366d4422a479a ("percpu: don't
implicitly include slab.h from percpu.h") from the slabh tree interacting
with commit 5ff775e4c3d6b0ead7d8784797123a2deed73364 ("ioq: add
driver-side vbus helpers") from the alacrity tree.

I applied the following merge fixup patch which should be applied to the
alacrity tree (see Documentation/SubmitChecklist Rule #1 :-)).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Mar 2010 17:03:25 +1100
Subject: [PATCH] vbus: use of kzalloc/kfree requires the include of slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/vbus/bus-proxy.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/vbus/bus-proxy.c b/drivers/vbus/bus-proxy.c
index 4792842..ae11f67 100644
--- a/drivers/vbus/bus-proxy.c
+++ b/drivers/vbus/bus-proxy.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/vbus_driver.h>
 
 MODULE_AUTHOR("Gregory Haskins");
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
