Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab2CGS0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:26:03 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36906 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2CGS0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:26:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/3] Kbuild: centralize MKIMAGE and cmd_uimage definitions
Date: Wed, 7 Mar 2012 13:25:51 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        nico@fluxnic.net, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org> <201203062256.16105.vapier@gentoo.org> <4F579DE0.3050400@wwwdotorg.org>
In-Reply-To: <4F579DE0.3050400@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3453817.5KXmdesmuJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201203071326.00264.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3453817.5KXmdesmuJ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 07 March 2012 12:41:52 Stephen Warren wrote:
> On 03/06/2012 08:56 PM, Mike Frysinger wrote:
> > On Tuesday 06 March 2012 19:30:36 Stephen Warren wrote:
> >> +UIMAGE_ENTRYADDR =3D $(shell $(NM) vmlinux | awk '$$NF =3D=3D "__star=
t"
> >> {print $$1}')
> >=20
> > i feel like if we tried harder, we could automate the -e arg for all
> > arches. i understand if you don't want to undertake that though.
>=20
> Yes, this might be possible. I'd guess the symbol name varies between
> archs, but that can probably be taken care of.

i think we could avoid the symbol lookup.  if the entry point is set correc=
tly=20
in the ELF, we could do:
UIMAGE_ENTRYADDR =3D $(shell $(READELF) -h vmlinux | \
	awk '$$0 ~ /Entry point address:/ { print $$NF }'

99% sure this would work for Blackfin kernel images ...

> This is probably best
> left as a follow-on patch though, since it's a behavioral change,
> whereas this patch is just consolidation.

of course
=2Dmike

--nextPart3453817.5KXmdesmuJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPV6g2AAoJEEFjO5/oN/WBGsYP/0LuhueJyy+ApCnyRU4eAlt8
uNqSCCBHqhDLbGKA04czwUBKCXczhfBs7vOPz4v5GCkPYajflecF0zrJpyGokurD
Bl/1JF6bQzEt8314UyHpHN3L1hF7+VyI5/jWC/6GaBVrxPst+PHz7oaUEcFUr/9o
XL+sVZ2ckHerFKwRY7gK6CtW9QWrQWKyCys+huleSarE8jgsvZdmIyWlmxWKuEYQ
A4iyQCSMZ0rayCysyuSPVbdoVaNNHAHcZldhYAIRPNg2/wOJu8RmuWgfmZ7Qf6yv
ndAJZz8mdjzF8Intm9K+oNEivDOExGUoL0iUO48gD+oAxhFJhGVxbXK4qYtfDe1j
WKDRc/8dU3K4i0AcyvyLb2gUjaFhLEoE29Sh57AaTykDLyE1OITZpeT/mfMzGPrW
jx1Nz/0WpQEtyX76jy5ioD3ypI5XjqWypm0TPpcBGwR33QaHR6ezqrK7swL9LnXb
ku3oLHbiJukDSI0nR2tyTPFivp7glQ0Up3kQ8/s3BuYj55s8v4txTDwPT3YnaptF
9OL6/YcHUYZc9QnAYPKXo91CQHYoT60sZpUvuEUIB+y1w1yTC2E9uOsCB5XzfEkq
YslRhKWielv+GPZdXRD73G1cCVZWOI9WvRFo23dIm06p60K9hl68A6grVU4LyeLA
NqB0V2d1dK8ii1f5je9z
=/F8M
-----END PGP SIGNATURE-----

--nextPart3453817.5KXmdesmuJ--
