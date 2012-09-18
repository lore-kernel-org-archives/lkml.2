Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2IRGMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:12:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab2IRGMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:12:50 -0400
Date: Tue, 18 Sep 2012 08:11:55 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 5/7] pwm: i.MX: add devicetree support
Message-ID: <20120918061154.GB1459@avionic-0098.mockup.avionic-design.de>
References: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
 <1347267577-3296-6-git-send-email-s.hauer@pengutronix.de>
 <20120911144043.GA3824@avionic-0098.mockup.avionic-design.de>
 <20120912090458.GN6180@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <20120912090458.GN6180@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:5ic3iP4/H3zr8fs2S/6Vc3zK79P3KoowJVxHwaaMdZN
 QYg+Q7MQZ6MK9IoQaRrgARN1z5JQ837mkx+I/lqXDA8rEXJwNS
 DzJ7QKt/T9ldYUeK4kRFS4L5/S7j2PjGPd5Llpa5jUDEZZDBq2
 7dmfozcsrQDnHb2rm0u8MPROYhk/6yxsAeMQSUSlUhviYXG8rA
 ATFhxGErmNLTbnMChm+4JQKJPcvq4XHZ7viLTH/ZRy4dYKyIZr
 YMBgEfeQ5Rm9o2y/IFbpdnjcPl2gtTtesU+9UcV9iIALGW1xt8
 b4jXGiFndzA9U3oXml1MJy8nSIaS5P4/eqE9Qkm91QCSYsIS5W
 mIQjF30hEZejJG3pUypkbI6RzkjWLDBfqePALcgQhohsexd0u4
 3Mjw9I87B11YosQGmY+cbSQWddxB42wynznRigtGvdfX6VOBqg
 Ln6CP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 12, 2012 at 11:04:58AM +0200, Sascha Hauer wrote:
> On Tue, Sep 11, 2012 at 04:40:43PM +0200, Thierry Reding wrote:
> > On Mon, Sep 10, 2012 at 10:59:35AM +0200, Sascha Hauer wrote:
> > > From: Philipp Zabel <p.zabel@pengutronix.de>
> > >=20
> > > At the same time remove platform based support. No user for
> > > this driver has made it into mainline so far, so all we break
> > > is out of tree stuff.
> > >=20
> > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> > > Reviewed-by: Beno=C3=AEt Th=C3=A9baudeau <benoit.thebaudeau@advansee.=
com>
> > [...]
> >=20
> > I was just doing some build tests on the series and noticed that it
> > fails with this:
> >=20
> > 	  CC [M]  drivers/pwm/pwm-imx.o
> > 	/home/thierry.reding/src/kernel/linux-pwm.git/drivers/pwm/pwm-imx.c: I=
n function 'imx_pwm_config_v2':
> > 	/home/thierry.reding/src/kernel/linux-pwm.git/drivers/pwm/pwm-imx.c:14=
0:2: error: implicit declaration of function 'cpu_is_mx25' [-Werror=3Dimpli=
cit-function-declaration]
> >=20
> > This breaks bisection in the middle of the series. It seems to be
> > related to this change.
> >=20
> > > diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> > > index a1e799e..b4e0ad3 100644
> > > --- a/drivers/pwm/pwm-imx.c
> > > +++ b/drivers/pwm/pwm-imx.c
> > > @@ -16,8 +16,7 @@
> > >  #include <linux/clk.h>
> > >  #include <linux/io.h>
> > >  #include <linux/pwm.h>
> > > -#include <mach/hardware.h>
> >=20
> > This probably needs to be postponed to the next patch, until the final
> > reference to cpu_is_mx25() is removed.
>=20
> Oops, you are right. I updated the tag accordingly, and did a full
> compile test over this series, so please pull again:
>=20
>=20
> The following changes since commit fea7a08acb13524b47711625eebea40a0ede69=
a0:
>=20
>   Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.pengutronix.de/git/imx/linux-2.6.git tags/imx-pwm-oftree
>=20
> for you to fetch changes up to a1d38ca9e249e670aa9f608e1cc7491fb4ca45af:
>=20
>   pwm: i.MX: fix clock lookup (2012-09-12 11:00:55 +0200)
>=20
> ----------------------------------------------------------------
> Cleanup i.MX PWM driver and add devicetree support
>=20
> ----------------------------------------------------------------
> Philipp Zabel (2):
>       pwm: i.MX: add devicetree support
>       pwm: i.MX: fix clock lookup
>=20
> Sascha Hauer (5):
>       pwm: i.MX: factor out SoC specific functions
>       pwm: i.MX: remove unnecessary if in pwm_[en|dis]able
>       pwm: i.MX: add functions to enable/disable pwm.
>       pwm: i.MX: Use module_platform_driver
>       pwm: i.MX: use per clock unconditionally
>=20
>  Documentation/devicetree/bindings/pwm/imx-pwm.txt |   17 ++
>  drivers/pwm/pwm-imx.c                             |  278 ++++++++++++++-=
------
>  2 files changed, 199 insertions(+), 96 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pwm/imx-pwm.txt

Applied, thanks. On a side note, I decided to pull the branch, extract
the patches and apply them to my tree with git am, so this won't show up
as a proper merge. This is all still pretty new to me and I'm still in
the process of finding out what works best, so I hope you don't mind.

Thierry

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWBCqAAoJEN0jrNd/PrOhVoEQALw+0hVGEdBB7WSu2a8vv8vF
S9dPKQ9nZDbua+jA59rzZ1U9C4QwLUdyOxMHa5ccNXr5chM2gOwiFBdAtzqpu84T
um/6cYd4C7aIW/qm79WKKuKKTWvlkFU+oleCOYjf/YuMEFKLmueMOLudFxVblZ70
TeH5wzR+I/bttJlDjE0YLo4/DQlcM2izNzTWatzbhXs4hHIfrWmL02TVsbcwfO2N
WQ2Sxx75t6fAem68pPNo05K8o6q+zlPXQJyO+AgrUNRiunmoH7kTbz0BEbOathMk
N67W11nWHfqSgDiKBY2mh9tPMBgouDa5j2shvte1j0+Mlk9+vxua7S/dZNaMQWXq
hF+C6mI1SO8SrL3PXqJE2HA6+jdQyWgXWhz9B/46ie6XCZk3Y8NONpbdFfYbEI6L
lJQgCn8qP2hBlcRFo1pnamI5b3m6rCAvh22s6fhf2GUONvQkwCYpUgLtCGosb5LG
wUPfbALTvxjPVEMpjIbCeoMyeA/Z6P+CHQLQqLDyQMP/yIqMXQyOT3ESAPgKuCSF
VDDL04N8oo1xIxrhe4TQtzfTxvCpGftztayqQNCnCEdoX1Tq+JPNYAnXnKdRmqWW
JfLQTMz82J07DXatISo8hjMIkj4vUTeS9wq3iLWRY8ZWAHOIUbXp8nEJ1j7Ccs6p
KOQiPxqNNyt6c4ONKAO6
=m7AS
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
