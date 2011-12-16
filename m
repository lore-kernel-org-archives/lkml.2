Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1LPXGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:06:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35948 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760965Ab1LPXGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:06:17 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=9Eu-n8KfqFYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=WfulkdPnAAAA:8 a=meVymXHHAAAA:8 a=xMw-xWDpt8kuUQIESIkA:9 a=Mljc0igdFrOWSPI8JDkA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=rsL0JgEmX32GWOTPpAkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111216230614.461932921@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 16 Dec 2011 17:59:08 -0500
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
Subject: [PATCH 2/6] x86: Document the NMI handler about not using paranoid_exit
References: <20111216225906.481643317@goodmis.org>
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

iQIcBAABAgAGBQJO687mAAoJEIy3vGnGbaoAJqkQALZdrvvMg14QzXm7i/ffW3Q+
eu2JbNQbn+fuT9k2YIjqJZn/Lkb5fH24WVAnQqQyYojzKubGhPlZOchDNnkwCXYR
AOl0MB1g6jxNgZ/ZzFrEwAvg9XHPxCGSl6PC5UQETH0R7jkohOmzQJOQ9WaKrSSh
rc+dwUf5uWBrDujYUx7y5CF4mxGaM8u5q68sGuICiJYrSzz3g1Q2Y5KVSxz8KAg2
/asPovDx2F49ebLuCe26jv+Yigu6+Bu/Ixl1Vp4Z1CDoSURb2tXprRoHmYzuNIbU
3W1VFtMkjAcTiv1dI6GXuOmaBnopxVJYfTSRJ2NlCdCEbY5a7rP08xbKUSuxQJ9N
xk8RoqgQGdzJOsgL1JLdnNsVAm+KtETroto0CNF4Ymv6lCpTnt+CSYijjcfgZRf2
2hoAmZVqLvpqkdoaucNBufVGxbETTYDf6PxTY20gs9Jl9eIHorlQ3ipG631navwY
JPN5oD2hU+n0lL9tGHKtn5NDZ8OyXiVo1M2VFbi1O02bXGOziZv58lgJDtuWtj+K
pBbx+R4T07NPl9JNFwXXb87t52v8Ped07gadVM0hxcV0J6WpuGEoYs0P6iCDoCW0
o5iIhCvjyo638+zKQ1AezwnPkYt3R1OLtikrtvKcfFaZR3mI/1cL7c6BbRo1dNQl
wBBjt55fwKBhBETcHImI
=t33F
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
