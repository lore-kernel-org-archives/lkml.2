Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2IRSqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:46:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49416 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2IRSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:45:59 -0400
Date: Tue, 18 Sep 2012 20:45:53 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Describe interrupt-controller binding
Message-ID: <20120918184552.GD29360@avionic-0098.mockup.avionic-design.de>
References: <1347958274-19425-1-git-send-email-thierry.reding@avionic-design.de>
 <505876F0.6010809@gmail.com>
 <50588B6C.6080402@wwwdotorg.org>
 <20120918180600.GA29360@avionic-0098.mockup.avionic-design.de>
 <5058BA26.20403@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Content-Disposition: inline
In-Reply-To: <5058BA26.20403@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:baW9pVueH1P9g20wj/3YJSLnRR6f95N+6fuW7H56l+L
 n9Mcku19omY2iRVAFvMiuzav6VdPbNTaZCPBbXqosTRNu2SN3b
 ur8p/8QQZ+b44QFkRvDiKwykUUGbeXxZjorE8m1f/4AGFeYqYm
 sPGr9s8OHnpGbdxXkB4i2wrCm8DqdSwtwLSviuAg3Su5vnsx8q
 HJwG1x8hUL+3jSXdkU7uq2V4eAvAe4w3FxlAkWQqlu2iHBjHb4
 34VO5wil1OsJ8zKgRinIEV3yPK6UuKAPhvS08mwMoTwR/0cqa/
 vN76kt0h14Spk43Vs1qzxNVkdYyGGhA4CzR+irSNhn59UxbQU7
 Gpk8rH6pFW0txewa5NtPdjnXi7QOfzOvXUr7QGMWSVq4xUVYsB
 NW4KB3V2/6KjZp4zE0iGSx1/KzOzaFz+I8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 18, 2012 at 12:15:02PM -0600, Stephen Warren wrote:
> On 09/18/2012 12:06 PM, Thierry Reding wrote:
> > On Tue, Sep 18, 2012 at 08:55:40AM -0600, Stephen Warren wrote:
> >> On 09/18/2012 07:28 AM, Rob Herring wrote:
> >>> On 09/18/2012 03:51 AM, Thierry Reding wrote:
> >>>> In order to use GPIO controllers as interrupt controllers,
> >>>> they need to be marked with the DT interrupt-controller
> >>>> property. This commit adds some documentation about this to
> >>>> the general GPIO binding document.
> >>>>=20
> >>>> Cc: Linus Walleij <linus.walleij@stericsson.com> Cc: Grant
> >>>> Likely <grant.likely@secretlab.ca> Cc: Rob Herring
> >>>> <rob.herring@calxeda.com> Cc:
> >>>> devicetree-discuss@lists.ozlabs.org Cc:
> >>>> linux-kernel@vger.kernel.org Signed-off-by: Thierry Reding
> >>>> <thierry.reding@avionic-design.de>
> >>>=20
> >>> Applied for 3.7.
> >>>=20
> >>> Rob
> >>>=20
> >>>> --- Documentation/devicetree/bindings/gpio/gpio.txt | 33
> >>>> +++++++++++++++++++++++++ 1 file changed, 33 insertions(+)
> >>>>=20
> >>>> diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt
> >>>> b/Documentation/devicetree/bindings/gpio/gpio.txt index
> >>>> 4e16ba4..8d125b0 100644 ---
> >>>> a/Documentation/devicetree/bindings/gpio/gpio.txt +++
> >>>> b/Documentation/devicetree/bindings/gpio/gpio.txt @@ -75,4
> >>>> +75,37 @@ Example of two SOC GPIO banks defined as
> >>>> gpio-controller nodes: gpio-controller; };
> >>>>=20
> >>>> +If the GPIO controller supports the generation of
> >>>> interrupts, it should +also contain an empty
> >>>> "interrupt-controller" property as well as an=20
> >>>> +"#interrupt-cells" property. This is required in order for
> >>>> other nodes +to use the GPIO controller as their interrupt
> >>>> parent.
> >>=20
> >> Surely this is generic information for any interrupt controller,
> >> and hence doesn't belong in the GPIO binding?
> >=20
> > LinusW requested this in order to avoid having to list these
> > properties in every GPIO controller.
>=20
> There's no need to list this property in an individual GPIO
> controller's binding either; it's a standard property for any
> interrupt controller of any type.
>=20
> > I suppose that having it in an extra binding for interrupt
> > controllers might make sense as well, but in that case we should
> > probably provide a reference because the GPIO binding is where=20
> > people are most likely to look for this information.
>=20
> Yes, we probably should have a centralized .txt for the base interrupt
> controller properties. I guess we don't today because it's probably so
> old everyone assumes it.

