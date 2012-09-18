Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2IRSGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:06:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2IRSGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:06:09 -0400
Date: Tue, 18 Sep 2012 20:06:00 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Describe interrupt-controller binding
Message-ID: <20120918180600.GA29360@avionic-0098.mockup.avionic-design.de>
References: <1347958274-19425-1-git-send-email-thierry.reding@avionic-design.de>
 <505876F0.6010809@gmail.com>
 <50588B6C.6080402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <50588B6C.6080402@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ZGEvfGqv9AIXoj7wv8DGzcsvXW0Q/3iyRtSbMuEp1xb
 EtCWCp/TCdGk1tXOKlmVmsqAOFwdZFkp7G1lwNwm9BY46OrbWW
 irCfD4OuWM5LPzUH0tJhHklEpRlrzTYE2d2ldFSNwhjFpVfLv5
 vkDC9jgoX2tz6mWw/JbdOfbf+dUTYP7uItW03kIOvnHc32NnUn
 TyLpqg8THxcZ/VVywsjU8FKDXeMCXG79xdgGcoWFWOjIbjGbwS
 /N7zw/tmM1eeDutCEBse/+q49pgY4ANL9A5P3eCUhzZGbX7lFR
 ve8gcyS5c0vSUx+ysrpHP6zqkWLKpO1nUlBsVQX+TfT2WQSBO8
 yU24+9lm97JzZ0NsPq4Vq2aWMZ5DfFwTdJiryjGqtecVpeRfrQ
 +lJMIs+w826yKp8PPHTMDGc2XArigDqayE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 18, 2012 at 08:55:40AM -0600, Stephen Warren wrote:
> On 09/18/2012 07:28 AM, Rob Herring wrote:
> > On 09/18/2012 03:51 AM, Thierry Reding wrote:
> >> In order to use GPIO controllers as interrupt controllers, they need to
> >> be marked with the DT interrupt-controller property. This commit adds
> >> some documentation about this to the general GPIO binding document.
> >>
> >> Cc: Linus Walleij <linus.walleij@stericsson.com>
> >> Cc: Grant Likely <grant.likely@secretlab.ca>
> >> Cc: Rob Herring <rob.herring@calxeda.com>
> >> Cc: devicetree-discuss@lists.ozlabs.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> >=20
> > Applied for 3.7.
> >=20
> > Rob
> >=20
> >> ---
> >>  Documentation/devicetree/bindings/gpio/gpio.txt | 33 ++++++++++++++++=
+++++++++
> >>  1 file changed, 33 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documen=
tation/devicetree/bindings/gpio/gpio.txt
> >> index 4e16ba4..8d125b0 100644
> >> --- a/Documentation/devicetree/bindings/gpio/gpio.txt
> >> +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
> >> @@ -75,4 +75,37 @@ Example of two SOC GPIO banks defined as gpio-contr=
oller nodes:
> >>  		gpio-controller;
> >>  	};
> >> =20
> >> +If the GPIO controller supports the generation of interrupts, it shou=
ld
> >> +also contain an empty "interrupt-controller" property as well as an
> >> +"#interrupt-cells" property. This is required in order for other nodes
> >> +to use the GPIO controller as their interrupt parent.
>=20
> Surely this is generic information for any interrupt controller, and
> hence doesn't belong in the GPIO binding?

LinusW requested this in order to avoid having to list these properties
in every GPIO controller. I suppose that having it in an extra binding
for interrupt controllers might make sense as well, but in that case we
should probably provide a reference because the GPIO binding is where
people are most likely to look for this information.

There is Documentation/devicetree/bindings/open-pic.txt, which already
lists most of this information, so maybe a reference to that document
will do just as well?

> >> +If #interrupt-cells is 1, the single cell is used to specify the numb=
er
> >> +of the GPIO that is to be used as an interrupt.
> >> +
> >> +If #interrupt-cells is 2, the first cell is used to specify the number
> >> +of the GPIO that is to be used as an interrupt, whereas the second ce=
ll
> >> +is used to specify any of the following flags:
> >> +  - bits[3:0] trigger type and level flags
> >> +      1 =3D low-to-high edge triggered
> >> +      2 =3D high-to-low edge triggered
> >> +      4 =3D active high level-sensitive
> >> +      8 =3D active low level-sensitive
>=20
> That certainly shouldn't be in the generic GPIO binding; the format of
> the interrupt specifier is determined by the binding for the individual
> device that is the interrupt controller. Just because a device is also a
> GPIO controller doesn't mean that it has to conform to a specific format
> for the interrupt specifier.

I think it does make sense to provide a description of the most commonly
used variants. The above certainly is what the majority is using and
many of those that do not use one of the predefined irq_domain_xlate_*()
functions reimplement them with some additional checks or conversions.

Thierry

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWLgIAAoJEN0jrNd/PrOhojMP/11Yf+MFQtyJQLAV4gaqZWUA
mGrxS4bRqEpqAfLQiT3GzwLHDirrhsHio5lUF81ynk4PBmApW5+8fAlCLhLxRAu1
6pDq+mexqJuz/U7wUKxzbR72FCRxed/IbZUNaZZ14JkoNyn9XZaX4W1AhWbfuNMn
qwOX2zXR4BkopD7CfY7BzV0RleKnBKTTDVNfwX2eHdcV4n4XFlzSkW8cJycjqvYs
3yqCXprX4UwBPUW78fA27UwdeP++a1RU/n/dS0oOcjNTAYdufBh6ke0FuTGiz/l2
dXvfLZ0pSTGfYUcU8/1y669eppKdjw6Y+y82UjuQ+lPGUhcwsLjEUKcr92Jb/OvQ
Aagp1nPbNKSFgX1YlfJIqyq+rAfj7yLfDTI6iCYtU+4gLNbx+MzwMyUxXWO5oDLr
Sr+dzUXCz5lNwn9ChdOkvGdE9QWiDO2xIPBXv+NHbPnRq8MOtF5Wq9XtrkJ1XaGg
loCZ2Gzgswa2KSMCILn25GfPc0ARBuVFyv1W46hJA1KFAWhUcDMoxlZPVycrB7qN
9RTFXc/5ue1CRixxQhPG6E2wpf+8hFQCE6PinvV4tSdYob4NvbSuLVKpwNE7i9QD
30UPHNsqCZOr1urjAvUr3zMccyu4FcOcV4HtCEIuxCLjpH+31o5Mgd9eZ3gtRC3O
sHryf4ZDviaAh+LjotaC
=CQA5
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
