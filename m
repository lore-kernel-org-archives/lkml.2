Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755Ab2KBNgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:36:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762194Ab2KBNfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:08 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=_35cMLPAm4kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OvHXHjnsBl0A:10 a=20KFwNOVAAAA:8 a=xTmkAlXm4ev871geS_cA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=wXM8LopmM4Ihf1vtBb8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133501.251584577@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:33:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 18/22] tracing: Remove unused function unregister_tracer()
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0018-tracing-Remove-unused-function-unregister_tracer.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The function register_tracer() is only used by kernel core code,
that never needs to remove the tracer. As trace_events have become
the main way to add new tracing to the kernel, the need to
unregister a tracer has diminished. Remove the unused function
unregister_tracer(). If a need arises where we need it, then we
can always add it back.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   26 --------------------------
 kernel/trace/trace.h |    1 -
 2 files changed, 27 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 599b29a..65b5fc9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -884,32 +884,6 @@ int register_tracer(struct tracer *type)
 	return ret;
 }
=20
-void unregister_tracer(struct tracer *type)
-{
-	struct tracer **t;
-
-	mutex_lock(&trace_types_lock);
-	for (t =3D &trace_types; *t; t =3D &(*t)->next) {
-		if (*t =3D=3D type)
-			goto found;
-	}
-	pr_info("Tracer %s not registered\n", type->name);
-	goto out;
-
- found:
-	*t =3D (*t)->next;
-
-	if (type =3D=3D current_trace && tracer_enabled) {
-		tracer_enabled =3D 0;
-		tracing_stop();
-		if (current_trace->stop)
-			current_trace->stop(&global_trace);
-		current_trace =3D &nop_trace;
-	}
-out:
-	mutex_unlock(&trace_types_lock);
-}
-
 void tracing_reset(struct trace_array *tr, int cpu)
 {
 	struct ring_buffer *buffer =3D tr->buffer;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0e2c215..8301d6d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -410,7 +410,6 @@ void tracing_sched_switch_assign_trace(struct trace_arr=
ay *tr);
 void tracing_stop_sched_switch_record(void);
 void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
-void unregister_tracer(struct tracer *type);
 int is_tracing_stopped(void);
=20
 extern cpumask_var_t __read_mostly tracing_buffer_mask;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wFAAoJEOdOSU1xswtM1cwIAMw0J9fnWJTnZ71KQDcUYRhf
UK7HIGmAajRzn9PX0uBJRfwq0AQPekMKvDGudVf2zwlZPo9zwCIETN7qwW6Eh5Q/
i7sAWUUhFgZs4B1ZT1vIi7XghpmKHwuMEpZzU3s7CgWb2PNXNuyi+b9ja3fpcu4y
u46DOopGvYuBG8NXbWYVP5aMMkP0vwFUlljtfQFoCXIMw+V1MNwXs2iEBQTnQyGr
42UZ6j8awc37jt2yfNTG2+NNT22fsW7+NwTyQT87ljFHIkFr5fEMK+0Shfem44MO
UsQ+QDzFvGndQHzhdE2HnzxnneIzRMtBiZ/PXbtnLgtMRjzFPCaEhEm5cjVfkRk=
=40KO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
