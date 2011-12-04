Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1LDTAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:00:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40896 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab1LDTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:10 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=soH2ajQQyi4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=Scopg583AAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=n3Yv3MhLhy3a0x0I4RwA:9 a=PgOFUIcPIoEFqauMDYIA:7 a=QEXdDO2ut3YA:10 a=YudZRJjv1OwA:10 a=Zh68SRI7RUMA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=T83Qai-aHd7HJv5BHIwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111204190002.599581896@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sun, 04 Dec 2011 13:54:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Edward Donovan <edward.donovan@numble.net>,
        stable@kernel.org ("2.6.39+")
Subject: [PATCH 02/11] genirq: fix regression in irqfixup, irqpoll
References: <20111204185444.411298317@goodmis.org>
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

iQIcBAABAgAGBQJO28MyAAoJEIy3vGnGbaoA61IQAJl+l7oQkA5wS3kSPfvCUzk8
IycVSVNbGPuK0saqkaDCSKmGGj9jtAwKfPKKSDp27sLajQvJbVyVDpry4O37AKwY
KP7NVt3OW1QI0SWM7Sqipe8P8Qgf5LZplQwV4hhEyfDdPIoKWMcDSFX0lr4NCNaJ
0KHb2VZu7kEwLP9n20YWZgrgMzJbEdHQFRpxLFntGzkXl5qCQJYgEoWhNdMDWNA3
BroIZlW9mvoZHUhIvGEQqfFS0o9XuZAFlrj3YhxbAK9BCe19zsk4Qm6w03WQjyJX
+JtJ3IW6SzdRVqiekZxOEIW39heL1pOv7qsBpRf//UPr5j3I47gww3k0glh5yWMw
QzgIWYsFf4JOjGTKZuF2K3zDKIHkkePFxVyx7ddJZK6KzLiAikdH0i1hgHjzApA9
U1NwWwSGqvyfdYhPKCeaNk2x/c0T9En1kLw+729ADCgzavAMUpOzqdEKQlc7QYrm
1Pvm0qvcPXgpIMSTvWlRlyGjRdR1vFZTrNPChzNVomr+h8Tf48H03q0wv8q/Mw6K
hYbMCoApl7wkjp3Kgk8nqucmjs//8giAbzInLMM5tcMxrC2pwLWmUbiGH8gL2bAV
sdt8o3yY/9tcq7ED6urliCieB9Gc9DVzMIZ0j1qRHAkR2y3TOn+KyEiqDtH4rPyD
T+sFU+W+nVqFRFGc67/o
=wZCa
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
