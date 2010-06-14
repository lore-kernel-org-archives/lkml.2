Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab0FNWWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:22:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48133 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab0FNWVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=TNteOcrR6y+MxeE679CIJkFkxDRfq+pP2Gigg7EdIzA6n/FTC4L5ENL1tKTjvKzG9G
         nrFVbcym3wx2oue3D93MiR/3OS/k21OfL8Bv6KAOyAx/sElD4Sk92w10bhEWu4oFIckk
         JVLJgR7GzCEFGF4x7mYV622461hjnp4j2aFjQ=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/6: v4] lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.
Date: Tue, 15 Jun 2010 00:21:23 +0200
Message-Id: <1276554087-3632-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
References: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain debug configurations that have LOCKDEP turned on, run into the limit
where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply turning
off the locking correctness validator, let the user configure this value
to something reasonable for their system.

This patch was generated against 2.6.33.5-rt23 but is also intended to be
picked-up for mainline.

Message-ID: <alpine.LFD.2.00.1004161329030.11320@localhost.localdomain>
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/lockdep_internals.h |    2 +-
 lib/Kconfig.debug          |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2ee95a..d0797bc 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -65,7 +65,7 @@ enum {
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the hash_lock.
  */
-#define MAX_STACK_TRACE_ENTRIES	262144UL
+#define MAX_STACK_TRACE_ENTRIES	(CONFIG_MAX_STACK_ENTRIES_KIB*1024UL)
 
 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cbf6e02..6087fb0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -509,6 +509,16 @@ config LOCKDEP
 	select KALLSYMS
 	select KALLSYMS_ALL
 
+config MAX_STACK_ENTRIES_KIB
+	int "MAX_STACK_ENTRIES_KIB for LOCKDEP"
+	depends on LOCKDEP
+	default 256
+	help
+	   This option allows you to change the default MAX_STACK_TRACE_ENTRIES
+	   used by LOCKDEP. The default is 256*1024 = 262144.
+	   Warning: increasing this will increase the size of stack_trace_array
+	   and therefore the kernel size too.
+
 config LOCK_STAT
 	bool "Lock usage statistics"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
-- 
1.6.6.1

