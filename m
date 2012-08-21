Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2HUIdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:33:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2HUIdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:33:40 -0400
Date: Tue, 21 Aug 2012 10:33:30 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120821083329.GA28992@avionic-0098.adnet.avionic-design.de>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
 <1345535069.4085.7.camel@deskari>
 <1562509.b0FYTUZ1D8@percival>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1562509.b0FYTUZ1D8@percival>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:pB30nVu79wibitzf0pTWjjsjjrKd0z8zUXGhcw/jh4R
 Lrp4ll5BSFZFTQeYG5z7+b6ONYvzScup9v4fIS8FcFLxWBuyFQ
 4NgmNcY74jplfBmtPYxEGNnwdIpREDdt2ZmJSvQmSpvJX+22wR
 ujx0L66bHDy3xSk++0YafPV+tIHUFKSI1O5Wy28fai8uommd2b
 /kpJncoEFENkseedS7bhICFDhceSsq9YYidhqZxiNGzsNNZeMz
 J5Hfuvs2Ci7PmHB9YvlYKpJj/1/GCPVwIQTyjXzey9z0iSiKNm
 6ASQKJm6sNshvKCtpxgKTZEDWuWs01BSpnErft+kq9GbzgmX2r
 xBqO/3Y7YUEnpYmZICMOuIQmiBneCvjGCSN+eHFQ6kM+9JNSql
 GCyDsbCVhIsYPJq9v7+p8GUXotSU4TSgClfJJsurwpbO2304jH
 agI/2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 05:22:12PM +0900, Alex Courbot wrote:
> Hi Tomi,
>=20
> On Tuesday 21 August 2012 15:44:29 Tomi Valkeinen wrote:
> > > +Problem
> > > +-------
> > > +One very common board-dependent code is the out-of-driver code that =
is
> > > used to +turn a device on or off. For instance, SoC boards very commo=
nly
> > > use a GPIO +(abstracted to a regulator or not) to control the power
> > > supply of a backlight, +disabling it when the backlight is not used in
> > > order to save power. The GPIO +that should be used, however, as well =
as
> > > the exact power sequence that may +also involve other resources, is
> > > board-dependent and thus unknown of the driver. +
> > > +This was previously addressed by having hooks in the device's platfo=
rm
> > > data that +are called whenever the state of the device might reflect a
> > > power change. This +approach, however, introduces board-dependant code
> > > into the kernel and is not +compatible with the device tree.
> >=20
> > I've been having the same problems on OMAP display related code, but the
> > problem has always been fixable by just having the driver to use a
> > common framework to do the job (a framework which may not have existed
> > at the time). The problems have never been board specific in the end,
> > but device specific.
> >=20
> > Can you describe your particular HW problem a bit more? In the backlight
> > case, what exactly requires the delays and the sequence you show in the
> > example to enable/disable the backlight?
>=20
> In the example, the sequence (including delays) is clearly stated by the=
=20
> backlight specification, which is part of the panel specification. The ba=
cklight=20
> uses a PWM, which makes it suitable to use the generic PWM backlight driv=
er,=20
> but how to turn the backlight on and off is very backlight specific. The =
power=20
> sequences allow to replace the board-specific backlight callbacks by sequ=
ences=20
> in the DT.
>=20
> On the other hand, I saw your discussion with Laurent about the panel=20
> framework, and I wonder how this would fit into it. Backlights are typica=
lly=20
> embedded within panels. Power sequences are a good way to deal with the=
=20
> absence of specific drivers for every panels, since they allow to tailor =
the=20
> behavior of generic drivers to fit particular needs. But if every panel c=
omes=20
> with its own driver (which would define the backlight device using the mo=
st=20
> appropriate driver), then it could just as well perform its backlight's=
=20
> sequences via regular callbacks. In this particular case, there would be =
no=20
> need for power sequences.
>=20
> Power sequences are supposed to go beyond backlight drivers and support a=
ll=20
> sort of devices (I have heard that it could be useful for modems as well)=
, but=20
> I wonder how relevant they are when there is a proper driver for a device=
=2E I=20
> hate to question my own work but now I cannot help but think that a prope=
r=20
> driver could do the same job. So what are we trying to achieve with power=
=20
> sequences? Are we trying to avoid a drivers' explosion by keeping some of=
 the=20
> specifics out of them? Which approach would be preferable? Are there case=
s=20
> where a dedicated driver could not replace power sequences?

I suppose power sequences aren't needed if you have a specific driver
for every panel out there. However that also means that you'd have to
write drivers for literally every panel that requires support. In the
end this will just result in discussion down the road how the common
functionality can be refactored and we may end up with power sequences
again.

Also as you mentioned, power sequences are useful for a number of other
use-cases. Without power sequences you'll have to potentially create
extra frameworks tha reimplement parts of the power sequence code for
their specific hardware needs.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQM0fZAAoJEN0jrNd/PrOhR6sP/AuUV9F0HZHGKO/QPyO9Snit
9/Az5XzsYW/b2Hee+7kiGtI4N1ZinKFr5Q4PtxCLJgwlzJf1s94HUQf0Oql+bhj2
f3OBh5ojaTQzfGkf9pLasd7hqAxHjEd6TlQkHFNPJX++zQB5POLUoaHtCfI0EjX+
tdHQpEx/7726fJ+dUAGhGcnYmGI/7bLB5LrDf8iJK7F5Lo1RC9eN5NOkNkn+WmGq
mIXT18sv1j1J3QYF1Rb9eZzDJrbN6KOYFo5VtjFWmVvnaWPOQ0HWN0iXW6mWhM7F
WS7XL+Dxk2KLGWYFZ4mjHi2P20YyHb2aLW3VcWGnh7JvIZJdhJCbS6b7HS0ixQwI
u/mcMIjSK5PjkorzAZTYOr02W1tdSKTPyO4zVWeIEFAu6shMMxaz8m0SDjtHsN1C
UnMSuReaRnOm1aJbI5rmb59YSEx0jLW6dkDk9JgDOke41/5MyuN2cPLM3WTQU4wJ
oQkfgxzvRiw3lLmLichEFiaRlC0ROhC4xs1pUbZgoWUPaaBtT3tgaf3uAKR6XEcR
zFiJTlZmYt/lVhqN5zyG1T9/R7WvQIQJJqt6e/qjvBm4PqTPnW/q1x23jHYSmOqy
OjDICroa9wGZe7K1IF4+UUZVDYCN4E/8ho42fOFVm4V/ylV83OSe2BSj77U3tJQh
YYljHeSGqboKdsvgzEAP
=lozy
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
