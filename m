Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab2EVWqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:46:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58424 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2EVWqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:46:44 -0400
Date: Wed, 23 May 2012 08:46:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <guenter@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Sierra <asierra@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-watchdog@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: manual merge of the watchdog tree with the mfd tree
Message-Id: <20120523084639.bbc57455a6527c9cb983fb2d@canb.auug.org.au>
In-Reply-To: <6.2.5.6.2.20120522153050.0284ee38@roeck-us.net>
References: <20120518152348.1e5070cdc16cfdf00682546d@canb.auug.org.au>
	<20120518083234.GW3074@spo001.leaseweb.com>
	<6.2.5.6.2.20120518181141.028c8090@roeck-us.net>
	<20120522163559.GD3074@spo001.leaseweb.com>
	<6.2.5.6.2.20120522153050.0284ee38@roeck-us.net>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_08_46_39_+1000_4Myc+6Vdin_Vg/d9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_08_46_39_+1000_4Myc+6Vdin_Vg/d9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi guys,

On Tue, 22 May 2012 15:37:04 -0700 Guenter Roeck <guenter@roeck-us.net> wro=
te:
>
> >I don't think we have a clear standard yet, but I'm fine with either=20
> >one of them.
>=20
> Me too, though %04lx and typecast to long should really be sufficient.
>=20
> I'd guess the change was made because resource_size_t is sometimes a long
> and sometimes a long long, depending on the platform. I hit that=20
> problem a couple of times myself.

Exactly.  Since resource_size_t can be either 32 bit or 64 bit on 32 bit
platforms, you must print it as %llx and cast it to u64 always to
prevent these warnings.  If you cast it to (unsigned) long you could
possibly truncate the value.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_May_2012_08_46_39_+1000_4Myc+6Vdin_Vg/d9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvBdPAAoJEECxmPOUX5FESgoP/1PSMgkC4kj2PiU2JDVuNwq9
jEap/xPlLSk1C2R0F0UPrELjOkxE1M1eQda2Q51ym6dDhZ91THQEU1dQxhu3lsGN
dCcNX2Ndc66hfQiM7hpOKl3qtappwXoUNsXbSzFa52puZWRxFCXLMm3L4sBrThz8
vxZKYP3UojTsN5XEca0D9Avoeupc2Gb/aJkp1mUxCYNMLcHtKmJX/UXTTGT9FXMf
EoUby6GOjgZXBvqI0k7HjeC+EGzZ0LtjC3QJ1snMBw10Nrlfv8q19Z1h1S+yQNmR
JCxI8xTHuZjnSmbYCgdBVVqoRASXcy1Qj1fZRcuOlEs3nzQZ8gwit/+pLi/g4ucX
OcuQnH7J6aXRUnyx+ZLx75zQ9sEyNMmYTUIQ5fEH6KDkvXcyZokejhs9mSxuqoed
643kMU5IDjgNmhL8QdgTeKEPYXdOjXyCS3Er1RzrPW0dfAX3pQRNVr1LthveSVjk
wVUmN8WNSJXD6Rxo+FhGaI5yyCgKOKLO+pLdeh+XycC3gNo3ChHcASLdxrH4UuQq
8v8XPjFnwBa32ZjBgp9cnpArTARwn1QEMM99SlFBcqr5huumLtquVADkV9JfsiFs
/x3A0Bu4UeN/NS9M6FwDsyFOlcWvBu3FYGORTTQQY4gOOwtPmlnZEqF9CxaRIL7f
pnLs4PvM0GKoPhS9jsk4
=yoln
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_08_46_39_+1000_4Myc+6Vdin_Vg/d9--
