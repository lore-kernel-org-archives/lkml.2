Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0DBRV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:21:28 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:48923 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0DBRVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:21:22 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2010 13:21:22 EDT
Date: Fri, 2 Apr 2010 19:16:00 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: "Ramesh.R" <ramesh.kvp@gmail.com>
Cc: linux-kernel@vger.kernel.org, srini@arasan.com, ramesh@arasan.com
Subject: Re: 64 bit Descriptors in ADMA of Linux SDHost controller driver.
Message-ID: <20100402191600.19af3ffc@mjolnir.ossman.eu>
In-Reply-To: <p2r1e3142441004011446r707284b7p2cd5e3046719c2ed@mail.gmail.com>
References: <p2r1e3142441004011446r707284b7p2cd5e3046719c2ed@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-11662-1270228563-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-11662-1270228563-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Apr 2010 14:46:14 -0700
"Ramesh.R" <ramesh.kvp@gmail.com> wrote:

> Hi Pierre Ossman,
>=20
> When we go though the Linux Standard SD Host controller driver(Using the
> Kernel 2.6.33), we saw only the 32 bit Descriptors implemented in it.
>=20
> We confirmed this status for 32 bit and 64 bit processors.
>=20
> Are these observations correct. Please clarify us.
>=20

Quite. The hardware I had at my disposal only supported 32-bit
descriptors and I didn't want to write code that I had no way of
testing.

> Also how the 64 bit machines will process the data, if the Descriptors are
> implemented with 32 bit. If they are using the 32 bit and don't care about
> the MSB 32 bits, then there is no major difference in performance wise,
> whether it is 32 or 64 bit processors. Please correct me if my understand=
ing
> is wrong.

The only performance impact that might occur is if you try to transfer
to/from an address above 4 GiB, at which point you need a bounce buffer
and an extra memory copy.

(I believe the kernel does this by default if the driver doesn't
explicitly say that it is 64-bit compatible)

>=20
> Also please point us, if we need to use 64 bit addressing for DMA
> descriptors is there any way with the current SD host controller or not.
>=20

It's been quite some time since I looked at the driver, but I seem to
recall that adding 64-bit support is not a particularly difficult task.
As long as you have hardware for testing then it is something that you
should be able to sort out with less than a week of work.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-11662-1270228563-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAku2JlIACgkQ7b8eESbyJLgFZQCghFqvWYO+5C47Qp3XyF2EDIHD
kfMAniFlo/ObXC+50v1grmZIEUqFzDC8
=d5dm
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-11662-1270228563-0001-2--
