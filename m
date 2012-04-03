Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2DCIDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:03:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60126 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2DCIDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:03:04 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Simon Wood <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Bauer <michael@m-bauer.org>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff: Use Private Data
Date: Tue, 03 Apr 2012 10:02:46 +0200
Message-ID: <1594934.O1AHdBE0Y7@qosmio-x300>
User-Agent: KMail/4.8.0 (Linux/3.3.0-1-ck1-ARCHMOD; KDE/4.8.1; x86_64; ; )
In-Reply-To: <alpine.LNX.2.00.1204030413030.16928@pobox.suse.cz>
References: <a4e40aa5c43be934d83240849aa25f3b.squirrel@mungewell.org> <1333378444-3117-1-git-send-email-simon@mungewell.org> <alpine.LNX.2.00.1204030413030.16928@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3368184.RPl2r7lJPh"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3368184.RPl2r7lJPh
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Tuesday 03. of April 2012 4:13:37 you wrote:
> On Mon, 2 Apr 2012, Simon Wood wrote:
> > Use private data in hid-lg4ff to store device properties.
>=20
> I'd like to have a more verbose changelog -- namely what advantage th=
is
> brings compared to the previous state.
>=20
> Thanks.
Hi,

the previous implementation used a linked list to store the device=20
configuration (at this point it was just the operating range, but I hav=
e plans=20
for further expansion, I guess Simon's LEDs patch could use that too).=20=

Searching through the list every time the user adjusted the range wasn'=
t=20
exactly fast, particularly because the list used kobj name as the ID. I=
=20
originally opted for that solution because I didn't want to mess with t=
he code=20
of the whole hid-lg driver.
This patch takes advantage of the changes introduced in my patches from=
=20
2011/04/02. lg4ff now calls hid_get/set_drvdata() to read or store devi=
ce=20
configuration. The way I understand it, this is how all HID drivers sto=
re their=20
private data.

Since J. Slab=FD complained about unnecessary uninitialized_var() macro=
s, I'll=20
update the patch to remove them.

Michal M.
--nextPart3368184.RPl2r7lJPh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJPeq6uAAoJEERrVaOJCK16H60IAJkoy5J1d+ZJU2OhUg/iPIHP
MYRpqlKhVlAvHONN2OgXFnNITV+tEoolsE5LVUiiX+T3YinR+3f6YpD0CexnbHjH
VNQUiK+OnmBD82dDTIt3UnfPO6FN5CMJTms9dgu+wPydM9Dd4ckNkyMo2VTj76VC
w/yyW5+2mX6yhhL5NiKHPrzs+CHNc1alHp3QInaEwfRW4IfpLTDwfmvt4mxqFHTn
6ePINwhEZjZJ5/fV1fXsa2QA6XPrgGZF5u7l7VfDm72rCD3jkOzr3aX8z+l1isIk
h0er91AlDf8hFoKN/img3rIkrNQBHFnMHznJWRn21sihWhRxZAIrpHq+oaxMoSA=
=S19U
-----END PGP SIGNATURE-----

--nextPart3368184.RPl2r7lJPh--

