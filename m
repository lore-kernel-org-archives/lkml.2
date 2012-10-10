Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2JJNvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:51:10 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:56076 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab2JJNvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:51:05 -0400
Date: Wed, 10 Oct 2012 16:45:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 1/4] dmaengine: dw_dmac: use helper macro
 module_platform_driver()
Message-ID: <20121010134536.GB4114@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1349178121-9105-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <1349859841.10584.122.camel@smile>
 <CAOh2x=mNiL4k=v3YGexq7YMZUx131QWBpm11QXupnWLUPuKU4Q@mail.gmail.com>
 <CAHp75VePqj3FViNrOcicHXhv9BzhJQgSg6KvA31HmdEFf7BXOg@mail.gmail.com>
 <20121010124002.GF3197@arwen.pp.htv.fi>
 <CAHp75VdprTQBsmEJudGExceFRRjXiN_xFGaMtU+mcw+vzM1oVg@mail.gmail.com>
 <20121010134159.GA4114@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <20121010134159.GA4114@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 10, 2012 at 04:42:00PM +0300, Felipe Balbi wrote:
> On Wed, Oct 10, 2012 at 03:52:40PM +0300, Andy Shevchenko wrote:
> > On Wed, Oct 10, 2012 at 3:40 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > On Wed, Oct 10, 2012 at 12:21:04PM +0300, Andy Shevchenko wrote:
> > >> On Wed, Oct 10, 2012 at 12:08 PM, viresh kumar <viresh.kumar@linaro.=
org> wrote:
> > >> > On Wed, Oct 10, 2012 at 2:34 PM, Andy Shevchenko
> > >> > <andriy.shevchenko@linux.intel.com> wrote:
> > >> >> On Tue, 2012-10-02 at 14:41 +0300, Andy Shevchenko wrote:
> > >> >>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > >> >>>
> > >> >>> Since v3.2 we have nice macro to define the platform driver's in=
it and exit
> > >> >>> calls. This patch simplifies the dw_dmac driver by using that ma=
cro.
> > >> >>
> > >> >> Actually we can't do this. It will break initialization of some o=
ther
> > >> >> drivers.
> > >> >
> > >> > why?
> > >>
> > >> We have spi, i2c and hsuart devices connected to the DMA controller.
> > >> In case we would like to use DMA we have to have the dw_dmac loaded
> > >> before them. Currently we have spi driver on subsys_initcall level,
> > >> and Mika, who is developing it, will change to module_init_call leve=
l.
> > >> However, it will just hide the potential issue. He also tried to use
> > >> deferred module loading, but we don't know if it's good solution or
> > >> not, and that solution requires something to stop deferring at some
> > >> moment.
> > >>
> > >> Might be we missed something and there is a better solution.
> > >
> > > if they can only work with DMA, they should return -EPROBE_DEFER so
> > > their probe() function can be called after DMA driver has finished
> > > probing.
> >=20
> > They could work either with DMA or via PIO mode.
> > How does the driver know when to stop to return -EPROBE_DEFER?
>=20
> Why would you even allow to work as PIO-only ? Who would even want to
> use the driver as PIO only ?
>=20
> In any case, you can add a Kconfig choice like WHATEVER_PIO_ONLY and
> only return -EPROBE_DEFER ifndef WHATEVER_PIO_ONLY.

yet another comment is that any user of this dma engine will have to
pass the filter function as argument to request_channel, which means
Modules.dep will make sure for dw_dmac to probe before its users.

What am I missing here ?

--=20
balbi

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQdXwAAAoJEIaOsuA1yqREJrUP/3iI04OOXdEHeutGkkdNp6t1
kC/OwwHu3ZRciemOQHpw3FuCmxfjRcCIi0q22qWwdIT3TPPZejyDmC8yM2MusqXi
mTnMxZ/vp0GDPLsvXOkND/NrH5xtcZuxiHMu1G7W0rIB4wwmzwbFirMWoOjPZHue
UvZKU9hF/0blNA9fZ4Zdw44jSBdejVNpmYb+c1TwbpG0SyBMfOnyu5mU749S1jfb
mCo+C8qbNpX6KkKsiutFXyfiGGDF/5LurlKP9a3utqbKTVk9kXhgW59AEbOz6jPq
k0X4TYkyOL0im/Gz5SwpDzJLYXcGG1nTJ+x+X9sI+Su5M2jmXljdRIeOvDZQ+4Td
WLCalG3t32d2VA2zUpFJtgFptYu4Kh7F5N4xXc3LvH1io5zxmxrkiZOl7HS1sVjv
howwqWV5ZOLIxGgWbtgZha1yCearrjbA/eNcbwbDxyuKdmu5NW8BlSzFZ5oBidsi
SPCjMugC9ot8yWux+F7/pL1YUdDOEGC7Z2zeyamyvhRwEdcARbMlINBjNGwvustX
8lb1qP5zl0W/TGzjr4w2sRBXpuj+UBsOu6nyahmo/YUOUYflPMm98mJmRnrpuHog
a/3pKzoroH5qCMKiiGYJor6ziOpEur2Jg2JAgc5GT2V6zfuD0v5RiEEjcNVaofK9
Wgb6XJINRF6ftNb8Mtc4
=v9NK
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
