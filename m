Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab2JCBDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 21:03:33 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40665 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2JCBDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 21:03:31 -0400
X-Greylist: delayed 3110 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2012 21:03:31 EDT
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: silence GCC warning
In-Reply-To: Your message of "Mon, 01 Oct 2012 11:03:21 +0100."
             <20121001100321.GB4360@opensource.wolfsonmicro.com>
From: Valdis.Kletnieks@vt.edu
References: <1349000155.1553.27.camel@x61.thuisdomein>
            <20121001100321.GB4360@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1349223065_2241P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Oct 2012 20:11:05 -0400
Message-ID: <64681.1349223065@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.506B829A.0062,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1349223065_2241P
Content-Type: text/plain; charset=us-ascii

On Mon, 01 Oct 2012 11:03:21 +0100, Mark Brown said:
> On Sun, Sep 30, 2012 at 12:15:55PM +0200, Paul Bolle wrote:
> > Building regmap.o triggers this GCC warning:
> >     drivers/base/regmap/regmap.c: In function ‘regmap_raw_read’:
> >     drivers/base/regmap/regmap.c:1172:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> >
> > It seems 'ret' should always be set when this function returns. See, the
> > else-branch can leave 'ret' uninitialized only if 'val_count' is zero.
> > But if 'val_count' is zero regmap_volatile_range() will return true.

I've not dug into it that deeply - is there a way that gcc is able to intuit
this fact and use it for flow analysis?  If not, it's not going to be able to
include that information in its analysis.

> > That implies that 'ret' will be set in the if-branch. ('val_count' could
> > be zero if 'val_len' is, for example, zero. That would be useless input,
> > however.)

But gcc doesn't know what "useless input" means, semantically.

> > Anyhow, initializing 'ret' to -EINVAL silences GCC and is harmless.
>
> Have you reported this bug in GCC?  Their flow analyis just seems to
> keep on getting worse and worse.

I'm not convinced that it's at fault in this particular case...

--==_Exmh_1349223065_2241P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUGuCmAdmEQWDXROgAQJFZA/6AhJnS3TOyoCffs5jQCP1vGVyxmlI1Hsk
cNeO/TqWfhKEu+R/AEhgBv4YtrxfknfUe8u92ad09mHdJnRYNnkyokyZn0ojmD7H
C0mcNKk8kV+EFIg9Z66smXQLoG0XtnfzJwQzGqAjvTR6RdcFTxnE4LUW4eVTFyMe
VBVUpAj/pHv8jtztpZVQiri/CH0yeuzdXhlXKte3mBWR1ea2iAF6d15Hj6tI4mz0
aYEGYEH6N/EZsldyMlaQovK/R3WXUXoQLNiKE4HKDJGw4LjvB6W0xanScQyWh3xO
yKlL4zkEf+z15NnPOrwHelhtZXwwtc2HCx4Eu5fdsI5h3g4ravzEcJzkYs0m8zII
6Vpy4a3pW74LrLrrnm1hj8FenXt0/iYeNHMwBfo4BcfX6kY+/fsNFcVrtjZqrOir
dbRwEL7WrxfDBgD0k9+cCmxz6dSNQXYNPKbesgT07kuIRmE/siMeso3HgwCxyZNJ
dit1ZPnHzZBDRHvq/Yh4itdHT+GMqLgjBiDy+F1JHuTYV43Q1vRm901peh/AUrZa
R0sbe3y7QpSBN4kzTng5xGawoFnle3JDGsvAK0XBSxI00555jh3iyB0wYMQDfF1F
5yMlc7tArpB9XCOEm0YVqBz08FaRdGWaXRJeoTR+6PCYmODW3eLqnswu1/TqpYau
3tATUzgfgNk=
=VBgf
-----END PGP SIGNATURE-----

--==_Exmh_1349223065_2241P--

