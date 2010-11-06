Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0KFS0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:26:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41354 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab0KFS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=hzub7bWDnCjWA6nqQavjtiCDFuTsxyPhLmZ+js7YmeAZr9ygOr/azM2A/NX1bqr9IP
         K1lUXv4jJIj6ObSKkH/Ve7k1nTLL0ywcf8gm0mRn9GVB9+mhXJYOgt+uU5ekVpsxQqJ0
         GoXjxDnlGaJlFU6k4h4BiTZ5EfT22wcosobig=
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 6/6] ARM: ftrace: enable function graph tracer
Date: Sat,  6 Nov 2010 23:55:54 +0530
Message-Id: <1289067954-5080-6-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289067954-5080-1-git-send-email-rabin@rab.in>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the options to enable the function graph tracer on ARM.  Function
graph tracer support requires frame pointers, so exclude Thumb-2 and
also explicitly select FRAME_POINTER in FUNCTION_GRAPH_TRACER since
FUNCTION_TRACER doesn't select FRAME_POINTER when ARM_UNWIND is used
Therefore, with GCC 4.4.0+, you get plain function tracing without frame
pointers, but you'll need them if you want function graph tracing.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/Kconfig     |    1 +
 kernel/trace/Kconfig |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a19a526..c5e96ff 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
 	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
+	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e04b8bc..ff23dcf 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,6 +141,7 @@ config FUNCTION_TRACER
 
 config FUNCTION_GRAPH_TRACER
 	bool "Kernel Function Graph Tracer"
+	select FRAME_POINTER if ARM_UNWIND
 	depends on HAVE_FUNCTION_GRAPH_TRACER
 	depends on FUNCTION_TRACER
 	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
-- 
1.7.2.3

