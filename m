Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2HRACI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 20:02:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2HRACB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 20:02:01 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=VLYvds_yI8QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=AMm9vkyltg0A:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8 a=9Wbp7B8dAAAA:8 a=pGLkceISAAAA:8 a=A7dRAwK91z7IvThWmZMA:9 a=PUjeQqilurYA:10 a=Odly5QsfgCAA:10 a=ESTKKtUg-DoA:10 a=jEp0ucaQiEUA:10 a=QKMRfEvApNQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345248118.3708.37.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL][v3.6] tracing/syscalls: Fix perf syscall tracing
 when syscall_nr == -1
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>, Jason Baron <jbaron@redhat.com>,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 17 Aug 2012 20:01:58 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 60916a9382e88fbf5e54fd36a3e658efd7ab7bed


Will Deacon (1):
      tracing/syscalls: Fix perf syscall tracing when syscall_nr == -1

----
 kernel/trace/trace_syscalls.c |    4 ++++
 1 file changed, 4 insertions(+)
---------------------------
commit 60916a9382e88fbf5e54fd36a3e658efd7ab7bed
Author: Will Deacon <will.deacon@arm.com>
Date:   Thu Aug 16 18:14:14 2012 +0100

    tracing/syscalls: Fix perf syscall tracing when syscall_nr == -1
    
    syscall_get_nr can return -1 in the case that the task is not executing
    a system call.
    
    This patch fixes perf_syscall_{enter,exit} to check that the syscall
    number is valid before using it as an index into a bitmap.
    
    Link: http://lkml.kernel.org/r/1345137254-7377-1-git-send-email-will.deacon@arm.com
    
    Cc: Jason Baron <jbaron@redhat.com>
    Cc: Wade Farnsworth <wade_farnsworth@mentor.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Will Deacon <will.deacon@arm.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 60e4d78..6b245f64 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -506,6 +506,8 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
@@ -580,6 +582,8 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 


