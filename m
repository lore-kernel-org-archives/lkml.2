Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793Ab2KBNhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:37:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761181Ab2KBNfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:04 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=UUALxtUs0nsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=RaXdcHgNDvUA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=TgJG3LqQqHbs6aKwffAA:9 a=QEXdDO2ut3YA:10 a=aBoZ2TYS_3EA:10 a=UTB_XpHje0EA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=h4wISTTLcWZLhp3VAlMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133500.337156347@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:33:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 13/22] tracing: Reset ring buffer when changing trace_clocks
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-Reset-ring-buffer-when-changing-trace_clocks.patch
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
index d7d6c52..d598ede 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4074,6 +4074,14 @@ static ssize_t tracing_clock_write(struct file *filp=
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

iQEcBAABAgAGBQJQk8wEAAoJEOdOSU1xswtMj6kH/2VeJihYmGA1XWsiCwAy55wb
eQgMkW0sIGtixYsPLAuwPg6Q7xx72vwBw50Igfq02nx8A1evpdN9oeb4xX3mVTOu
rUPKgvmI2CvYdd8r7xvwIjbWvzZBHy6QLqYfnQ/XwkIFPuZwNel78BHLu/ds/x1A
jPD5L4HqIM7If9aelbR30YetaBzNUZRszVY6GyjDdkKY/PMWltyffBgXWqwCfkP9
CnTFURwXs5rB0BEaGbrEJSOlp3doAdvs+wzSiBalX7r0VmrFqTHhTaCRGc7LppL5
TxTucZIIXXxOo3/LtX1/XAYUSdmjCiVM1KDS2D4sOAqn3TWXoZ8IqtHVrBYx3OU=
=zCf/
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
