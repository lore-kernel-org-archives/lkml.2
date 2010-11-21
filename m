Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0KUAoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:44:12 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:54426 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0KUAoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:44:10 -0500
X-Spam-ASN: 
Date: Sun, 21 Nov 2010 03:44:02 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tilman Schmidt <tilman@imap.cc>, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 12/17] pps: timestamp is always passed to dcd_change()
Message-ID: <20101121034402.273f7ac9@apollo.gnet>
In-Reply-To: <20101120162304.GE13356@enneenne.com>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<74f895fecc315f781a97b12d7feba3d6c4053195.1290087480.git.lasaine@lvk.cs.msu.su>
	<20101120162304.GE13356@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/vgfy9GjJBLC.jKWA3F3ZJuX"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vgfy9GjJBLC.jKWA3F3ZJuX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sat, 20 Nov 2010 17:23:04 +0100
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, Nov 18, 2010 at 07:01:05PM +0300, Alexander Gordeev wrote:
> > Remove the code that gatheres timestamp in pps_tty_dcd_change() in case
> > passed ts parameter is NULL because it never happens in the current
> > code. Fix comments as well.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > ---
> >  Documentation/serial/tty.txt    |    2 +-
> >  drivers/pps/clients/pps-ldisc.c |    8 --------
> >  include/linux/tty_ldisc.h       |    2 +-
> >  3 files changed, 2 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/Documentation/serial/tty.txt b/Documentation/serial/tty.txt
> > index 7c90050..540db41 100644
> > --- a/Documentation/serial/tty.txt
> > +++ b/Documentation/serial/tty.txt
> > @@ -107,7 +107,7 @@ write_wakeup()	-	May be called at any point between=
 open and close.
> > =20
> >  dcd_change()	-	Report to the tty line the current DCD pin status
> >  			changes and the relative timestamp. The timestamp
> > -			can be NULL.
> > +			cannot be NULL.
>=20
> Can you please explain why it cannot be null? O_o
>=20
> Who does supply the timestamp to dcd_change?

dcd_change() is called only from one place - uart_handle_dcd_change() -
which always obtains and passes timestamps to the former. So no need to
check if ts is NULL and obtain ts again.

--=20
  Alexander

--Sig_/vgfy9GjJBLC.jKWA3F3ZJuX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6GtSAAoJEElrwznyooJbmsUH+gMRuBuimJ3/1Rz3SWgxfh2G
FWr5l4OCQVIH2LCwl1LnZCiqpLtwAizK0cdgesBlZrK8FRlPfdBFHBHh0zK+AvpA
FwkPmG4n7UO9xv1ZfFZjSB8tXLZ9tNpcT7sFDqFvHnWqlFMJV+FVo9unZnsVi6P4
CRkkmmD6G8ysHnKon6+3GZtMUupDJqPyzMNWmakUo5g2aCfLRvKy+oC3cGWoOROF
8zfg9Lf7l/KyNvVkeWzdioBVGP5J/CjvmMw88hNG3e4B/KFTfLuO/C16IoBbt3WV
Z9fHsnG0d2JZiGXUA2CtHk8suvJvr4LUOHYLmW7mB/EOOiOKjjesp9T86+fegmA=
=ZTmW
-----END PGP SIGNATURE-----

--Sig_/vgfy9GjJBLC.jKWA3F3ZJuX--
