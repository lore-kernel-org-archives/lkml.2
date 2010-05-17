Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0EQTbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:31:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0EQTbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:31:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/4] perf options: Type check all the remaining OPT_ variants
Date: Mon, 17 May 2010 16:31:18 -0300
Message-Id: <1274124678-24781-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274124678-24781-1-git-send-email-acme@infradead.org>
References: <1274124678-24781-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

OPT_SET_INT was renamed to OPT_SET_UINT since the only use in these
tools is to set something that has an enum type, that is builtin
compatible with unsigned int.

Several string constifications were done to make OPT_STRING require a
const char * type.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-bench.c      |    4 ++--
 tools/perf/builtin-help.c       |    6 +++---
 tools/perf/builtin-kvm.c        |    2 +-
 tools/perf/builtin-report.c     |    4 ++--
 tools/perf/builtin-sched.c      |    2 +-
 tools/perf/builtin-top.c        |    2 +-
 tools/perf/util/hist.c          |    2 +-
 tools/perf/util/parse-options.c |   10 +++++-----
 tools/perf/util/parse-options.h |   16 ++++++++--------
 tools/perf/util/sort.c          |    8 ++++----
 tools/perf/util/sort.h          |    8 ++++----
 tools/perf/util/symbol.h        |    2 +-
 12 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 4699677..fcb9626 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -95,7 +95,7 @@ static void dump_suites(int subsys_index)
 	return;
 }
 
-static char *bench_format_str;
+static const char *bench_format_str;
 int bench_format = BENCH_FORMAT_DEFAULT;
 
 static const struct option bench_options[] = {
@@ -126,7 +126,7 @@ static void print_usage(void)
 	printf("\n");
 }
 
