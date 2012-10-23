Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2JWJXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:23:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab2JWJXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:23:14 -0400
Date: Tue, 23 Oct 2012 11:22:47 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
Message-ID: <20121023092247.GA13220@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
 <1350643135-13197-2-git-send-email-linux@prisktech.co.nz>
 <20121022063423.GA17181@avionic-0098.mockup.avionic-design.de>
 <1350888712.3592.11.camel@gitbox>
 <1350889747.3592.17.camel@gitbox>
 <20121022072448.GB30026@avionic-0098.mockup.avionic-design.de>
 <1350891382.3592.22.camel@gitbox>
 <20121022080414.GB4931@avionic-0098.mockup.avionic-design.de>
 <1350981706.20938.7.camel@gitbox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <1350981706.20938.7.camel@gitbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:OneuApvsASCC3wm9pHTqedjwXwVjHo5nkiH1xyW+/5H
 +4+BZ5nQyTtOXPyjrH7uePGQN0ZSc/KH53Pl0jFdabS3uN2zUs
 oJF27vpfetSSNte83ZH20/H2pcXHS3hLzOwyHro6lv3daSj12G
 EmmXmAvsLwZWuQ/RSBEpa07M/HJKDnPs4pIe7YxholwfszpsK+
 D56f5z8tzJZCDLAlRYic3yUjbMmBMueBPUSVBb8rOQBMIhq47r
 8nCWtPwnmJAHUmRAd/HlEwadrHwC70Il9bNQaimbXpy2NIOCxT
 3stK6a9SIovdopA40s2qFdOVoJPvlAM7QbAC4pn7Jxz4ZEKg8p
 mFdqKNouUN7LtG6/008dqIQBaP88QNXD3FS6KYbV6TpmLmkLTe
 sfxb/71hwVIevZXPI1Ggo1yWOblcLF4qEy8PKESoVBAQl5ng9x
 zNSEj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 23, 2012 at 09:41:46PM +1300, Tony Prisk wrote:
> On Mon, 2012-10-22 at 10:04 +0200, Thierry Reding wrote:
> > On Mon, Oct 22, 2012 at 08:36:22PM +1300, Tony Prisk wrote:
> > > On Mon, 2012-10-22 at 09:24 +0200, Thierry Reding wrote:
> > > > On Mon, Oct 22, 2012 at 08:09:07PM +1300, Tony Prisk wrote:
> > > > > On Mon, 2012-10-22 at 19:51 +1300, Tony Prisk wrote:
> > > > > > >=20
> > > > > > > >  	chip =3D devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERN=
EL);
> > > > > > > >  	if (chip =3D=3D NULL) {
> > > > > > > >  		dev_err(&pdev->dev, "failed to allocate memory\n");
> > > > > > > > @@ -123,26 +144,32 @@ static int __devinit pwm_probe(struct=
 platform_device *pdev)
> > > > > > > >  	chip->chip.ops =3D &vt8500_pwm_ops;
> > > > > > > >  	chip->chip.base =3D -1;
> > > > > > > >  	chip->chip.npwm =3D VT8500_NR_PWMS;
> > > > > > > > +	chip->clk =3D of_clk_get(np, 0);
> > > > > > >=20
> > > > > > > I thought this was supposed to work transparently across OF a=
nd !OF
> > > > > > > configurations by using just clk_get() or devm_clk_get()? I g=
uess that
> > > > > > > if the driver depends on OF, then this would be moot, but we =
should
> > > > > > > probably stick to the standard usage anyway.
> > > > > > >=20
> > > > > > > Furthermore, of_clk_get() doesn't seem to be managed, so you'=
d need to
> > > > > > > add explicit clk_put() in the error cleanup paths. One more a=
rgument in
> > > > > > > favour of using devm_clk_get() instead.
> > > > > >=20
> > > > > > Hmm good point. I stuck with of_ functions because its an OF on=
ly driver
> > > > > > and it seemed 'backward' to mix old code with new. It does pose=
 the
> > > > > > question of 'why have of_clk_get() if existing functions work b=
etter'.
> > > > >=20
> > > > > Was about to fix this but noticed why it wasn't like this to start
> > > > > with :)
> > > > >=20
> > > > > struct clk *devm_clk_get(struct device *dev, const char *id);
> > > > > struct clk *of_clk_get(struct device_node *np, int index);
> > > > >=20
> > > > > devm_clk_get requires me to 'get' the clock by name. arch-vt8500 =
(and I
> > > > > believe a lot of other arch's) don't enforce names for clocks def=
ined in
> > > > > devicetree, therefore there is no way for me to know what name th=
e clk
> > > > > has unless I include in the binding that the clock must be named =
'xxx'.
> > > >=20
> > > > I thought clk_get() was supposed to return the first clock specifie=
d in
> > > > DT if you pass NULL as the consumer name. I haven't tested this tho=
ugh.
> > > > And I haven't looked at the code.
> > > >=20
> > > > > of_clk_get retrieves it by the dt-node + index, so it doesn't car=
e as
> > > > > long as its the 1st clock listed.
> > > >=20
> > > > So the usual way to do this, I believe, is:
> > > >=20
> > > > 	clocks =3D <&clk_foo>;
> > > > 	clock-names =3D "foo";
> > > >=20
> > > > Then use:
> > > >=20
> > > > 	clk =3D devm_clk_get(&pdev->dev, "foo");
> > > >=20
> > > > And as I said above, I was under the impression that the default wo=
uld
> > > > be to use the first clock if NULL was specified instead of "foo".
> > > >=20
> > > > Thierry
> > >=20
> > > clock-names is an optional property (as defined in
> > > bindings/clock/clock-bindings.txt) so relying on it is .. well,
> > > unreliable.
> > >=20
> > > What you say makes sense, but it means the binding document has to ma=
ke
> > > an optional property into a required property simply to use an 'old'
> > > function when a new function would 'work' (granted not as well, as you
> > > pointed out) without requiring the optional property.
> >=20
> > Okay, I've just checked the core clock code, and indeed if you run
> > clk_get() with con_id set to NULL, you'll eventually call of_clk_get()
> > with index =3D=3D 0. That's exactly what you want, right? The only setup
> > where this won't work out is if you need to handle multiple clocks, in
> > which case I think it would make sense to make the clock-names property
> > mandatory. But for this driver that won't be necessary, since it will
> > never use a second clock, right?
> >=20
> > > Your subsystem - your rules. Let me know if I've managed to sway you =
or
> > > not :)
> >=20
> > I'd rather persuade you than force the issue. =3D)
> >=20
> > Thierry
>=20
> Further to the discussion, my preference is still for of_clk_get()
> (although I've changed the patch anyway as you saw because it makes no
> difference in this case) :)
>=20
> clk_get(x, NULL) and devm_clk_get(x, NULL) both seems like 'hacks' to
> allow platforms to convert to DT without having to update all their
> drivers first. It only allows the first (default) clock, as your pointed
> out. Getting a 2nd... clock relies on an optional property in DT (which
> again, seems like it is there to support 'old' drivers) which allows you
> to request clocks by name.
>=20
> of_clk_get() on the other hand seems like a properly native DT function.
> You don't need to know anything about the clock, as long as the correct
> clock is specified in the correct order as documented by the binding.
> Relying on 'pre-OF' code for a OF-only driver also seems
> counter-intuitive.

