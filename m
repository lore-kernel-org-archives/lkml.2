Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2FNLso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:48:44 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:48879 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755627Ab2FNLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:48:43 -0400
Date: Thu, 14 Jun 2012 14:46:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, ben-linux@fluff.org,
        Tony Lindgren <tony@atomide.com>, w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/17] i2c: omap: ack IRQ in parts
Message-ID: <20120614114638.GQ13602@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
 <1339669250-9183-10-git-send-email-balbi@ti.com>
 <CAMQu2gw4B_5eFSAq_o+MamNDDwoZi2CitmC+dM=+pi3R1Z2QCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JKGvNdIvrY8Ovf7Z"
Content-Disposition: inline
In-Reply-To: <CAMQu2gw4B_5eFSAq_o+MamNDDwoZi2CitmC+dM=+pi3R1Z2QCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JKGvNdIvrY8Ovf7Z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 14, 2012 at 04:41:45PM +0530, Shilimkar, Santosh wrote:
> On Thu, Jun 14, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> > According to flow diagrams on OMAP TRMs,
> > we should ACK the IRQ as they happen.
> >
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> > =A0drivers/i2c/busses/i2c-omap.c | =A0 29 +++++++++++++++++------------
> > =A01 file changed, 17 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-oma=
p.c
> > index f978b14..c00ba7d 100644
> > --- a/drivers/i2c/busses/i2c-omap.c
> > +++ b/drivers/i2c/busses/i2c-omap.c
> > @@ -894,21 +894,20 @@ omap_i2c_isr(int this_irq, void *dev_id)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> >
> > =A0complete:
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Ack the stat in one go, but [R/X]DR =
and [R/X]RDY should be
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* acked after the data operation is co=
mplete.
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Ref: TRM SWPU114Q Figure 18-31
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 omap_i2c_write_reg(dev, OMAP_I2C_STAT_REG=
, stat &
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ~(OMAP_I2=
C_STAT_RRDY | OMAP_I2C_STAT_RDR |
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 OMAP_I2C_=
STAT_XRDY | OMAP_I2C_STAT_XDR));
> > -
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (stat & OMAP_I2C_STAT_NACK)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (stat & OMAP_I2C_STAT_NACK) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev->dev, "No Ack=
nowledge\n");
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err |=3D OMAP_I2C_STAT_N=
ACK;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 omap_i2c_ack_stat(dev, OM=
AP_I2C_STAT_NACK);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 omap_i2c_complete_cmd(dev=
, err);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return IRQ_HANDLED;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >
> Do you think making I2C IRQ ack + complete as one small static inline fun=
ction
> can save clean the code further. I see it has been used in multiple paths.

done in a later patch

--=20
balbi

--JKGvNdIvrY8Ovf7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2c8eAAoJEIaOsuA1yqREXwUP/i3tHN51zYrf+Y8+lTo5K6rF
Y3fcSSjcKA4brPyyPN/FZJW6pqRMDceTy+ZocxmL3mW3MZkJgSpX3jM3ltkvZgXV
xnsNhO5k0UlHvqVfD/BrmXeIuTcCnLCDoOX3zPmfcLClfbvW27BELZNk3FMt5g2R
HVTs56rBPJUpzaUXPmyyx/ZX1DT4DhkQVT1q37fpUb4QnSz1Hr6ucc+52HLZ3KGA
jEOHDO64UUpk1DRGSr/LENa7iBrdBmqjw6tMJ1iP+0v3kpc5EsYf2J/cXxdGUbim
z44EqRJLxoNiF8ru7JRxd6Ln5HRm3yZ+yAN1IsGyr297zX2/YTnBlKw/XaPeemzI
Kbmr9qmAp0guLvruy3CTk3BTvpubrznZGWHq2PLtSa1ph1MOHkNORBw53Hh2E8js
C3lTnsUwEDCpLJSPZTZ+WMy9BbQYollRd4CbLy7e2se5OTVB0aYYifUiyysT489G
0KV7X5llsxu3KmYsMy1alvV4CrVuQMmz0OsBvwLd4tq6lCxWXYjfTzJYkl5EJkpS
5RPEMyPP5Qkj7eIE+HL2QkQoHNUMg20ERozbNuxsABoXR2IzDsQkmDlK5JncZXCP
IP/r4h4saJDagQCk3j8pksKAbXSmQe9Gk97yPEmlf8VEYjYUqBRpmyNlqmMHpBwN
XMyNqr/Ks6SA3NJRNSic
=4WMV
-----END PGP SIGNATURE-----

--JKGvNdIvrY8Ovf7Z--
