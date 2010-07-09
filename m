Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0GIT4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:56:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44982 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab0GIT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:56:45 -0400
X-Authority-Analysis: v=1.1 cv=o8sBXTxWt3Y8I13SYZ0pmcTcOViZ+nX/QX6HkgGmvUU= c=1 sm=0 a=wpy7bjtF3aoA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=a9rkG6VOnv5bY2BC6AoA:9 a=r5BxIpcJHS9MmzIlr6shjf7v8cEA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL][for 2.6.35] tracing: Add alignment to syscall
 metadata declarations
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 09 Jul 2010 15:56:42 -0400
Message-ID: <1278705402.1537.157.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Steven Rostedt (1):
      tracing: Add alignment to syscall metadata declarations

----
 include/linux/syscalls.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)
---------------------------
commit 44a54f787c0abcf75a2ed49b8ec8b2b512468f73
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Jul 9 15:41:44 2010 -0400

    tracing: Add alignment to syscall metadata declarations
    
    For some reason if we declare a static variable and then assign it
    later, and the assignment contains a __attribute__((__aligned__(#))),
    some versions of gcc will ignore it.
    
    This caused the syscall meta data to not be compact in its section
    and caused a kernel oops when the section was being read.
    
    The fix for these versions of gcc seems to be to add the aligned
    attribute to the declaration as well.
    
    This fixes the BZ regression:
    
      https://bugzilla.kernel.org/show_bug.cgi?id=16353
    
    Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
    Tested-by: Zeev Tarantov <zeev.tarantov@gmail.com>
    Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
    LKML-Reference: <AANLkTinkKVmB0fpVeqUkMeqe3ZYeXJdI8xDuzJEOjYwh@mail.gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7f614ce..13ebb54 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -124,7 +124,8 @@ extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata					\
+	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
 	static struct ftrace_event_call __used				\
@@ -138,7 +139,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata					\
+	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct ftrace_event_call __used				\


