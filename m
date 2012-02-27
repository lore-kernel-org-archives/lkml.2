Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2B0IUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:20:15 -0500
Received: from mail.de.keymile.com ([195.8.104.1]:52383 "HELO
	mail.de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752682Ab2B0IUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:20:13 -0500
X-Greylist: delayed 653 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Feb 2012 03:20:13 EST
From: Gerlando Falauto <gerlando.falauto@keymile.com>
To: holger.brunck@keymile.com
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        ---@mailrelay.de.keymile.net, 1.7.1@mailrelay.de.keymile.net
Subject: [PATCH] tracing: don't select FRAME_POINTER on PPC
Date: Mon, 27 Feb 2012 09:08:21 +0100
Message-Id: <1330330101-8618-1-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: git-send-email 1.7.1
X-ESAFE-STATUS: [srvhellgate.de.keymile.net] Mail clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC, FUNCTION_TRACER selects FRAME_POINTER, even
though the architecture does not support it.

This causes the following warning:
warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)

So remove the warning by adding the extra condition
"if !PPC" to FUNCTION_TRACER for FRAME_POINTER selection

Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
---
 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 2ad39e5..fbdec2e 100644
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
-- 
1.7.1

