Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab2CVVST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:18:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2CVVSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:18:16 -0400
Date: Thu, 22 Mar 2012 14:17:56 -0700
From: tip-bot for Gerlando Falauto <gerlando.falauto@keymile.com>
Message-ID: <tip-8c9cf542b8a66c231747a550573d910daf17f0e9@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, gerlando.falauto@keymile.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, gerlando.falauto@keymile.com
In-Reply-To: <1330330101-8618-1-git-send-email-gerlando.falauto@keymile.com>
References: <1330330101-8618-1-git-send-email-gerlando.falauto@keymile.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Do not select FRAME_POINTER on PPC
Git-Commit-ID: 8c9cf542b8a66c231747a550573d910daf17f0e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 22 Mar 2012 14:18:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c9cf542b8a66c231747a550573d910daf17f0e9
Gitweb:     http://git.kernel.org/tip/8c9cf542b8a66c231747a550573d910daf17f0e9
Author:     Gerlando Falauto <gerlando.falauto@keymile.com>
AuthorDate: Mon, 27 Feb 2012 09:08:21 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 27 Feb 2012 08:45:11 -0500

tracing: Do not select FRAME_POINTER on PPC

On PowerPC, FUNCTION_TRACER selects FRAME_POINTER, even
though the architecture does not support it.

This causes the following warning:
warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)

So remove the warning by adding the extra condition
"if !PPC" to FUNCTION_TRACER for FRAME_POINTER selection

Link: http://lkml.kernel.org/r/1330330101-8618-1-git-send-email-gerlando.falauto@keymile.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cd31345..a1d2849 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,7 +141,7 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if !ARM_UNWIND && !S390 && !MICROBLAZE
+	select FRAME_POINTER if !ARM_UNWIND && !PPC && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
