Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2BVQFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:05:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50977 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2BVQF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:05:28 -0500
Date: Wed, 22 Feb 2012 08:04:06 -0800
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-biuyhhwohxgbp2vzbap5yr8o@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jkenisto@us.ibm.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkenisto@us.ibm.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        srikar@linux.vnet.ibm.com, oleg@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/uprobes] uprobes: Move to kernel/events/
Git-Commit-ID: a5f4374a9610fd7286c2164d4e680436727eff71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:04:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5f4374a9610fd7286c2164d4e680436727eff71
Gitweb:     http://git.kernel.org/tip/a5f4374a9610fd7286c2164d4e680436727eff71
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 22 Feb 2012 11:01:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 11:08:00 +0100

uprobes: Move to kernel/events/

Consolidate the uprobes code under kernel/events/, where the various
core kernel event handling routines live.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Anton Arapov <anton@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Link: http://lkml.kernel.org/n/tip-biuyhhwohxgbp2vzbap5yr8o@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/Kconfig                  |    2 +-
 kernel/Makefile               |    1 -
 kernel/events/Makefile        |    3 +++
 kernel/{ => events}/uprobes.c |    0
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index cca5b54..d0e37c9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -67,7 +67,7 @@ config OPTPROBES
 
 config UPROBES
 	bool "Transparent user-space probes (EXPERIMENTAL)"
-	depends on ARCH_SUPPORTS_UPROBES
+	depends on ARCH_SUPPORTS_UPROBES && PERF_EVENTS
 	default n
 	help
 	  Uprobes is the user-space counterpart to kprobes: they
diff --git a/kernel/Makefile b/kernel/Makefile
index 8609dd3..2d9de86 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -107,7 +107,6 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
-obj-$(CONFIG_UPROBES) += uprobes.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 22d901f..103f5d1 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -3,4 +3,7 @@ CFLAGS_REMOVE_core.o = -pg
 endif
 
 obj-y := core.o ring_buffer.o callchain.o
+
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
+obj-$(CONFIG_UPROBES) += uprobes.o
+
diff --git a/kernel/uprobes.c b/kernel/events/uprobes.c
similarity index 100%
rename from kernel/uprobes.c
rename to kernel/events/uprobes.c
