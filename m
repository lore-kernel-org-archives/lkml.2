Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2EHETY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:19:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2EHETW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:19:22 -0400
Date: Mon, 7 May 2012 21:19:05 -0700
From: tip-bot for Kyle McMartin <kmcmarti@redhat.com>
Message-ID: <tip-2a01bb3885c9145dbb7583d5aa5f5d5504f6f46f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        kmcmarti@redhat.com, kyle@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        kmcmarti@redhat.com, kyle@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20120411121529.GH26688@redacted.bos.redhat.com>
References: <20120411121529.GH26688@redacted.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debug] panic: Make panic_on_oops configurable
Git-Commit-ID: 2a01bb3885c9145dbb7583d5aa5f5d5504f6f46f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:19:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a01bb3885c9145dbb7583d5aa5f5d5504f6f46f
Gitweb:     http://git.kernel.org/tip/2a01bb3885c9145dbb7583d5aa5f5d5504f6f46f
Author:     Kyle McMartin <kmcmarti@redhat.com>
AuthorDate: Wed, 11 Apr 2012 08:15:29 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 14:45:29 +0200

panic: Make panic_on_oops configurable

Several distros set this by default by patching panic_on_oops.
It seems to fit with the BOOTPARAM_{HARD,SOFT}_PANIC options
though, so let's add a Kconfig entry and reduce some more
upstream delta.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120411121529.GH26688@redacted.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/panic.c    |    2 +-
 lib/Kconfig.debug |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 8ed89a1..b6215b7 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -27,7 +27,7 @@
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
 
-int panic_on_oops;
+int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
 static unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6777153..91858cd 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -228,6 +228,26 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
+config PANIC_ON_OOPS
+	bool "Panic on Oops" if EXPERT
+	default n
+	help
+	  Say Y here to enable the kernel to panic when it oopses. This
+	  has the same effect as setting oops=panic on the kernel command
+	  line.
+
+	  This feature is useful to ensure that the kernel does not do
+	  anything erroneous after an oops which could result in data
+	  corruption or other issues.
+
+	  Say N if unsure.
+
+config PANIC_ON_OOPS_VALUE
+	int
+	range 0 1
+	default 0 if !PANIC_ON_OOPS
+	default 1 if PANIC_ON_OOPS
+
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
