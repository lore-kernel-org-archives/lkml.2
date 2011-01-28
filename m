Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1A1VEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 16:04:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:49891 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1A1VEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 16:04:41 -0500
Date: Fri, 28 Jan 2011 21:04:02 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110120141530.25915.12673.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110120141530.25915.12673.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add strfilter for general purpose string filter
Message-ID: <tip-68baa431ec2f14ba7510d4e79bceb6ceaf0d3b74@git.kernel.org>
Git-Commit-ID: 68baa431ec2f14ba7510d4e79bceb6ceaf0d3b74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 21:04:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68baa431ec2f14ba7510d4e79bceb6ceaf0d3b74
Gitweb:     http://git.kernel.org/tip/68baa431ec2f14ba7510d4e79bceb6ceaf0d3b74
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 20 Jan 2011 23:15:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 28 Jan 2011 09:19:38 -0200

perf tools: Add strfilter for general purpose string filter

Add strfilter for general purpose string filter.

Every filter rules are descrived by glob matching pattern and '!' prefix
which means Logical NOT.

A strfilter consists of those filter rules connected with '&' and '|'.

A set of rules can be folded by using '(' and ')'.

It also accepts spaces around rules and those operators.

Format:
<rule> ::= <glob-exp> | "!" <rule> | <rule> <op> <rule> | "(" <rule> ")"
<op> ::= "&" | "|"

e.g.:

 "(add* | del*) & *timer" filter rules pass strings which start with add
 or del and end with timer.

This will be used by perf probe --filter.

Changes in V2:
 - Fix to check result of strdup() and strfilter__alloc().
 - Encapsulate and simplify interfaces as like regex(3).

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20110120141530.25915.12673.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile         |    2 +
 tools/perf/util/strfilter.c |  200 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/strfilter.h |   48 ++++++++++
 3 files changed, 250 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 638e8e1..eedcf95 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -417,6 +417,7 @@ LIB_H += util/help.h
 LIB_H += util/session.h
 LIB_H += util/strbuf.h
 LIB_H += util/strlist.h
+LIB_H += util/strfilter.h
 LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
@@ -458,6 +459,7 @@ LIB_OBJS += $(OUTPUT)util/quote.o
 LIB_OBJS += $(OUTPUT)util/strbuf.o
 LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/strlist.o
+LIB_OBJS += $(OUTPUT)util/strfilter.o
 LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
