Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1LCBrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:47:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab1LCBrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:47:45 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=yTRiKB6edxQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=Scopg583AAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=n3Yv3MhLhy3a0x0I4RwA:9 a=PgOFUIcPIoEFqauMDYIA:7 a=QEXdDO2ut3YA:10 a=YudZRJjv1OwA:10 a=Zh68SRI7RUMA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=2hK06Ys4sc0Ya_EtQx8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203014741.569973127@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:46:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Edward Donovan <edward.donovan@numble.net>,
        stable@kernel.org ("2.6.39+"),
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 02/10] genirq: fix regression in irqfixup, irqpoll
References: <20111203014641.165123482@goodmis.org>
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

iQIcBAABAgAGBQJO2X+9AAoJEIy3vGnGbaoAnVEQAK5rVOASxIRNo2irtX3dHzQv
d4Ljq/CvR0q2EmB1KWjeDpd5LMg7bEKuq3t0Ke8THSGOY6u1WrJLT28uQTwQ9i+b
Tqphww5iaMyCxWaVndiJsNkACLEyLBZJy6WQhPXhY1aeOwpD1qaoALRCq2f0QIKv
UfuMnYC9SXpAO6d7hN+oAXYGp/lAfqHiQw7NAAt+Maze839oYmCphQvLdOAtk9Aq
qcmOPI+nDMaYbtvjBrkLoa2Jr8YFOdKRdrVyV0h/nm03o+TJqaVCz8C9/jhwlHk9
adRK9XNz0v0od/qhNulDqpBNvcsYlYzxs76mhALjzNCCj9wuut0CpapNZ2JtIT1N
paxsHflpGY2RM76LdYiaCFR109QU6SC9nWy8NskQqLdAFWObTZ3cXnQiymESb1ik
u3LCL1/ox+RekKD23TRq59qXnHMxaM/foPiMWnmPXcMqdu9rr+596EJRD171FL1A
mWXXTKqKdoGiXDf/yx2Z3e8XTUdW776sbKY4tZcPrjs/fC3cXple6+UtYITX/NHS
RVcgRXPPsbsO2rKiiq1mEexRCtrSkXXv1l4hqUXwrF4yE+YYWvXUWMoATmlCjb45
3gytd5eN5jDdX7cHLNrFcRPi+xzv8CnNB8SMOSVr0Fw3qL5B1+cJ6N3krT2sNU9a
i7Cp/W/Ure3G9aDwTWUC
=7o9s
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
