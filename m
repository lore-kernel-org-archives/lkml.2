Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509Ab2CNQ1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:27:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759788Ab2CNQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:27:13 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=-8ZUZ03paj4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=rMmU4aD2UK3NG_EXmIsA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rS5H_3uvNq6Sho21f0AA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314162709.323685292@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 14 Mar 2012 12:26:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/6] tracing: Fix build breakage without CONFIG_PERF_EVENTS
References: <20120314162629.118638243@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Fix-build-breakage-without-CONFIG_PERF_EVENT.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Today's -next fails to build for me:

  CC      kernel/trace/trace_export.o
In file included from kernel/trace/trace_export.c:197: kernel/trace/trace_e=
ntries.h:58: error: 'perf_ftrace_event_register' undeclared here (not in a =
function)
make[2]: *** [kernel/trace/trace_export.o] Error 1
make[1]: *** [kernel/trace] Error 2
make: *** [kernel] Error 2

because as of ced390 (ftrace, perf: Add support to use function
tracepoint in perf) perf_trace_event_register() is declared in trace.h
only if CONFIG_PERF_EVENTS is enabled but I don't have that set.

Ensure that we always have a definition of perf_trace_event_register()
by making the definition unconditional.

Link: http://lkml.kernel.org/r/1330426967-17067-1-git-send-email-broonie@op=
ensource.wolfsonmicro.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ce887c0..95059f0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -836,13 +836,11 @@ extern const char *__stop___trace_bprintk_fmt[];
 		     filter)
 #include "trace_entries.h"
=20
-#ifdef CONFIG_PERF_EVENTS
 #ifdef CONFIG_FUNCTION_TRACER
 int perf_ftrace_event_register(struct ftrace_event_call *call,
 			       enum trace_reg type, void *data);
 #else
 #define perf_ftrace_event_register NULL
 #endif /* CONFIG_FUNCTION_TRACER */
-#endif /* CONFIG_PERF_EVENTS */
=20
 #endif /* _LINUX_KERNEL_TRACE_H */
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPYMbdAAoJEIy3vGnGbaoAflUP/24NsvRRP9HZZ7oGDcRsb8R8
yABY4f4PZLg2xAsTvbOdmHFpHealdzXi7WJIfFmfXwiJnpuiPeQLHZr/24JvLP7L
0idaWDE1QL0NxIMUjmYEBn7cWwVg5zDUG5jd0XGsFGMXTMNM1gkf5wN/vK0qRx1g
rjToWEupGyzZMScBInGj4JXqs12pPdib9El3YkaRujO8srzDZrWUBsuuh+fgpEgw
YDfv79+DVrJpOdEMiejZFnSRnbj+pLNK0prLW21ZeL7FbKfgHx2jEIKhILqCOcSa
7RZZPvRw1P2g8CSl3wKOb0nXWnAndyDg9iUeExZsP4A0NKkTw9VcswJklsnVxxmC
OAGhe6pGiwmLXloWXhaUu7lEWw1WYoRMnmxlR2kPlPcJpebKBIXCeeyy6hVJBOFU
UcBOGId2Kd4n42kkvJTlGySVHLM0g56ADh+0f3v1TgCqln/YBLw72WBQjQ/8UDh2
aFAkg1HcypUhbK88rJvIF4i+vEtODmF/+fbRMgzsIhTcNlma0xP/TsRWv8yue1D8
tG7Z/I0Qj2gmBrh5eZ5wMUa2vzf+63zntX2OXMtVXzwxp0zdPnd4/ry1CDEcSt75
aW75hQ2eB8SrY6jnc817PUV7Fz5VYIUplYeiBHBaEcifjCWjfSEW+BdFfvxlDcIt
FTGOYFneu3SshwzRHXuP
=9OLe
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
