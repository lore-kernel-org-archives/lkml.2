Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1CHLpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:45:05 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55892 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab1CHLpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:45:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QIU6hSPGc2T3H7Yg5FvY771T2vsQrw3Uf/ZxyMbvXnyxZoPGMnXkaePij1bQDGBJe8
         QqZ+lBc0NxY1murL4Ox7hxHzkl3ngs3nknvGgn/NJLQgI1T/G+Jk9fAjpY8+NyRvmiM8
         Vr20WUFwumIBAnwbNiOu1vAUNAUZSF5RYs4mM=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 -tip 4/4] x86, dumpstack: Use frame pointer during stack trace
Date: Tue,  8 Mar 2011 20:44:22 +0900
Message-Id: <1299584662-24421-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
References: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have CONFIG_FRAME_POINTER=y by default, it would be better
use the frame pointer for the stack backtrace rather than scanning
whole stack blindly.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/kernel/dumpstack.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 38b74a5e59aba..56db27d36858 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -170,7 +170,11 @@ static const struct stacktrace_ops print_trace_ops = {
 	.warning_symbol		= print_trace_warning_symbol,
 	.stack			= print_trace_stack,
 	.address		= print_trace_address,
+#ifdef CONFIG_FRAME_POINTER
+	.walk_stack		= walk_context_stack_bp,
+#else
 	.walk_stack		= walk_context_stack,
+#endif
 };
 
 void
-- 
1.7.4