diff --git a/tools/perf/util/strfilter.c b/tools/perf/util/strfilter.c
new file mode 100644
index 0000000..4064b7d
--- /dev/null
+++ b/tools/perf/util/strfilter.c
@@ -0,0 +1,200 @@
+#include <ctype.h>
+#include "util.h"
+#include "string.h"
+#include "strfilter.h"
+
+/* Operators */
+static const char *OP_and	= "&";	/* Logical AND */
+static const char *OP_or	= "|";	/* Logical OR */
+static const char *OP_not	= "!";	/* Logical NOT */
+
+#define is_operator(c)	((c) == '|' || (c) == '&' || (c) == '!')
+#define is_separator(c)	(is_operator(c) || (c) == '(' || (c) == ')')
+
+static void strfilter_node__delete(struct strfilter_node *self)
+{
+	if (self) {
+		if (self->p && !is_operator(*self->p))
+			free((char *)self->p);
+		strfilter_node__delete(self->l);
+		strfilter_node__delete(self->r);
+		free(self);
+	}
+}
+
+void strfilter__delete(struct strfilter *self)
+{
+	if (self) {
+		strfilter_node__delete(self->root);
+		free(self);
+	}
+}
+
+static const char *get_token(const char *s, const char **e)
+{
+	const char *p;
+
+	while (isspace(*s))	/* Skip spaces */
+		s++;
+
+	if (*s == '\0') {
+		p = s;
+		goto end;
+	}
+
+	p = s + 1;
+	if (!is_separator(*s)) {
+		/* End search */
+retry:
+		while (*p && !is_separator(*p) && !isspace(*p))
+			p++;
+		/* Escape and special case: '!' is also used in glob pattern */
+		if (*(p - 1) == '\\' || (*p == '!' && *(p - 1) == '[')) {
+			p++;
+			goto retry;
+		}
+	}
+end:
+	*e = p;
+	return s;
+}
+
+static struct strfilter_node *strfilter_node__alloc(const char *op,
+						    struct strfilter_node *l,
+						    struct strfilter_node *r)
+{
+	struct strfilter_node *ret = zalloc(sizeof(struct strfilter_node));
+
+	if (ret) {
+		ret->p = op;
+		ret->l = l;
+		ret->r = r;
+	}
+
+	return ret;
+}
+
+static struct strfilter_node *strfilter_node__new(const char *s,
+						  const char **ep)
+{
+	struct strfilter_node root, *cur, *last_op;
+	const char *e;
+
+	if (!s)
+		return NULL;
+
+	memset(&root, 0, sizeof(root));
+	last_op = cur = &root;
+
+	s = get_token(s, &e);
+	while (*s != '\0' && *s != ')') {
+		switch (*s) {
+		case '&':	/* Exchg last OP->r with AND */
+			if (!cur->r || !last_op->r)
+				goto error;
+			cur = strfilter_node__alloc(OP_and, last_op->r, NULL);
+			if (!cur)
+				goto nomem;
+			last_op->r = cur;
+			last_op = cur;
+			break;
+		case '|':	/* Exchg the root with OR */
+			if (!cur->r || !root.r)
+				goto error;
+			cur = strfilter_node__alloc(OP_or, root.r, NULL);
+			if (!cur)
+				goto nomem;
+			root.r = cur;
+			last_op = cur;
+			break;
+		case '!':	/* Add NOT as a leaf node */
+			if (cur->r)
+				goto error;
+			cur->r = strfilter_node__alloc(OP_not, NULL, NULL);
+			if (!cur->r)
+				goto nomem;
+			cur = cur->r;
+			break;
+		case '(':	/* Recursively parses inside the parenthesis */
+			if (cur->r)
+				goto error;
+			cur->r = strfilter_node__new(s + 1, &s);
+			if (!s)
+				goto nomem;
+			if (!cur->r || *s != ')')
+				goto error;
+			e = s + 1;
+			break;
+		default:
+			if (cur->r)
+				goto error;
+			cur->r = strfilter_node__alloc(NULL, NULL, NULL);
+			if (!cur->r)
+				goto nomem;
+			cur->r->p = strndup(s, e - s);
+			if (!cur->r->p)
+				goto nomem;
+		}
+		s = get_token(e, &e);
+	}
+	if (!cur->r)
+		goto error;
+	*ep = s;
+	return root.r;
+nomem:
+	s = NULL;
+error:
+	*ep = s;
+	strfilter_node__delete(root.r);
+	return NULL;
+}
+
+/*
+ * Parse filter rule and return new strfilter.
+ * Return NULL if fail, and *ep == NULL if memory allocation failed.
+ */
+struct strfilter *strfilter__new(const char *rules, const char **err)
+{
+	struct strfilter *ret = zalloc(sizeof(struct strfilter));
+	const char *ep = NULL;
+
+	if (ret)
+		ret->root = strfilter_node__new(rules, &ep);
+
+	if (!ret || !ret->root || *ep != '\0') {
+		if (err)
+			*err = ep;
+		strfilter__delete(ret);
+		ret = NULL;
+	}
+
+	return ret;
+}
+
+static bool strfilter_node__compare(struct strfilter_node *self,
+				    const char *str)
+{
+	if (!self || !self->p)
+		return false;
+
+	switch (*self->p) {
+	case '|':	/* OR */
+		return strfilter_node__compare(self->l, str) ||
+			strfilter_node__compare(self->r, str);
+	case '&':	/* AND */
+		return strfilter_node__compare(self->l, str) &&
+			strfilter_node__compare(self->r, str);
+	case '!':	/* NOT */
+		return !strfilter_node__compare(self->r, str);
+	default:
+		return strglobmatch(str, self->p);
+	}
+}
+
+/* Return true if STR matches the filter rules */
+bool strfilter__compare(struct strfilter *self, const char *str)
+{
+	if (!self)
+		return false;
+	return strfilter_node__compare(self->root, str);
+}
diff --git a/tools/perf/util/strfilter.h b/tools/perf/util/strfilter.h
new file mode 100644
index 0000000..00f58a7
--- /dev/null
+++ b/tools/perf/util/strfilter.h
@@ -0,0 +1,48 @@
+#ifndef __PERF_STRFILTER_H
+#define __PERF_STRFILTER_H
+/* General purpose glob matching filter */
+
+#include <linux/list.h>
+#include <stdbool.h>
+
+/* A node of string filter */
+struct strfilter_node {
+	struct strfilter_node *l;	/* Tree left branche (for &,|) */
+	struct strfilter_node *r;	/* Tree right branche (for !,&,|) */
+	const char *p;		/* Operator or rule */
+};
+
+/* String filter */
+struct strfilter {
+	struct strfilter_node *root;
+};
+
+/**
+ * strfilter__new - Create a new string filter
+ * @rules: Filter rule, which is a combination of glob expressions.
+ * @err: Pointer which points an error detected on @rules
+ *
+ * Parse @rules and return new strfilter. Return NULL if an error detected.
+ * In that case, *@err will indicate where it is detected, and *@err is NULL
+ * if a memory allocation is failed.
+ */
+struct strfilter *strfilter__new(const char *rules, const char **err);
+
+/**
+ * strfilter__compare - compare given string and a string filter
+ * @self: String filter
+ * @str: target string
+ *
+ * Compare @str and @self. Return true if the str match the rule
+ */
+bool strfilter__compare(struct strfilter *self, const char *str);
+
+/**
+ * strfilter__delete - delete a string filter
+ * @self: String filter to delete
+ *
+ * Delete @self.
+ */
+void strfilter__delete(struct strfilter *self);
+
+#endif
