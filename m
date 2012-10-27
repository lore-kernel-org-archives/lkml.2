Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab2J0OBI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 10:01:08 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:41977 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab2J0OBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 10:01:06 -0400
Date: Sat, 27 Oct 2012 09:00:53 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH v4 1/5] zynq: use GIC device tree bindings
Message-ID: <20121027140053.GB5190@beefymiracle.amer.corp.natinst.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200310.GB6713@beefymiracle.amer.corp.natinst.com>
 <0d1c4cf8-70d8-4d12-bd77-393009d32b22@CH1EHSMHS001.ehs.local>
MIME-Version: 1.0
In-Reply-To: <0d1c4cf8-70d8-4d12-bd77-393009d32b22@CH1EHSMHS001.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/27/2012 09:00:44 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/27/2012 09:00:45 AM,
	Serialize complete at 10/27/2012 09:00:45 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-27_03:2012-10-26,2012-10-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 27, 2012 at 01:39:00PM +0000, Michal Simek wrote:
> Hi Josh,
>=20
> > -----Original Message-----
> > From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> > Sent: Wednesday, October 24, 2012 10:03 PM
> > To: arm@kernel.org; Arnd Bergmann
> > Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;=
 John
> > Linn; Nick Bowler; Michal Simek
> > Subject: [PATCH v4 1/5] zynq: use GIC device tree bindings
> >
> > The Zynq uses the cortex-a9-gic.  This eliminates the need to hardcode =
register
> > addresses.
> >
> > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> > Cc: John Linn <john.linn@xilinx.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  arch/arm/boot/dts/zynq-ep107.dts           | 8 +++++---
> >  arch/arm/mach-zynq/common.c                | 7 ++++++-
> >  arch/arm/mach-zynq/include/mach/zynq_soc.h | 2 --
> >  3 files changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-
> > ep107.dts
> > index 37ca192..7bfff4a 100644
> > --- a/arch/arm/boot/dts/zynq-ep107.dts
> > +++ b/arch/arm/boot/dts/zynq-ep107.dts
> > @@ -36,10 +36,12 @@
> >               ranges;
> >
> >               intc: interrupt-controller@f8f01000 {
> > +                     compatible =3D "arm,cortex-a9-gic";
> > +                     #interrupt-cells =3D <3>;
>=20
> If you change git to 3 cells format you should also change it for uart be=
low.
>
> Also will be the best to remove this dts entirely and replace it by exist=
ing
> Platform.

Do you mean to say get rid of the ep107 entirely and replace it with,
for example, a zc702 dts?

I have a follow up patchset which splits off a zynq-7000.dtsi and a
zynq-zc702.dts, and which also fixes the 3 interrupt cell problem.
Would you like for me to pull this into v5, or spin up a separate patch
series?

Thanks,

  Josh

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQi+kVAAoJEEef0niEbw+lk0UP/AkCeoJVW78nf5jsEQtXKh00
2ULrNeyPkozTlXPrT1tFWKwiO6bQ9Vm9HjjN/5f04ZMzErda8WWIZmrgC9Gy89Q+
4BOY9vcs+26vsQipPmkNvNCnnA9+roaQ6MP3M0qIZ9hQ6sZMe+EG+S87/55z+U1e
I3irc8KwrYIQe7wmzsRXvyo/nbUMWDbqbgolV4PTjRy7WI8Mg+Rxm8nj+Oxv2Qav
h27Ra1CARmtr5zZO74vtbnOe0Vr5UrM0xu7tUyiAij+DRD9hNaQh/BeJPc/TlOPl
kjJSlpt+iOAtrgaDNKKs/e2uKn18fLtVh/6nx6TfwjbL/nwsV09G1IBrFlIg+fxS
b8jMy+0P/7iE8F1EPt98epzepgbDypWAsuxVdVsQ9KIiaa82LgF+2OiDYgkMxDZd
OXGkFdNJGKXC2H0ayGdxxF/ZmK5Ka2wZ2Q+2mWil6U2ThR2Z23Nf52oRC/AJWp9a
/IsfKp9ybxJFao4FN0mYViR+NNj6qMmjsWf8K8TG5i2SY0WyWzp/gPpUbXZ8ZEab
a4IuPY/yOu9XA7zeTWG9yfnANYQXRXFQKFCmRNWC1EyeMjhqIwkJFxfffVqZofN9
LVTyPgKp6SE2erLEL508awMSbdczvKAljuWGQQd4qgdNHMbpHHMtgbJO2hLsv6cw
gKcu7z3KmNekHLlOuZ33
=poWl
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
