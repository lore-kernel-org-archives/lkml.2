Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1A1O7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:59:31 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43878 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab1A1O73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:59:29 -0500
Date: Fri, 28 Jan 2011 08:59:26 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] [v2] zram/xvmalloc: create CONFIG_ZRAM_DEBUG for debug
 code
Message-ID: <20110128145926.GE2062@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110128145602.GA2062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128145602.GA2062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debug config flag to enable debug printk output and future
debug code.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/Kconfig    |    8 ++++++++
 drivers/staging/zram/xvmalloc.c |    4 ++++
 drivers/staging/zram/zram_drv.c |    4 ++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index da079f8..d957747 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -15,3 +15,11 @@ config ZRAM
 
 	  See zram.txt for more information.
 	  Project home: http://compcache.googlecode.com/
+
+config ZRAM_DEBUG
+	bool "Compressed RAM block device debug support"
+	depends on ZRAM
+	default n
+	help
+	  This option adds additional debugging code to the compressed
+	  RAM block device driver.
diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index 149138a..0560e9d 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -10,6 +10,10 @@
  * Released under the terms of GNU General Public License Version 2.0
  */
 
+#ifdef CONFIG_ZRAM_DEBUG
+#define DEBUG
+#endif
+
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/highmem.h>
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d85d034..c67060c 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -15,6 +15,10 @@
 #define KMSG_COMPONENT "zram"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#ifdef CONFIG_ZRAM_DEBUG
+#define DEBUG
+#endif
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/bio.h>
-- 
1.7.0.4

