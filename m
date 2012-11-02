Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab2KBNmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:42:11 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:48123 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2KBNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:42:07 -0400
Date: Fri, 2 Nov 2012 07:39:29 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 7/8] serial: xilinx_uartps: get clock rate info from dts
Message-ID: <20121102133929.GP5190@beefymiracle.amer.corp.natinst.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
 <23a299ee5e89cfd17bb9affd8fbb9f41b79cfd46.1351721190.git.josh.cartwright@ni.com>
 <50939061.9060201@metafoo.de>
MIME-Version: 1.0
In-Reply-To: <50939061.9060201@metafoo.de>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/02/2012 08:39:22 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/02/2012 08:39:22 AM,
	Serialize complete at 11/02/2012 08:39:22 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sMZCuqyhuhd4ycTi"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-11-02_02:2012-11-02,2012-11-02,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sMZCuqyhuhd4ycTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 02, 2012 at 10:20:33AM +0100, Lars-Peter Clausen wrote:
> On 10/31/2012 08:28 PM, Josh Cartwright wrote:
> > Add support for specifying clock information for the uart clk via the
> > device tree.  This eliminates the need to hardcode rates in the device
> > tree.
> >=20
> > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> > ---
> >  arch/arm/boot/dts/zynq-7000.dtsi   |  4 ++--
> >  drivers/tty/serial/xilinx_uartps.c | 30 +++++++++++++++++-------------
> >  2 files changed, 19 insertions(+), 15 deletions(-)
> >=20
> > diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-=
7000.dtsi
> > index bb3085c..5fb763f 100644
> > --- a/arch/arm/boot/dts/zynq-7000.dtsi
> > +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> > @@ -44,14 +44,14 @@
> >  			compatible =3D "xlnx,xuartps";
> >  			reg =3D <0xE0000000 0x1000>;
> >  			interrupts =3D <0 27 4>;
> > -			clock =3D <50000000>;
> > +			clocks =3D <&uart_clk 0>;
> >  		};
> > =20
> >  		uart1: uart@e0001000 {
> >  			compatible =3D "xlnx,xuartps";
> >  			reg =3D <0xE0001000 0x1000>;
> >  			interrupts =3D <0 50 4>;
> > -			clock =3D <50000000>;
> > +			clocks =3D <&uart_clk 0>;
>=20
> Shouldn't this be <&uart_clk 1>?

Yes, indeed.

Thanks,
  Josh

--sMZCuqyhuhd4ycTi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQk80RAAoJEEef0niEbw+lVz8QAIgrOMIAe4j45xbHk3FISYvp
tKczq+rVKoS89bCR8Y1SwCHZ95vxR22UulCer3Ipc60KyIY/Zi1EOj/CNDauOz84
mteTZ77kv6bL4BNdh5xw6mDBwkFPDq/QgYt8+rcHVDzAUwwG4GX2U8kPCuBrgnOF
Xp5UrScOSRj+LwpSz50+g2y1aJmu9aI2fM6nlEwYxb85PqV7ujfXxAoT3dkdyITu
PkZiWL4YPLq8pfOZ7qBLkIVu0oKShnLQXBQHOr3x6sNV+ICNj1HuB56cmMSrBJkd
3rvPf2d7pjXAI5H5i7TygEKlLgl4ikpo/N2auelM2lYg7WeRAf5Gpe1F9l0gBrC8
E06ilrcyF04OzdKSMIdRVYkLJSjq9KEqPeYAtITkdLnfZCu7KdQDnNlkQgEOzsMd
FKvDmEfTg0QNY50X6KTCKlnb00XQ+NY4opgWjr/DLc+GzfKJgaexLaV9UtCh4Xqa
2AgPa9R9Xafr4mAiw2eKkHydr84QX04xKVc9BznIlJ694EP4bi+F0URtP7BstCTs
G8qWBaqP6Bw+rvYz1+6qragDGjBJ9wo6gavln7N94yy7CHMO28P9RS0GPKqrSdjZ
h94E7RF13W5QzFqUgIxfyR6AgXhaIgpri+Nw8R3T5UgBIZLk7ZZHHmNmqAK9X+a5
HnO8jrmKse7aV4OG8mrK
=Tx3u
-----END PGP SIGNATURE-----

--sMZCuqyhuhd4ycTi--
