Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2DIJSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 05:18:53 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40984 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879Ab2DIJSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 05:18:49 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Date: Mon, 09 Apr 2012 14:41:33 +0530
Message-Id: <20120409091133.8343.65289.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 1/3] tracing: Modify is_delete, is_return from int to bool
x-cbid: 12040909-2674-0000-0000-000003F98848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

is_delete and is_return can take utmost 2 values and are better of
being a boolean than a int. There are no functional changes.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog:
(v5):
 - separated out as different patch on Masami's suggestion.

 kernel/trace/trace_kprobe.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 580a05e..4f935f8 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -651,7 +651,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 					     void *addr,
 					     const char *symbol,
 					     unsigned long offs,
-					     int nargs, int is_return)
+					     int nargs, bool is_return)
 {
 	struct trace_probe *tp;
 	int ret = -ENOMEM;
@@ -944,7 +944,7 @@ static int split_symbol_offset(char *symbol, unsigned long *offset)
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
 static int parse_probe_vars(char *arg, const struct fetch_type *t,
-			    struct fetch_param *f, int is_return)
+			    struct fetch_param *f, bool is_return)
 {
 	int ret = 0;
 	unsigned long param;
@@ -977,7 +977,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 
 /* Recursive argument parser */
 static int __parse_probe_arg(char *arg, const struct fetch_type *t,
-			     struct fetch_param *f, int is_return)
+			     struct fetch_param *f, bool is_return)
 {
 	int ret = 0;
 	unsigned long param;
@@ -1089,7 +1089,7 @@ static int __parse_bitfield_probe_arg(const char *bf,
 
 /* String length checking wrapper */
 static int parse_probe_arg(char *arg, struct trace_probe *tp,
-			   struct probe_arg *parg, int is_return)
+			   struct probe_arg *parg, bool is_return)
 {
 	const char *t;
 	int ret;
@@ -1162,7 +1162,7 @@ static int create_trace_probe(int argc, char **argv)
 	 */
 	struct trace_probe *tp;
 	int i, ret = 0;
-	int is_return = 0, is_delete = 0;
+	bool is_return = false, is_delete = false;
 	char *symbol = NULL, *event = NULL, *group = NULL;
 	char *arg;
 	unsigned long offset = 0;
@@ -1171,11 +1171,11 @@ static int create_trace_probe(int argc, char **argv)
 
 	/* argc must be >= 1 */
 	if (argv[0][0] == 'p')
-		is_return = 0;
+		is_return = false;
 	else if (argv[0][0] == 'r')
-		is_return = 1;
+		is_return = true;
 	else if (argv[0][0] == '-')
-		is_delete = 1;
+		is_delete = true;
 	else {
 		pr_info("Probe definition must be started with 'p', 'r' or"
 			" '-'.\n");


