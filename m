Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1KHBa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:30:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab1KHBam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:42 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=6VAA3esN-JUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=NhtBtEL0z_mfO4uRI8AA:9 a=gkxmORsVIG5pEmYEuHwA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=TnI-X32I2Ns1GUGET3sA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013040.631725481@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/10] tracing/latency: Fix header output for latency tracers
References: <20111108012939.372220547@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-latency-Fix-header-output-for-latency-tracer.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

In case the the graph tracer (CONFIG_FUNCTION_GRAPH_TRACER) or even the
function tracer (CONFIG_FUNCTION_TRACER) are not set, the latency tracers
do not display proper latency header.

The involved/fixed latency tracers are:
        wakeup_rt
        wakeup
        preemptirqsoff
        preemptoff
        irqsoff

The patch adds proper handling of tracer configuration options for latency
tracers, and displaying correct header info accordingly.

* The current output (for wakeup tracer) with both graph and function
  tracers disabled is:

  # tracer: wakeup
  #
    <idle>-0       0d.h5    1us+:      0:120:R   + [000]     7:  0:R watchd=
og/0
    <idle>-0       0d.h5    3us+: ttwu_do_activate.clone.1 <-try_to_wake_up
    ...

* The fixed output is:

  # tracer: wakeup
  #
  # wakeup latency trace v1.1.5 on 3.1.0-tip+
  # --------------------------------------------------------------------
  # latency: 55 us, #4/4, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
  #    -----------------
  #    | task: migration/0-6 (uid:0 nice:0 policy:1 rt_prio:99)
  #    -----------------
  #
  #                  _------=3D> CPU#
  #                 / _-----=3D> irqs-off
  #                | / _----=3D> need-resched
  #                || / _---=3D> hardirq/softirq
  #                ||| / _--=3D> preempt-depth
  #                |||| /     delay
  #  cmd     pid   ||||| time  |   caller
  #     \   /      |||||  \    |   /
       cat-1129    0d..4    1us :   1129:120:R   + [000]     6:  0:R migrat=
ion/0
       cat-1129    0d..4    2us+: ttwu_do_activate.clone.1 <-try_to_wake_up

* The current output (for wakeup tracer) with only function
  tracer enabled is:

  # tracer: wakeup
  #
       cat-1140    0d..4    1us+:   1140:120:R   + [000]     6:  0:R migrat=
ion/0
       cat-1140    0d..4    2us : ttwu_do_activate.clone.1 <-try_to_wake_up

* The fixed output is:
  # tracer: wakeup
  #
  # wakeup latency trace v1.1.5 on 3.1.0-tip+
  # --------------------------------------------------------------------
  # latency: 207 us, #109/109, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:=
2)
  #    -----------------
  #    | task: watchdog/1-12 (uid:0 nice:0 policy:1 rt_prio:99)
  #    -----------------
  #
  #                  _------=3D> CPU#
  #                 / _-----=3D> irqs-off
  #                | / _----=3D> need-resched
  #                || / _---=3D> hardirq/softirq
  #                ||| / _--=3D> preempt-depth
  #                |||| /     delay
  #  cmd     pid   ||||| time  |   caller
  #     \   /      |||||  \    |   /
    <idle>-0       1d.h5    1us+:      0:120:R   + [001]    12:  0:R watchd=
og/1
    <idle>-0       1d.h5    3us : ttwu_do_activate.clone.1 <-try_to_wake_up

Link: http://lkml.kernel.org/r/20111107150849.GE1807@m.brq.redhat.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              |   15 +++++++++++++++
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |   13 ++++++++++++-
 kernel/trace/trace_sched_wakeup.c |   13 ++++++++++++-
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b24a72d..b296186 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2140,6 +2140,21 @@ enum print_line_t print_trace_line(struct trace_iter=
ator *iter)
 	return print_trace_fmt(iter);
 }
