Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2B0XIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:08:40 -0500
Received: from mail.windriver.com ([147.11.1.11]:45839 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2B0XIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:08:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: tony.luck@intel.com, jes@trained-monkey.org, fenghua.yu@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] ia64: fix a couple of warnings for EXPORT_SYMBOL
Date: Mon, 27 Feb 2012 18:08:25 -0500
Message-Id: <1330384105-27794-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get rid of things like:

arch/ia64/sn/kernel/sn2/sn_hwperf.c:1002:1: warning: data definition has no type or storage class
arch/ia64/sn/kernel/sn2/sn_hwperf.c:1002:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/ia64/sn/kernel/sn2/sn_hwperf.c:1002:1: warning: parameter names (without types) in function declaration

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[I can carry this patch if required, but it is 100% independent and
 can go in via the ia64 maintainers.  Let me know which is best. ]

diff --git a/arch/ia64/sn/kernel/io_common.c b/arch/ia64/sn/kernel/io_common.c
index 4433dd0..fbb5f2f 100644
--- a/arch/ia64/sn/kernel/io_common.c
+++ b/arch/ia64/sn/kernel/io_common.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bootmem.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <asm/sn/types.h>
 #include <asm/sn/addrs.h>
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index 2de41d4..4554f68 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -25,6 +25,7 @@
 
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/export.h>
 #include <linux/vmalloc.h>
 #include <linux/seq_file.h>
 #include <linux/miscdevice.h>
-- 
1.7.9.1

