Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab1LEXC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:02:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab1LEXCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:02:53 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=ROuX91PNEugA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=Scopg583AAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=n3Yv3MhLhy3a0x0I4RwA:9 a=PgOFUIcPIoEFqauMDYIA:7 a=QEXdDO2ut3YA:10 a=YudZRJjv1OwA:10 a=Zh68SRI7RUMA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=ivm5OkYmNu6OQY86ciAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111205230250.165366297@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 18:00:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Edward Donovan <edward.donovan@numble.net>,
        stable@kernel.org ("2.6.39+")
Subject: [PATCH RT 02/12 rc3] genirq: fix regression in irqfixup, irqpoll
References: <20111205230046.736851081@goodmis.org>
Content-Disposition: inline; filename=0002-genirq-fix-regression-in-irqfixup-irqpoll.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Edward Donovan <edward.donovan@numble.net>

Commit fa27271bc8d2("genirq: Fixup poll handling") introduced a
regression that broke irqfixup/irqpoll for some hardware configurations.

Amidst reorganizing 'try_one_irq', that patch removed a test that
checked for 'action->handler' returning IRQ_HANDLED, before acting on
the interrupt.  Restoring this test back returns the functionality lost
since 2.6.39.  In the current set of tests, after 'action' is set, it
must precede '!action->next' to take effect.

With this and my previous patch to irq/spurious.c, c75d720fca8a, all
IRQ regressions that I have encountered are fixed.

Signed-off-by: Edward Donovan <edward.donovan@numble.net>
Reported-and-tested-by: Rog=C3=A9rio Brito <rbrito@ime.usp.br>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org (2.6.39+)
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/irq/spurious.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index bfe1004..d09e0f5 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -84,7 +84,9 @@ static int try_one_irq(int irq, struct irq_desc *desc, bo=
ol force)
 	 */
 	action =3D desc->action;
 	if (!action || !(action->flags & IRQF_SHARED) ||
-	    (action->flags & __IRQF_TIMER) || !action->next)
+	    (action->flags & __IRQF_TIMER) ||
+	    (action->handler(irq, action->dev_id) =3D=3D IRQ_HANDLED) ||
+	    !action->next)
 		goto out;
=20
 	/* Already running on another processor */
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3U2aAAoJEIy3vGnGbaoAwSkP/3eccOCoTn+jyWWcWu2LDVqt
/5XANWMG7Ry1Yc87AzH0nB2HQ6tGjPcHgAcYOejwudvlzqMcA0NS740Dkhkk1Clc
VOsG93lMgSqBhJgpkK9TmOWHraXn5zI4ORR5Rmjx6etXECBB4hNi7/grvynKCpYh
3LTH5MTdcpaOvyUdc3D8zJgaYAzdfq3RvwROuQrVOgFIKR0W3r1qo1KhD597pvUh
HFTJDHhANl6pmTj+3XM6UGw5Y1Sa3w3MNPBdiMjXJhiLwMm+kogfP9lcUmsyEdPi
JWf/tiEoqM2bv2utWMYKkEv2PwsJL8lLlpWflhYb15Cw5cvI+jUdzJTot9z3ViTC
mNGNmxERQNsnlaSzMkZGPfNddI1Fwb2hRrIHJgg7HNmZywO4EqeYhc9HI1N+k1VP
yZln21kK5+eKp8t+sdE5PMyb/77DHkyKR/VWvuLLaiZ3HmJd+zhET/POhSXenmiE
2Ec2zY+xgP0gmKKn46BvdmA1DktPxYYrxSkEHdh4iZdYloaxNH9KJPXrFDiO9I/9
MZMg5WX7YM29dxLk/Y+7U2XSxxGouY6gZgzww1MR7hrW0bQnFGd1pzlPkMcgavNy
Z3vYYzC4NIcLsdBX8Lxz8tpB5jn7Ei8OIYUCJ+s6G6Pde5Lc0wa3AC8njH9NbC48
Q7noF69VkuYW1JrbhCve
=ZIKv
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
