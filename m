Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab1FHSeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 14:34:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:34491 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab1FHSel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:34:41 -0400
Date: Wed, 8 Jun 2011 18:34:33 GMT
From: tip-bot for GuoWen Li <guowen.li.linux@gmail.com>
Message-ID: <tip-0aff1c0cef13b34c17e81a502336fad738151c37@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, guowen.li.linux@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, guowen.li.linux@gmail.com
In-Reply-To: <201106011918.47939.guowen.li.linux@gmail.com>
References: <201106011918.47939.guowen.li.linux@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ftrace: Fix possible undefined return code
Git-Commit-ID: 0aff1c0cef13b34c17e81a502336fad738151c37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Jun 2011 18:34:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0aff1c0cef13b34c17e81a502336fad738151c37
Gitweb:     http://git.kernel.org/tip/0aff1c0cef13b34c17e81a502336fad738151c37
Author:     GuoWen Li <guowen.li.linux@gmail.com>
AuthorDate: Wed, 1 Jun 2011 19:18:47 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 6 Jun 2011 22:34:25 -0400

ftrace: Fix possible undefined return code

kernel/trace/ftrace.c: In function 'ftrace_regex_write.clone.15':
kernel/trace/ftrace.c:2743:6: warning: 'ret' may be used uninitialized in this
function

Signed-off-by: GuoWen Li <guowen.li.linux@gmail.com>
Link: http://lkml.kernel.org/r/201106011918.47939.guowen.li.linux@gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ee417f..204b3eb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2740,7 +2740,7 @@ static int ftrace_process_regex(struct ftrace_hash *hash,
 {
 	char *func, *command, *next = buff;
 	struct ftrace_func_command *p;
-	int ret;
+	int ret = -EINVAL;
 
 	func = strsep(&next, ":");
 
