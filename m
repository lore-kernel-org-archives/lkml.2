Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2JWVY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:24:28 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:40080 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab2JWVY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:24:26 -0400
Date: Tue, 23 Oct 2012 16:24:19 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH v2 2/4] zynq: move static peripheral mappings
Message-ID: <20121023212419.GK20593@beefymiracle.amer.corp.natinst.com>
References: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com>
 <201210231450.11540.arnd@arndb.de>
 <5086F973.6050309@gmail.com>
 <20121023205304.GJ20593@beefymiracle.amer.corp.natinst.com>
 <20121023211742.GA14047@elliptictech.com>
MIME-Version: 1.0
In-Reply-To: <20121023211742.GA14047@elliptictech.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 04:24:15 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 04:24:15 PM,
	Serialize complete at 10/23/2012 04:24:15 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDnEQgWzhgf+8aPe"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-23_07:2012-10-23,2012-10-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDnEQgWzhgf+8aPe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 23, 2012 at 05:17:42PM -0400, Nick Bowler wrote:
> On 2012-10-23 15:53 -0500, Josh Cartwright wrote:
> > On Tue, Oct 23, 2012 at 03:09:23PM -0500, Rob Herring wrote:
> > > On 10/23/2012 09:50 AM, Arnd Bergmann wrote:
> > > > On Monday 22 October 2012, Josh Cartwright wrote:
> > > >> -#define SCU_PERIPH_PHYS			0xF8F00000
> > > >> -#define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
> > > >> +#define SCU_PERIPH_PHYS		0xF8F00000
> > > >> +#define SCU_PERIPH_SIZE		SZ_8K
> > > >> +#define SCU_PERIPH_VIRT		(PL310_L2CC_VIRT - SCU_PERIPH_SIZE)
> > > >
> > > > And your patch 3 already obsoletes this mapping.
> > >
> > > Actually, it's probably still needed. The smp platform code typically
> > > reads the number of cores from the SCU and the mapping has to be in
> > > place before ioremap is up. I don't think there is an architected way=
 to
> > > get the number of cores, but it would be nice to avoid this early SCU
> > > access. We could also mandate getting the core count from DT instead.
> > >
> > > Also, the physical address can be read with this on A9's:
> > >
> > >         asm("mrc p15, 4, %0, c15, c0, 0" : "=3Dr" (base));
> >=20
> > For the sake of the zynq cleanups, I think it may still make sense to
> > remove the SCU peripheral mappings for now.  By the time we're ready to
> > push in SMP support for zynq, maybe we can tackle the problem of how to
> > solve the SCU mapping problem generically.
>=20
> Then the static mapping can be removed if and when the we "solve the SCU
> mapping problem generically".  There's no point in removing it until
> then since it doesn't cause any actual problems, does it?

That's also fine with me as well.  I'm not strongly opinionated, and not
convinced it really matters much.

Thanks,

  Josh

--dDnEQgWzhgf+8aPe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhwsDAAoJEEef0niEbw+lI6oP/ils06JCqeR8rMF/StkouGzY
eUGcPTzWLjS8lTUa1UlKCt5dY8c05Cv7DwCm4Mb8oylEsBjcU6/Q5l4tWP3S2wqb
Fg+XCUYcpr/L8YGVeTS07vcdOUT+7hwMmwwTpxNXWBeAzfD5Ew3XJ5lTZy65mjpK
kwq30LSicab6PkDu8KcaRP84XPNZQzEQO1wvvtn/JTqAiHWGpOtBi1EM78UtBxv0
SICRf0650oiWZq6h/rE/AonQ77xgGYIAef2Ir47Qk8QFwyjXvdiAuKzF1+Gg1Iio
EaSq8o8wZnL3hSt5pff+3lNaziGWu4QXBdK9E+mD8RC2kLDLtlvfkDOttx35/4b9
88PPkHpes8SLS0vkvY/dYtsgfRgMTEvXb46S8NQBfOa9lSHN8rVqqRV738CSI0Fs
xjeccG2EneAXVqgwCVOI2T4Qih4h6WNStUjlK0nk78pcmt5WWVN5IE9i6/5OzUQh
4GqFyUOEG4YDXeG3PGll2U6GYlXqPVJ9Ss6oWr8MGTG4O6BDddbj7yjdTQ5nDWdy
xacat9jFYLvrhLxx0O3NURb0dVrPHCjLB80psrrbNbDhKX4131FHmho0cMeuJSKW
nIkBSCNF0co9pmZk1nVZ4BcE8qwzmHlwryBjAmi17LrisnNSRzAAYe0MgHvrLFn4
SX/gKdDdpDd24YtSOFS2
=uB73
-----END PGP SIGNATURE-----

--dDnEQgWzhgf+8aPe--
