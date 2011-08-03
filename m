Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1HCEKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 00:10:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34154 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1HCEKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 00:10:18 -0400
Date: Wed, 3 Aug 2011 14:10:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110803141013.2ca5285e5b13a837fcf2c763@canb.auug.org.au>
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

drivers/md/persistent-data/dm-transaction-manager.c:137:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-transaction-manager.c:137:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-transaction-manager.c:137:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-transaction-manager.c:143:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-transaction-manager.c:143:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-transaction-manager.c:143:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-transaction-manager.c:158:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-transaction-manager.c:158:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-transaction-manager.c:158:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-transaction-manager.c:169:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-transaction-manager.c:169:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-transaction-manager.c:169:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-transaction-manager.c:292:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-transaction-manager.c:292:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-transaction-manager.c:292:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-transaction-manager.c:303:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-transaction-manager.c:303:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-transaction-manager.c:303:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-transaction-manager.c:402:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-transaction-manager.c:402:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-transaction-manager.c:402:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-transaction-manager.c:413:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-transaction-manager.c:413:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-transaction-manager.c:413:1: warning: parameter names (without types) in function declaration

Caused by an interaction between the module.h split and commit
90616764c64f ("The persistent-data library offers a re-usable framework
for the storage").

I have applied the below patch for today.  This file should really have
included module.h anyway ...

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 3 Aug 2011 14:06:38 +1000
Subject: [PATCH] dm: dm-transaction-manager.c needs export.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 .../md/persistent-data/dm-transaction-manager.c    |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 4284921..bf9b61b 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -10,6 +10,7 @@
 #include "dm-persistent-data-internal.h"
 
 #include <linux/slab.h>
+#include <linux/export.h>
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "transaction manager"
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
