Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab2ALKp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 05:45:58 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:36517 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055Ab2ALKp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 05:45:56 -0500
Date: Thu, 12 Jan 2012 12:45:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
Message-ID: <20120112104549.GA3549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 12, 2012 at 10:55:03AM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Add missing iounmap in error handling code, in a case where the function
> already preforms iounmap on some other execution path.
>=20
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> expression e;
> statement S,S1;
> int ret;
> @@
> e =3D \(ioremap\|ioremap_nocache\)(...)
> ... when !=3D iounmap(e)
> if (<+...e...+>) S
> ... when any
>     when !=3D iounmap(e)
> *if (...)
>    { ... when !=3D iounmap(e)
>      return ...; }
> ... when any
> iounmap(e);
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

This is not related to this patch actually, but when you send a series
of patches could you make sure to send them all as a thread ? It makes
it easier (at least for me) to see that those are all related to each
other (in your case, sematich patches).

In order to do that with git you could:

$ git format-patch -o patches --cover-letter linus/master

[ edit cover letter]

$ git send-email --to lkml patches/

that will do the trick. Thanks

--=20
balbi

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPDrndAAoJEIaOsuA1yqREORoP/0IcRn+/KvjBvyn6Sp3S2kLQ
eWz3BoyriEZioRjmNXc2NIYH6+8A2Z/V4nH2z608r+vMor9Kfck+5RxDcuqRhHde
E4KWaz1BJ2llOq3P18IpsU6I/KIJlk9bpBK2a/lKCcR54iqdIDe/leuMOoX7Tdy6
efV4l1ylPK5G83yGGtMDiTl++R0rcfCHCz/b6AmBZ7kqBXIDq/tL0zaTYHAPWCjF
lx8HLk/WlRombimVO2jF4+SjoBMFYohI1kb5/D15YDKzvIioRknFZULkJPQlczMP
iJb0fe2phB1A0icfvgVjcC6vXfudUdW7GaO9oLlNA8FROHUYAHyGI/ZSbZicZr8g
9gmVzqOqH1afZoWKm/zoboJqsGfCEiwJ3qexy/vldoYiJBLFklKmaOEK60iyl5qp
+tpWQTV/Mifut+OSb/LvndwDp2A9pvRbzUr6063PO6YqFlrZUnhetrVAICREkFMX
Z4EgT8h6dtklePG3vypu9474aSva/GRjI9WbJw0qWs9/54JMngMbsqAyZ0F9+o0l
owGL2/4e/cZZe/3dnJVlDksLCHJeGFVEoQOAD9eJsPt1SUiv8UemNbl5eTXTSnAZ
hY3zHPZ8QU4WCxA9Rm/j7jB4OP1JRRa0UpVECICenVd56nJ5xtVTSdHrEkwBqfrt
5WN+okbq74B/P/jfGvLO
=LvWk
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
