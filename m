Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab2HZFU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 01:20:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2HZFU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 01:20:28 -0400
From: Huang Shijie <shijie8@gmail.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        dedekind1@gmail.com, shmulik.ladkani@gmail.com,
        Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 1/3] mtd: cmdlinepart: make the partitions rule more strict
Date: Sun, 26 Aug 2012 13:21:38 -0400
Message-Id: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are typically two types to set the mtd partitions:

<1> set with the `size`, such as
    gpmi-nand:100m(boot),100m(kernel),1g(rootfs)

<2> set with the `offset`, such as
    gpmi-nand:100m@0(boot),100m@100m(kernel),1g@200m(rootfs)
    gpmi-nand:1g@200m(rootfs),100m@0(boot),100m@100m(kernel)

If we mix these two types, such as:
     gpmi-nand:100m@0(boot),100m(kernel),1g@200m(rootfs)
     gpmi-nand:1g@200m(rootfs),100m@0(boot),100m(kernel)

It's hard to understand the cmdline. And also it is hard to sort the
partitions in this mixed type. So we explicitly forbid the mixed type.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/mtd/cmdlinepart.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index fe7e3a5..0b7b2ad 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -35,6 +35,15 @@
  *
  * 1 NOR Flash with 2 partitions, 1 NAND with one
  * edb7312-nor:256k(ARMboot)ro,-(root);edb7312-nand:-(home)
+ *
+ * Note:
+ * If you choose to set the @offset for the <partdef>, please set all
+ * the partitions with the same syntax, such as:
+ *     gpmi-nand:100m@0(boot),100m@100m(kernel),1g@200m(rootfs)
+ *
+ * Please do _NOT_ set the partitions like this:
+ *     gpmi-nand:100m@0(boot),100m(kernel),1g@200m(rootfs)
+ * The `kernel` partition does not set with the @offset, this is not permitted.
  */
 
 #include <linux/kernel.h>
-- 
1.7.4.4

