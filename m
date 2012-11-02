Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811Ab2KBNiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:38:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760987Ab2KBNfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:03 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=D2EVz2yggjMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Su98XoBufucA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=0ERITLS6YsdD9AKEyr4A:9 a=QEXdDO2ut3YA:10 a=aBoZ2TYS_3EA:10 a=UTB_XpHje0EA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=oyEV70pxRct3Gb1qEnwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133500.545578634@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:33:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 14/22] tracing: Format non-nanosec times from tsc clock without a decimal
 point.
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-Format-non-nanosec-times-from-tsc-clock-with.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Sharp <dhsharp@google.com>

With the addition of the "tsc" clock, formatting timestamps to look like
fractional seconds is misleading. Mark clocks as either in nanoseconds or
not, and format non-nanosecond timestamps as decimal integers.

Tested:
$ cd /sys/kernel/debug/tracing/
$ cat trace_clock
[local] global tsc
$ echo sched_switch > set_event
$ echo 1 > tracing_enabled ; sleep 0.0005 ; echo 0 > tracing_enabled
$ cat trace
          <idle>-0     [000]  6330.555552: sched_switch: prev_comm=3Dswappe=
r prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Dbash next=
_pid=3D29964 next_prio=3D120
           sleep-29964 [000]  6330.555628: sched_switch: prev_comm=3Dbash p=
rev_pid=3D29964 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=3Dswapper =
next_pid=3D0 next_prio=3D120
  ...
$ echo 1 > options/latency-format
$ cat trace
  <idle>-0       0 4104553247us+: sched_switch: prev_comm=3Dswapper prev_pi=
d=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Dbash next_pid=3D29=
964 next_prio=3D120
   sleep-29964   0 4104553322us+: sched_switch: prev_comm=3Dbash prev_pid=
=3D29964 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=3Dswapper next_pi=
d=3D0 next_prio=3D120
  ...
$ echo tsc > trace_clock
$ cat trace
$ echo 1 > tracing_enabled ; sleep 0.0005 ; echo 0 > tracing_enabled
$ echo 0 > options/latency-format
$ cat trace
          <idle>-0     [000] 16490053398357: sched_switch: prev_comm=3Dswap=
per prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Dbash ne=
xt_pid=3D31128 next_prio=3D120
           sleep-31128 [000] 16490053588518: sched_switch: prev_comm=3Dbash=
 prev_pid=3D31128 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=3Dswappe=
r next_pid=3D0 next_prio=3D120
  ...
echo 1 > options/latency-format
$ cat trace
  <idle>-0       0 91557653238+: sched_switch: prev_comm=3Dswapper prev_pid=
=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Dbash next_pid=3D311=
28 next_prio=3D120
   sleep-31128   0 91557843399+: sched_switch: prev_comm=3Dbash prev_pid=3D=
31128 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=3Dswapper next_pid=
=3D0 next_prio=3D120
  ...

v2:
Move arch-specific bits out of generic code.
v4:
Fix x86_32 build due to 64-bit division.

Google-Bug-Id: 6980623
Link: http://lkml.kernel.org/r/1349998076-15495-4-git-send-email-dhsharp@go=
ogle.com

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/trace_clock.h |    2 +-
 include/linux/ftrace_event.h       |    6 +++
 kernel/trace/trace.c               |   15 +++++--
 kernel/trace/trace.h               |    4 --
 kernel/trace/trace_output.c        |   80 +++++++++++++++++++++++++-------=
----
 5 files changed, 74 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/trace_clock.h b/arch/x86/include/asm/trac=
e_clock.h
index 7ee0d8c..45e17f5 100644
--- a/arch/x86/include/asm/trace_clock.h
+++ b/arch/x86/include/asm/trace_clock.h
@@ -9,7 +9,7 @@
 extern u64 notrace trace_clock_x86_tsc(void);
=20
 # define ARCH_TRACE_CLOCKS \
-	{ trace_clock_x86_tsc,	"x86-tsc" },
+	{ trace_clock_x86_tsc,	"x86-tsc",	.in_ns =3D 0 },
=20
 #endif
=20
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 642928c..c760670 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -86,6 +86,12 @@ struct trace_iterator {
 	cpumask_var_t		started;
 };
