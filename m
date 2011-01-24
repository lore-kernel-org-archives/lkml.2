Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1AXPBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:01:14 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57654 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1AXPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:01:12 -0500
X-Spam-ASN: 
Date: Mon, 24 Jan 2011 18:00:57 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PPS parport boot lockup: INFO: HARDIRQ-READ-safe ->
 HARDIRQ-READ-unsafe lock order detected
Message-ID: <20110124180057.4c0e7b49@desktopvm.lvknet>
In-Reply-To: <AANLkTi=p3=MkGevrW1YU0v_V5iXLw7iLDuWeb7Rf8Xx_@mail.gmail.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	<20110119083916.GA2166@elte.hu>
	<20110121174438.7521539f@tornado.gnet>
	<AANLkTi=p3=MkGevrW1YU0v_V5iXLw7iLDuWeb7Rf8Xx_@mail.gmail.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/P_IFKvyjBwb7BLmDhKKdUKQ"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/P_IFKvyjBwb7BLmDhKKdUKQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Fri, 21 Jan 2011 08:37:34 -0800
Linus Torvalds <torvalds@linux-foundation.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=
=82:

> On Fri, Jan 21, 2011 at 6:44 AM, Alexander Gordeev
> <lasaine@lvk.cs.msu.su> wrote:
> >
> > But parport_unregister_device should probably never be called while
> > parport interrupts are enabled (in hardware). So this is a false
> > positive. Is this right?
>=20
> "Enabled in hardware" is immaterial - with shared interrupts, it
> doesn't matter one whit whether parport interrupts are disabled on the
> chip, because some other chip may be using the same interrupt line.
>=20
> So you'd need to have something that guarantees that there is no
> concurrent use, like actually unregistering the irq handler itself.
> Things like that can work.
>=20
> HOWEVER, even then I think you should see the lockdep message as a
> problem. The automated toolchain is great because it shows problems
> that it thinks might happen - not when they happen, but based on a
> simpler theoretical model. Ignoring the error because there is some
> rule in place that is hard to explain to the automated toolchain is
> the wrong thing to do, because it makes the lockdep automation less
> reliable.
>=20
> Think of it as a compiler warning - maybe the warning doesn't actually
> imply an actual bug, but you should strive to write code that doesn't
> warn, because otherwise the noise from the warning you ignored will
> make it harder for others to see the _real_ bugs.
>=20
>                  Linus


Ok, thank you very much for clarification!
I'll send the patch as reply to the first e-mail.

--=20
  Alexander

--Sig_/P_IFKvyjBwb7BLmDhKKdUKQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNPZQqAAoJEElrwznyooJbA48H/1mScxYuFuuvO7XfXvGbGJL/
8I6IA19XOK8FhcjKcGHp1C3w/DTgMTe+QzarjFFx1dyRaNO2J76RMX+/ZKEmfZk3
rLZge5yT9VWcp8BY/4ip2KGPr7kBHizYyXWF2ojRNnvChgJsYRuGoVwaIK2GddTb
GBG+Kq+qtTv6lqsAKvcmA+MpMDxkzi282tHau60+NlcioqIQDR/8xG6ev8Oxha2O
7Ai2rS5NgtmMHv2zU0x0RmrFNpO8unhUP7U6vrO6YVF8x1Nfnoe41DU7is9fLNeV
jx4d7ExZAYPQJxuRYXtC50xvcUPf7IRqIT7fqlin6I3IAV4P8cucD6A9RSoud/8=
=XHWN
-----END PGP SIGNATURE-----

--Sig_/P_IFKvyjBwb7BLmDhKKdUKQ--