-static int bench_str2int(char *str)
+static int bench_str2int(const char *str)
 {
 	if (!str)
 		return BENCH_FORMAT_DEFAULT;
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 81e3ecc..6d5a8a7 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -33,10 +33,10 @@ static bool show_all = false;
 static enum help_format help_format = HELP_FORMAT_MAN;
 static struct option builtin_help_options[] = {
 	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
-	OPT_SET_INT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
-	OPT_SET_INT('w', "web", &help_format, "show manual in web browser",
+	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
+	OPT_SET_UINT('w', "web", &help_format, "show manual in web browser",
 			HELP_FORMAT_WEB),
-	OPT_SET_INT('i', "info", &help_format, "show info page",
+	OPT_SET_UINT('i', "info", &help_format, "show info page",
 			HELP_FORMAT_INFO),
 	OPT_END(),
 };
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b1c6b38..34d1e85 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -19,7 +19,7 @@
 #include <pthread.h>
 #include <math.h>
 
-static char			*file_name;
+static const char		*file_name;
 static char			name_buffer[256];
 
 bool				perf_host = 1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6826512..1d3c100 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -39,8 +39,8 @@ static bool		dont_use_callchains;
 static bool		show_threads;
 static struct perf_read_values	show_threads_values;
 
-static char		default_pretty_printing_style[] = "normal";
-static char		*pretty_printing_style = default_pretty_printing_style;
+static const char	default_pretty_printing_style[] = "normal";
+static const char	*pretty_printing_style = default_pretty_printing_style;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c80acdf..f67bce2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -22,7 +22,7 @@
 static char			const *input_name = "perf.data";
 
 static char			default_sort_order[] = "avg, max, switch, runtime";
-static char			*sort_order = default_sort_order;
+static const char		*sort_order = default_sort_order;
 
 static int			profile_cpu = -1;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9f0cfa0..397290a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -96,7 +96,7 @@ struct source_line {
 	struct source_line	*next;
 };
 
-static char			*sym_filter			=   NULL;
+static const char		*sym_filter			=   NULL;
 struct sym_entry		*sym_filter_entry		=   NULL;
 struct sym_entry		*sym_filter_entry_sched		=   NULL;
 static int			sym_pcnt_filter			=      5;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f75c5f6..9a71c94 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -662,7 +662,7 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 	long displacement = 0;
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
-	char *col_width = symbol_conf.col_width_list_str;
+	const char *col_width = symbol_conf.col_width_list_str;
 
 	init_rem_hits();
 
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 36d955e..99d02aa 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -51,7 +51,7 @@ static int get_value(struct parse_opt_ctx_t *p,
 		case OPTION_BOOLEAN:
 		case OPTION_INCR:
 		case OPTION_BIT:
-		case OPTION_SET_INT:
+		case OPTION_SET_UINT:
 		case OPTION_SET_PTR:
 			return opterror(opt, "takes no value", flags);
 		case OPTION_END:
@@ -83,8 +83,8 @@ static int get_value(struct parse_opt_ctx_t *p,
 		*(int *)opt->value = unset ? 0 : *(int *)opt->value + 1;
 		return 0;
 
-	case OPTION_SET_INT:
-		*(int *)opt->value = unset ? 0 : opt->defval;
+	case OPTION_SET_UINT:
+		*(unsigned int *)opt->value = unset ? 0 : opt->defval;
 		return 0;
 
 	case OPTION_SET_PTR:
@@ -515,13 +515,13 @@ int usage_with_options_internal(const char * const *usagestr,
 					pos += fprintf(stderr, " ...");
 			}
 			break;
-		default: /* OPTION_{BIT,BOOLEAN,SET_INT,SET_PTR} */
+		default: /* OPTION_{BIT,BOOLEAN,SET_UINT,SET_PTR} */
 		case OPTION_END:
 		case OPTION_GROUP:
 		case OPTION_BIT:
 		case OPTION_BOOLEAN:
 		case OPTION_INCR:
-		case OPTION_SET_INT:
+		case OPTION_SET_UINT:
 		case OPTION_SET_PTR:
 			break;
 		}
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index 5838e2d..c7d72dc 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -13,7 +13,7 @@ enum parse_opt_type {
 	OPTION_BIT,
 	OPTION_BOOLEAN,
 	OPTION_INCR,
-	OPTION_SET_INT,
+	OPTION_SET_UINT,
 	OPTION_SET_PTR,
 	/* options with arguments (usually) */
 	OPTION_STRING,
@@ -79,7 +79,7 @@ typedef int parse_opt_cb(const struct option *, const char *arg, int unset);
  *
  * `defval`::
  *   default value to fill (*->value) with for PARSE_OPT_OPTARG.
- *   OPTION_{BIT,SET_INT,SET_PTR} store the {mask,integer,pointer} to put in
+ *   OPTION_{BIT,SET_UINT,SET_PTR} store the {mask,integer,pointer} to put in
  *   the value when met.
  *   CALLBACKS can use it like they want.
  */
@@ -101,16 +101,16 @@ struct option {
 #define OPT_END()                   { .type = OPTION_END }
 #define OPT_ARGUMENT(l, h)          { .type = OPTION_ARGUMENT, .long_name = (l), .help = (h) }
 #define OPT_GROUP(h)                { .type = OPTION_GROUP, .help = (h) }
-#define OPT_BIT(s, l, v, h, b)      { .type = OPTION_BIT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (b) }
+#define OPT_BIT(s, l, v, h, b)      { .type = OPTION_BIT, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h), .defval = (b) }
 #define OPT_BOOLEAN(s, l, v, h)     { .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), .value = check_vtype(v, bool *), .help = (h) }
-#define OPT_INCR(s, l, v, h)        { .type = OPTION_INCR, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
-#define OPT_SET_INT(s, l, v, h, i)  { .type = OPTION_SET_INT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (i) }
+#define OPT_INCR(s, l, v, h)        { .type = OPTION_INCR, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
+#define OPT_SET_UINT(s, l, v, h, i)  { .type = OPTION_SET_UINT, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h), .defval = (i) }
 #define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
 #define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
 #define OPT_UINTEGER(s, l, v, h)    { .type = OPTION_UINTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h) }
-#define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
-#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
-#define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h) }
+#define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = check_vtype(v, long *), .help = (h) }
+#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, u64 *), .help = (h) }
+#define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
 #define OPT_DATE(s, l, v, h) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index da30b30..2316cb5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,10 +1,10 @@
 #include "sort.h"
 
 regex_t		parent_regex;
-char		default_parent_pattern[] = "^sys_|^do_page_fault";
-char		*parent_pattern = default_parent_pattern;
-char		default_sort_order[] = "comm,dso,symbol";
-char		*sort_order = default_sort_order;
+const char	default_parent_pattern[] = "^sys_|^do_page_fault";
+const char	*parent_pattern = default_parent_pattern;
+const char	default_sort_order[] = "comm,dso,symbol";
+const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index eab2e0b..0d61c40 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -25,10 +25,10 @@
 #include "sort.h"
 
 extern regex_t parent_regex;
-extern char *sort_order;
-extern char default_parent_pattern[];
-extern char *parent_pattern;
-extern char default_sort_order[];
+extern const char *sort_order;
+extern const char default_parent_pattern[];
+extern const char *parent_pattern;
+extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
 extern char *field_sep;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6389d1a..032469e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -78,7 +78,7 @@ struct symbol_conf {
 			*default_guest_kallsyms,
 			*default_guest_modules;
 	const char	*guestmount;
-	char		*dso_list_str,
+	const char	*dso_list_str,
 			*comm_list_str,
 			*sym_list_str,
 			*col_width_list_str;
-- 
1.6.2.5

