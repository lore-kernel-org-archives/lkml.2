Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2DRBFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:05:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2DRBFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:05:43 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=yiglvEkJKfMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=rMmU4aD2UK3NG_EXmIsA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=NBN8T57MxCJvL9qulQoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120418010541.616718610@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Apr 2012 21:05:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] tracing: Fix build breakage without CONFIG_PERF_EVENTS (again)
References: <20120418010505.756823546@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-build-breakage-without-CONFIG_PERF_EVENT.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Today's -next fails to link for me:

kernel/built-in.o:(.data+0x178e50): undefined reference to `perf_ftrace_eve=
nt_register'

It looks like multiple fixes have been merged for the issue fixed by
commit fa73dc9 (tracing: Fix build breakage without CONFIG_PERF_EVENTS)
though I can't identify the other changes that have gone in at the
minute, it's possible that the changes which caused the breakage fixed
by the previous commit got dropped but the fix made it in.

Link: http://lkml.kernel.org/r/1334307179-21255-1-git-send-email-broonie@op=
ensource.wolfsonmicro.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 95059f0..f95d65d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -836,11 +836,11 @@ extern const char *__stop___trace_bprintk_fmt[];
 		     filter)
 #include "trace_entries.h"
=20
-#ifdef CONFIG_FUNCTION_TRACER
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_FUNCTION_TRACER)
 int perf_ftrace_event_register(struct ftrace_event_call *call,
 			       enum trace_reg type, void *data);
 #else
 #define perf_ftrace_event_register NULL
-#endif /* CONFIG_FUNCTION_TRACER */
+#endif
=20
 #endif /* _LINUX_KERNEL_TRACE_H */
--=20
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPjhNlAAoJEIy3vGnGbaoAyp0P/jWa4zEl1hIR7oxBR2LUbM4j
qLv5DQykgBOTwi/oEd5V6JvbttYSIo/gwozRufAvBrk6GgbPniMvMVjxz2oxb3XM
9+FwfIyw2vlo/0vLArEnH+MiqLrdtknej4f9i49hXxboJkN+GDRCsjnifFw9z8ge
hkaOmNyGUKfgcjXynna2T+Tvpqu4ndaZfm2LOMIurX4GUOS/dOzBvuxCAgGZuOi/
Yxb/x0fP4zDfWVzFVOMt9vU3johigP59nzkWeflAiqZCfMvQY0Wg39SOv19KBl/f
CrivuIow/1kIzdvmlU4Qj3CmljLM7AjjG2289/30pNpJm5axZ37mQYB026vt5fTK
50W4CQ9wEl4TrtZ9psvJbe4RUltooiOzRXmmdomBdOibBZ11oaeKUs6llor/ziDm
knfBI4UKg2CHOjolI/1rbAQkXG6e/K/gsfk8AaVYnw5fWry8PYHPhxf8dJ152lFo
Dc5IsM68XCuTVKm2ieLnxQVFGuR0vC+4sr2+pE2a7kOUWJtBZP6/04ZOQ8YilUGs
o816UsLjIE+VZ36NZov1rqG9PUpW6FfJE/kWI4/Np3dr0gYgIXUX6I2srPHCFczH
Qt6k0ZaauvKUlicEjbPptLGQaOZAtAShPvfvunewP/WT4Q9dmXjKWy1BQx1NqMEf
RUWeiGZYdFpakX73NR27
=VkpU
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
