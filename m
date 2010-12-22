Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0LVLat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:30:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:34706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0LVLaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:30:46 -0500
Date: Wed, 22 Dec 2010 11:30:08 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101217131211.24123.40437.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101217131211.24123.40437.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Cleanup messages
Message-ID: <tip-0e43e5d222095ca2d1d825dd2e4fa158bdc4cc9b@git.kernel.org>
Git-Commit-ID: 0e43e5d222095ca2d1d825dd2e4fa158bdc4cc9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:30:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e43e5d222095ca2d1d825dd2e4fa158bdc4cc9b
Gitweb:     http://git.kernel.org/tip/0e43e5d222095ca2d1d825dd2e4fa158bdc4cc9b
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 17 Dec 2010 22:12:11 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 20:20:58 -0200

perf probe: Cleanup messages

Add new lines for error or debug messages, change dwarf related words to more
generic words (or just removed).

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20101217131211.24123.40437.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |   30 +++++++++++++++-------------
 tools/perf/util/probe-finder.c |   42 ++++++++++++++++++++-------------------
 2 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3b6a529..089d78e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -95,7 +95,7 @@ static int init_vmlinux(void)
 		goto out;
 
 	if (machine__create_kernel_maps(&machine) < 0) {
-		pr_debug("machine__create_kernel_maps ");
+		pr_debug("machine__create_kernel_maps() failed.\n");
 		goto out;
 	}
 out:
@@ -140,7 +140,8 @@ static int open_vmlinux(const char *module)
 {
 	const char *path = kernel_get_module_path(module);
 	if (!path) {
-		pr_err("Failed to find path of %s module", module ?: "kernel");
+		pr_err("Failed to find path of %s module.\n",
+		       module ?: "kernel");
 		return -ENOENT;
 	}
 	pr_debug("Try to open %s\n", path);
@@ -217,7 +218,7 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 		pr_warning("Warning: No dwarf info found in the vmlinux - "
 			"please rebuild kernel with CONFIG_DEBUG_INFO=y.\n");
 		if (!need_dwarf) {
-			pr_debug("Trying to use symbols.\nn");
+			pr_debug("Trying to use symbols.\n");
 			return 0;
 		}
 	}
@@ -457,7 +458,7 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 
 	fd = open_vmlinux(module);
 	if (fd < 0) {
-		pr_warning("Failed to open debuginfo file.\n");
+		pr_warning("Failed to open debug information file.\n");
 		return fd;
 	}
 
@@ -690,39 +691,40 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 
 	/* Exclusion check */
 	if (pp->lazy_line && pp->line) {
-		semantic_error("Lazy pattern can't be used with line number.");
+		semantic_error("Lazy pattern can't be used with"
+			       " line number.\n");
 		return -EINVAL;
 	}
 
 	if (pp->lazy_line && pp->offset) {
-		semantic_error("Lazy pattern can't be used with offset.");
+		semantic_error("Lazy pattern can't be used with offset.\n");
 		return -EINVAL;
 	}
 
 	if (pp->line && pp->offset) {
-		semantic_error("Offset can't be used with line number.");
+		semantic_error("Offset can't be used with line number.\n");
 		return -EINVAL;
 	}
 
 	if (!pp->line && !pp->lazy_line && pp->file && !pp->function) {
 		semantic_error("File always requires line number or "
-			       "lazy pattern.");
+			       "lazy pattern.\n");
 		return -EINVAL;
 	}
 
 	if (pp->offset && !pp->function) {
-		semantic_error("Offset requires an entry function.");
+		semantic_error("Offset requires an entry function.\n");
 		return -EINVAL;
 	}
 
 	if (pp->retprobe && !pp->function) {
-		semantic_error("Return probe requires an entry function.");
+		semantic_error("Return probe requires an entry function.\n");
 		return -EINVAL;
 	}
 
 	if ((pp->offset || pp->line || pp->lazy_line) && pp->retprobe) {
 		semantic_error("Offset/Line/Lazy pattern can't be used with "
-			       "return probe.");
+			       "return probe.\n");
 		return -EINVAL;
 	}
 
@@ -996,7 +998,7 @@ int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf, size_t len)
 
 	return tmp - buf;
 error:
-	pr_debug("Failed to synthesize perf probe argument: %s",
+	pr_debug("Failed to synthesize perf probe argument: %s\n",
 		 strerror(-ret));
 	return ret;
 }
@@ -1046,7 +1048,7 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 
 	return buf;
 error:
