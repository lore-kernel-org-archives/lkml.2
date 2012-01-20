Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2ATNpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:45:10 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:45514 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2ATNpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:45:07 -0500
Date: Fri, 20 Jan 2012 16:46:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        swetland@google.com, devel@linuxdriverproject.org,
        Pradheep Shrinivasan <pradheep.sh@gmail.com>
Subject: Re: [PATCH 1/6] staging:android_pmem.h: Fixes the space and other
 formating issues pointed out by checkpatch.pl
Message-ID: <20120120134604.GM3356@mwanda>
References: <1326856764-2531-1-git-send-email-pradheep.sh@gmail.com>
 <20120118065620.GE3294@mwanda>
 <CANz8tm1imZ3njy_uV0tkq0sXwyB5ZLLJsrp4G1zjcBDnJUrjiw@mail.gmail.com>
 <20120118185457.GH3356@mwanda>
 <CAAq6er0OPkvTCLt1DvHSjyqM4pH7GMb-D78M09cJY+1ZV3miiQ@mail.gmail.com>
 <1327065315.6176.24.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z/kiM2A+9acXa48/"
Content-Disposition: inline
In-Reply-To: <1327065315.6176.24.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F196FDD.0032,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z/kiM2A+9acXa48/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2012 at 05:15:15AM -0800, Joe Perches wrote:
> @@ -2838,7 +2849,8 @@
>                         if ($dstat ne '' &&
>                             $dstat !~ /^(?:$Ident|-?$Constant),$/ &&     =
               # 10, // foo(),
>                             $dstat !~ /^(?:$Ident|-?$Constant);$/ &&     =
               # foo();
> -                           $dstat !~ /^(?:$Ident|-?$Constant)$/ &&      =
               # 10 // foo()
> +                           $dstat !~ /^[!~-]?(?:$Ident|$Constant)$/ &&  =
       # 10 // foo() // !foo // ~foo // -foo
> +                           $dstat !~ /^'X'$/ &&                         =
               # character constants
>                             $dstat !~ /$exceptions/ &&
>                             $dstat !~ /^\.$Ident\s*=3D/ &&               =
                 # .foo =3D
>                             $dstat !~ /^do\s*$Constant\s*while\s*$Constan=
t;?$/ &&       # do {...} while (...); // do {...} while (...)
>=20
> I think the character change test is fine but
> the !~- addition/change is suspect.
>=20
> !~- are precedence level 3 operators

Level 2?

> and can be impacted by things like ++

They work like you would expect:

#define NOT_FOO !foo
	++NOT_FOO <-- compile error.
	NOT_FOO++ <-- works.

Anyway if people are really writing macros which are used this way,
then that's something which is outside of the scope of checkpatch.pl
to fix.

regards,
dan carpenter

--Z/kiM2A+9acXa48/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGXAcAAoJEOnZkXI/YHqR3G4QAK8XKfXkzKmK87NsDnHx+f3i
Yd2KQMmuVoTed56HnyEXVkJLwO63XSi4R3xDn2/ouqns6mvg/BH4uDqyOTloqsjh
EqlYdawZBU2QWnpWpCbxIt1zXogSnek4JLh5ysCVoVpHrRfRgU1DqtQ4Txp+6Qwk
xUkzm4fk8zWkoBcuBtuwVX1p2nYvuLmqflPdaGVExZoAbMlWJtQ6Mzf2KR1SwQ5M
XJaU6S4iqkgyxone7Hluzdj84qHG+3LjK3AksnysEuzsXORbcarUwxSNjUt1sYN2
GjLm0IJX+12CbEp16dxpyCgxQAG4NxYtk5EpHjKQu+EoOygwYdS7RgNj/92U/iLd
1rz8R+TbVzclMsmpAopxmmGjuoCPhagmrj+S5n6StrTZEmjxz4fd/W8MyV8f1NoO
rAg0rjUh38ImqW4cgNgWurq9bC59nlI/QDJ2o1jhsvgeAKejznCPzkmyEvoeM5lD
B98ZfHMN3zh3usA9e4ZsLMz5HLLF7udSlUM3efvXzKg+c6ZLmzGbcaO4/H1bj8oy
QFNJCXUeqdGRg6UiL2qiZYJN8PvJQ+7X4X87tQefG6vcSHWP6rk18QO/EOC0ZpTC
ZjN5h1cWAh3fwWystgbnPMri719iKyDu6fXFO5TXZaZPDIAYmy6mqXKljl4imPqo
F2mkiME88dOQ6nBivbJ2
=OVYq
-----END PGP SIGNATURE-----

--Z/kiM2A+9acXa48/--
