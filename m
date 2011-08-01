Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1HAD6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 23:58:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36090 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1HAD61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 23:58:27 -0400
Date: Mon, 1 Aug 2011 13:58:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Donggeun Kim <dg77.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        KyungMin Park <kyungmin.park@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110801135822.c5514475f2c76a05788c7505@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

[I reported this on Friday, but this time I have a patch.]

After merging the moduleh tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/power/max8997_charger.c:185:12: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/power/max8997_charger.c:204:20: error: expected declaration specifiers or '...' before string constant
drivers/power/max8997_charger.c:204:1: warning: data definition has no type or storage class
drivers/power/max8997_charger.c:204:1: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/power/max8997_charger.c:204:20: warning: function declaration isn't a prototype
drivers/power/max8997_charger.c:205:15: error: expected declaration specifiers or '...' before string constant
drivers/power/max8997_charger.c:205:1: warning: data definition has no type or storage class
drivers/power/max8997_charger.c:205:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/power/max8997_charger.c:205:15: warning: function declaration isn't a prototype
drivers/power/max8997_charger.c:206:16: error: expected declaration specifiers or '...' before string constant
drivers/power/max8997_charger.c:206:1: warning: data definition has no type or storage class
drivers/power/max8997_charger.c:206:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/power/max8997_charger.c:206:16: warning: function declaration isn't a prototype

Caused by commit 149c077b4bd7 ("power_supply: Add charger driver for
MAX8997/8966") interacting with the modules.h split.

I have applied the following patch for today.  This file is now upstream,
so this patch could be applied to Linus' tree (or the battery tree where
this commit originated).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Aug 2011 13:51:35 +1000
Subject: [PATCH] power_supply: max8997_charger.c need to include module.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/power/max8997_charger.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index 7106b49..b093af9 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
+#include <linux/module.h>
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
 
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