-	pr_debug("Failed to synthesize perf probe point: %s",
+	pr_debug("Failed to synthesize perf probe point: %s\n",
 		 strerror(-ret));
 	if (buf)
 		free(buf);
@@ -1787,7 +1789,7 @@ static int del_trace_probe_event(int fd, const char *group,
 
 	ret = e_snprintf(buf, 128, "%s:%s", group, event);
 	if (ret < 0) {
-		pr_err("Failed to copy event.");
+		pr_err("Failed to copy event.\n");
 		return ret;
 	}
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3991d73..90b6292 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -627,8 +627,8 @@ static_var:
 	regs = get_arch_regstr(regn);
 	if (!regs) {
 		/* This should be a bug in DWARF or this tool */
-		pr_warning("Mapping for DWARF register number %u "
-			   "missing on this architecture.", regn);
+		pr_warning("Mapping for the register number %u "
+			   "missing on this architecture.\n", regn);
 		return -ERANGE;
 	}
 
@@ -674,13 +674,14 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 		if (ret != DW_TAG_pointer_type &&
 		    ret != DW_TAG_array_type) {
 			pr_warning("Failed to cast into string: "
-				   "%s(%s) is not a pointer nor array.",
+				   "%s(%s) is not a pointer nor array.\n",
 				   dwarf_diename(vr_die), dwarf_diename(&type));
 			return -EINVAL;
 		}
 		if (ret == DW_TAG_pointer_type) {
 			if (die_get_real_type(&type, &type) == NULL) {
-				pr_warning("Failed to get a type information.");
+				pr_warning("Failed to get a type"
+					   " information.\n");
 				return -ENOENT;
 			}
 			while (*ref_ptr)
@@ -695,7 +696,7 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 		if (!die_compare_name(&type, "char") &&
 		    !die_compare_name(&type, "unsigned char")) {
 			pr_warning("Failed to cast into string: "
-				   "%s is not (unsigned) char *.",
+				   "%s is not (unsigned) char *.\n",
 				   dwarf_diename(vr_die));
 			return -EINVAL;
 		}
@@ -805,8 +806,8 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			return -EINVAL;
 		}
 		if (field->name[0] == '[') {
-			pr_err("Semantic error: %s is not a pointor nor array.",
-			       varname);
+			pr_err("Semantic error: %s is not a pointor"
+			       " nor array.\n", varname);
 			return -EINVAL;
 		}
 		if (field->ref) {
@@ -953,7 +954,7 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
 	name = dwarf_diename(sp_die);
 	if (name) {
 		if (dwarf_entrypc(sp_die, &eaddr) != 0) {
-			pr_warning("Failed to get entry pc of %s\n",
+			pr_warning("Failed to get entry address of %s\n",
 				   dwarf_diename(sp_die));
 			return -ENOENT;
 		}
@@ -969,7 +970,7 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
 	if (retprobe) {
 		if (eaddr != paddr) {
 			pr_warning("Return probe must be on the head of"
-				   " a real function\n");
+				   " a real function.\n");
 			return -EINVAL;
 		}
 		tp->retprobe = true;
@@ -1008,7 +1009,7 @@ static int call_probe_finder(Dwarf_Die *sp_die, struct probe_finder *pf)
 		Dwarf_Frame *frame;
 		if (dwarf_cfi_addrframe(pf->cfi, pf->addr, &frame) != 0 ||
 		    dwarf_frame_cfa(frame, &pf->fb_ops, &nops) != 0) {
-			pr_warning("Failed to get CFA on 0x%jx\n",
+			pr_warning("Failed to get call frame on 0x%jx\n",
 				   (uintmax_t)pf->addr);
 			return -ENOENT;
 		}
@@ -1035,7 +1036,7 @@ static int find_probe_point_by_line(struct probe_finder *pf)
 	int ret = 0;
 
 	if (dwarf_getsrclines(&pf->cu_die, &lines, &nlines) != 0) {
-		pr_warning("No source lines found in this CU.\n");
+		pr_warning("No source lines found.\n");
 		return -ENOENT;
 	}
 
@@ -1137,7 +1138,7 @@ static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 	}
 
 	if (dwarf_getsrclines(&pf->cu_die, &lines, &nlines) != 0) {
-		pr_warning("No source lines found in this CU.\n");
+		pr_warning("No source lines found.\n");
 		return -ENOENT;
 	}
 
@@ -1195,7 +1196,7 @@ static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 	else {
 		/* Get probe address */
 		if (dwarf_entrypc(in_die, &addr) != 0) {
-			pr_warning("Failed to get entry pc of %s.\n",
+			pr_warning("Failed to get entry address of %s.\n",
 				   dwarf_diename(in_die));
 			param->retval = -ENOENT;
 			return DWARF_CB_ABORT;
@@ -1236,8 +1237,8 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 			param->retval = find_probe_point_lazy(sp_die, pf);
 		else {
 			if (dwarf_entrypc(sp_die, &pf->addr) != 0) {
-				pr_warning("Failed to get entry pc of %s.\n",
-					   dwarf_diename(sp_die));
+				pr_warning("Failed to get entry address of "
+					   "%s.\n", dwarf_diename(sp_die));
 				param->retval = -ENOENT;
 				return DWARF_CB_ABORT;
 			}
@@ -1279,7 +1280,7 @@ static int find_probes(int fd, struct probe_finder *pf)
 
 	dbg = dwfl_init_offline_dwarf(fd, &dwfl, &bias);
 	if (!dbg) {
-		pr_warning("No dwarf info found in the vmlinux - "
+		pr_warning("No debug information found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
 		return -EBADF;
 	}
@@ -1524,7 +1525,7 @@ int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
 	/* Open the live linux kernel */
 	dbg = dwfl_init_live_kernel_dwarf(addr, &dwfl, &bias);
 	if (!dbg) {
-		pr_warning("No dwarf info found in the vmlinux - "
+		pr_warning("No debug information found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
 		ret = -EINVAL;
 		goto end;
@@ -1534,7 +1535,8 @@ int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
 	addr += bias;
 	/* Find cu die */
 	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr - bias, &cudie)) {
-		pr_warning("No CU DIE is found at %lx\n", addr);
+		pr_warning("Failed to find debug information for address %lx\n",
+			   addr);
 		ret = -EINVAL;
 		goto end;
 	}
@@ -1659,7 +1661,7 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 
 	line_list__init(&lf->lr->line_list);
 	if (dwarf_getsrclines(&lf->cu_die, &lines, &nlines) != 0) {
-		pr_warning("No source lines found in this CU.\n");
+		pr_warning("No source lines found.\n");
 		return -ENOENT;
 	}
 
@@ -1784,7 +1786,7 @@ int find_line_range(int fd, struct line_range *lr)
 
 	dbg = dwfl_init_offline_dwarf(fd, &dwfl, &bias);
 	if (!dbg) {
-		pr_warning("No dwarf info found in the vmlinux - "
+		pr_warning("No debug information found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
 		return -EBADF;
 	}
