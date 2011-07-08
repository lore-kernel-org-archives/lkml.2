Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1GHVdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:33:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:38264 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab1GHVdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:33:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,500,1304319600"; 
   d="scan'208";a="24639268"
From: james_p_freyensee@linux.intel.com
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        sfr@canb.auug.org.au, christophe.guerard@intel.com,
        pranav.k.sanghadia@intel.com, geert@linux-m68k.org
Subject: [PATCH] PTI implicit declaration fix.
Date: Fri,  8 Jul 2011 14:34:11 -0700
Message-Id: <1310160851-26415-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

In a certain compile configuration, functions like
'kmalloc' and 'copy_from_user' were coming up as
implicit errors.  This patch adds slab.h and
uaccess.h to the driver.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 8653bd0..4ba4e5f 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -22,6 +22,8 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/console.h>
-- 
1.7.0.4

