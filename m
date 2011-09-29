Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1I2Gkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 02:40:31 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:52333 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1I2Gka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 02:40:30 -0400
Date: Thu, 29 Sep 2011 16:40:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (moduleh
 tree related)
Message-Id: <20110929164028.912fba5b3fd2c4d12663de04@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/cxt1e1/linux.c:113:32: error: expected ')' before 'int'
drivers/staging/cxt1e1/linux.c:117:30: error: expected ')' before 'int'
drivers/staging/cxt1e1/linux.c:121:30: error: expected ')' before 'int'
drivers/staging/cxt1e1/linux.c:125:31: error: expected ')' before 'int'
drivers/staging/cxt1e1/linux.c:129:31: error: expected ')' before 'int'

Caused by the module split.  The fix in the moduleh tree (commit
6eee8b750254 ("staging: Add module.h to more drivers implicitly using
i")) is incorrect in that module.h has been included too late.

I have applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 Sep 2011 16:36:21 +1000
Subject: [PATCH] staging: move the module.h include in cxt1e1/linux.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/cxt1e1/linux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index e7029af..6e574fe 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -15,6 +15,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/types.h>
+#include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/hdlc.h>
 #include <linux/if_arp.h>
@@ -163,7 +164,6 @@ mkret (int bsd)
 
 /***************************************************************************/
 #include <linux/workqueue.h>
-#include <linux/module.h>
 
 /***
  * One workqueue (wq) per port (since musycc allows simultaneous group
-- 
1.7.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
