Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab0I1Qsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:48:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36547 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab0I1Qsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:48:53 -0400
Date: Tue, 28 Sep 2010 09:48:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] hwmon/pkgtemp: fix build error
Message-Id: <20100928094821.2ff11701.randy.dunlap@oracle.com>
In-Reply-To: <20100928141823.8c61000e.sfr@canb.auug.org.au>
References: <20100928141823.8c61000e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error and config symbol comment:

drivers/hwmon/pkgtemp.c:413: error:'pkgtemp_cpu_notifier' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/hwmon/pkgtemp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20100928.orig/drivers/hwmon/pkgtemp.c
+++ linux-next-20100928/drivers/hwmon/pkgtemp.c
@@ -386,7 +386,7 @@ static int __cpuinit pkgtemp_cpu_callbac
 static struct notifier_block pkgtemp_cpu_notifier __refdata = {
 	.notifier_call = pkgtemp_cpu_callback,
 };
-#endif				/* !CONFIG_HOTPLUG_CPU */
+#endif				/* CONFIG_HOTPLUG_CPU */
 
 static int __init pkgtemp_init(void)
 {
@@ -408,9 +408,9 @@ static int __init pkgtemp_init(void)
 		err = -ENODEV;
 		goto exit_driver_unreg;
 	}
-#endif
-
+#else
 	register_hotcpu_notifier(&pkgtemp_cpu_notifier);
+#endif
 	return 0;
 
 #ifndef CONFIG_HOTPLUG_CPU
