Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab2JJNrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:47:23 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:59555 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755276Ab2JJNrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:47:22 -0400
Date: Wed, 10 Oct 2012 16:42:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: balbi@ti.com, viresh kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 1/4] dmaengine: dw_dmac: use helper macro
 module_platform_driver()
Message-ID: <20121010134159.GA4114@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1349178121-9105-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <1349859841.10584.122.camel@smile>
 <CAOh2x=mNiL4k=v3YGexq7YMZUx131QWBpm11QXupnWLUPuKU4Q@mail.gmail.com>
 <CAHp75VePqj3FViNrOcicHXhv9BzhJQgSg6KvA31HmdEFf7BXOg@mail.gmail.com>
 <20121010124002.GF3197@arwen.pp.htv.fi>
 <CAHp75VdprTQBsmEJudGExceFRRjXiN_xFGaMtU+mcw+vzM1oVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <CAHp75VdprTQBsmEJudGExceFRRjXiN_xFGaMtU+mcw+vzM1oVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 10, 2012 at 03:52:40PM +0300, Andy Shevchenko wrote:
> On Wed, Oct 10, 2012 at 3:40 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Wed, Oct 10, 2012 at 12:21:04PM +0300, Andy Shevchenko wrote:
> >> On Wed, Oct 10, 2012 at 12:08 PM, viresh kumar <viresh.kumar@linaro.or=
g> wrote:
> >> > On Wed, Oct 10, 2012 at 2:34 PM, Andy Shevchenko
> >> > <andriy.shevchenko@linux.intel.com> wrote:
> >> >> On Tue, 2012-10-02 at 14:41 +0300, Andy Shevchenko wrote:
> >> >>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >> >>>
> >> >>> Since v3.2 we have nice macro to define the platform driver's init=
 and exit
> >> >>> calls. This patch simplifies the dw_dmac driver by using that macr=
o.
> >> >>
> >> >> Actually we can't do this. It will break initialization of some oth=
er
> >> >> drivers.
> >> >
> >> > why?
> >>
> >> We have spi, i2c and hsuart devices connected to the DMA controller.
> >> In case we would like to use DMA we have to have the dw_dmac loaded
> >> before them. Currently we have spi driver on subsys_initcall level,
> >> and Mika, who is developing it, will change to module_init_call level.
> >> However, it will just hide the potential issue. He also tried to use
> >> deferred module loading, but we don't know if it's good solution or
> >> not, and that solution requires something to stop deferring at some
> >> moment.
> >>
> >> Might be we missed something and there is a better solution.
> >
> > if they can only work with DMA, they should return -EPROBE_DEFER so
> > their probe() function can be called after DMA driver has finished
> > probing.
>=20
> They could work either with DMA or via PIO mode.
> How does the driver know when to stop to return -EPROBE_DEFER?

Why would you even allow to work as PIO-only ? Who would even want to
use the driver as PIO only ?

In any case, you can add a Kconfig choice like WHATEVER_PIO_ONLY and
only return -EPROBE_DEFER ifndef WHATEVER_PIO_ONLY.

--=20
balbi

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQdXsnAAoJEIaOsuA1yqREDvYP/RTGVlVdWjKVD5vbSEDgmt2W
vbInMaU/wCJrn0+EsZwpkdvx1HOC+CSKUUlxbFSRQRnf1/oLIIwheV/XXC+7nNW/
buA3uvvPEhoriZ8WEwzP9MEuXtLS7dg5Ak4/UEhZWcrRG30n0FYz3oElINDfhOUD
EvqIKEJsM4t1h2YmVmEPJWBkYQ7YIXCOcTmclH9ainXpZNW4dqRZpQjmWSwaOTrj
r0s/9CPtFCyJEJ0smuJtn3NKy3td4U2PNPkevQtxRYVC+iE14CSRkZdld482ZGnm
xGJ7aPmX6mOR2gIn/51rKrryxOLsWXqkt64aJ60lLQXf6gdwuFGP+UFqTTgBhCZp
lcWsRVd64NbeOHCoPBg/LOjeux1S6/eE16kaVm0BAmH1/lz4lzzdXRKYv4J5yyw4
ziHJIScdVjC9Xjzqh1pe9dKo0owtwPOK//E2Hmy9pvBGAoXzN4gABNnO8YOPZxvu
Fp6oLvu1Sh3rJNxDe0gzUIA9OkmBCyo9dL1++RB8PHjmgilhN6TE1zXpvNb3yLPJ
aIBO2KmGfOh/bqwukRsy2iJ+WBy39ATcxXL3nrqo8q462v87cn3b6WU54bzSyHvh
nszipEmef21dW7X556niQcFrQXCC329LZO8E4PKFo5GSdmH4sHoVQjUYWB/4LQP1
ev2vMwafvj29/3iElZvf
=TSgR
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
