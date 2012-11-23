Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2KWHQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:16:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:63594 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab2KWHQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:16:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,306,1352102400"; 
   d="scan'208";a="171630485"
Message-ID: <50AF2244.7050501@intel.com>
Date: Fri, 23 Nov 2012 15:14:12 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@linuxfoundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: [PATCH] driver core: use initcall_debug to control shutdown info
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

syscore_shutdown uses initcall_debug to control the debug info output.
It’s a good programming. But device_shutdown doesn’t. The patch changes
device_shutdown to follow the style.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
 drivers/base/core.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index abea76c..985f69c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1840,10 +1840,12 @@ void device_shutdown(void)
 		pm_runtime_barrier(dev);
 
 		if (dev->bus && dev->bus->shutdown) {
-			dev_dbg(dev, "shutdown\n");
+			if (initcall_debug)
+				dev_info(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
 		} else if (dev->driver && dev->driver->shutdown) {
-			dev_dbg(dev, "shutdown\n");
+			if (initcall_debug)
+				dev_info(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
 
-- 
1.7.1
