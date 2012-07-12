Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab2GLKFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:05:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2GLKFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:05:02 -0400
Date: Thu, 12 Jul 2012 12:04:56 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Simon Glass <sjg@chromium.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC][PATCH V2 3/3] tegra: add pwm backlight device tree nodes
Message-ID: <20120712100456.GA1949@avionic-0098.adnet.avionic-design.de>
References: <1341814105-20690-1-git-send-email-acourbot@nvidia.com>
 <1341814105-20690-4-git-send-email-acourbot@nvidia.com>
 <CAPnjgZ1QbjE+-tr0c01K2feUdEE2wMBfR=bKpTxnyDOJbY8+1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <CAPnjgZ1QbjE+-tr0c01K2feUdEE2wMBfR=bKpTxnyDOJbY8+1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:8WOO8cTlmrZbApD4XnWLeqFmcwyTWWuXjj/wQBbObE6
 sZW5m4sZbtE8izTE1psswUU50+Lw01K2r5LztcRacGdD+B2wsy
 yIm3unExS6wWi+i2Yfs/3KG/V7EuNT6J07ovEkC3C670GHDL8v
 wlFr5brME9jZjxBB0g7piWgMz45KOXwz/R9AOkhx+4Xbao0X0/
 sqQIHzd34OlE4cUWiMoXIFYsd3uckIEHWuweMUyyMclzEoysHo
 zPvErbNTV1EiC9qAo2ipdZo09HUxkb2r1ALF4vkCLIybzxWDDa
 Adb7c90YdMX5few/okDfilTjwnO+vGZgTn2UZC4N0Ie9L+S0cO
 PjChvVFm678dAP1u2fGyzR5q5gglkd8cbSGcqvvYuU5mtOh+9Z
 wgDawHnDNixuqB1zYjQgqefvoW2/Nt0k0A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 12, 2012 at 11:37:33AM +0200, Simon Glass wrote:
> Hi Alex,
>=20
> On Mon, Jul 9, 2012 at 8:08 AM, Alexandre Courbot <acourbot@nvidia.com> w=
rote:
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > ---
> >  arch/arm/boot/dts/tegra20-ventana.dts | 31 +++++++++++++++++++++++++++=
++++
> >  arch/arm/boot/dts/tegra20.dtsi        |  2 +-
> >  2 files changed, 32 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/=
tegra20-ventana.dts
> > index be90544..c67d9e1 100644
> > --- a/arch/arm/boot/dts/tegra20-ventana.dts
> > +++ b/arch/arm/boot/dts/tegra20-ventana.dts
> > @@ -317,6 +317,37 @@
> >                 bus-width =3D <8>;
> >         };
> >
>=20
> I would like to do something similar in U-Boot for Tegra, although
> perhaps not right away. For now I will go with something considerably
> simpler! But if this is merged into the kernel we will move to it in
> U-Boot. Anyway here are my comments:
>=20
> > +       backlight {
> > +               compatible =3D "pwm-backlight";
> > +               brightness-levels =3D <0 16 32 48 64 80 96 112 128 144 =
160 176 192 208 224 240 255>;
>=20
> We seem to have a lot of these - should we move to a range and step size?

These actually seem to be a little bogus. The reason for introducing the
levels was to allow calibration of these values because they in fact
usually do not scale linearly. Instead, a linear brightness increase
usually maps to something like a logarithmic (at best) increase of the
duty cycle.

> > +               default-brightness-level =3D <12>;
> > +
> > +               pwms =3D <&pwm 2 5000000>;
> > +               pwm-names =3D "backlight";
> > +               power-supply =3D <&backlight_reg>;
> > +               enable-gpios =3D <&gpio 28 0>;
> > +
> > +               power-on-sequence =3D "REGULATOR", "power", <1>,
> > +                                   "DELAY", <10>,
> > +                                   "PWM", "backlight", <1>,
> > +                                   "GPIO", "enable", <1>;
>=20
> So the names REGULATOR, DELAY, etc. here are looked up through some
> existing mechanism? In general I am not a big fan of mixing strings
> and numbers in a property. Maybe something like:
>=20
> power_on_sequence {
>    step@0 {
>       phandle =3D <&backlight_reg>;
>       enable =3D <1>;
>       post-delay =3D <10>;
>    }
>    step@1 {
>       phandle =3D <&pwm 2 5000000>;
>    }
>    step@2 {
>       phandle =3D <&gpio 28 0>;
>       enable =3D <1>;
>    }

I actually like that a lot. What's missing from your example is a way to
specify the type of the phandle because it cannot be safely inferred.
Perhaps this could be done by just the property name:

	power_on_sequence {
		step@0 {
			power-supply =3D <&backlight_reg>;
			enable =3D <1>;
			post-delay =3D <10>;
		};
		step@1 {
			pwm =3D <&pwm 2 5000000>;
		};
		step@2 {
			enable-gpios =3D <&gpio 28 0>;
			enable =3D <1>;
		};
	};

However I think one of the reasons for Alex to choose his particular
representation is that people want this to be representable in the
platform data as well, which unfortunately can't deal very well with
this kind of situation.

Usually in the kernel you have one API to obtain a resource (pwm_get(),
regulator_get(), ...) which takes as an argument a device handle and a
name. For device tree, that API will lookup the resource by phandle,
while the non-DT code path typically uses a static lookup table.

It's a shame that we have to keep this kind of backwards compatibility
because it prevents these things from being represented in a logic way
in the DT sense.

Thierry

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP/qFIAAoJEN0jrNd/PrOhx8IQAKlUx6mLvkbPu7V+iX8DpWE3
chGdHh8cSoXBS5WrW0bTPlmYMzIgSUBa64eBZVT0e7nbyrgeltY04LSPydoHlfyK
tQYWv4i5hmD8m9zo4e0IMp85SVite+QEhFNPapCyTiL7Os3BoyX8olOxPlrPC7Rg
NpbYItUaqRM2sEIAyTHpgVGuPSocrva9dgFWlxr8dwvfHL3qCbT9gylj1hOMhlit
k7V6Vdg9WWu+lyboLGMbgVTmZDWqFcj51enuNnaL7UW9DPB9AMSA9jxZKtVBnffX
xwAc4SWkNqQ2PlOBhvyZ8IcO47p8JQ423+HaNHMlPGaXZZkmnU8VSlDWYlJFFbIa
Fzskn92DUibgvc3K8V6GHXtrpeW+ci5ng3swxj9gTNiGGF3SR42Zb+S3uERvelfG
E8TOAzKpO5a12L6lYrrBhMVwKjl5HWjShhiyCwVkEGhcRa6dJp6eGWZ8K3y6jqCB
T6dRaJy6Up0m3C29RSV6tbDAIP8bUq47Ko1HiTotMVB422mIRWTQFV9LI3ciogIL
aEhRsJk8bYF8244KFsn1FAKWQz8ZnrxTpuRXP2GsEdf6LOyt5Rng1EMzYMOMAXoG
sFO8BBdIeIDRrcy7ZourtEp9wh9S+mHOTrAwEzwcjcCZAPd+ZZxiwrJC22jZ69XZ
gU/YMjRyIHjwV2KU6rEc
=P1Hh
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