Since each driver binding still needs to document it and in order to
avoid needless duplication I think having a central location for this
makes a lot of sense.

> For some other patches I sent, I created
> Documentation/devicetree/bindings/interrupt-controller/ - a file in
> that directory would make sense (bike-shedding: irq.txt, interrupts.txt?)
>=20
> Yes, each individual GPIO binding (that actually is an interrupt
> controller; some may not be) should probably mention this and refer to
> whatever documents the interrupt controller properties.

Okay. So how about I add a file interrupts.txt in that directory and put
something like what this patch contains into it? Then I can just add a
reference to the driver binding that the controller can be used as an
interrupt-controller and that a description can be find in this new
document.

> > There is Documentation/devicetree/bindings/open-pic.txt, which
> > already lists most of this information, so maybe a reference to
> > that document will do just as well?
>=20
> I think that's just one random interrupt controller. The common/core
> properties probably should be separated out.
>=20
> >>>> +If #interrupt-cells is 1, the single cell is used to specify
> >>>> the number +of the GPIO that is to be used as an interrupt.=20
> >>>> + +If #interrupt-cells is 2, the first cell is used to
> >>>> specify the number +of the GPIO that is to be used as an
> >>>> interrupt, whereas the second cell +is used to specify any of
> >>>> the following flags: +  - bits[3:0] trigger type and level
> >>>> flags +      1 =3D low-to-high edge triggered +      2 =3D
> >>>> high-to-low edge triggered +      4 =3D active high
> >>>> level-sensitive +      8 =3D active low level-sensitive
> >>=20
> >> That certainly shouldn't be in the generic GPIO binding; the
> >> format of the interrupt specifier is determined by the binding
> >> for the individual device that is the interrupt controller. Just
> >> because a device is also a GPIO controller doesn't mean that it
> >> has to conform to a specific format for the interrupt specifier.
> >=20
> > I think it does make sense to provide a description of the most
> > commonly used variants. The above certainly is what the majority is
> > using and many of those that do not use one of the predefined
> > irq_domain_xlate_*() functions reimplement them with some
> > additional checks or conversions.
>=20
> OK, but the document can't say "this is how the IRQ specifier is
> formatted", when it clearly isn't generally true.
>=20
> The document should say that the format of the IRQ specifier is
> entirely determined by the individual binding, but that bindings may
> often choose to re-use the following common format. Each individual
> binding would then need to document whether it did choose to use that
> common format, or whether it instead chose something custom.

Yes, that makes sense.

Rob, given the above discussion I think it'd be better if I followed up
with a patch that moves this description into a more generic location
and we removed this patch.

Thierry

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWMFgAAoJEN0jrNd/PrOhqfoP/RUaVL9W15SoIclcP7Zp9tdo
Pzi8R83R0+a92JXgrhvEffKVf3aNxI+wCpDvWIbCcQJqOJC9M1amE9r6/iq98Ju1
qNbXKJOJ+gA8wl5+H2RdiL7CsmM/xOnsTQNU8hesVuzST3A0bUscUiHW7NZYzuaT
MF6USBZio8PutdukD3hib7BBDnCTkiHCZ/bwuYwGLMM+UT25rAFhp1Xw+9v0ydEN
fCtyvziOtqgJGgXfprhcLuf4UpKbkVFFCuhLlAuEXBSinkJAC3PNge6/m3HAX89/
4QbofXuXul0h0jT8T0QEquo6ps8UFJ0puW5hsf24NyZhdm8OXy1S0LPXtpOW/cDf
zsVrLRxNqeLGjIj4NUzXeoi08SHwmvSeKpXIWwafoMMuf6k3IQimM9GtjIZ9Dbxm
8wJSWXDKcZ35yQzj7rN4PH9O4P+RzIqak+O+a3iIf+FHAdkI5DuIaUGyRJYMfU0I
o0Guip6DGLghr1YcWDZyG2o/rObhKqeHL+3lbTJs/UZ8HaBnRNvk2tv4iXHfKOaU
HBTzTtUa9n290awQcZ66+QNbFwdElC8HN5qAcTCRIjdSEQAn0X5JwyNwqTTrgA3O
P15R/PuJP0IAGkVG5FIqMkglOHnKQEwPtBGRfQln0WMgVszqBPeabWeKgCABqCoS
N9QxKvgbCgeI6tbBkhyQ
=qDVm
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
