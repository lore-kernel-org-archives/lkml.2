Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1JJNmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:42:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab1JJNlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:47 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=X5HkpzxN330A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=PY17Gt4sfXfoMNNknBEA:9 a=b_Yvu9i6qurNOh7tFbQA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=EmOpybYGQwPVCni8jVYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134145.620847514@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 18/20] tracing: Fix preemptirqsoff tracer to not stop at preempt off
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0018-tracing-Fix-preemptirqsoff-tracer-to-not-stop-at-pre.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If irqs are disabled when preemption count reaches zero, the
preemptirqsoff tracer should not flag that as the end.

When interrupts are enabled and preemption count is not zero
the preemptirqsoff correctly continues its tracing.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_irqsoff.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 667aa8c..a1a3359 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -505,13 +505,13 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller);
 #ifdef CONFIG_PREEMPT_TRACER
 void trace_preempt_on(unsigned long a0, unsigned long a1)
 {
-	if (preempt_trace())
+	if (preempt_trace() && !irq_trace())
 		stop_critical_timing(a0, a1);
 }
=20
 void trace_preempt_off(unsigned long a0, unsigned long a1)
 {
-	if (preempt_trace())
+	if (preempt_trace() && !irq_trace())
 		start_critical_timing(a0, a1);
 }
 #endif /* CONFIG_PREEMPT_TRACER */
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYZAAoJEIy3vGnGbaoApQUP/0v1KBo4mQHD9J8+M+zwn/TK
l5f9I2Yxdp9771ZjKkh9oExFZ2ItlkZgkGeegLBo4uIw4ORV7qf5Ko6YcXLTifGc
v/CdjPKKuRU/ZhjpM807PQhIdmEVWop0rNSVfprTw2Nvse8VrGdvJi4ERvlxglph
kCrL0AZaUVPnYL1X/d/CD3e51ivH7enqa75LbzTG0Zbb9G/ikulFexN3gjZqK6t4
hzXIrEz2VsOokY9oqZfCKjBy5dpS2NnE43Gdc1nKu1rTZmavU2PwqFAn42B23PBB
uGc67XHkmRLE3RbrHa1oFpKDtg94ah8y1XvtmNZvpDWQg8gPiDVpq73nB6ETFZsQ
tDHaS8Ovrj0npMDhwsq3Ace04MJLshg4rY6r+0EByg4z8kcaZAtNdZh8s1p4UA/k
9zkWXmXgY64ls+9XpEblVZGbDyIfQRy1n+5ei5vd67gfmU6StalYM9dmAxRnk0pB
RwecueGMIQ6V10F3ts1NFNUdqGZ1Ol3rmefIPaYihGG3WaZ1neCxM00aNwflwgn6
xYz4eh7E5vFWOCzuqPkQxXldPDFpJ5fSP+y9JfLDDWhAYbnmYhvMZN0AHXAt+Ja2
jXhyaQLsHkxvl2vWcFWb4frhLht4P4ugSuvB9KwplTIKken0xyIQrv1KFSLd3PUL
tZH+ri/qjoIVksDA6LzH
=Kmz3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
