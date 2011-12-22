Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1LVDT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:19:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab1LVDTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:19:53 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=j9Mp8ZKtlQsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=WfulkdPnAAAA:8 a=meVymXHHAAAA:8 a=xMw-xWDpt8kuUQIESIkA:9 a=Mljc0igdFrOWSPI8JDkA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=QAIFVBVWlpLkC-NNMjEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111222031950.658022251@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 22:13:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/6 v3] x86: Document the NMI handler about not using paranoid_exit
References: <20111222031357.120841629@goodmis.org>
Content-Disposition: inline; filename=0002-x86-Document-the-NMI-handler-about-not-using-paranoi.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Linus cleaned up the NMI handler but it still needs some comments to
explain why it uses save_paranoid but not paranoid_exit. Just to keep
others from adding that in the future, document why it's not used.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3819ea9..d1d5434 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1480,9 +1480,16 @@ END(error_exit)
 ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq_cfi $-1
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
+	/*
+	 * Use save_paranoid to handle SWAPGS, but no need to use paranoid_exit
+	 * as we should not be calling schedule in NMI context.
+	 * Even with normal interrupts enabled. An NMI should not be
+	 * setting NEED_RESCHED or anything that normal interrupts and
+	 * exceptions might do.
+	 */
 	call save_paranoid
 	DEFAULT_FRAME 0
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8qHWAAoJEIy3vGnGbaoAvikP/itD5u0060NPew+4n2uRjZrP
DCjKRhVQXPZ5dAEKsqs59UmnoforOTLSALBDBaIogEsO8wbBiWIz9FVeh/4PP3kv
bpnIiu8sUqVWe2OYkbBh+UJuet1CcSUnGBN71rxBjPsD3tkX9oBbwXjVzE+rElEC
LSACsJYsIyopOSHjhSUKTugE+fWOYj1e4t0e+Ak7WTCob9w2+4N5lmcN5qXnZj1w
N/OAhQv4CoMdeU63EL+G/qbXYfw2nj32ur1PLYBLFCJB6/O2Ia1RRLBPpDww32tA
GeD6RCeW2g32Kv8w7dl+yDMlMw+chSya9l0EEd3FYqfYXsVlbidNsO18ItPy/+Ar
vV1CdFLDkg4uhve8CLdZeO54/9ErZsWApghggAX4YyZF5k9SskZZGjBcJiJ9kchQ
s20PuqaZ2BcnrlYNqlkQet2BlnswxhyFlMeOLMGkA3IjnvrjY7Yes45+QPE9aL9N
gg/UL5WkGjje8XmC9DGXJL2DYGm/hEQ1cHev5JoQSAs6LOQjil8q4qKtx1RF6E2W
BZ4K0QD9tfCW3sPQa1OuVuJc/Ah4BCf+vGDxGHZGurjSzQH0pmJRlDmpQ+YxRF05
h5VRWGQLq9Kdv3MyAuR7Ved0UuNzW6XyBTAjTiJJE36VBwxJPjIVpOCE5j4rking
0l862c4NQHhi+QDBBpWd
=vyH1
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
