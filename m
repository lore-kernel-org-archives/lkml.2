Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1G2GYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:24:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38441 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab1G2GYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:24:21 -0400
Date: Fri, 29 Jul 2011 16:24:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729162418.b3154ff2b25de69a55c22329@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (powerpc
allnoconfig) failed like this:

kernel/ksysfs.c:161:11: error: 'S_IRUGO' undeclared here (not in a function)

Caused by commit d03b684f1773 ("kernel: Map most files to use export.h
instead of module.h").

I added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 16:21:37 +1000
Subject: [PATCH] ksysfs: include stat.h for S_IRUGO

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/ksysfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 6771de3..ece4547 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -17,6 +17,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/capability.h>
+#include <linux/stat.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
