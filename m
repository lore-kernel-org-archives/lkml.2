Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2BSBsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 20:48:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab2BSBsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 20:48:40 -0500
Date: Sun, 19 Feb 2012 12:48:20 +1100
From: NeilBrown <neilb@suse.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: w1: Fix w1_bq27000
Message-ID: <20120219124820.4a8989f0@notabene.brown>
In-Reply-To: <20120218205125.GA26827@elgon.mountain>
References: <20120218205125.GA26827@elgon.mountain>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Yje.pJ8sr0IwSAd0qyfGQfA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Yje.pJ8sr0IwSAd0qyfGQfA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 18 Feb 2012 23:51:25 +0300 Dan Carpenter <dan.carpenter@oracle.com>
wrote:

> Hello NeilBrown,
>=20
> This is a semi-automatic email about new static checker warnings.
>=20
> The patch 9f3519d2ed26: "w1: Fix w1_bq27000" from Feb 15, 2012, leads=20
> to the following Smatch complaint:
>=20
> drivers/w1/slaves/w1_bq27000.c:48 w1_bq27000_read()
> 	 warn: variable dereferenced before check 'dev' (see line 46)
>=20
> drivers/w1/slaves/w1_bq27000.c
>     45		u8 val;
>     46		struct w1_slave *sl =3D container_of(dev->parent, struct w1_slave=
, dev);
>                                                    ^^^^^^^^^^^
> New dereference.
>=20
>     47=09
>     48		if (!dev)
>                      ^^^
> Old check.
>=20
>     49			return 0;
>     50=09
>=20
> regards,
> dan carpenter

Thanks..
I suspect we should just remove the
   if (!dev)
       return

I should probably get rid of w1_bq27000_write as it is totally unused, and I
need to hold a lock in w1_bq27000_read or I can get really bad things
happening if two threads try to rad the status at the same time.

Ho hum.

Thanks,
NeilBrown

--Sig_/Yje.pJ8sr0IwSAd0qyfGQfA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0BU6znsnt1WYoG5AQIotw/6Ah7yGZ7i7ZADigaXCgADyZmP33Y/U2yW
NQJdLHggf3549Kr5/Hbg2ifZomN5eopluWbR33GXLEPOapTc/u1aMIHzxaZcuOS4
JTo4yOacIYLlG8PRz7scZEqULoPBXaHjY0/za3so0pWQT80HRPXrAYyi6oBQxgUf
HyKf0IigX53klABVRpxxL8465e5CKN/BkKA/B8xZsnzZxjZ267uAKhJX2HVJm39G
gc7JqLfZt0+Q4VwOF3kGuuNPc7kld5SvZnleZFgT1v+ZIfnwapdORmZ4npj74Tjw
r/CqU0CtVkeHXQDDdSjh/9aEofJhOlMju9VfAo1kVTqulCjY+tdF4Fm+44rnZ0u/
p5AvRkja3ggVC3xnTGO2aUh/4C1dqvPKh3UX58T3VNpC2lGDQ5/6+ihUISxg0zXM
YHvgLAsbmi1hQJgtPlnWdevcOqRZa9Y9AVNHAQvOnSTE57X5UW3On+ubfad//WEo
zZ2O6Sbxpg0cJ5YZo7XVgvmTI0DOvt1fmyn7pRO4NK1LdPEsEtAJXq6kuxdZ0HLh
GD1c6yKaPxJQViNb4GizkwKU1bgDNNZG2gvWs9b+G4rurt2zTCzD7LAtj8UPWdME
6sJdxFGHlgQ2jqbQYap25Y4QAj5yDrPE+Bk1eKbF3hTrnoWm0fyv0S+KY1iKBOj+
PKz2eId+efs=
=ocL2
-----END PGP SIGNATURE-----

--Sig_/Yje.pJ8sr0IwSAd0qyfGQfA--
