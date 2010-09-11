Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0IKXAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 19:00:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24269 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab0IKXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 19:00:06 -0400
Date: Sat, 11 Sep 2010 15:57:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Subject: [PATCH] PM_SLEEP_SMP: fix kconfig warning
Message-Id: <20100911155720.c4fe6b4b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig unmet dependency warning:

warning: (PM_SLEEP_SMP && SMP && (ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE) && PM_SLEEP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && HOTPLUG)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/power/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100908.orig/kernel/power/Kconfig
+++ linux-next-20100908/kernel/power/Kconfig
@@ -83,7 +83,7 @@ config PM_TRACE_RTC
 
 config PM_SLEEP_SMP
 	bool
-	depends on SMP
+	depends on SMP && HOTPLUG
 	depends on ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
 	depends on PM_SLEEP
 	select HOTPLUG_CPU
