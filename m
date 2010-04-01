Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0DAFlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 01:41:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47487 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab0DAFlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 01:41:14 -0400
Date: Thu, 1 Apr 2010 16:41:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sjur Braendeland <sjur.brandeland@stericsson.com>,
       David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: build failure after merge of the slabh tree
Message-Id: <20100401164110.80e3b18f.sfr@canb.auug.org.au>
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

net/caif/cfcnfg.c: In function 'cfcnfg_create':
net/caif/cfcnfg.c:68: error: implicit declaration of function 'kmalloc'
net/caif/cfcnfg.c:68: warning: assignment makes pointer from integer without a cast
net/caif/cfcnfg.c:100: error: implicit declaration of function 'kfree'

Caused by commit 15c9ac0c80e390df09ce5730a7b08b13e07a8dd5 ("net-caif: add
CAIF generic caif support functions") from the net interacting with
commit de380b55f92986c1a84198149cb71b7228d15fbd ("percpu: don't
implicitly include slab.h from percpu.h") from the slabh tree.

I have applied the following patch for today.  Dave, could you apply this
to the net tree please?

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 1 Apr 2010 16:31:50 +1100
Subject: [PATCH] net-caif: using kmalloc/kfree requires the include of slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/caif/cfcnfg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/caif/cfcnfg.c b/net/caif/cfcnfg.c
index 70a733d..c873e3d 100644
--- a/net/caif/cfcnfg.c
+++ b/net/caif/cfcnfg.c
@@ -5,6 +5,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/stddef.h>
+#include <linux/slab.h>
 #include <net/caif/caif_layer.h>
 #include <net/caif/cfpkt.h>
 #include <net/caif/cfcnfg.h>
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
