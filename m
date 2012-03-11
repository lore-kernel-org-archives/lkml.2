Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2CKL6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 07:58:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57992 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661Ab2CKL6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 07:58:00 -0400
Date: Sun, 11 Mar 2012 11:57:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] regmap: add structs to fix build warnings when
 REGMAP is not enabled
Message-ID: <20120311115757.GD3233@opensource.wolfsonmicro.com>
References: <20120309191101.8634973f7d9988c602143f7c@canb.auug.org.au>
 <4F5A5AAD.1000105@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
Content-Disposition: inline
In-Reply-To: <4F5A5AAD.1000105@xenotime.net>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 09, 2012 at 11:31:57AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> Fix build warnings when CONFIG_REGMAP is not enabled by providing
> struct forward references.

This isn't a great approach - you've put the forward declarations into
the ifdef which is at best needless (if they conflict with anything real
something went badly wrong) and for the register defaults the chances
are anything actually trying to use that stub needs to know about the
definition so the ifdef should be pulled further down the function.

I've done something better.

--P+33d92oIH25kiaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXJM9AAoJEBus8iNuMP3dFxEQAIlm4qlI1vaajDbPQrviYbaW
bw0hoBOVsAVzFEKla8Zc3TNFVsA0qvukWFVVnB2Sb3YEcitSPa/htEvVc4QOC3Ox
pBQfnAjTCIgObweeJgG5C9rL+rmq+NKM7lL85Nr7Jy+r+u/bdbOyOC6CUwu0pa/r
Mjf1d7KfZrDGyVyJZ6pvSmwfWiYrXwNYOSVoneK8FAcgbmHmE7So2SGBEv2Lcjtp
yvPUAoD78m6h4W8YHZGLNJbEZnlNQYxd9KDFhWvlP1UD+OykRLakDrwkvaPDXBhq
1B457mCevbku3ntgVa4+neq6z74wPX0ehe5AGbUZwK25SdX5eXTuEpJCSy97RkEm
xzExAb7EPtfxONzkpvti66Q2CAMPCFMdy+MVAULgR1Jq8AtSBhLIT1tZ/O5vrTa5
lnde9Za7xiQExV89N6lEMZG1/FuADQ8BBAsvyxhikiWwPIe6CX8f+Z5MRWoFot3h
fkS++uUpLenh2bpvghlJk/U6QseeCBr72QT5WFWbZ8LujxoyNP/2D0iHtpusmE0x
uX3W088g00Yzb1xlOD917Qn7FqnZL1krEcdJextPZsjnZDYb6KE+ODDDxapigyjW
f1ufFoP6WwKMwc1Rp2XVreg/D6sMFKrHC+8hrPd0fYdug9zzzfwD1/Y2Mq9uN2YQ
cExDP3zQcVRYbx65qR0f
=4w2r
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
