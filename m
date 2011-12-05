Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab1LETU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:20:27 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:57884 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932159Ab1LETUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:20:25 -0500
Date: Mon, 5 Dec 2011 11:22:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [git pull] PCI fixes
Message-ID: <20111205112256.68e59434@jbarnes-desktop>
In-Reply-To: <CA+55aFyaiJBYmgVCLfPA7q3hqtPHYh9wwsmVTCewbBoxMsDE8A@mail.gmail.com>
References: <20111123144417.2da5958c@jbarnes-desktop>
	<CA+55aFyaiJBYmgVCLfPA7q3hqtPHYh9wwsmVTCewbBoxMsDE8A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/22HaF6ZG3v03x=U.UpeUOMw"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/22HaF6ZG3v03x=U.UpeUOMw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 15:02:01 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Nov 23, 2011 at 2:44 PM, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:
> >
> > Nothing too exciting this time, mostly some minor fixes for things
> > normal people don't really hit. =A0Happy Thanksgiving.
>=20
> Ugh. This looks bogus:
>=20
> > Kenji Kaneshige (2):
> > =A0 =A0 =A0PCI: pciehp: wait 1000 ms before Link Training check
>=20
> Look at that patch more closely. After the patch, the code looks like thi=
s:
>=20
>=20
>          if (ctrl->link_active_reporting)
>                  pcie_wait_link_active(ctrl);
>          else
>                  msleep(1000);
>=20
> +	/*
> +	 * Need to wait for 1000 ms after Data Link Layer Link Active
> +	 * (DLLLA) bit reads 1b before sending configuration request.
> +	 * We need it before checking Link Training (LT) bit becuase
> +	 * LT is still set even after DLLLA bit is set on some platform.
> +	 */
> +	msleep(1000);
>=20
> and I'm pretty sure you should remove the "else msleep(1000)" there.
> Doing the 1s wait *twice* seems entirely bogus, even if you are
> missing link_active_reporting. No?
>=20
> I pulled it since I can't test it, but it really smells fishy to me.

Sure looks like it... Kenji-san, you went back and forth on this one a
little, can you confirm (and preferably test)?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/22HaF6ZG3v03x=U.UpeUOMw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3RoQAAoJEIEoDkX4Qk9hVKQQAIxWTLpY6Ebg7L38ZyGmXW8n
g4G/YQd/VnSUcWY33PKNH3qi/vUtUfNo1RDdpRBrWUQCq/VADRPoceKUOcddKRzq
yBlGrwcDr9+FBFzrI4Sm3RlUcL/wQ0Lq9Ftb0sGe5/qrhZ8TQEQJVCg6ezQBmuJo
ULffC9sU2LeItKlNw4iuqsRdG9G8+Z8Om1znOp3abwmJMMzG03WmhcWMI8x1ywiy
X/MajhFS1w3cOONy/XZer+48/9neZA5wLw0li2LOGzoeE0a9XCGBnYkLaqKXCjQG
byEXZfGHvIuZc+c/ERA1Xf5N470H07eZi2HIuKEZIyxd82iDTm+UUqhZpOI36w3F
jTpWCP5kAD8T3/MkW/4xLLWJn3U1OSnU3vrhDnVX5L5fiugrvJ069RdZeGGAZGig
adqTeY+T/94WnSMO2LtYUQ4P9Pj9Pnbb9FISX0xKmGXY1rwTUu4MNFjTLXimy2//
WqCVvhErrOpCqfQVkhiXARTbn3O0fQyML2OPkB3Y2kxS9MZhPMEZtQGpOKVd/Dz3
Bd/0xzAthTOmGqIuqhw9CzADJjcJlJofrD6DIdb0R5oXNzdwlWcja2nqtsFcHH/U
Cqpf5CNKTooSb/4LbrkycHantYeCxlDTM/0w89Ny4n8zbysVgkS373Imu9tDKVGn
AoFSWVnNA3aZbmnNx4Bv
=QlPY
-----END PGP SIGNATURE-----

--Sig_/22HaF6ZG3v03x=U.UpeUOMw--
