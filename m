Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab0DSJUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:20:43 -0400
Received: from pc175e.fzu.cz ([147.231.127.175]:57234 "EHLO postak-1.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab0DSJUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:20:40 -0400
Message-ID: <4BCC203F.4070501@gentoo.org>
Date: Mon, 19 Apr 2010 11:19:59 +0200
From: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <jkt@gentoo.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: boot device order troubleshooting without an initrd
References: <4BCB87E2.4090807@gentoo.org> <20100418165125.1d2b2843@infradead.org>
In-Reply-To: <20100418165125.1d2b2843@infradead.org>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5A891B12AD6DABECDC1F710C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5A891B12AD6DABECDC1F710C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Arjan van de Ven wrote:
> so the problem is that the boot order you want is pretty much opposite
> from what "normal" people want.
> AHCI sata before CF slots is pretty much the right thing and what most
> people will use.... most people will have their OS on AHCI SATA, and
> occasionally stick in some photo card or whatever.... and they'd ask
> the flipside question basically.

On this particular motherboard, the CF slot is soldered to the bottom
side of the PCB, so it is normally situated between the motherboard and
the computer case, completely inaccessible to the user at runtime.

> We could have pretty evil things in the kernel, so that we'd deal with
> multiple root=3D lines in the kernel, one by one trying them until one
> sticks. Right now we don't.... but if you make a clean enough patch
> it might even pass the review here...

If the ordering stays the same and such patch existed, I should probably
use something like
"root=3D/dev/sdf1,/dev/sde1,/dev/sdd1,/dev/sdc1,/dev/sdb1,/dev/sda1". Now=
,
 I'd guess this would break as soon as I attempt to boot with a USB
flash device present (I'm assuming it will be enumerated after the CF
card, right?).

So, in short, what I'd love to see is a special device alias which would
mean the "BIOS-provided boot device". Would such an approach be
reasonable? Is it possible at all?

Cheers,
-jkt

--=20
cd /local/pub && more beer > /dev/mouth


--------------enig5A891B12AD6DABECDC1F710C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkvMIEQACgkQamXfqERyJRdzqgCeMqbLsHfokDub+Aw88yYp2QoB
Qu0AmwTgi5n2tjHCSV9DF87AZr3VxwVe
=Zyfv
-----END PGP SIGNATURE-----

--------------enig5A891B12AD6DABECDC1F710C--
