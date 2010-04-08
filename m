Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0DHC5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:57:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54511 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab0DHC5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:57:23 -0400
Date: Thu, 8 Apr 2010 12:57:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Todd Fischer <todd.fischer@ridgerun.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20100408125721.f93c1225.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mfd/tps6507x.c: In function 'tps6507x_i2c_probe':
drivers/mfd/tps6507x.c:90: error: implicit declaration of function 'kzalloc'
drivers/mfd/tps6507x.c:90: warning: assignment makes pointer from integer without a cast
drivers/mfd/tps6507x.c:92: error: implicit declaration of function 'kfree'

Caused by commit 353dd1bf937f319eb6fdf35a461bf0bea1361d23 ("mfd: Add
TPS6507x support").

I applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 8 Apr 2010 12:53:32 +1000
Subject: [PATCH] mfd: TPS6507x: using kzalloc/kfree requires including slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mfd/tps6507x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index dcddef0..d859dff 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6507x.h>
-- 
1.7.0.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
