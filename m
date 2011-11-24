Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1KXR0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:26:13 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56604 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1KXR0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:26:12 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 1/8] firmware: Sigma: Prevent out of bounds memory access
Date: Thu, 24 Nov 2011 12:26:21 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, stable@kernel.org
References: <1322138908-32127-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1322138908-32127-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4229609.AZRXZAXq2a";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111241226.23405.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4229609.AZRXZAXq2a
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 24 November 2011 07:48:20 Lars-Peter Clausen wrote:
> The SigmaDSP firmware loader currently does not perform enough boundary
> size checks when processing the firmware. As a result it is possible that
> a malformed firmware can cause an out of bounds memory access.
>=20
> This patch adds checks which ensure that both the action header and the
> payload are completely inside the firmware data boundaries before
> processing them.

in general this looks fine ...

> --- a/drivers/firmware/sigma.c
> +++ b/drivers/firmware/sigma.c
>=20
> -/* Return: 0=3D=3DOK, <0=3D=3Derror, =3D1 =3D=3Dno more actions */
>  static int
> +process_sigma_action(struct i2c_client *client, struct
> sigma_action *sa)

looks like you're inverting the semantics of this func.  i'd add an updated=
=20
comment above the func to document the new return values.

> +	/* Reject too small or unreasonable large files. The upper limit is
> +	 * chosen a bit arbitrarily but it should be enough for all practical
> +	 * purposes and having the limit makes it easier to avoid integer
> +	 * overflows later in the loading process. */

multi-line comment style:
	/*
	 * line one
	 * line two
	 */
=2Dmike

--nextPart4229609.AZRXZAXq2a
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOzn4/AAoJEEFjO5/oN/WB2ykQAMI2muC3qvaKD4sk97zYkXLv
mimJas1rBlhLcOjPp440qO6KiZ6mMIG+2W548oGvDe1hzGWF50oVLgRr4qHtS1/T
Ft9UxqDzUKU5lBbEK0XdWlRkw+s9d8MGKjuSqaC0tDcV3eQczLSy8UwuXQ860g2I
LYvHJ+Rx1PJ1UNzdh9dM0mbI4G2pKQAqRSIBco/IAHqejsNNjGiWVHVf/5GNLOoh
g98+MYZDayDPOSZTea4o4q6pWqTEQvkbLDIACucXs8Elx8BELgjwPuKpIStAn7rj
QxpUu3+igYxtjfJgIEOdTpVAik9WNMyVMMmTPI/p1o637HmsPve2UgZkrhzB9t2h
HWotQSbcIr0PM8SYQUyuitWHx7lqiw/SPmdUSs+Q7F5lHBdARyQ3s1ZYp4RvwFbK
IJW5D/nPuNi081xFpZOioqvpRenKVflS92ThzKjAxcBB4d5hOToZ37AF8XpFM2tV
Tc3dx9X01JhbOwS3IqgoIi87Emqrczdj1vOJAJ8B0rS5GrKdl3eakiLFK0mkLmDe
aaFNJGNuUf2a9SH1TPf7AjYLekZtJpFmky4wj17z9HVGHiwh3fyVzH6NHzodziIg
5LcWePNMdwHekHWvirRgfAZojWbDwoe/W+wEbOOC0KL6Ol77wO9SYXpwsfAPGCZ7
mYQddpM+KHTzRBKjYZfr
=39ib
-----END PGP SIGNATURE-----

--nextPart4229609.AZRXZAXq2a--
