Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab0ETHOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:14:35 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:43831 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab0ETHOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:14:34 -0400
Date: Thu, 20 May 2010 09:14:29 +0200
From: Pierre Ossman <pierre-list@ossman.eu>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
Message-ID: <20100520091429.192d560c@mjolnir.ossman.eu>
In-Reply-To: <20100519233408.7436bd9b@mjolnir.ossman.eu>
References: <20100519225653.1fedb453@mjolnir.ossman.eu>
	<20100519230426.47c6c1ed@mjolnir.ossman.eu>
	<20100519232906.3be82279@mjolnir.ossman.eu>
	<20100519233408.7436bd9b@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-2779-1274339671-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-2779-1274339671-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

(adding linux-ide)

On Wed, 19 May 2010 23:34:08 +0200
Pierre Ossman <pierre@ossman.eu> wrote:

>=20
> I'm mostly talking to myself at this point, but one thing that occurs
> to me here is 4096 sectors line up decently with the numbers above.
> 0x380 is just at the end of a 512 byte sector, and 0xf80 is just at the
> end of a 4096 byte one. Not sure it's relevant, but then again I've
> stayed blissfully unaware of how this sector size transformation is
> going to happen. :)
>=20

Ignore the above. Math is hard.

I did some more testing though, and this might be a low level issue. I
did the following multiple times:

# dd if=3D/dev/sde skip=3D4k bs=3D4M count=3D500 | md5sum

And the results were:

13aa29adcd16f8d0faf3cb5c39f43826
d1e3df33c0b0d03c61f880a8f2bb6cfb
13aa29adcd16f8d0faf3cb5c39f43826
13aa29adcd16f8d0faf3cb5c39f43826
13aa29adcd16f8d0faf3cb5c39f43826
13aa29adcd16f8d0faf3cb5c39f43826
7a746328b60a63b76847c3e1319a8534
13aa29adcd16f8d0faf3cb5c39f43826

Note that this is a live system, so there is some chance that something
wrote to than area, then restored it to the previous state. I'm not
sure how likely that is.

If not, then it would seem that this is a problem in either the disks,
the controller or the controller driver. The components are WD
WD1002FAEX, sil3132 and sata_sil24 respectively.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-2779-1274339671-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkv04VcACgkQ7b8eESbyJLjnUQCcDlywNYs+N1yxf1SdSLV8tk7L
4PEAoL6uqr0V1Nw5SrL9T9nZsmlDxspk
=PQgQ
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-2779-1274339671-0001-2--
