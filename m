Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934603Ab2KBSPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:15:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934334Ab2KBSOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:35 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=y_zD4AAgMZsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=RaXdcHgNDvUA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=TgJG3LqQqHbs6aKwffAA:9 a=QEXdDO2ut3YA:10 a=aBoZ2TYS_3EA:10 a=UTB_XpHje0EA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=G1C8RtGmQQTamidhk5wA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181431.934089002@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 12/19] tracing: Reset ring buffer when changing trace_clocks
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-Reset-ring-buffer-when-changing-trace_clocks.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Sharp <dhsharp@google.com>

Because the "tsc" clock isn't in nanoseconds, the ring buffer must be
reset when changing clocks so that incomparable timestamps don't end up
in the same trace.

Tested: Confirmed switching clocks resets the trace buffer.

Google-Bug-Id: 6980623
Link: http://lkml.kernel.org/r/1349998076-15495-3-git-send-email-dhsharp@go=
ogle.com

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 88111b0..6ed6013 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4073,6 +4073,14 @@ static ssize_t tracing_clock_write(struct file *filp=
, const char __user *ubuf,
 	if (max_tr.buffer)
 		ring_buffer_set_clock(max_tr.buffer, trace_clocks[i].func);
=20
+	/*
+	 * New clock may not be consistent with the previous clock.
+	 * Reset the buffer so that it doesn't have incomparable timestamps.
+	 */
+	tracing_reset_online_cpus(&global_trace);
+	if (max_tr.buffer)
+		tracing_reset_online_cpus(&max_tr);
+
 	mutex_unlock(&trace_types_lock);
=20
 	*fpos +=3D cnt;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2IAAoJEOdOSU1xswtMFGwH/A5qcyNbFpQe4ayYzwsxZvGA
4gyA4z0CCd6tiKfidzII/9qR8Qb0wPEGFjAiJO1tgRubH97RyNxC//4/D0XTbk2E
u7PmHoVVfEujvZ/NSuNDxgtsjr4ODZvvNXnekpjUdzOAqQlvn2LosGcmPYGJPqyv
fku+rTiFqYKdNM7ZJeou7veZw0odSHiBKgUCJ7K1WidDbwOaFjEWO6Tj8ddlqx5X
YfovJxrR9TkHHzG7Limr+26k4YJiKe++1rOphhwkBzfdzQFwc5ELjDAxysxBBbbI
kTIMOyrJ6rUYMyj6Tjw7PTmg8U1emWJ49JoPejYfd67IxZiGvYwDuj0mwzMATzc=
=S0aV
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
