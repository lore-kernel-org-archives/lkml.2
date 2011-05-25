Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1EYJtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:49:11 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:49298 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab1EYJtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:49:08 -0400
Date: Wed, 25 May 2011 12:49:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110525094902.GM14556@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <011d01cc19ff$616055c0$24210140$@org>
 <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
 <013201cc1a96$bdda7910$398f6b30$@org>
 <20110525092124.GI14556@legolas.emea.dhcp.ti.com>
 <015801cc1abd$ca534e20$5ef9ea60$@org>
 <20110525092743.GK14556@legolas.emea.dhcp.ti.com>
 <018e01cc1ac0$2b09b040$811d10c0$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l3ej7W/Jb2pB3qL2"
Content-Disposition: inline
In-Reply-To: <018e01cc1ac0$2b09b040$811d10c0$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l3ej7W/Jb2pB3qL2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 25, 2011 at 12:43:10PM +0300, Tanya Brokhman wrote:
> > > But that's why we added the feature flag. Isn't leaving it FALSE the
> > > same as removing the part that updates gadget speed? It is protected
> > with #ifdef.
> >=20
> > you mean the module parameter ? This will mean that users will have to
> > remember another module parameter otherwise it will not work in some
> > situations :-)
> >=20
> > the module should work without that parameter :-)
> >=20
>=20
> No, I'm afraid we're talking about different things here.=20
> As far as dummy_hcd is concerned:
> Dummy_hcd has a new module parameter that should be set to true if the
> developer wishes the gadget driver to be connected to a SS root hub. Since
> at the moment most of the gadget drivers woun't work at SS connection (la=
ck
> of SS descriptors) the default of this parameter is true and thus the
> connected gadget driver will be enumerated over a HS root hub. Users don't
> have to remember t set anything in order to be able to work with dummy_hcd
> and the existing gadget drivers just as they did up until now.
>=20
> We did add a new feature flag (CONFIG_USB_GADGET_SUPERSPEED) that is set
> during compilation. If that flag is defined, then (and only then!) will t=
he
> driver->speed be set to SS by composite_bind. Please keep in mind the

and that's the only thing I'm asking you to remove :-)

we should be to compile dummy_hcd in SuperSpeed and still have
high-speed gadget drivers :-)

> following:
> 1. if CONFIG_USB_GADGET_SUPERSPEED=3Dtrue, existing gadget drivers are st=
ill
> functional with dummy_hcd since as I already mentioned, they will be
> enumerated through HS root hub and thus the gadget.speed will be set to H=
S.
> This is true for all gadget drivers, including the once that don't define=
 SS
> descriptors.

only due the module parameter, right ?

--=20
balbi

--l3ej7W/Jb2pB3qL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3NCOAAoJEAv8Txj19kN1rDMIAIypycrvw9e7YiHWuWMquZqN
BD1SeDosOmvO0AICCGRxuFbhyiLp3c2AAulRzRjn77ggzIEFGlcOnyrDPF9A49AR
0LOVyF0f9VEsUO7xCMEU1XLCrjhZiTVU1kmtoSXBjlP8VngCRkU58VmBz6llD2mG
0m3j6Be+qCK2VSBDRocSChUgr5Tz7Vwc3d2mBHWBh9UiEIkz+3LM5D3Rf+xPrE1m
OQtE2TT8qB53rnIqh6oCvFHEqytkSLohuKBXNt3d1Xna2GdlcEzAsIzRTT8fFK8z
1I8V1XQlGv6o5HCeGfzMF2fM+z0d/zm0+zcpTHoC23xWbsCnG0KhXgQWBl8EisM=
=BUhJ
-----END PGP SIGNATURE-----

--l3ej7W/Jb2pB3qL2--
