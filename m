Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2KNGmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:42:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43222 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2KNGmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:42:03 -0500
Date: Tue, 13 Nov 2012 22:41:44 -0800
From: tip-bot for Daniel Walter <sahne@0x90.at>
Message-ID: <tip-bcd83ea6cbfee54e33d1527b87538dc99ca2137b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, sahne@0x90.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, sahne@0x90.at, tglx@linutronix.de
In-Reply-To: <20120926200838.GC1244@0x90.at>
References: <20120926200838.GC1244@0x90.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Replace strict_strto* with kstrto*
Git-Commit-ID: bcd83ea6cbfee54e33d1527b87538dc99ca2137b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:41:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcd83ea6cbfee54e33d1527b87538dc99ca2137b
Gitweb:     http://git.kernel.org/tip/bcd83ea6cbfee54e33d1527b87538dc99ca2137b
Author:     Daniel Walter <sahne@0x90.at>
AuthorDate: Wed, 26 Sep 2012 22:08:38 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 31 Oct 2012 16:45:23 -0400

tracing: Replace strict_strto* with kstrto*

 * remove old string conversions with kstrto*

Link: http://lkml.kernel.org/r/20120926200838.GC1244@0x90.at

Signed-off-by: Daniel Walter <sahne@0x90.at>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c              |    2 +-
 kernel/trace/trace.c               |    2 +-
 kernel/trace/trace_events_filter.c |    4 ++--
 kernel/trace/trace_functions.c     |    2 +-
 kernel/trace/trace_kprobe.c        |    2 +-
 kernel/trace/trace_probe.c         |   14 +++++++-------
 kernel/trace/trace_uprobe.c        |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9dcf15d..60ad606 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4381,7 +4381,7 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 	if (strlen(tmp) == 0)
 		return 1;
 
-	ret = strict_strtol(tmp, 10, &val);
+	ret = kstrtol(tmp, 10, &val);
 	if (ret < 0)
 		return ret;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 31e4f55..f6928ed 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -431,7 +431,7 @@ static int __init set_tracing_thresh(char *str)
 
 	if (!str)
 		return 0;
-	ret = strict_strtoul(str, 0, &threshold);
+	ret = kstrtoul(str, 0, &threshold);
 	if (ret < 0)
 		return 0;
 	tracing_thresh = threshold * 1000;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c154797..e5b0ca8 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1000,9 +1000,9 @@ static int init_pred(struct filter_parse_state *ps,
 		}
 	} else {
 		if (field->is_signed)
-			ret = strict_strtoll(pred->regex.pattern, 0, &val);
+			ret = kstrtoll(pred->regex.pattern, 0, &val);
 		else
-			ret = strict_strtoull(pred->regex.pattern, 0, &val);
+			ret = kstrtoull(pred->regex.pattern, 0, &val);
 		if (ret) {
 			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
 			return -EINVAL;
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 507a7a9..618dcf8 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -366,7 +366,7 @@ ftrace_trace_onoff_callback(struct ftrace_hash *hash,
 	 * We use the callback data field (which is a pointer)
 	 * as our counter.
 	 */
-	ret = strict_strtoul(number, 0, (unsigned long *)&count);
+	ret = kstrtoul(number, 0, (unsigned long *)&count);
 	if (ret)
 		return ret;
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1a21170..5a3c533 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -444,7 +444,7 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 		/* an address specified */
-		ret = strict_strtoul(&argv[1][0], 0, (unsigned long *)&addr);
+		ret = kstrtoul(&argv[1][0], 0, (unsigned long *)&addr);
 		if (ret) {
 			pr_info("Failed to parse address.\n");
 			return ret;
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index daa9980..412e959 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -441,7 +441,7 @@ static const struct fetch_type *find_fetch_type(const char *type)
 			goto fail;
 
 		type++;
-		if (strict_strtoul(type, 0, &bs))
+		if (kstrtoul(type, 0, &bs))
 			goto fail;
 
 		switch (bs) {
@@ -501,8 +501,8 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 
 	tmp = strchr(symbol, '+');
 	if (tmp) {
-		/* skip sign because strict_strtol doesn't accept '+' */
-		ret = strict_strtoul(tmp + 1, 0, offset);
+		/* skip sign because kstrtoul doesn't accept '+' */
+		ret = kstrtoul(tmp + 1, 0, offset);
 		if (ret)
 			return ret;
 
@@ -533,7 +533,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			else
 				ret = -EINVAL;
 		} else if (isdigit(arg[5])) {
-			ret = strict_strtoul(arg + 5, 10, &param);
+			ret = kstrtoul(arg + 5, 10, &param);
 			if (ret || param > PARAM_MAX_STACK)
 				ret = -EINVAL;
 			else {
@@ -579,7 +579,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 
 	case '@':	/* memory or symbol */
 		if (isdigit(arg[1])) {
-			ret = strict_strtoul(arg + 1, 0, &param);
+			ret = kstrtoul(arg + 1, 0, &param);
 			if (ret)
 				break;
 
@@ -597,14 +597,14 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		break;
 
 	case '+':	/* deref memory */
-		arg++;	/* Skip '+', because strict_strtol() rejects it. */
+		arg++;	/* Skip '+', because kstrtol() rejects it. */
 	case '-':
 		tmp = strchr(arg, '(');
 		if (!tmp)
 			break;
 
 		*tmp = '\0';
-		ret = strict_strtol(arg, 0, &offset);
+		ret = kstrtol(arg, 0, &offset);
 
 		if (ret)
 			break;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..4ff9ca4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -252,7 +252,7 @@ static int create_trace_uprobe(int argc, char **argv)
 	if (ret)
 		goto fail_address_parse;
 
-	ret = strict_strtoul(arg, 0, &offset);
+	ret = kstrtoul(arg, 0, &offset);
 	if (ret)
 		goto fail_address_parse;
 
