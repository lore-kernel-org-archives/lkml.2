Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0KVOz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:55:57 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:48632 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab0KVOz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:55:56 -0500
X-Spam-ASN: 
Date: Mon, 22 Nov 2010 17:55:47 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv4 05/17] pps: access pps device by direct pointer
Message-ID: <20101122175547.7cf78af1@desktopvm.lvknet>
In-Reply-To: <20101121141226.1576758b@lxorguk.ukuu.org.uk>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<57dad12253191b67a6a08bb9c464bd54e70e52a3.1290087479.git.lasaine@lvk.cs.msu.su>
	<20101120154416.GX13356@enneenne.com>
	<20101121141226.1576758b@lxorguk.ukuu.org.uk>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/dK6SNkXMf0IwWyPCapA6xI9"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dK6SNkXMf0IwWyPCapA6xI9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sun, 21 Nov 2010 14:12:26 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

>=20
> > Maybe this lock is useless... however, are we sure that before setting
> > tty->disc_data to pps its value is null? Otherwise the dcd_change may
> > be called with an oops! We cannot control serial port IRQ
> > generation... :-/
>=20
> tty->disc_data is LDISC private. It may be any arbitary value on entry to
> the ldisc open method.
>=20
>=20
> > > +	spin_lock_irq(&pps_ldisc_lock);
> > > +	tty->disc_data =3D NULL;
> > > +	spin_unlock_irq(&pps_ldisc_lock);
>=20
> And you don't need to set it to NULL after - some ldiscs do this mostly
> as a debug aid.

It was a part of attempt to do a workaround. But it still is not safe
enough because it doesn't protect from a sudden ldisc change while we
are at the beginning of pps_tty_dcd_change() i.e. haven't acquired spin
lock yet. The real fix is ready, I'll send it soon.

--=20
  Alexander

--Sig_/dK6SNkXMf0IwWyPCapA6xI9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6oR0AAoJEElrwznyooJbthAH+gOvoP2km7AYMQs/PkV/XqDy
bJqHtZs08BTuMrk49YtMsgev4G2mDbwx4M+whCJN27jldOrw1DplD9sj9fr2SFdY
LgTl7zGdn7gqzu4bwonWhJ2I4/gZHCj5hHyehJiHBxTxt311tJNfDeSULDkfyK3v
TvfAiYWzIw0gvNL+Oj4BVkaivLmPeeIPwg7f4hFsowwHfuqgp4fX16gcQiXgxttn
9ezLpGVkuYXDV4RaxypmhaveTEiaX9n7uH/mpIeb8v8Y1zKGvdiG6KqqBfgAYlBh
Jn5pSkdjyDrAFWs3R6aRbCGmGoexG6Wmmrj1iaDoaGd+cmRLfsbi6HahXK5ae6k=
=rlzm
-----END PGP SIGNATURE-----

--Sig_/dK6SNkXMf0IwWyPCapA6xI9--
