Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1HRFJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 01:09:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35370 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1HRFJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 01:09:54 -0400
Date: Thu, 18 Aug 2011 15:09:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: build warning after merge of the moduleh tree
Message-Id: <20110818150945.b429ef302fd45a6a309b52d4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/base/power/common.c:51:1: warning: data definition has no type or storage class
drivers/base/power/common.c:51:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/base/power/common.c:51:1: warning: parameter names (without types) in function declaration
drivers/base/power/common.c:85:1: warning: data definition has no type or storage class
drivers/base/power/common.c:85:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/base/power/common.c:85:1: warning: parameter names (without types) in function declaration

Caused by the interaction of the module.h split up with commit
616d5814c605 ("PM: Reference counting of power.subsys_data") from the pm
tree.

I added this patch for today (Rafael, in your tree this needs to include
module.h) and will carry it as necessary:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 18 Aug 2011 15:06:10 +1000
Subject: [PATCH] PM: EXPORT_SYMBOL needs export.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/power/common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/common.c b/drivers/base/power/common.c
index 1f58cf0..5b86d84 100644
--- a/drivers/base/power/common.c
+++ b/drivers/base/power/common.c
@@ -8,6 +8,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/pm_clock.h>
 
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