=20
+void trace_latency_header(struct seq_file *m)
+{
+	struct trace_iterator *iter =3D m->private;
+
+	/* print nothing if the buffers are empty */
+	if (trace_empty(iter))
+		return;
+
+	if (iter->iter_flags & TRACE_FILE_LAT_FMT)
+		print_trace_header(m, iter);
+
+	if (!(trace_flags & TRACE_ITER_VERBOSE))
+		print_lat_help_header(m);
+}
+
 void trace_default_header(struct seq_file *m)
 {
 	struct trace_iterator *iter =3D m->private;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 092e1f8..f8ec229 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -370,6 +370,7 @@ void trace_graph_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
+void trace_latency_header(struct seq_file *m);
 void trace_default_header(struct seq_file *m);
 void print_trace_header(struct seq_file *m, struct trace_iterator *iter);
 int trace_empty(struct trace_iterator *iter);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index a1a3359..a248c68 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -280,9 +280,20 @@ static enum print_line_t irqsoff_print_line(struct tra=
ce_iterator *iter)
 }
=20
 static void irqsoff_graph_return(struct ftrace_graph_ret *trace) { }
-static void irqsoff_print_header(struct seq_file *s) { }
 static void irqsoff_trace_open(struct trace_iterator *iter) { }
 static void irqsoff_trace_close(struct trace_iterator *iter) { }
+
+#ifdef CONFIG_FUNCTION_TRACER
+static void irqsoff_print_header(struct seq_file *s)
+{
+	trace_default_header(s);
+}
+#else
+static void irqsoff_print_header(struct seq_file *s)
+{
+	trace_latency_header(s);
+}
+#endif /* CONFIG_FUNCTION_TRACER */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
=20
 /*
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index e4a70c0..ff791ea 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -280,9 +280,20 @@ static enum print_line_t wakeup_print_line(struct trac=
e_iterator *iter)
 }
=20
 static void wakeup_graph_return(struct ftrace_graph_ret *trace) { }
-static void wakeup_print_header(struct seq_file *s) { }
 static void wakeup_trace_open(struct trace_iterator *iter) { }
 static void wakeup_trace_close(struct trace_iterator *iter) { }
+
+#ifdef CONFIG_FUNCTION_TRACER
+static void wakeup_print_header(struct seq_file *s)
+{
+	trace_default_header(s);
+}
+#else
+static void wakeup_print_header(struct seq_file *s)
+{
+	trace_latency_header(s);
+}
+#endif /* CONFIG_FUNCTION_TRACER */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
=20
 /*
--=20
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIZAAAoJEIy3vGnGbaoAmpAP/3tHwgLvSG3N5LMPWXvtH4Ez
tj6VPYI+gInaQbHIqPClmg7904NyoQzQcyh+D61xF4EarkqBtGlnTV4//yfPeBgd
r218WKV0R9c6T2Ur4Zcn9FE8cfOCn7pRAmnQvsW4EHDQ76RjG6VkiegSO7vCm3q9
WK0DrVCCvpUkBkFT/xx+KW/Gmii7KI9Ap5B85Bcnf3y7NCrhfVO/QmHqFDzeay7s
JvZH/Zwld5wUNDRZjRaobBOY17rHmgAeJk/pDhcn3v4LhPIWFXgrK8jaIvlJv3C7
H0OvzbW0QD3K0bHL6Q4A5JRugQsW6w9R1dZe8G6y65ds1OjvHiQ/NoQrGCp6Cr/1
778wcF9H5hYLJ1Epmr5AhYMae4A4kS/WGgXEkpe0kaX52eJ+n7Ay1FT/zbKCfiIX
5tylTQHSgxYEtCSqxkOdZmRQnAbQqh6NPZS0+wzKZH+ng/jiQ+wGQ+1kPrwqAGX0
7uDwItlVAdW32D4XPKegwbECHDHLkmIVionT5AEYCHWBIKBJI2yGHQm2m8GKcXE7
KgTNupm4nR81daNGnR3jx/iDHPzXzWEL+ZmG3Xpj/R5v96V6NJtp6684ianG3szP
TH4kEatX10xXUrAWFbKgRqa4+Be7p7+wCzI8whqOaibDe3D82To2x/yhPBohN/pn
1FycPqbviqr7SOia2l50
=sTO3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
