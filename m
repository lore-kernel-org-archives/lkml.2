Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2G0STV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:19:21 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43975 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab2G0STG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:19:06 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 3/4] drivers: add memory management driver class
Date: Fri, 27 Jul 2012 13:18:36 -0500
Message-Id: <1343413117-1989-4-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072718-5112-0000-0000-00000A763989
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset creates a new driver class under drivers/ for
memory management related drivers, like zcache.

This driver class would be for drivers that don't actually enabled
a hardware device, but rather augment the memory manager in some
way.

In-tree candidates for this driver class are zcache, zram, and
lowmemorykiller, both in staging.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/Kconfig    |    2 ++
 drivers/Makefile   |    1 +
 drivers/mm/Kconfig |    3 +++
 3 files changed, 6 insertions(+)
 create mode 100644 drivers/mm/Kconfig

diff --git a/drivers/Kconfig b/drivers/Kconfig
index ece958d..67fe7bd 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -152,4 +152,6 @@ source "drivers/vme/Kconfig"
 
 source "drivers/pwm/Kconfig"
 
+source "drivers/mm/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 5b42184..121742e 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -139,3 +139,4 @@ obj-$(CONFIG_EXTCON)		+= extcon/
 obj-$(CONFIG_MEMORY)		+= memory/
 obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_VME_BUS)		+= vme/
+obj-$(CONFIG_MM_DRIVERS)	+= mm/
diff --git a/drivers/mm/Kconfig b/drivers/mm/Kconfig
new file mode 100644
index 0000000..e5b3743
--- /dev/null
+++ b/drivers/mm/Kconfig
@@ -0,0 +1,3 @@
+menu "Memory management drivers"
+
+endmenu
-- 
1.7.9.5

