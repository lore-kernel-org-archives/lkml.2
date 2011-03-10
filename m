Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1CJAZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:25:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46614 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1CJAZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:25:51 -0500
Date: Thu, 10 Mar 2011 11:25:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: build failure lin Linus' tree
Message-Id: <20110310112543.5ae7fb7e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

After merging the spi-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

include/linux/sysctl.h:28: included file 'linux/rcupdate.h' is not exported

Caused by commit dfef6dcd35cb ("unf*ck proc_sysctl ->d_compare()").

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 10 Mar 2011 11:14:17 +1100
Subject: [PATCH] sysctl: the include of rcupdate.h is only needed in the kernel

Fixes this built error:

include/linux/sysctl.h:28: included file 'linux/rcupdate.h' is not exported

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/sysctl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index bb7c2b0..11684d9 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -25,7 +25,6 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/rcupdate.h>
 
 struct completion;
 
@@ -931,6 +930,7 @@ enum
 
 #ifdef __KERNEL__
 #include <linux/list.h>
+#include <linux/rcupdate.h>
 
 /* For the /proc/sys support */
 struct ctl_table;
-- 
1.7.4.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
