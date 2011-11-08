Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab1KHSoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:44:54 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:34167 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644Ab1KHSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:44:52 -0500
Date: Tue, 8 Nov 2011 20:44:48 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        rmallon@gmail.com, Nikolaus Voss <n.voss@weinmann.de>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, khali@linux-fr.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20111108184447.GB24399@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1320753142.git.n.voss@weinmann.de>
 <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
 <20111108144115.GH20728@legolas.emea.dhcp.ti.com>
 <4EB9477E.8070002@atmel.com>
 <20111108152343.GJ20728@legolas.emea.dhcp.ti.com>
 <20111108182955.GH12913@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <20111108182955.GH12913@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Tue, Nov 08, 2011 at 06:29:55PM +0000, Russell King - ARM Linux wrote:
> On Tue, Nov 08, 2011 at 05:23:46PM +0200, Felipe Balbi wrote:
> > On Tue, Nov 08, 2011 at 04:15:10PM +0100, Nicolas Ferre wrote:
> > > -----BEGIN PGP SIGNED MESSAGE-----
> > > Hash: SHA1
> > >=20
> > > On 11/08/2011 03:41 PM, Felipe Balbi :
> > >=20
> > > >> +	if (cpu_is_at91rm9200()) {			/* AT91RM9200 Errata #22 */
> > > >=20
> > > > I don't think you should be using cpu_is_* on drivers.
> > >=20
> > > It is a common pattern in at91 drivers and has worked for ages.
> > > Do you think it is related to the need to be able to compile the
> > > driver for any SoC in the case of multi-SoC zImage support?
> >=20
> > we have drivers compiling on multiple OMAP versions without those hacks.
> > Generally, we check the IP revision for that. Don't you have a Revision
> > register of some sort ?
>=20
> I'm not sure what your objection is - this is no different from what
> happens with OMAP when detecting OMAP1,2,3,4 etc.  E.g.:

so ? Instead of saying this to me, you should contact the
authors/maintainers of those drivers and ask them to clean that up.

Moreover, just because there are a bunch of drivers with such silly
mistakes, is it really enough argument to perpetuate the problem ?

You were (actually still is) one of the biggest source of complaints for
drivers using <mach/*> and <asm/*> includes and now you're changing your
mind ?

Also, instead of taking bad examples take the ones which are activelly
improving with regards to those details. I have been fighting against
those on the USB drivers, at least. And, except for
drivers/usb/musb/davinci.c you won't find those on MUSB driver or its
glue layers. Similarly, I have been asking all USB Peripheral Controller
drivers to make their driver buildable on all arches, which will get rid
of bad usage of <mach/*> and <asm/*> headers while also allowing for a
better coverage of compile tests on linux-next.

Now, if you really think those aren't problematic, refrain from
complaining next time someone adds a machine_is_* or cpu_is_* check on a
driver.

> drivers/mfd/twl-core.c:     if (cpu_is_omap2430())
> drivers/media/video/omap3isp/isp.c: if (cpu_is_omap3630())
> drivers/media/video/omap/omap_vout.c:               if (cpu_is_omap24xx()=
 || cpu_is_omap34xx())
> drivers/media/video/omap/omap_voutlib.c:    if (cpu_is_omap24xx()) {
> drivers/media/video/omap/omap_voutlib.c:    } else if (cpu_is_omap34xx())=
 {
> drivers/media/video/omap/omap_voutlib.c:    if (cpu_is_omap24xx()) {

at least vout and voutlib haven't been touched since january.

--=20
balbi

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuXifAAoJEIaOsuA1yqREC74QAJgD975RQCu8+AeTtyJZ+YJ5
flt8iPjNuzb1WC+8P+w3P+oMQv0A5p5GnsnEbLuWDGqbu+VdEjc+/GkcVyRyMvyp
Uv7GsNgdcK3wKTf1FRu2zOxFwkNxUOfrHVaClNneJozQoUGy8Z9PrtpktrhjmdkN
qwAAB3njFfUYnxMkIDYSVutujAs88Qpuejsm75JpWWXdvm7IVPgRZv1AZu9wQhbW
Yer92nU5cYb6pvLmWzXkaarFkoOtJYgEljbHJf6WighSBCqZHB+72/s2NUhBVPsb
iIH/cYWddd3pIPWBktZwCNzQvodJKydMVFyOftAsaKbjtn95JrCbWXYeJCX/LGWt
SR0Ndwp3yybcfMLwEhzM0JjLoPaqb/kHJCBS2FZdqNSbdEQnDg7hxW3P2tJ292hw
wRNt/X5KHR2g/xWZdG5lBuLxSWcdqybpf6QFqlhW8ae7YImtb/YbfG6stcuQkKlj
MvaVjLDYeNfnIiVyJs59cfilB5bMTYiPAp71d9t2jNTTzaqA6OeqJCOaKAEbBZ1y
81XE/B46lCRAGnDRsn8l1OFdGZhaNyS33S75MSruKw+b7LGzqLkVv5dJhCF0AXVP
2YF8qNOqp4IkaU0996UoyI6dvCW/TbSQ+lojNm9JkOgVJ1GT1nj8OZJaHJ7REDuH
CQBnTIBnOXW5s7b2xT0Y
=MhnF
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
