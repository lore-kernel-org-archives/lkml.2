Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2B0Qp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:45:29 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:50186 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753654Ab2B0Qp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:45:28 -0500
Date: Mon, 27 Feb 2012 08:45:20 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eugeni Dodonov <eugeni@dodonov.net>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>, DRI@freedesktop.org,
        linux-kernel@vger.kernel.org,
        mailing list <dri-devel@lists.freedesktop.org>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: Re: [git pull] drm fixes
Message-ID: <20120227084520.548ea01b@jbarnes-desktop>
In-Reply-To: <CAC7Lmnu6Wp1aVDuCkP6+UN7jVW8jCk5PcufBn1nVANJfNQzq0A@mail.gmail.com>
References: <alpine.DEB.2.00.1202221952430.18534@skynet.skynet.ie>
	<CAPVoSvSvQv14dM6EWTi3YxUtxNWB8+kypDHSwkYTiWpBxL2eug@mail.gmail.com>
	<20120227080912.5e2163ee@jbarnes-desktop>
	<CAC7Lmnu6Wp1aVDuCkP6+UN7jVW8jCk5PcufBn1nVANJfNQzq0A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/O9HfGuL/eGRM622r3V.7QA/"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/O9HfGuL/eGRM622r3V.7QA/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Feb 2012 13:33:53 -0300
Eugeni Dodonov <eugeni@dodonov.net> wrote:

> On Mon, Feb 27, 2012 at 13:09, Jesse Barnes <jbarnes@virtuousgeek.org>wro=
te:
>=20
> > On Thu, 23 Feb 2012 21:19:20 +0100
> > Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> >
> > > On Wed, Feb 22, 2012 at 8:56 PM, Dave Airlie <airlied@linux.ie> wrote:
> > > > Eugeni Dodonov (4):
> > > >      drm/i915: gen7: implement rczunit workaround
> > > >      drm/i915: gen7: Implement an L3 caching workaround.
> > > >      drm/i915: gen7: work around a system hang on IVB
> > > >      drm/i915: do not enable RC6p on Sandy Bridge
> > >
> > > That last patch about RC6p looks wrong.
> > >
> > > It does:
> > >  GEN6_RC_CTL_RC6_ENABLE |
> > >                       (IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENA=
BLE
> > : 0;
> > > But I think this was meant:
> > >  GEN6_RC_CTL_RC6_ENABLE |
> > >                       ((IS_GEN7(dev_priv->dev)) ?
> > GEN6_RC_CTL_RC6p_ENABLE : 0);
> > >
> > > Or did I get the operator precedence wrong?
> >
> > You're right, no cookie for Eugeni. :)  This would have prevented RC6
> > from ever getting enabled though, which should have the same effect as
> > the patch intended, though at the cost of higher power consumption.
> >
>=20
> Actually, no, it got RC6p enabled - so it got to have all the power savin=
gs
> of RC6 plus some additional ones in the range of 0.1W, but it also result=
ed
> in the very same problem as before, when both RC6 and RC6p were enabled.
>=20
> So, from what we've seen with
> https://wiki.ubuntu.com/Kernel/PowerManagementRC6, the graphics corruptio=
ns
> do only happen when RC6p is enabled (either together with RC6, or
> individually, on its own). If we have only RC6, all the issues are gone so
> far.
>=20
> So this bad patch had its use after all - it served to finally isolate and
> prove that the i915_enable_rc6-related issues are caused directly by RC6p.

Oh you're right; I had the bit positions mixed up...  I thought the
higher level bit toggled all RC6 functionality, but that's kept
separate from this.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/O9HfGuL/eGRM622r3V.7QA/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPS7MgAAoJEIEoDkX4Qk9hGfcP+waBb3coh9733z8cnoJlIRnC
2KYZRw0CkEJ6Cp8qYxDOyyDnSLNqD/KN0ooFjljuSmgG/YENrC3dPbJad1HE92Wx
yJHEQetucz2j35vvHHfFQIFEzutKku3iR0UGO69b8DZJ3zPtvS/Hl8jLwYXPgj9b
mePLEjv2iVYdTezoMnkILSXShD2mX/c51UdpX5CQVKdxoEfkHVkDRGCGdv7bYtDy
Q4tSS/P4aTXql4ApvGyWkA6EVnyeZbvW/nJNGxkqviY2dqm7ie7ZaWsRshCnTt/9
RY86wCHu1rP1iGnFLEDmW20zlkuc/zGKpyP6ZIss0cB+aIHE37JA+ifSjXuEEz6k
TI8ISWEwVcN9yMcbhQTcdVoiUgDgLandfzSNMiBpIL8aQLs5uE8mI0jGx01a4S7q
urFh+OWuyiFvsCnnQRhtrnVIm61gjA3lkrD+BxWpXWn921JgAxolV2GwYBmFHaz5
YMeoHi171ggb5u8HGgBFXj2O+Bu13ScRHQJCgs2B82kwG/bxQXK6UPqoS1FyzHRh
BIvhtOR/XHpVhJGfXrpDDdRJ2sq6BCckdEPmALd/zQGynM751IzXe/maAkfxuJBY
7ngeG5izQAs/TQYvpy16lbGJcGDHMB9+oHN64O3dYJjQemz7bJaBS+8iDS6F2b21
+jZC7a24sq9x2OdmmFcJ
=BCvm
-----END PGP SIGNATURE-----

--Sig_/O9HfGuL/eGRM622r3V.7QA/--
