Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789Ab2KBNi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:38:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998Ab2KBNfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:02 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4sBK6fA3KjUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ganCZYQ3fQAA:10 a=20KFwNOVAAAA:8 a=NScBLMBZN6_eZyQlLGMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=I0E-28y9EIg7w2DZVtIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133459.196907830@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:32:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/22] tracing: Have tracing_sched_wakeup_trace() use standard
 unlock_commit
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Have-tracing_sched_wakeup_trace-use-standard.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The functon tracing_sched_wakeup_trace() does an open coded unlock
commit and save stack. This is what the trace_nowake_buffer_unlock_commit()
is for.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_switch.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_s=
witch.c
index 7e62c0a..b0a136a 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -102,9 +102,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_cpu			=3D task_cpu(wakee);
=20
 	if (!filter_check_discard(call, entry, buffer, event))
-		ring_buffer_unlock_commit(buffer, event);
-	ftrace_trace_stack(tr->buffer, flags, 6, pc);
-	ftrace_trace_userstack(tr->buffer, flags, pc);
+		trace_nowake_buffer_unlock_commit(buffer, event, flags, pc);
 }
=20
 static void
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wDAAoJEOdOSU1xswtMlrsH/0bs/yD55CJ45w+eUFV6oKsD
SLeoSsE7Q0ThxvDk/movYKFXNAmhItYJPUCMVbP7otqij2LawUVzPSoOWLyDlQeL
v8823pdO9fju/UMivMhIsOyVUiWoMOUpJNnnx7T/36rJcWeVgfaDeOyAdpuq4HRE
XXYSeu2dR1NeFhJt+jZWnlq6wQmEy0uSv8rL1bKRD3OLC8j+w3eKswABmY7hhm1d
nfT3bk3D47B3vDrXBb8tsJWG4IYXlxBeYbayyqmOCvR4ImsBzXzS5HOrCdl3m/hq
+oDYJ8Zj4REX0UjCFLDQTY191YUMLBkH7Qu5tIXVetZb6qL1b5tXSelPd3ym6+Y=
=k0hl
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
