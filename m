Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1HDLrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:47:32 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:35332 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab1HDLra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:47:30 -0400
Date: Thu, 4 Aug 2011 14:47:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: balbi@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] dt: remove of_alias_get_id() reference
Message-ID: <20110804114725.GK17540@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110804102950.10845.67898.stgit@ponder>
 <20110804103336.GE17540@legolas.emea.dhcp.ti.com>
 <CACxGe6vnspztEnUH5odGnK4x_K9Ej3Nt7BxikVQwOr9Uh_ED7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mit9XoPEfICDqq/V"
Content-Disposition: inline
In-Reply-To: <CACxGe6vnspztEnUH5odGnK4x_K9Ej3Nt7BxikVQwOr9Uh_ED7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mit9XoPEfICDqq/V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 04, 2011 at 12:42:41PM +0100, Grant Likely wrote:
> On Thu, Aug 4, 2011 at 11:33 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Thu, Aug 04, 2011 at 11:30:27AM +0100, Grant Likely wrote:
> >> of_alias_get_id() is broken and being reverted. =A0Remove the reference
> >> to it and replace with a single incrementing id number.
> >>
> >> There is no risk of regression here on the imx driver since the imx
> >> change to use of_alias_get_id() is commit 22698aa2, "serial/imx: add
> >> device tree probe support" which is new for v3.1, and it won't get
> >> used unless CONFIG_OF is enabled and the board is booted using a
> >> device tree. =A0A single incrementing integer is sufficient for now.
> >>
> >> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> >> ---
> >>
> >> I'm about to ask Linus to pull this patch through the devicetree/merge
> >> branch along with the of_alias revert.
> >>
> >> =A0drivers/tty/serial/imx.c | =A0 13 ++++---------
> >> =A01 files changed, 4 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> >> index 827db76..7e91b3d 100644
> >> --- a/drivers/tty/serial/imx.c
> >> +++ b/drivers/tty/serial/imx.c
> >> @@ -1286,22 +1286,17 @@ static int serial_imx_resume(struct platform_d=
evice *dev)
> >> =A0static int serial_imx_probe_dt(struct imx_port *sport,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct platform_device *pdev)
> >> =A0{
> >> + =A0 =A0 static int portnum =3D 0;
> >
> > would it be better to use an IDR here ?
>=20
> Hmmm, I've not looked at idr before.  Yes, it would probably be the
> right thing to do.  This patch is needed to fix a build failure, but
> when it is reworked for v3.2 I think idr should be considered.
> Thanks!

no problem ;-)

--=20
balbi

--Mit9XoPEfICDqq/V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOobNAAoJEAv8Txj19kN1j3kIAIdRVuQSDt2IuXrCQTzGrIh+
AwdZVUuXrwSLOAaiWuh+W+Kl9PTXxad8t7PH1lXulk3goTsHGL82isuJaNvF2h1d
F445R8ludhOpeB2dFTQQ5gWzwSf67Veuh6RfOY2CbOrJ2yyOuXLxz4esvnR7Eg59
aT/zXSCG+qBYwOZna+uw8Ppe4mr/4Jnc1/6jyEqs6o91VY6MCJyDrBgcvs8aoEF0
hPPRFfwYufRA4bc1hkwLeZTttKm7xeQHYLn/8vgeXWsNODD3P71TnRhoMz08LyGs
Xo2EIxSqt8jMdCuwc57yQ6g71ZWbqVDzWtkCgJGNgJnHiQ0FZjn9AEIWPFidOHE=
=h9oy
-----END PGP SIGNATURE-----

--Mit9XoPEfICDqq/V--
