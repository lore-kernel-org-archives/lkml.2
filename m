Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2KXUe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 15:34:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2KXUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 15:34:56 -0500
Date: Sat, 24 Nov 2012 21:34:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: "Philip, Avinash" <avinashphilip@ti.com>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 05/11] pwm: pwm-tiecap: pinctrl support
Message-ID: <20121124203423.GA26951@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-6-git-send-email-avinashphilip@ti.com>
 <20121122205944.GC16716@avionic-0098.adnet.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9EE991@DBDE01.ent.ti.com>
 <20121123105110.GA6884@avionic-0098.adnet.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9EEAAA@DBDE01.ent.ti.com>
 <20121123111811.GA5072@avionic-0098.adnet.avionic-design.de>
 <87mwy8eb7w.fsf@dell.be.48ers.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <87mwy8eb7w.fsf@dell.be.48ers.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:739WV8JyQr5bsprihRIwOlD/t2q+GL4Y1vPvt7vG4C5
 0LDVDy2brenxrx3gcXQ53gbXDruU4BFGZcQZyicCyWgyHJioAo
 04hCenZ5yj9Tkt+7Kd6HRfOvlnu/u3BNH3EcoZZMYZeTSVnfr3
 PhiAIYayMtL2wNk7+pjhdueKVWR1iSNEXkwUb46xCIOYW18buE
 AMJfpiHZUaxp5pWNPT0jYCgMp0ifsy0XmcjkKukz1Pbho6HDRN
 8wrB3DmfkNM/os1lcNMOhv5XUQdM7AoFgMLigVULf+RnDPQVuV
 bXhPCzZAKaF3Tm0ufyVduew1BmMA9+SwPXaSFOWfOij7DmCPkv
 uTBBBlVWyZVhCgHd8SzY6ngoyK9JjDnsGkEoDR89wIZJA6tqWW
 jIaevVT+mXvw5mkR4wnfHYqOnaU4NXi3qJgghH8DF2CeNXnvlg
 Stbgt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 23, 2012 at 01:48:51PM +0100, Peter Korsgaard wrote:
> >>>>> "Thierry" =3D=3D Thierry Reding <thierry.reding@avionic-design.de> =
writes:
>=20
> Hi,
>=20
>  Thierry> Everybody seems to be doing it with a warning, so I guess
>  Thierry> that's fine for now. I just find it strange that if you
>  Thierry> request the default pin group to be selected when in fact the
>  Thierry> hardware doesn't support pinctrl at all you shouldn't be
>  Thierry> getting an error either.
>=20
> There's several different situations:
>=20
> - Platform without pinctrl support
> - Platform with pinctrl support but no pinmux specified in dt for device
>   (E.G. pinmux setup in bootloader)
> - Pinmux specified in dt
> - Some kind of misconfiguration in dt
>=20
> You could argue that devm_pinctrl_get_select_default() shouldn't return
> an error for the first situation, but how should it be able to know the
> difference between 2 and 4?

In case where the platform supports pinctrl but no pinmux is specified
for the device it should just assume that no pinmuxing is needed. That
sounds like the most logical behaviour to me. In those cases pinctrl
could just assume that the default has already been selected and not
return an error.

But you can't reasonably expect to cope with misconfigured DT content.
Heck, there's no way for you to even know if it is misconfigured.

That said, I'm not sure how much of an issue this really is. Pinmuxing
is only used for functions local to a given chip, right? So if an SoC
supports pinctrl and a given peripheral needs pinmuxing then we can
reasonably assume that your second case can't happen, can't we?

Thierry

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQsS9PAAoJEN0jrNd/PrOha9oP/RS/X0G6dTICS4zTToAOG48Y
BXZfFk6WqdhIFygeHfB1cQgO5zoitWTiH1/D5zA4yUIoJrgn670wZkN59b8uWhei
vVfh6QmKfEIASd6DkQUFAuXibTLUBy/E5kcWpRZbQ5DZNOSU4NktrsLIYBG6DfAu
O4FSZmw+TppRyuHvi/JG3WAyV0h2wfXTH259+nIJJM+iqPxnRQTZi+rAFwFL+vij
r2BHZ17ozg5pXIaxEXwfNXCO9SE8LpX9d/Sxe1Er+ZwxstS9X2LTrlwU3JGu31zQ
xoD/NpswTmgm9hUcbjZogpUsBAF52dmWC8dYOntF9MEO4Vzu2lj8T7fc+/FyuZ2H
GQV7fdfFKRK7uBwAzUCTSswsemvRp0MCMHrx9RziuKEZGXjCoitqUVQpFxMkMkNT
H8aYbXpUrWRdN+mvQrEbnR8Ts20hCQr2x8ioIeqCLXRefzPPRtj6mbg2kPQkd+pm
ED2OvCU8PH+yl1iKX/rg29cHdQPHxNYlt63s0TQwfs5NjIjle039o1oLaoed/wcr
+P288bxV4XEtlN0rwWdKiQhCIJgZ4E692nMoLcLO0LgM3rIraNVtnoOctqfTsfsG
0YR5mxudEZQAS75EFGaM9cFf8fatw+AMC64jPmmFGr7VT0n6HA+W5UE28ZtbqEIC
G1gK/343v+RBoCIbuJsc
=V52s
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