=20
+enum trace_iter_flags {
+	TRACE_FILE_LAT_FMT	=3D 1,
+	TRACE_FILE_ANNOTATE	=3D 2,
+	TRACE_FILE_TIME_IN_NS	=3D 4,
+};
+
=20
 struct trace_event;
=20
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d598ede..e0e7a8d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -484,10 +484,11 @@ static const char *trace_options[] =3D {
 static struct {
 	u64 (*func)(void);
 	const char *name;
+	int in_ns;		/* is this clock in nanoseconds? */
 } trace_clocks[] =3D {
-	{ trace_clock_local,	"local" },
-	{ trace_clock_global,	"global" },
-	{ trace_clock_counter,	"counter" },
+	{ trace_clock_local,	"local",	1 },
+	{ trace_clock_global,	"global",	1 },
+	{ trace_clock_counter,	"counter",	0 },
 	ARCH_TRACE_CLOCKS
 };
=20
@@ -2477,6 +2478,10 @@ __tracing_open(struct inode *inode, struct file *fil=
e)
 	if (ring_buffer_overruns(iter->tr->buffer))
 		iter->iter_flags |=3D TRACE_FILE_ANNOTATE;
=20
+	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
+	if (trace_clocks[trace_clock_id].in_ns)
+		iter->iter_flags |=3D TRACE_FILE_TIME_IN_NS;
+
 	/* stop the trace while dumping */
 	tracing_stop();
=20
@@ -3383,6 +3388,10 @@ static int tracing_open_pipe(struct inode *inode, st=
ruct file *filp)
 	if (trace_flags & TRACE_ITER_LATENCY_FMT)
 		iter->iter_flags |=3D TRACE_FILE_LAT_FMT;
=20
+	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
+	if (trace_clocks[trace_clock_id].in_ns)
+		iter->iter_flags |=3D TRACE_FILE_TIME_IN_NS;
+
 	iter->cpu_file =3D cpu_file;
 	iter->tr =3D &global_trace;
 	mutex_init(&iter->mutex);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 839ae00..0e2c215 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -412,10 +412,6 @@ void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
 int is_tracing_stopped(void);
-enum trace_file_type {
-	TRACE_FILE_LAT_FMT	=3D 1,
-	TRACE_FILE_ANNOTATE	=3D 2,
-};
=20
 extern cpumask_var_t __read_mostly tracing_buffer_mask;
=20
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 123b189..c8d2a60 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -610,24 +610,56 @@ lat_print_generic(struct trace_seq *s, struct trace_e=
ntry *entry, int cpu)
 	return trace_print_lat_fmt(s, entry);
 }
=20
-static unsigned long preempt_mark_thresh =3D 100;
+static unsigned long preempt_mark_thresh_us =3D 100;
=20
 static int
-lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
-		    unsigned long rel_usecs)
+lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 {
-	return trace_seq_printf(s, " %4lldus%c: ", abs_usecs,
-				rel_usecs > preempt_mark_thresh ? '!' :
-				  rel_usecs > 1 ? '+' : ' ');
+	unsigned long verbose =3D trace_flags & TRACE_ITER_VERBOSE;
+	unsigned long in_ns =3D iter->iter_flags & TRACE_FILE_TIME_IN_NS;
+	unsigned long long abs_ts =3D iter->ts - iter->tr->time_start;
+	unsigned long long rel_ts =3D next_ts - iter->ts;
+	struct trace_seq *s =3D &iter->seq;
+	int ret;
+
+	if (in_ns) {
+		abs_ts =3D ns2usecs(abs_ts);
+		rel_ts =3D ns2usecs(rel_ts);
+	}
+
+	if (verbose && in_ns) {
+		unsigned long abs_msec =3D abs_ts;
+		unsigned long abs_usec =3D do_div(abs_msec, USEC_PER_MSEC);
+		unsigned long rel_msec =3D rel_ts;
+		unsigned long rel_usec =3D do_div(rel_msec, USEC_PER_MSEC);
+
+		ret =3D trace_seq_printf(
+				s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
+				ns2usecs(iter->ts),
+				abs_msec, abs_usec,
+				rel_msec, rel_usec);
+	} else if (verbose && !in_ns) {
+		ret =3D trace_seq_printf(
+				s, "[%016llx] %lld (+%lld): ",
+				iter->ts, abs_ts, rel_ts);
+	} else if (!verbose && in_ns) {
+		ret =3D trace_seq_printf(
+				s, " %4lldus%c: ",
+				abs_ts,
+				rel_ts > preempt_mark_thresh_us ? '!' :
+				  rel_ts > 1 ? '+' : ' ');
+	} else { /* !verbose && !in_ns */
+		ret =3D trace_seq_printf(s, " %4lld: ", abs_ts);
+	}
+	return ret;
 }
