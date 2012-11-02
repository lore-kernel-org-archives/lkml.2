Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781Ab2KBSRC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:17:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18827 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934232Ab2KBSOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:34 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=v4ulaLF1MHUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ganCZYQ3fQAA:10 a=20KFwNOVAAAA:8 a=NScBLMBZN6_eZyQlLGMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=JTCHrAgd2eIJ2LFmxI8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181431.031622010@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/19] tracing: Have tracing_sched_wakeup_trace() use standard
 unlock_commit
References: <20121102181331.513782854@goodmis.org>
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

iQEcBAABAgAGBQJQlA2HAAoJEOdOSU1xswtMpl4H/i0x98a1Jr3ksFrLkb48/Put
ACUhcVzGZrLiKihJ2XbznWgIowjo2x/Lf8ehKOOKE37Rgf0iXHIApIsksq8irZmA
Z9ov4fdoMMyL4H8VXB2XeLbOr8wJ332pG8QHxbyI75G70BENsvCPqeS9tXbZtJX7
DRnQt4evcmNhdOGHm74/yNSvW5fZ11nByJnX7sefo+OBUc+tzA+YhqhWQ+gSpGf3
HYj6UgqbWJ/60dERqiBox7RNDyYcFTeM4uRq5Wap/xifVej7pVFbYacuIpU7nmST
IWv9PQZa9/4oVRBeEnj381o9Mjda/Bp2Ox9FoCSVIoS1ki52Fo+8wawxyh01IYk=
=WzXx
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
