Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1CJW0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:26:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:60996 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab1CJW0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:26:24 -0500
Date: Thu, 10 Mar 2011 22:26:07 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, namhyung@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1299584662-24421-4-git-send-email-namhyung@gmail.com>
References: <1299584662-24421-4-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, dumpstack: Use frame pointer during stack trace
Message-ID: <tip-2f8058ae197236f9d5641850ce27f67d8f3e0b39@git.kernel.org>
Git-Commit-ID: 2f8058ae197236f9d5641850ce27f67d8f3e0b39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Mar 2011 22:26:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f8058ae197236f9d5641850ce27f67d8f3e0b39
Gitweb:     http://git.kernel.org/tip/2f8058ae197236f9d5641850ce27f67d8f3e0b39
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 8 Mar 2011 20:44:22 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Mar 2011 23:20:30 +0100

x86, dumpstack: Use frame pointer during stack trace

If CONFIG_FRAME_POINTER is set then use the frame pointer for the
stack backtrace rather than scanning whole stack blindly.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1299584662-24421-4-git-send-email-namhyung@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/dumpstack.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 38b74a5e..56db27d 100644
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
