Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1JRGZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:25:24 -0400
Received: from www17.your-server.de ([213.133.104.17]:55238 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab1JRGZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:25:22 -0400
Message-ID: <1318919100.1652.6.camel@localhost.localdomain>
Subject: Re: [BUG] Device node major comes out wrong on HFS+ under linux
From: Thomas Meyer <thomas@m3y3r.de>
To: DagB <dag@bakke.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Oct 2011 08:25:00 +0200
In-Reply-To: <4E99CB18.2080302@bakke.com>
References: <4E99CB18.2080302@bakke.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VkCX8t9fNjyqwXvXBW1v"
X-Mailer: Evolution 3.2.0 (3.2.0-1.fc16) 
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VkCX8t9fNjyqwXvXBW1v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Samstag, den 15.10.2011, 20:04 +0200 schrieb DagB:
> Hi.
>=20
> Executive summary:
>=20
> /dev/null:
> osx:	crw-rw-rw- 1 root wheel 1, 3 Oct 13 04:12 null=09
> linux:	crw-rw-rw- 1 root root 16, 3 Oct 13 02:12 /dev/null
>=20
> /dev/console:
> osx:	crw------- 1 root wheel 5, 1 Oct 13 04:12 console
> linux:	crw------- 1 root root 80, 1 Oct 13 02:12 /dev/console
>=20
> /dev/sda4:
> osx:	brw-r----- 1 root wheel  8, 4 Oct 13 04:12 sda4
> linux:	brw-r----- 1 root root 128, 4 Oct 13 02:12 /dev/sda4

>=20
> Anyone care to squash this bug, please?
>=20

This is not a bug. Linux uses a 12/20 split for major and minor device
ids and the xnu kernel uses a 8/24 split:

8, 4
00001000 000000000000000000000100
=3D 128, 4
000010000000 00000000000000000100

with kind regards
thomas


--=-VkCX8t9fNjyqwXvXBW1v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOnRu8AAoJEK2Y/UtDbsHsXvYIAMwOyu84c8sGf6HwskmF4ekA
y2eZ4XiRU/prJdauz+PVcxKcrXRDUpEO5yrz0gYO4h/p5uprIYqHpKRMG2hR4SXV
Q/LXEoBem42gmjNLBfoShnDtp4KcXbPM2JoqheuJhua3e4xPlsqUF+G5KuAUgPKy
8CFG2IZFAYwJFj9dGN1cM6oR1CC76cDgXsYOhEbqL+kjgCoNhM0o8VteUPDWsWXd
nHrNthfdaFkDZWdjMROTGSKYmE97FP0qhK/NT+j5l+c5a2o3C1tjepu9MyqoDRP/
PInTByLg0RAK357bOZDV5dyBt7tzKz+kY3jWS2Wo7YuimTHUYUO34Fk/ITblBnA=
=HKha
-----END PGP SIGNATURE-----

--=-VkCX8t9fNjyqwXvXBW1v--

