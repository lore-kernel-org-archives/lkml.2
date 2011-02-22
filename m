Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1BVQVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:21:04 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:46361 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1BVQVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:21:01 -0500
X-Spam-ASN: 
Date: Tue, 22 Feb 2011 19:20:52 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pps: Make pps_gen_parport depend on BROKEN
Message-ID: <20110222192052.60039749@desktopvm.lvknet>
In-Reply-To: <1298064881.2431.3.camel@work-vm>
References: <alpine.LFD.2.00.1102182214190.2701@localhost6.localdomain6>
	<1298064881.2431.3.camel@work-vm>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/Ukatl1=BdzZ1jHJYttZTBRr"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ukatl1=BdzZ1jHJYttZTBRr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi John,

=D0=92 Fri, 18 Feb 2011 13:34:41 -0800
john stultz <johnstul@us.ibm.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Fri, 2011-02-18 at 22:16 +0100, Thomas Gleixner wrote:
> > This driver causes hard lockups, when the active clock soure is
> > jiffies. The reason is that it loops with interrupts disabled waiting
> > for a timestamp to be reached by polling getnstimeofday(). Though with
> > a jiffies clocksource, when that code runs on the same CPU which is
> > responsible for updating jiffies, then we loop in circles for ever
> > simply because the timer interrupt cannot update jiffies. So both UP
> > and SMP can be affected.
>=20
> Yuck.
>=20
> Alexander, Rodolfo: Instead of polling on gtod, could you take a
> timestamp, calculate the delay and then use udelay()?

Sure, it's possible but it would be less precise IMHO. I'll test it.

--=20
  Alexander

--Sig_/Ukatl1=BdzZ1jHJYttZTBRr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNY+JkAAoJEElrwznyooJbO1oH/RRo1L+63VaqUvfUNa1j3qCC
T/MXOy0z42m8AtRRfpfzZyWgPlnSOctML1dwgEO3udtc7jOEqJemYRILGnxU9OmS
gbuvrdjQdKvnb9StEbJIgGJVCaridqbq+xLuzGbe9hxadDwl+u+S3dJltT0AXh6B
W+jcVHSqdVrwqm6f+58tYCgWoNCznP88skfu+dg6GcXJWvHCCQXIrsh27I87YAkB
G2jywdQaPI2JH0PTfd6q7Ro9RazPMrqv5jp9X8TRaPhtKJAm1Rrk+ZCwtdzb1P4c
K+Nm4P0KRN0yc1AJosOMXuxdvkGfn8PfnH04EylQL2a8TrCom4IkThz9jpQc6ls=
=/oE8
-----END PGP SIGNATURE-----

--Sig_/Ukatl1=BdzZ1jHJYttZTBRr--
