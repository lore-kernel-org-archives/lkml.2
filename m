Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab2HVPCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:02:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab2HVPBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:01:31 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 27/36] autonuma: add CONFIG_AUTONUMA and CONFIG_AUTONUMA_DEFAULT_ENABLED
Date: Wed, 22 Aug 2012 16:59:11 +0200
Message-Id: <1345647560-30387-28-git-send-email-aarcange@redhat.com>
In-Reply-To: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the config options to allow building the kernel with AutoNUMA.

If CONFIG_AUTONUMA_DEFAULT_ENABLED is "=y", then
/sys/kernel/mm/autonuma/enabled will be equal to 1, and AutoNUMA will
be enabled automatically at boot.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/Kconfig     |    3 +++
 arch/x86/Kconfig |    1 +
 mm/Kconfig       |   17 +++++++++++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 72f2fa1..ee3ed89 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -281,4 +281,7 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_ARCH_AUTONUMA
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..4cbdfce 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -97,6 +97,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_ARCH_AUTONUMA
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
diff --git a/mm/Kconfig b/mm/Kconfig
index d5c8019..f00a0cd 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -211,6 +211,23 @@ config MIGRATION
 	  pages as migration can relocate pages to satisfy a huge page
 	  allocation instead of reclaiming.
 
+config AUTONUMA
+	bool "AutoNUMA"
+	select MIGRATION
+	depends on NUMA && HAVE_ARCH_AUTONUMA
+	help
+	  Automatic NUMA CPU scheduling and memory migration.
+
+	  Avoids the administrator to manually setup hard NUMA
+	  bindings in order to achieve optimal performance on NUMA
+	  hardware.
+
+config AUTONUMA_DEFAULT_ENABLED
+	bool "Auto NUMA default enabled"
+	depends on AUTONUMA
+	help
+	  Automatic NUMA CPU scheduling and memory migration enabled at boot.
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