I do agree with those arguments. What I was saying is that for drivers
which aren't DT only, of_clk_get() is not an option and that maybe
others would be encouraged by the example to not use the generic APIs
even if their driver could be used in non-DT setups. But maybe I'm
worrying needlessly.

That said, maybe somebody with a broader view of things like Arnd
(Cc'ed) could share his thoughts.

> Granted of_clk_get() doesn't provide the 'garbage-collection' of
> devm_get_clk() but I think that is just an arguement to needing
> of_devm_clk_get().

That can be remedied by adding a corresponding function, so the argument
doesn't really count.

Thierry

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhmHnAAoJEN0jrNd/PrOhTJ0P/jz6v1hV0ZPHe556ZmyFGafO
oGKGkF3TbDi3ff3+Xv4oD02ppxmtetRLcrKYbTLYlQVVQfE+4DgAg48H+6PZjs6y
WExO7GEINz/6YGdYz2LtpnGeRLXOXYZVS9Mtb77PmX+9TKrDRgvPqKnJ8ivnj/lP
Ht/RWhT/iqTle003U6y5yIIvwMXmmt71zCecX+24Imp7LQEjVbOdSAX16plx9Sgk
foiu9tl7+CHN7229u3WTl0+c/Mr295OaeAIxBapCELm5/v3tPWLiZ/ova2DbNv+G
KeRLlHXgebaX1S2Ocj2NeSjdUspNotVeimUVV4xuDnJ8KX823VIBqYZRkrUuMoXw
1u3yCuzTLagv8e2Q4B98+d/rHuP5shhAdi7WKX6hYng3ezVDCJIyTv9yS3NhLM9B
mdjLUWLD7r6fdKjL8ZM89J2dUnxo0vxJltaOBIwc7Q5vJAKZ9sk4b+pF7BpBBJNg
zVzVSb4gAXZQAOveFCEC7XW3BWOqnsE5fxkoxQD9ZyJPq2SBW2f3kgN7BVdnWlv7
HWlJCgbKq7s27lOXfMGR+fx5vErF/1uIMtXOwz7ek9mwlq9th5xoA7gHWQIYbLjZ
ex/JNL4RWjdTUeooyK/oXEB/mHIihyzGp30G8r/2RZyZG6ySG623G43LuES0PO/a
OP1defE7uT7RcxeAS5AE
=j0t/
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
