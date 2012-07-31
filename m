Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2GaGrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:47:16 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:33190 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505Ab2GaGrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:47:14 -0400
Date: Tue, 31 Jul 2012 09:43:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: "Poddar, Sourav" <sourav.poddar@ti.com>,
        "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>,
        lo <linux-omap@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [GPIO] Crashed when not using
Message-ID: <20120731064350.GD6004@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <CAKdam54gXixs4F-a07ajj9GNMth46d4NTdoUL3GokzvjuWaGyg@mail.gmail.com>
 <CAC83ZvKnOw+UBOWYtt294k-5Xk8S6Gy1pChSF7aXGmGjLGSeCA@mail.gmail.com>
 <CAKdam56QEXY55SYC7YND4BP=tQmiyAa=avVCADTj3Ym6X9cCvg@mail.gmail.com>
 <87fw89gf4w.fsf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
Content-Disposition: inline
In-Reply-To: <87fw89gf4w.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 30, 2012 at 01:36:47PM -0700, Kevin Hilman wrote:

<little trimming>

> >>> The device tree data for acquiring the above GPIO interrupt line looks
> >>> like this.
> >>>
> >>> +++ linux-omap-storage/arch/arm/boot/dts/omap5-evm.dts  2012-07-30
> >>> 14:11:08.931694001 +0530
> >>> @@ -42,7 +42,8 @@
> >>>         tsl2771@39 {
> >>>                 compatible =3D "taos,tsl2771";
> >>>                 reg =3D <0x39>;
> >>> +                interrupt-parent =3D <&gpio5>;
> >>> +                interrupts =3D <21>; /* gpio line 149 */
> >>>         };
> >>>  };
> >>>
> >>> Note: using "gpio_request_one" in the driver solves the issue.
> >>> Is using this api in the driver required?
> >>> Any pointer on the above crash?
> >>
> > Hi Tarun,
> >> Any user/client driver of GPIO is supposed to go through
> >> gpio_request() API so that module clock
> >> is enabled correctly. Overriding of APIs would put the power
> >> management state machine in jeopardy.
> >> --
> > I tried putting "pm_runtime_get_sync" in gpio_irq_type api where the ke=
rnel
> > is crashing and the crash is no longer observed. So indeed, its about
> > enabling clocks.
> >
> > One doubt: Can't we put runtime apis in "gpio_irq_type" and eliminate
> > the use of
> > "gpio_request_one"??
>=20
> No.
>=20
> You must use the GPIO requiest/free APIs to tell the GPIO core that
> the GPIO line is in use.
>=20
> Why do you want to avoid using gpio_request/gpio_free?

Then how do we differentiate from a driver perspective if e.g.
client->irq (for I2C client drivers) refers to a pin on a GPIO
controller or a real interrupt when running with DT ?

Having something like:

#interrupt-parent =3D &<gpio5>;
interrupts =3D <21>;

would already give me the correct IRQ number from the driver, now how do
we differentiate the interrupt parents ? There's no way to do that from
a driver perspective, so DT core has to either do it, or provide means
for drivers to detect it themselves.

--=20
balbi

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQF36mAAoJEIaOsuA1yqREgBIP/2rbS9fWN3llwkxNhT43ynef
tijg2r1FMIXqXPrQiBjnyI9ISbhEcN9LBTtU8YQrwYPwyNVK2p2xdLii+2DTUfi8
QrSeyKUgsAI7tIQjy477DeLfM3UQNemoSY0EBjX8DrckoftmLPc1zqtNDNlQbBoy
H6uRjoSCszqrn37GgXUhj1+9rJHsKxoOiphTuFphtFIeUJcnJ9IF3gjYlcFA3FgB
fYqArK+qWrrkeJfeVnm0jox4RS6bvhbANSqsz4jJERu1lBS0zaPdAXnt7PdzGry+
2GAo+TfpSVcI58oz0D/m6VHLpvtawv66+MZTEbMJG7LWVlg/gf1CnBwWGLhAi1Jt
n97z+g7HuBiZ5Q/jXjFNTsSo0A8XIXFTpzsRg7PXX5riC5yzc+opwGhEjMJ+KbLL
D2f4GfMCDFpyNNJ0PSAZWdPliMx7iryEuOBFSGXfuwWVCkZPvPIET0c+k+6NTxH5
VFBobrLkTSApaTfqWBcC/sOS8kclO73ZkyPUtDyCqXNKQ71xrWkjvnqywMP4Zaaz
TZmZzQa7p2ORyjzHXbC5Zd6fQWy1ms9AwTmZfugkkHNHM/Y1itqT8PGtDzdRuBLT
sttCiE2pjR9F8XEOynYXcvAArEOyYHjgy1+bU7F2U/HWp6BbO9zuiPPAh2B+XTNx
9uqD3Xumgq7tw73wBjTT
=1Y3c
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