=20
 int trace_print_context(struct trace_iterator *iter)
 {
 	struct trace_seq *s =3D &iter->seq;
 	struct trace_entry *entry =3D iter->ent;
-	unsigned long long t =3D ns2usecs(iter->ts);
-	unsigned long usec_rem =3D do_div(t, USEC_PER_SEC);
-	unsigned long secs =3D (unsigned long)t;
+	unsigned long long t;
+	unsigned long secs, usec_rem;
 	char comm[TASK_COMM_LEN];
 	int ret;
=20
@@ -644,8 +676,13 @@ int trace_print_context(struct trace_iterator *iter)
 			return 0;
 	}
=20
-	return trace_seq_printf(s, " %5lu.%06lu: ",
-				secs, usec_rem);
+	if (iter->iter_flags & TRACE_FILE_TIME_IN_NS) {
+		t =3D ns2usecs(iter->ts);
+		usec_rem =3D do_div(t, USEC_PER_SEC);
+		secs =3D (unsigned long)t;
+		return trace_seq_printf(s, " %5lu.%06lu: ", secs, usec_rem);
+	} else
+		return trace_seq_printf(s, " %12llu: ", iter->ts);
 }
=20
 int trace_print_lat_context(struct trace_iterator *iter)
@@ -659,36 +696,29 @@ int trace_print_lat_context(struct trace_iterator *it=
er)
 			   *next_entry =3D trace_find_next_entry(iter, NULL,
 							       &next_ts);
 	unsigned long verbose =3D (trace_flags & TRACE_ITER_VERBOSE);
-	unsigned long abs_usecs =3D ns2usecs(iter->ts - iter->tr->time_start);
-	unsigned long rel_usecs;
=20
 	/* Restore the original ent_size */
 	iter->ent_size =3D ent_size;
=20
 	if (!next_entry)
 		next_ts =3D iter->ts;
-	rel_usecs =3D ns2usecs(next_ts - iter->ts);
=20
 	if (verbose) {
 		char comm[TASK_COMM_LEN];
=20
 		trace_find_cmdline(entry->pid, comm);
=20
-		ret =3D trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08llx]"
-				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
-				       entry->pid, iter->cpu, entry->flags,
-				       entry->preempt_count, iter->idx,
-				       ns2usecs(iter->ts),
-				       abs_usecs / USEC_PER_MSEC,
-				       abs_usecs % USEC_PER_MSEC,
-				       rel_usecs / USEC_PER_MSEC,
-				       rel_usecs % USEC_PER_MSEC);
+		ret =3D trace_seq_printf(
+				s, "%16s %5d %3d %d %08x %08lx ",
+				comm, entry->pid, iter->cpu, entry->flags,
+				entry->preempt_count, iter->idx);
 	} else {
 		ret =3D lat_print_generic(s, entry, iter->cpu);
-		if (ret)
-			ret =3D lat_print_timestamp(s, abs_usecs, rel_usecs);
 	}
=20
+	if (ret)
+		ret =3D lat_print_timestamp(iter, next_ts);
+
 	return ret;
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wEAAoJEOdOSU1xswtMV28IAKflwXiP/3QFrWfH14c+szSw
oHTnJY3HDc3ElrnK+7RqBaFY0jAN2XUIn6KHU/JNmfLDFMDyu3Sq9RpEiPxxqvY1
O6eOYnZ8T+gpCgpIWfx9ChIhC9VscxD46R4dJnfbmTSse5IZHN3Bn2T/T+XtPM0A
wLo8Ez38POoX/DgY5KJH+YhWWj8nJA5WPWD0cgO/kmE0a+FjbIA5d/FGJmpehVTs
2WUvPw5rHWLKnoeZPcljJ9pgMTr0gQDlLCmGIdN4NzOcCWwZ6wXuUMVuRcAYlqie
jM/fX/yjI1ZiMTIs4jl2V4hdatv6bgO2OtK0/p0857O/laT7Q8wXbWPL1smCyMo=
=CSO+
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
