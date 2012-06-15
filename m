Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab2FOBEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:04:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2FOBDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:03:40 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=WYgrp5RFnWoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=xqPperEbOc1BrG7CF0sA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=py1D0jqhPT4ovLKgul8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120615010338.377961366@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 14 Jun 2012 21:01:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] tracing: Register the ftrace internal events during early boot
References: <20120615010123.722084844@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Register-the-ftrace-internal-events-during-e.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

All trace events including ftrace internel events (like trace_printk
and function tracing), register functions that describe how to print
their output. The events may be recorded as soon as the ring buffer
is allocated, but they are just raw binary in the buffer. The mapping
of event ids to how to print them are held within a structure that
is registered on system boot.

If a crash happens in boot up before these functions are registered
then their output (via ftrace_dump_on_oops) will be useless:

Dumping ftrace buffer:
---------------------------------
   <...>-1       0.... 319705us : Unknown type 6
---------------------------------

This can be quite frustrating for a kernel developer trying to see
what is going wrong.

There's no reason to register them so late in the boot up process.
They can be registered by early_initcall().

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index df611a0..123b189 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1325,4 +1325,4 @@ __init static int init_events(void)
=20
 	return 0;
 }
-device_initcall(init_events);
+early_initcall(init_events);
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP2onqAAoJEIy3vGnGbaoASlEP/2nKiaS6LxWpyRrluVBrcBY3
YGIw5BdkkOoqJwwHMT7Eurt3APb0xtDcyOOUiTng5Hq5w0abHMb+gWmWz9bSFw7K
O4jqrGl2569vB+7RXI3Kxm2lNd/ToXDHMOkWrUXy3XpjDZK6sYMeYUvu6VoMEsv9
knIFMWgmslU4ydTEJvfxFsn/uFyVa7Dvki6CPdMCVHST7u3X/WY0cS84ncbmpMF5
1j3cqjqx70m9+G89AeZ5vMyRx+5Ytl89+34dR0SdjVrlIbzr/8A6jig1wYW6ZVL2
L+K1au+yMmHnuig3Id6PE1C81X+A7umVm4gQnWSif/FuRz3S47WFa5NMMivQvy/w
juYqLNBW/1Hiobkw7Dlu6E1b5cY6QMP1TO5KV0D4Hi2eod6/HiHIUnyQSVuZ5tZy
sekMCal7Q/WKIQrEzOq37sk9dOvE4sNlOj0ZMV4XstveeJxygdpqzFJY4Gf00zkN
OEKpUIXcxgsZhchb6NB/krMncMBfeI/HjlLzTOfSChhZ2zTzUbiN7v5DTxqfcW8c
yG9FTqkZdCIpm4kzc9gsr6p0EjuaL063YvAZ9qwMhZuLuc73DaMZztFkV+S9xzMh
cM/wK0d7xHbnf2WCJHR/34zwtNm+PpREa/IZampM7dtJ8SoKBcXC7qNzHPRi8ADA
ZVdKLsipPDRLZHjQIldG
=tEJs
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
