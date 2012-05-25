Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab2EYRDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2EYRD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:28 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
        Christoph Lameter <cl@linux.com>
Subject: [PATCH 33/35] autonuma: add CONFIG_AUTONUMA and CONFIG_AUTONUMA_DEFAULT_ENABLED
Date: Fri, 25 May 2012 19:02:37 +0200
Message-Id: <1337965359-29725-34-git-send-email-aarcange@redhat.com>
In-Reply-To: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the config options to allow building the kernel with AutoNUMA.

If CONFIG_AUTONUMA_DEFAULT_ENABLED is "=y", then
/sys/kernel/mm/autonuma/enabled will be equal to 1, and AutoNUMA will
be enabled automatically at boot.

CONFIG_AUTONUMA currently depends on X86, because no other arch
implements the pte/pmd_numa yet and selecting =y would result in a
failed build, but this shall be relaxed in the future. Porting
AutoNUMA to other archs should be pretty simple.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index e338407..cbfdb15 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -207,6 +207,19 @@ config MIGRATION
 	  pages as migration can relocate pages to satisfy a huge page
 	  allocation instead of reclaiming.
 
+config AUTONUMA
+	bool "Auto NUMA"
+	select MIGRATION
+	depends on NUMA && X86
+	help
+	  Automatic NUMA CPU scheduling and memory migration.
+
+config AUTONUMA_DEFAULT_ENABLED
+	bool "Auto NUMA default enabled"
+	depends on AUTONUMA
+	help
+	  Automatic NUMA CPU scheduling and memory migration enabled at boot.
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
