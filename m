Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2EUJmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:42:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38967 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab2EUJmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:42:03 -0400
Date: Mon, 21 May 2012 02:41:32 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-b48285980de2070948c8ac73629c605ad9202589@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, dhsharp@google.com,
        namhyung.kim@lge.com, bp@alien8.de, jolsa@redhat.com,
        fweisbec@gmail.com, acme@infradead.org, mrubin@google.com,
        rostedt@goodmis.org, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, dhsharp@google.com, peterz@infradead.org,
        namhyung.kim@lge.com, bp@alien8.de, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, acme@infradead.org,
        mrubin@google.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1310785241-3799-4-git-send-email-vnagarnaik@google.com>
References: <1310785241-3799-4-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] parse-events: Support '+' opcode in print format
Git-Commit-ID: b48285980de2070948c8ac73629c605ad9202589
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:41:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b48285980de2070948c8ac73629c605ad9202589
Gitweb:     http://git.kernel.org/tip/b48285980de2070948c8ac73629c605ad9202589
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Fri, 6 Apr 2012 00:48:03 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 25 Apr 2012 13:35:38 +0200

parse-events: Support '+' opcode in print format

The '+' opcode is not supported in the arguments for the print format.
This patch adds support for it.

Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Link: http://lkml.kernel.org/r/1310785241-3799-4-git-send-email-vnagarnaik@google.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/lib/traceevent/event-parse.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 4d5092f..476626a 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2047,6 +2047,18 @@ static int arg_num_eval(struct print_arg *arg, long long *val)
 				break;
 			*val = left - right;
 			break;
+		case '+':
+			if (arg->op.left->type == PRINT_NULL)
+				left = 0;
+			else
+				ret = arg_num_eval(arg->op.left, &left);
+			if (!ret)
+				break;
+			ret = arg_num_eval(arg->op.right, &right);
+			if (!ret)
+				break;
+			*val = left + right;
+			break;
 		default:
 			do_warning("unknown op '%s'", arg->op.op);
 			ret = 0;
