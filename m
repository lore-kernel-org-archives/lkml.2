Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800Ab2KBNgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:36:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5843 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761244Ab2KBNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:05 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=tlxsXpNCEJwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FbA2kkj90RoA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=vR_tLfPqsBwRw38X8EMA:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=J1z37ABzf8eiYCYH:21 a=riljiUDZG5FoEZuW:21 a=MKSM97eRnRw54cQz8i8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133459.787988315@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:33:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 10/22] tracing: Cleanup unnecessary function declarations
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Cleanup-unnecessary-function-declarations.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

The functions defined in include/trace/syscalls.h are not used directly
since struct ftrace_event_class was introduced. Remove them from the
header file and rearrange the ftrace_event_class declarations in
trace_syscalls.c.

Link: http://lkml.kernel.org/r/1339112785-21806-2-git-send-email-vnagarnaik=
@google.com

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/syscall.h       |   21 --------------
 kernel/trace/trace_syscalls.c |   61 ++++++++++++++++++++-----------------=
----
 2 files changed, 29 insertions(+), 53 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 0c95796..84bc419 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -31,25 +31,4 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };
=20
-#ifdef CONFIG_FTRACE_SYSCALLS
-extern unsigned long arch_syscall_addr(int nr);
-extern int init_syscall_trace(struct ftrace_event_call *call);
-
-extern int reg_event_syscall_enter(struct ftrace_event_call *call);
-extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
-extern int reg_event_syscall_exit(struct ftrace_event_call *call);
-extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
-enum print_line_t print_syscall_enter(struct trace_iterator *iter, int fla=
gs,
-				      struct trace_event *event);
-enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flag=
s,
-				     struct trace_event *event);
-#endif
-
-#ifdef CONFIG_PERF_EVENTS
-int perf_sysenter_enable(struct ftrace_event_call *call);
-void perf_sysenter_disable(struct ftrace_event_call *call);
-int perf_sysexit_enable(struct ftrace_event_call *call);
-void perf_sysexit_disable(struct ftrace_event_call *call);
-#endif
-
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 2485a7d..7609dd6 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -21,9 +21,6 @@ static int syscall_enter_register(struct ftrace_event_cal=
l *event,
 static int syscall_exit_register(struct ftrace_event_call *event,
 				 enum trace_reg type, void *data);
=20
-static int syscall_enter_define_fields(struct ftrace_event_call *call);
-static int syscall_exit_define_fields(struct ftrace_event_call *call);
-
 static struct list_head *
 syscall_get_enter_fields(struct ftrace_event_call *call)
 {
@@ -32,30 +29,6 @@ syscall_get_enter_fields(struct ftrace_event_call *call)
 	return &entry->enter_fields;
 }
=20
-struct trace_event_functions enter_syscall_print_funcs =3D {
-	.trace		=3D print_syscall_enter,
-};
-
-struct trace_event_functions exit_syscall_print_funcs =3D {
-	.trace		=3D print_syscall_exit,
-};
-
-struct ftrace_event_class event_class_syscall_enter =3D {
-	.system		=3D "syscalls",
-	.reg		=3D syscall_enter_register,
-	.define_fields	=3D syscall_enter_define_fields,
-	.get_fields	=3D syscall_get_enter_fields,
-	.raw_init	=3D init_syscall_trace,
-};
-
-struct ftrace_event_class event_class_syscall_exit =3D {
-	.system		=3D "syscalls",
-	.reg		=3D syscall_exit_register,
-	.define_fields	=3D syscall_exit_define_fields,
-	.fields		=3D LIST_HEAD_INIT(event_class_syscall_exit.fields),
-	.raw_init	=3D init_syscall_trace,
-};
-
 extern struct syscall_metadata *__start_syscalls_metadata[];
 extern struct syscall_metadata *__stop_syscalls_metadata[];
=20
@@ -432,7 +405,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call =
*call)
 	mutex_unlock(&syscall_trace_lock);
 }
=20
-int init_syscall_trace(struct ftrace_event_call *call)
+static int init_syscall_trace(struct ftrace_event_call *call)
 {
 	int id;
 	int num;
@@ -457,6 +430,30 @@ int init_syscall_trace(struct ftrace_event_call *call)
 	return id;
 }
=20
+struct trace_event_functions enter_syscall_print_funcs =3D {
+	.trace		=3D print_syscall_enter,
+};
+
+struct trace_event_functions exit_syscall_print_funcs =3D {
+	.trace		=3D print_syscall_exit,
+};
+
+struct ftrace_event_class event_class_syscall_enter =3D {
+	.system		=3D "syscalls",
+	.reg		=3D syscall_enter_register,
+	.define_fields	=3D syscall_enter_define_fields,
+	.get_fields	=3D syscall_get_enter_fields,
+	.raw_init	=3D init_syscall_trace,
+};
+
+struct ftrace_event_class event_class_syscall_exit =3D {
+	.system		=3D "syscalls",
+	.reg		=3D syscall_exit_register,
+	.define_fields	=3D syscall_exit_define_fields,
+	.fields		=3D LIST_HEAD_INIT(event_class_syscall_exit.fields),
+	.raw_init	=3D init_syscall_trace,
+};
+
 unsigned long __init __weak arch_syscall_addr(int nr)
 {
 	return (unsigned long)sys_call_table[nr];
@@ -537,7 +534,7 @@ static void perf_syscall_enter(void *ignore, struct pt_=
regs *regs, long id)
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
=20
-int perf_sysenter_enable(struct ftrace_event_call *call)
+static int perf_sysenter_enable(struct ftrace_event_call *call)
 {
 	int ret =3D 0;
 	int num;
@@ -558,7 +555,7 @@ int perf_sysenter_enable(struct ftrace_event_call *call)
 	return ret;
 }
=20
-void perf_sysenter_disable(struct ftrace_event_call *call)
+static void perf_sysenter_disable(struct ftrace_event_call *call)
 {
 	int num;
=20
@@ -615,7 +612,7 @@ static void perf_syscall_exit(void *ignore, struct pt_r=
egs *regs, long ret)
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
=20
-int perf_sysexit_enable(struct ftrace_event_call *call)
+static int perf_sysexit_enable(struct ftrace_event_call *call)
 {
 	int ret =3D 0;
 	int num;
@@ -636,7 +633,7 @@ int perf_sysexit_enable(struct ftrace_event_call *call)
 	return ret;
 }
=20
-void perf_sysexit_disable(struct ftrace_event_call *call)
+static void perf_sysexit_disable(struct ftrace_event_call *call)
 {
 	int num;
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wDAAoJEOdOSU1xswtMwVIH/i4IXWPV54U4v1uHTWyB7uk1
M0DDKDuEiI51VnQcUiFKvA244+2wYn1OtwVsWYRQi6RY3nazVNIqQl6FstH3Ve5l
japOGtjwUwvoZYk/C4iuH83yfllGeHP+ET7eJSki5rQdAZVJ5KuKlt/geEixPyoU
k6+YIeoVx8c2dDMaThnixH9ZXq+Y7nNt3aZmDVfkJTmylmQ2vcurBfmDCCkV2Lb4
FnVlbauNKhL8+YcthRvs/cpNJsWt26V0mwJx5GwjofJcVHqiXHEsD0dx9B2Df2vd
BQ80h9GmNjsQ3snC2XasoiW2YvH+mK09AlblMbB7gie6oxBFrePosypbUErUUd0=
=3e+v
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
