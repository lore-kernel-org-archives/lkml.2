Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0GVQMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:12:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab0GVQMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:12:14 -0400
Date: Thu, 22 Jul 2010 12:11:49 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <201007221611.o6MGBnmW029378@hs20-bc2-1.build.redhat.com>
To: a.p.zijlstra@chello.nl, acme@redhat.com, davem@davemloft.net,
        imunsie@au.ibm.com, linux-kernel@vger.kernel.org, mhiramat@redhat.com,
        mingo@elte.hu, paulus@samba.org
Subject: Small perf optimization
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this bad practice of using arrays of string pointers to constant
strings further spreads let's fix it.  With this change not only is the
entire data associated with the arrays read-only, it also replaces a
memory lookup with a trivial arithmetic operation.  The result is
a smaller and faster binary.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>


diff --git a/tools/perf/arch/sparc/util/dwarf-regs.c b/tools/perf/arch/sparc/util/dwarf-regs.c
index 0ab8848..17f193e 100644
--- a/tools/perf/arch/sparc/util/dwarf-regs.c
+++ b/tools/perf/arch/sparc/util/dwarf-regs.c
@@ -14,7 +14,7 @@
 
 #define SPARC_MAX_REGS	96
 
-const char *sparc_regs_table[SPARC_MAX_REGS] = {
+static const char sparc_regs_table[SPARC_MAX_REGS][5] = {
 	"%g0", "%g1", "%g2", "%g3", "%g4", "%g5", "%g6", "%g7",
 	"%o0", "%o1", "%o2", "%o3", "%o4", "%o5", "%sp", "%o7",
 	"%l0", "%l1", "%l2", "%l3", "%l4", "%l5", "%l6", "%l7",
diff --git a/tools/perf/arch/x86/util/dwarf-regs.c b/tools/perf/arch/x86/util/dwarf-regs.c
index a794d30..fe5ef0f 100644
--- a/tools/perf/arch/x86/util/dwarf-regs.c
+++ b/tools/perf/arch/x86/util/dwarf-regs.c
@@ -28,7 +28,7 @@
  */
 
 #define X86_32_MAX_REGS 8
-const char *x86_32_regs_table[X86_32_MAX_REGS] = {
+static const char x86_32_regs_table[X86_32_MAX_REGS][7] = {
 	"%ax",
 	"%cx",
 	"%dx",
@@ -40,7 +40,7 @@ const char *x86_32_regs_table[X86_32_MAX_REGS] = {
 };
 
 #define X86_64_MAX_REGS 16
-const char *x86_64_regs_table[X86_64_MAX_REGS] = {
+static const char x86_64_regs_table[X86_64_MAX_REGS][5] = {
 	"%ax",
 	"%dx",
 	"%cx",
