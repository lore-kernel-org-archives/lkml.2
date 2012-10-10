Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2JJARX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:17:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46066 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752885Ab2JJARW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:17:22 -0400
X-Authenticated: #6479224
X-Provags-ID: V01U2FsdGVkX1/QAVZyr6PQUQxT71dmY+RL8y5S6h8AKrezy9YwD8
	huecWEgx4gmT1N
From: Martin Walch <walch.martin@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Subject: Documentation of kconfig language differs from implementation regarding existence of symbols
Date: Wed, 10 Oct 2012 02:17:09 +0200
Message-ID: <1940598.VZE8PFWQyj@tacticalops>
User-Agent: KMail/4.9.2 (Linux/3.4.9-gentoo-gnu; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2030477.0BHNyd6LV1"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2030477.0BHNyd6LV1
Content-Type: multipart/mixed; boundary="nextPart1389767.GSQefZBuOc"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart1389767.GSQefZBuOc
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

The file linux/Documentation/kbuild/kconfig-language.txt says:

> The following two methods produce the same kconfig symbol dependencies
> but differ greatly in kconfig symbol existence (production) in the
> generated config file.
>
> case 1:
>
> config FOO
>         tristate "about foo"
>         depends on BAR
>
> vs. case 2:
>
> if BAR
> config FOO
>         tristate "about foo"
> endif
>
> In case 1, the symbol FOO will always exist in the config file (given
> no other dependencies).  In case 2, the symbol FOO will only exist in
> the config file if BAR is enabled.

However, I can not reproduce this. The attached file contains both cases. When 
running make menuconfig, setting BAR0 and BAR1 both to n, and saving the 
configuration, there is neither FOO0 nor FOO1 in the resulting configuration 
file.

According to the documentation, at least FOO0 should exist, even if BAR0 is 
set to n. But this is not the case. AFAICS, both versions behave equivalently. 
I suggest changing the documentation accordingly.

Regards
Martin Walch
-- 

--nextPart1389767.GSQefZBuOc
Content-Disposition: attachment; filename="FOO.kconf"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="FOO.kconf"

config FOO0
        tristate "FOO0"
        depends on BAR0

config BAR0
        tristate "BAR0"

config BAR1
        tristate "BAR1"

if BAR1

config FOO1
        tristate "FOO1"

endif

--nextPart1389767.GSQefZBuOc--

--nextPart2030477.0BHNyd6LV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQdL6PAAoJEIoBMSmVzyrzS7IIAKiTdRuZuLlK7J23+dDjvmpD
/NnBXh2rLMspF9SkD9BMJQxl0rSKJyCJv1eS9WPANR1tx9KrA/IHqGeBgpSSnHrt
MPVfVhlPtnTP5cq7cUlcbp3Vjr4TbGExByLJveYSuvr2+aXvHP4weEwLZf7FEMEa
gNPMM+EUwjlQdAHdTZhwKImY1Vxv77FQzT3le/+KEQyIHeqhqDccx8mQcTbjWXT9
N+26CHjZskw4xQ8hTU7r0H3uY6wVnYNP/98I/RzHtrlbm8qE6f/lb5lqsG99oOch
xuobnFjU2j6vMjpWxZ0R232GitUZz79eAy9wCn7QqOZwN47jdxlj9rPqlgSrDtQ=
=rYq1
-----END PGP SIGNATURE-----

--nextPart2030477.0BHNyd6LV1--

