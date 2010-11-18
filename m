Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0KRLPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:15:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:57964 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0KRLO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:14:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,216,1288594800"; 
   d="scan'208";a="678704234"
Date: Thu, 18 Nov 2010 18:28:20 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: torvalds@linux-foundation.org
Cc: arnd@arndb.de, youquan.song@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix build failure at cx25821-video driver 
Message-ID: <20101118232820.GA14509@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel build fail for cx25821-video has depends on smp_lock.h header file, but
the dependency is removed in recent commit 451a3c24b013

This patch recover the dependency

Signed-off-by: Youquan Song <youquan.song@intel.com>
---


diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index acfd017..c940001 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/kdev_t.h>
+#include <linux/smp_lock.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
