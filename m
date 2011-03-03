Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab1CCMmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:42:42 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:52760 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab1CCMmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:42:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VHCrQSnBhp0srTDTK5d/RlgsdZB/MA6/hkcrhbjICT3znk2VtAtdlTgQ3T6uEkbWHg
         hZjBAwQVOPOrVAjFLIUsaPjxFHGm9DEyW0RBQWeme3WXUJjUQHLJ3jX14SHpLCX4pjW7
         cvMrJfbLFbwqGypmpwpc4jS8qfKqIEofO1iJI=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH/RFC -tip 2/2] x86, dumpstack: Use frame pointer during stack trace
Date: Thu,  3 Mar 2011 21:42:29 +0900
Message-Id: <1299156149-10929-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299156149-10929-1-git-send-email-namhyung@gmail.com>
References: <1299156149-10929-1-git-send-email-namhyung@gmail.com>
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
index a613a5f9ee79..6e5674d187d6 100644
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

