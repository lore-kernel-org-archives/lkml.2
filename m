Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab1D0P6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:58:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:59911 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab1D0P6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:58:04 -0400
Date: Wed, 27 Apr 2011 15:57:47 GMT
From: tip-bot for Michal Simek <monstr@monstr.eu>
Message-ID: <tip-d20ac252821ab9780ddf00b95629547d3cebc857@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, monstr@monstr.eu,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, monstr@monstr.eu, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1301908812-8119-2-git-send-email-monstr@monstr.eu>
References: <1301908812-8119-2-git-send-email-monstr@monstr.eu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ftrace: Build without frame pointers on Microblaze
Git-Commit-ID: d20ac252821ab9780ddf00b95629547d3cebc857
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:57:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d20ac252821ab9780ddf00b95629547d3cebc857
Gitweb:     http://git.kernel.org/tip/d20ac252821ab9780ddf00b95629547d3cebc857
Author:     Michal Simek <monstr@monstr.eu>
AuthorDate: Mon, 4 Apr 2011 11:20:12 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 21 Apr 2011 09:06:24 -0400

ftrace: Build without frame pointers on Microblaze

Microblaze doesn't need/support FRAME_POINTERS in order to have a working
function tracer.

The patch remove Kconfig warning.

Warning log:
warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP &&
FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct
dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 ||
SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)

Signed-off-by: Michal Simek <monstr@monstr.eu>
Link: http://lkml.kernel.org/r/1301908812-8119-2-git-send-email-monstr@monstr.eu
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 61d7d59f..2ad39e5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,7 +141,7 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if !ARM_UNWIND && !S390
+	select FRAME_POINTER if !ARM_UNWIND && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
