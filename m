Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2GJANa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:13:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62482 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab2GJAN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:13:26 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 8/8] tracing/function: Convert func_set_flag() to a switch statement
Date: Mon,  9 Jul 2012 17:10:46 -0700
Message-Id: <1341879046-5197-8-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120710001004.GA22744@lizard>
References: <20120710001004.GA22744@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the function accepts just one bit, we can use the switch
construction instead of if/else if/...

Just a cosmetic change, there should be no functional changes.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 kernel/trace/trace_functions.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 13770ab..a426f41 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -217,10 +217,11 @@ static void tracing_stop_function_trace(void)
 
 static int func_set_flag(u32 old_flags, u32 bit, int set)
 {
-	if (bit == TRACE_FUNC_OPT_STACK) {
+	switch (bit) {
+	case TRACE_FUNC_OPT_STACK:
 		/* do nothing if already set */
 		if (!!set == !!(func_flags.val & TRACE_FUNC_OPT_STACK))
-			return 0;
+			break;
 
 		if (set) {
 			unregister_ftrace_function(&trace_ops);
@@ -230,12 +231,14 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
 			register_ftrace_function(&trace_ops);
 		}
 
-		return 0;
-	} else if (bit == TRACE_FUNC_OPT_PSTORE) {
-		return 0;
+		break;
+	case TRACE_FUNC_OPT_PSTORE:
+		break;
+	default:
+		return -EINVAL;
 	}
 
-	return -EINVAL;
+	return 0;
 }
 
 static struct tracer function_trace __read_mostly =
-- 
1.7.10.4

