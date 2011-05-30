Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1E3FUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:20:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53553 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab1E3FUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:20:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [PATCH 0/4] Add a generic struct clk
Date: Mon, 30 May 2011 01:20:11 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
In-Reply-To: <1305876469.325655.313573683829.0.gpush@pororo>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2411672.Iv62CYSMZC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201105300120.12633.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2411672.Iv62CYSMZC
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday, May 20, 2011 03:27:49 Jeremy Kerr wrote:
> [This series was originally titled 'Add a common struct clk', but
> the goals have changed since that first set of patches. We're now aiming
> for a more complete generic clock infrastructure, rather than just
> abstracting struct clk]
>=20
> [This series still needs work, see the TODO section below]

for future series, could you cc uclinux-dist-devel@blackfin.uclinux.org ?  =
we=20
dont do clock management on Blackfin parts atm, but it's something we would=
=20
like to start doing.  our hardware can easily benefit from this.

basically, we have:
xtal -> pll -> divider -> core clock -> divider -> core timer
		\-> divider -> system clock
					|-> spi divider -> spi clock
					|-> i2c divider -> i2c clock
					|-> uart divider -> uart clock
					...etc...
and future parts are only going to get more complicated trees.

atm we only support changing core clock on the fly since it requires=20
reprogramming one device (the core timer).  we'd like to support changing t=
he=20
other clocks on the fly, but have no framework for doing so.  this obviousl=
y=20
would address that.
=2Dmike

--nextPart2411672.Iv62CYSMZC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJN4ykMAAoJEEFjO5/oN/WB7rgP+wWZfj1XCv6bRaNDLcepwkcJ
6ExDOqYK7tcJ0+mBdACrfBt0VxOd3pip96OIjv5Bf6GjgFeOA8y2jLWAQhOPsq3P
IRSHrIce5qM20jSP4UgDb0x0NnUcoiLY7MWEyJq/K1SiVctokW6gzE5EnVaKVv4K
ufo3uSYB9bKERBGtN985Mnv1PkJeh7Uhj4CfcO0JHzTpSqjnkEe3k79C92Do1lTY
Sd5qt1AW1fFMiyhQ4fM40IVDAVopNIUsWvRtOMzdrvboE2O+x/xgtYIRAHtut+Fw
gdmwe1YcflsqNQqTsPhtCMLXC8V+Vvj3kTa1YxTc2QhZSLxbxybgOwOda25qA8i2
5MXSUmJjqn69FDDKhHvcCsUULXQ1pdQ3MSJAoXxKL7T8Rt6CyTlH0HlAnKGeZMEy
sdqCnCM1iYN58pesbYesUW+stbaQgaBYeW68ztOE3GqQd+1+M5bPRwf1lMs85Wbx
FNmwoT8dPnOU+FkoRlmszCJhQLcl2ACNa/zqAqlyae0//a6hdvjzy0v8icIiG6wR
CGlG0xUGolfRSU0X1aLplIlaFDSsO878KQiay4P16/IwGUJmwuI8DVI8ssKteJYU
NWJPAIk3m07Qei/bu1h/ZxY/Kuoph3OhYlrlOnQA4flDhNEB0E7DDQD8eMTvOn8w
Bt9QN48ltJImpFWqhLxb
=Cpd/
-----END PGP SIGNATURE-----

--nextPart2411672.Iv62CYSMZC--
