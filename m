Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844Ab0HLTb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:31:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64510 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0HLTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:31:53 -0400
Date: Thu, 12 Aug 2010 12:31:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -next] latencytop: fix kconfig dependency warnings
Message-Id: <20100812123121.a7c99cde.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

warning: (LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects SCHED_DEBUG which has unmet direct dependencies (DEBUG_KERNEL && PROC_FS)
warning: (LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects SCHEDSTATS which has unmet direct dependencies (DEBUG_KERNEL && PROC_FS)

Add depends on STACKTRACE_SUPPORT for 'select STACKTRACE'.
Add depends on PROC_FS since that is where the output goes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-next-20100810.orig/lib/Kconfig.debug
+++ linux-next-20100810/lib/Kconfig.debug
@@ -1004,13 +1004,16 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 
 config LATENCYTOP
 	bool "Latency measuring infrastructure"
+	depends on HAVE_LATENCYTOP_SUPPORT
+	depends on DEBUG_KERNEL
+	depends on STACKTRACE_SUPPORT
+	depends on PROC_FS
 	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
 	select SCHEDSTATS
 	select SCHED_DEBUG
-	depends on HAVE_LATENCYTOP_SUPPORT
 	help
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
