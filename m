Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab2K3LHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:07:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:52261 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab2K3LH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:07:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="asc'?scan'208";a="227099118"
Message-ID: <1354273697.30168.87.camel@sauron.fi.intel.com>
Subject: Re: [RFC/PATCH 0/1] ubi: Add ubiblock driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Fri, 30 Nov 2012 13:08:17 +0200
In-Reply-To: <CALF0-+WuaUn5b=2XrzqW7pvM=N1MfQf=sFwLFOrokTkHbOXh3w@mail.gmail.com>
References: <CALF0-+WuaUn5b=2XrzqW7pvM=N1MfQf=sFwLFOrokTkHbOXh3w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-T2ppY0xXSwzL6fac1S/H"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-T2ppY0xXSwzL6fac1S/H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, without the reveiw, I can say that overall this sounds good, thanks!

On Tue, 2012-11-20 at 19:39 -0300, Ezequiel Garcia wrote:
> Also, I've decided to make block devices get automatically created for
> each ubi volume present.
> This has been done to match gluebi behavior of automatically create an
> mtd device
> per ubi volume, and to save us the usertool trouble.
>=20
> The latter is the most important reason: a new usertool means an added
> complexity
> for the user and yet more crap to maintain.

> I don't know how many ubi volumes a user typically creates, but I
> expect not to be too many.

I think I saw something like 8-10 in some peoples' reports.

> * Read/write support
>=20
> Yes, this implementation supports read/write access.
> It's expected to work fairly well because the request queue at block elev=
ator
> is suppose to order block transfers to be space-effective.
> In other words, it's expected that reads and writes gets ordered
> to point to the same LEB (see Artem's hint at [1]).
>=20
> To help this and reduce access to the UBI volume, a 1-LEB size
> write-back cache has been implemented (similar to the one at mtdblock.c).
>=20
> Every read and every write, goes through this cache and the write is only
> done when a request arrives to read or write to a different LEB or when
> the device is released, when the last file handle is closed.

Sounds good, but you should make sure you flush the cache when the
file-system syncs a file. You can consider this as a disk cache.
File-systems usually sends I/O barriers when the disk cache has to be
flushed. I guess this is what you should also do.

> This cache is 1-LEB bytes, vmalloced at open() and freed at release().

Is it per-block device? Then I am not sure it is a good idea to
automatically create them for every volume...

--=20
Best Regards,
Artem Bityutskiy

--=-T2ppY0xXSwzL6fac1S/H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQuJOhAAoJECmIfjd9wqK0gSkP/3PCVs4QxCNHWVuIqa9gh/Fa
tlMvC1lHaX0m0Xpq9N/cZyLmJNu73Bmop8hpUhWAk01y9P+fhgGbQliJP5+dZXpo
uMxLynGMPNW2mrFfCCPzVJjA0QIJ+249j53VzDzjzj+O7HG4bwI+UwV8PSFXZlLT
21tUnRjr0YEytorY9Swr/J6tETAhLIyn6L2gjYeLxS2QfYpzNn+t1UIJeJwKv+gQ
flSvZbBPvV75fd+kI+E7m7wXphf3ljRdAP8ioXdJUR36M8nyzlE5P7PXJChxOm2E
2tjaDDdVSjoA0D2SW2HSiqjCecS5dWWmtwOn2FEkYK2sHL0qoZi2wLQSb0gubZGf
e0t2BUhhFQjm1xq5iKKIeIQeCuRt3FEWfq5A2AAz1H2FIyDtOd8VCxWPTx/LHJWb
jArGLFiLazR4K2q/2ajhan7S4bfDHLTCC/HeyTa3PQGd51CAhZtQJQwqzzdBHYGW
W24GwuL3AyNkkbj8WjPL6rtwzxwfSzcd71VXfCUcO7ttO3OFV/9PMTbQwDxM/uXq
P0YUy5lCWQhR6OzArSgoADZ6A1PHXr4ww6aNcWK5FZAt6ZxphDUOlOt38IkTeZ04
y27Jc3DvizX7vtjVO7oa5WrMJuoY+gRU6Fs7Y44l2xhjuN6rUSql39DxwyUndID5
4P1wX/5FB6RpenH1Qn+/
=KaAc
-----END PGP SIGNATURE-----

--=-T2ppY0xXSwzL6fac1S/H--

