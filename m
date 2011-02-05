Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab1BEObf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:31:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1BEOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pAyOKJgSngyLJ06EnqizR0kq48iu/48zLK8Nwlaz90x7PKr3ECZNE2v0Bow5tlwGpb
         FYsQn/CD2wtBJXcTRZEbsEeXpQ+7ubKBF3TsQrD2uv1IwdvfNWuZfFGeOnfv/opIks4x
         9oVFPP9dNdA2ohEUOg7P6xIEEbZnUmTPudJZQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 03/52] kstrtox: convert kernel/trace/
Date: Sat,  5 Feb 2011 16:20:06 +0200
Message-Id: <1296915654-7458-3-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 kernel/trace/ftrace.c              |    6 +++---
 kernel/trace/ring_buffer.c         |    2 +-
 kernel/trace/trace.c               |   16 ++++++++--------
 kernel/trace/trace_events.c        |    8 ++++----
 kernel/trace/trace_events_filter.c |    4 ++--
 kernel/trace/trace_functions.c     |    4 ++--
 kernel/trace/trace_kprobe.c        |   25 ++++++++++++-------------
 kernel/trace/trace_stack.c         |    4 ++--
 8 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f3dadae..537fd31 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -747,7 +747,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 
 	buf[cnt] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
@@ -3053,7 +3053,7 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	char buf[64], *tmp;
-	long val;
+	int val;
 	int ret;
 
 	if (cnt >= sizeof(buf))
@@ -3072,7 +3072,7 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 	if (strlen(tmp) == 0)
 		return 1;
 
-	ret = strict_strtol(tmp, 10, &val);
+	ret = kstrtoint(tmp, 10, &val);
 	if (ret < 0)
 		return ret;
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bd1c35a..82ca69e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3972,7 +3972,7 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 
 	buf[cnt] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dc53ecb..9b24a46 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -389,7 +389,7 @@ static int __init set_tracing_thresh(char *str)
 
 	if (!str)
 		return 0;
-	ret = strict_strtoul(str, 0, &threshhold);
+	ret = kstrtoul(str, 0, &threshhold);
 	if (ret < 0)
 		return 0;
 	tracing_thresh = threshhold * 1000;
@@ -2702,7 +2702,7 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 
 	buf[cnt] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
@@ -2963,7 +2963,7 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 
 	buf[cnt] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
@@ -3422,7 +3422,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 
 	buf[cnt] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
@@ -4075,7 +4075,7 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 			 loff_t *ppos)
 {
 	struct trace_option_dentry *topt = filp->private_data;
-	unsigned long val;
+	unsigned int val;
 	char buf[64];
 	int ret;
 
@@ -4087,7 +4087,7 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	buf[cnt] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtouint(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
@@ -4137,7 +4137,7 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 {
 	long index = (long)filp->private_data;
 	char buf[64];
-	unsigned long val;
+	unsigned int val;
 	int ret;
 
 	if (cnt >= sizeof(buf))
@@ -4148,7 +4148,7 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	buf[cnt] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtouint(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 35fde09..c968830 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -486,7 +486,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 {
 	struct ftrace_event_call *call = filp->private_data;
 	char buf[64];
-	unsigned long val;
+	int val;
 	int ret;
 
 	if (cnt >= sizeof(buf))
@@ -497,7 +497,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	buf[cnt] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoint(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
@@ -569,8 +569,8 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		    loff_t *ppos)
 {
 	const char *system = filp->private_data;
-	unsigned long val;
 	char buf[64];
+	int val;
 	ssize_t ret;
 
 	if (cnt >= sizeof(buf))
@@ -581,7 +581,7 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	buf[cnt] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoint(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 36d4010..f17f6a0 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -807,9 +807,9 @@ static int filter_add_pred(struct filter_parse_state *ps,
 			fn = filter_pred_pchar;
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
index 16aee4d..2f0dab3 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -354,8 +354,8 @@ ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
 	 * We use the callback data field (which is a pointer)
 	 * as our counter.
 	 */
-	ret = strict_strtoul(number, 0, (unsigned long *)&count);
-	if (ret)
+	ret = kstrtoul(number, 0, (unsigned long *)&count);
+	if (ret < 0)
 		return ret;
 
  out_reg:
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2dec9bc..e29849d 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -684,9 +684,8 @@ static int split_symbol_offset(char *symbol, unsigned long *offset)
 
 	tmp = strchr(symbol, '+');
 	if (tmp) {
-		/* skip sign because strict_strtol doesn't accept '+' */
-		ret = strict_strtoul(tmp + 1, 0, offset);
-		if (ret)
+		ret = kstrtoul(tmp, 0, offset);
+		if (ret < 0)
 			return ret;
 		*tmp = '\0';
 	} else
@@ -715,8 +714,10 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			else
 				ret = -EINVAL;
 		} else if (isdigit(arg[5])) {
-			ret = strict_strtoul(arg + 5, 10, &param);
-			if (ret || param > PARAM_MAX_STACK)
+			ret = kstrtoul(arg + 5, 10, &param);
+			if (ret < 0)
+				return ret;
+			if (param > PARAM_MAX_STACK)
 				ret = -EINVAL;
 			else {
 				f->fn = t->fetch[FETCH_MTD_stack];
@@ -752,8 +753,8 @@ static int __parse_probe_arg(char *arg, const struct fetch_type *t,
 		break;
 	case '@':	/* memory or symbol */
 		if (isdigit(arg[1])) {
-			ret = strict_strtoul(arg + 1, 0, &param);
-			if (ret)
+			ret = kstrtoul(arg + 1, 0, &param);
+			if (ret < 0)
 				break;
 			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
@@ -772,11 +773,9 @@ static int __parse_probe_arg(char *arg, const struct fetch_type *t,
 		if (!tmp)
 			break;
 		*tmp = '\0';
-		ret = strict_strtol(arg + 1, 0, &offset);
-		if (ret)
+		ret = kstrtol(arg, 0, &offset);
+		if (ret < 0)
 			break;
-		if (arg[0] == '-')
-			offset = -offset;
 		arg = tmp + 1;
 		tmp = strrchr(arg, ')');
 		if (tmp) {
@@ -948,8 +947,8 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 		/* an address specified */
-		ret = strict_strtoul(&argv[1][0], 0, (unsigned long *)&addr);
-		if (ret) {
+		ret = kstrtoul(&argv[1][0], 0, (unsigned long *)&addr);
+		if (ret < 0) {
 			pr_info("Failed to parse address.\n");
 			return ret;
 		}
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 4c5dead..36ebd3b 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -153,7 +153,7 @@ static ssize_t
 stack_max_size_write(struct file *filp, const char __user *ubuf,
 		     size_t count, loff_t *ppos)
 {
-	long *ptr = filp->private_data;
+	unsigned long *ptr = filp->private_data;
 	unsigned long val, flags;
 	char buf[64];
 	int ret;
@@ -167,7 +167,7 @@ stack_max_size_write(struct file *filp, const char __user *ubuf,
 
 	buf[count] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.3.4

