Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab0ESVEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:04:32 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:57746 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0ESVEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:04:31 -0400
Date: Wed, 19 May 2010 23:04:26 +0200
From: Pierre Ossman <pierre-list@ossman.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
Message-ID: <20100519230426.47c6c1ed@mjolnir.ossman.eu>
In-Reply-To: <20100519225653.1fedb453@mjolnir.ossman.eu>
References: <20100519225653.1fedb453@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-29823-1274303068-0001-2"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-29823-1274303068-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 May 2010 22:56:53 +0200
Pierre Ossman <pierre-list@ossman.eu> wrote:

>=20
> Still, I managed to catch a hexdump of one of these corruptions.
> Perhaps someone can spot something familiar in it that reveals the
> source of the issue:
>=20

Sent this off a bit too fast. Forgot the analysis I did so far:

The corruption is 104 bytes. Somewhat odd number. I would have expected
something more fundamental like a sector or a page.

The data in question seems to come from another part of the file. The
two bad data chunks can be found in the original file:

015d1380  2b 53 f6 39 fa 9a 71 df  d0 0e 7d 09 44 20 42 0c  |+S.9..q...}.D =
B.|
015d1390  fa 0e 0b 71 36 19 8d d0  ed 7f c6 7f 47 8d 88 78  |...q6.......G.=
.x|
015d13a0  2e 23 ab b2 8a c5 e0 b0  45 36 0c a7 f4 c4 19 7b  |.#......E6....=
.{|
015d13b0  d2 fe 6f 99 b0 b9 08 c4  6b 42 62 50 9b ab 75 cc  |..o.....kBbP..=
u.|
015d13c0  3a 91 3e 4f b4 d0 68 5a  03 76 fc e4 ad 47 ed b3  |:.>O..hZ.v...G=
..|
015d13d0  59 04 f5 93 eb 3d fa ca  5a dc 2c 6c dd 5e da d8  |Y....=3D..Z.,l=
.^..|
015d13e0  71 30 75 89 12 99 a7 aa  d0 d1 4c a4 fd 2a f5 fa  |q0u.......L..*=
..|

02210380  e7 3b 47 3d ae 02 53 d4  1a d0 24 9a 69 c6 81 8a  |.;G=3D..S...$.=
i...|
02210390  82 1f 4e 6b 76 de 84 da  07 5d f2 89 50 9c 01 89  |..Nkv....]..P.=
..|
022103a0  d6 03 bb 7d 15 5a 39 05  c7 ee 4e 51 4b a9 84 1c  |...}.Z9...NQK.=
..|
022103b0  19 da 5e d8 95 2a 36 a5  cc 59 02 69 d6 11 e4 43  |..^..*6..Y.i..=
.C|
022103c0  5d 36 50 a0 ed 95 42 24  eb 9b e8 e7 ad 9d 23 9a  |]6P...B$......=
#.|
022103d0  d5 cb 32 2b e0 37 16 36  96 b8 9a 01 d5 00 eb 86  |..2+.7.6......=
..|
022103e0  09 db 97 5b 76 ed 0b 4f  6d 90 3b af 2a 1c 2a cc  |...[v..Om.;.*.=
*.|

The shifts are 015d1380 =3D> 015d0f80 (-1024 bytes) and 02210380 =3D>
0220ff80 (also -1024 bytes). At least the offset is a nice, sane power
of two number.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-29823-1274303068-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEUEARECAAYFAkv0Ul0ACgkQ7b8eESbyJLiMVwCYhk7sY//1qO+O2Bt3QAO5RmEZ
YACggjLH06/EJGGLIk5ujmiR9N1/4MQ=
=2Qty
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-29823-1274303068-0001-2--
