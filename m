Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab0DGEva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 00:51:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34330 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab0DGEvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 00:51:15 -0400
Date: Wed, 7 Apr 2010 14:51:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20100407145113.2f850106.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/gpio/janz-ttl.c: In function 'ttl_probe':
drivers/gpio/janz-ttl.c:158: error: implicit declaration of function 'kzalloc'
drivers/gpio/janz-ttl.c:158: warning: assignment makes pointer from integer without a cast
drivers/gpio/janz-ttl.c:210: error: implicit declaration of function 'kfree'

Caused by commit 989b68d7d885a45099126e32b46304afd9b3789e ("gpio: Add
support for Janz VMOD-TTL Digital IO module") interacting with commit
de380b55f92986c1a84198149cb71b7228d15fbd ("percpu: don't implicitly
include slab.h from percpu.h").

I applied the following fix patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 7 Apr 2010 14:47:52 +1000
Subject: [PATCH] gpio: janz-ttl: using kzalloc/kfree requires including slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpio/janz-ttl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/janz-ttl.c b/drivers/gpio/janz-ttl.c
index d97eeda..813ac07 100644
--- a/drivers/gpio/janz-ttl.c
+++ b/drivers/gpio/janz-ttl.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 
 #include <linux/mfd/janz.h>
 
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
