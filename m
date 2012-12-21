Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab2LUNEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:04:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28116 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2LUNE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:04:28 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=N7apZ2mRdwEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kkeB2nsji94A:10 a=QyXUC8HyAAAA:8 a=2fI_1bGreRXKKz6Lyv8A:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Z-dSymqPRmjn_ZaJ:21 a=s4WAr9l-bKdMQQ9N:21 a=k7M1AjPP8X9euP_yWA8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121221130426.971049063@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 21 Dec 2012 08:03:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 3/3] tracing/syscalls: Make local functions static
References: <20121221130323.940466074@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-syscalls-Make-local-functions-static.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Fengguang Wu <fengguang.wu@intel.com>

Some functions in the syscall tracing is used only locally to
the file, but they are labeled global. Convert them to static functions.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 7609dd6..5329e13e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -77,7 +77,7 @@ static struct syscall_metadata *syscall_nr_to_meta(int nr)
 	return syscalls_metadata[nr];
 }
=20
-enum print_line_t
+static enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags,
 		    struct trace_event *event)
 {
@@ -130,7 +130,7 @@ end:
 	return TRACE_TYPE_HANDLED;
 }
=20
-enum print_line_t
+static enum print_line_t
 print_syscall_exit(struct trace_iterator *iter, int flags,
 		   struct trace_event *event)
 {
@@ -270,7 +270,7 @@ static int syscall_exit_define_fields(struct ftrace_eve=
nt_call *call)
 	return ret;
 }
=20
-void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
+static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long =
id)
 {
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
@@ -305,7 +305,7 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs =
*regs, long id)
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
=20
-void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
+static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long r=
et)
 {
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
@@ -337,7 +337,7 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *=
regs, long ret)
 		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
=20
-int reg_event_syscall_enter(struct ftrace_event_call *call)
+static int reg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int ret =3D 0;
 	int num;
@@ -356,7 +356,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *c=
all)
 	return ret;
 }
=20
-void unreg_event_syscall_enter(struct ftrace_event_call *call)
+static void unreg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int num;
=20
@@ -371,7 +371,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call=
 *call)
 	mutex_unlock(&syscall_trace_lock);
 }
=20
-int reg_event_syscall_exit(struct ftrace_event_call *call)
+static int reg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int ret =3D 0;
 	int num;
@@ -390,7 +390,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *ca=
ll)
 	return ret;
 }
=20
-void unreg_event_syscall_exit(struct ftrace_event_call *call)
+static void unreg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int num;
=20
@@ -459,7 +459,7 @@ unsigned long __init __weak arch_syscall_addr(int nr)
 	return (unsigned long)sys_call_table[nr];
 }
=20
-int __init init_ftrace_syscalls(void)
+static int __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
 	unsigned long addr;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ1F5bAAoJEOdOSU1xswtMd9sH/36GrZULQjDMBJQFfWtzugq2
ODGo4v3UIfMWRjuDwfrhofY/Pvoe6hOFoqxUES7V73nDnvNhbiDPQZFrb+b87igS
AiNAEGtgkjRpk0fWD23gaj8rbN9+FCl5LpFaDM3b+543lXxtJczYFnENz0dbSkHT
oQkkN1R0QkiAF6S2H4o2v69n57Gy2nTDFGu6znu5upuQ8tEBnuzcXm5heU3UTIOj
kXoKh+J7kf1Ez6yB/27xZOpFkilDPwONm5NFAv05qmwWMCkjvjqRlwftI2ce5QoE
OgfuGMLznW7siMV+qc4eusv+yW0qlBGgAy8QhnxAcTR7Qqf3wbIdEGXTRfBkG7Y=
=w/w6
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
