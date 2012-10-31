Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422740Ab2JaLg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:36:58 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:37739 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2JaLg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:36:57 -0400
Date: Wed, 31 Oct 2012 05:36:48 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _AC
Message-ID: <20121031113648.GI5190@beefymiracle.amer.corp.natinst.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200431.GE6713@beefymiracle.amer.corp.natinst.com>
 <3c9e591c-a29f-446b-9256-bb23ff6d840d@TX2EHSMHS014.ehs.local>
 <201210302222.15656.arnd@arndb.de>
 <29530110-f967-49c0-a2bc-d035d02da2a5@VA3EHSMHS020.ehs.local>
MIME-Version: 1.0
In-Reply-To: <29530110-f967-49c0-a2bc-d035d02da2a5@VA3EHSMHS020.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:36:41 AM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:36:41 AM,
	Serialize complete at 10/31/2012 06:36:41 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCwQ2Y43eQY6RBgR"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-31_02:2012-10-31,2012-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rCwQ2Y43eQY6RBgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31, 2012 at 08:43:35AM +0000, Michal Simek wrote:
>=20
>=20
> > -----Original Message-----
> > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > Sent: Tuesday, October 30, 2012 11:22 PM
> > To: Michal Simek
> > Cc: Josh Cartwright; arm@kernel.org; linux-kernel@vger.kernel.org; linu=
x-arm-
> > kernel@lists.infradead.org; John Linn; Nick Bowler; Russell King - ARM =
Linux
> > Subject: Re: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _=
AC
> >
> > On Saturday 27 October 2012, Michal Simek wrote:
> > > > diff --git a/arch/arm/include/asm/pgtable.h
> > > > b/arch/arm/include/asm/pgtable.h index 08c1231..72904a2 100644
> > > > --- a/arch/arm/include/asm/pgtable.h
> > > > +++ b/arch/arm/include/asm/pgtable.h
> > > > @@ -40,7 +40,7 @@
> > > >   */
> > > >  #define VMALLOC_OFFSET               (8*1024*1024)
> > > >  #define VMALLOC_START                (((unsigned long)high_memory +
> > > > VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
> > > > -#define VMALLOC_END          0xff000000UL
> > > > +#define VMALLOC_END          _AC(0xff000000,UL)
> > >
> > > This shouldn't be the part of this series but should go to mainline t=
hrough
> > different tree.
> > > Arnd, Olof: Can you take this patch to your arm-soc tree?
> > >
> > > I don't think it is a good workstyle to propose it to mainline throug=
h zynq soc
> > tree.
> > > What do you think?
> >
> > The arm-soc tree is not the right place either, this is architecture co=
de which is in
> > Russell's domain. I would suggest getting an Ack from Russell if he's o=
k with it
> > and then merging it together with your other changes into arm-soc.
>=20
> That's what I thought too.
> Not sure if Josh wants to push this to mainline.

The patch is not relevant anymore.  It was needed when the virtual
address of the early uart mapping was defined via VMALLOC_END.  That was
causing us problems, so we ended up choosing a fixed, known working
address within the vmalloc region to map the uart.

Thanks,

  Josh

--rCwQ2Y43eQY6RBgR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQkQ1QAAoJEEef0niEbw+lgGAP/2NoR0hqitPmxkVbivymznVD
Zx3mqIa/fWTzex16hyYSuyah3H0SgtSkVwq+8SR+CMF2zsTtwaZZNW2q/FJv6rN/
eBK5CWlyOtyoo+vNl5lzLi0zwH0/JunubesvH7tfDY1CfoYJq1EOWp5ypJhIYcQ4
RFj6Mk9RP4raytWSOV1MqPBDPf3hJcZPusJNYzqxZ8zT9vOlQgQNxZDfvEfDQRVa
Q6Kw5wpu2YMoXouD1ADDKKqSg8sI/yRAgoYmbHidDObKSVB8S9vNLPtg9M/u6K2G
zF2UyNH7IjQsEfSoh/8FYK1/N0hRqGl5aDKI0M7CssOxC2Ppa6RSEFpzB0hnJT2t
bAmDol+UrDyqloxh+X4frvET0OyhdurjVnR8F3kpu68Gs6++Y3gKRByrG9/Dcebw
Rp7r8c7sY2xnHNX2Ox16HFJ5v8puxOweufarlp9b+GfWuiYK3OWgppc7KX0Wzj/3
CmBuo0MhyQIgo2GitUo6Nh16fC7M8SKvTNW6YiFV7SnLMENerWp81YlVA0qbliWY
8dc3tROHEApQFOIrKugBBVha1OCLJinA/iPHnlNU3zyPsgc9wuaD+rRHCQvWMs3v
LYligwR/QUk+CtcR1hE/XCr5umvtvLRB5Kw7I23ARgV2JvKkLwuIvOvKQxnLiqyW
zJPZt/w5G+YSVRYpUOC9
=5Zqc
-----END PGP SIGNATURE-----

--rCwQ2Y43eQY6RBgR--
