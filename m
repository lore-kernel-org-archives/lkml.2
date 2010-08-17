Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0HQHzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:55:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:47074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab0HQHzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:55:17 -0400
Date: Tue, 17 Aug 2010 07:54:47 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, tglx@linutronix.de, randy.dunlap@oracle.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, tglx@linutronix.de, randy.dunlap@oracle.com,
        mingo@elte.hu
In-Reply-To: <20100812123121.a7c99cde.randy.dunlap@oracle.com>
References: <20100812123121.a7c99cde.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] latencytop: Fix kconfig dependency warnings
Message-ID: <tip-625fdcaa6d2a3db6a922bbd833450424e906111c@git.kernel.org>
Git-Commit-ID: 625fdcaa6d2a3db6a922bbd833450424e906111c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 07:54:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  625fdcaa6d2a3db6a922bbd833450424e906111c
Gitweb:     http://git.kernel.org/tip/625fdcaa6d2a3db6a922bbd833450424e906111c
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Thu, 12 Aug 2010 12:31:21 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Aug 2010 09:09:03 +0200

latencytop: Fix kconfig dependency warnings

warning: (LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects
SCHED_DEBUG which has unmet direct dependencies (DEBUG_KERNEL &&
PROC_FS) warning: (LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects
SCHEDSTATS which has unmet direct dependencies (DEBUG_KERNEL && PROC_FS)

Add depends on STACKTRACE_SUPPORT for 'select STACKTRACE'.
Add depends on PROC_FS since that is where the output goes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20100812123121.a7c99cde.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9e06b7f..1b4afd2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -994,13 +994,16 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 
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
