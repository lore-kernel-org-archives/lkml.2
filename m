Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2AICLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:11:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:33081 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2AICLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:11:11 -0500
Date: Mon, 9 Jan 2012 13:11:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>
Subject: linux-next: build failure after merge of the battery tree
Message-Id: <20120109131100.941810596c078b4b6f5740e8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jan_2012_13_11_00_+1100_rVtmUsamD_=aXC27"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jan_2012_13_11_00_+1100_rVtmUsamD_=aXC27
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

After merging the battery tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/power/da9052-battery.c: In function 'da9052_bat_read_volt':
drivers/power/da9052-battery.c:293:2: error: implicit declaration of functi=
on 'da9052_adc_manual_read' [-Werror=3Dimplicit-function-declaration]
drivers/power/da9052-battery.c: In function 'da9052_bat_check_presence':
drivers/power/da9052-battery.c:306:2: error: implicit declaration of functi=
on 'da9052_adc_read_temp' [-Werror=3Dimplicit-function-declaration]
drivers/power/da9052-battery.c: In function 'da9052_determine_vc_tbl_index':
drivers/power/da9052-battery.c:348:1: warning: control reaches end of non-v=
oid function [-Wreturn-type]
cc1: some warnings being treated as errors

Caused by commit ded7fc7b0550 ("power_supply: Add DA9052 battery driver").

The commit message says "This driver depends on DA9052 MFD core dirver
for definitions and methods".  That core is presumably still pending
inclusion.

I have used the battery tree from next-20120104 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Jan_2012_13_11_00_+1100_rVtmUsamD_=aXC27
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCky0AAoJEECxmPOUX5FEjdcP/1vajtSQ9x77dtF4vlOxlpCZ
6JCwUlDCr/XD2NNdoP+HV3yRGkSADBfUjzyDsBDBeCSZ4EtK8NWLQpV8np3d7G/z
DFz6w5JAEDtw7nOSoa7xn6zQZxoZIuOqLP0a3/3YAG5EkGn6sUZQ/imeeYI/4CvI
8u7HkCbhZWug+AuuJinugWpqAvHRMCcqs/2MjlsoQ8EYgcy0xlds2c47qev3C/LB
ZB1lfY1BZ4ybGv+Z2xltuxNqx/0u6m2jtuxy4ghm0YGrkHimZgJL1yYLWS1hil/q
iIdmFX2JCrLhWh8o6pC7Dd24MUsd6GSYQTC/ay8p6VcXJep7uNaf5JuMxHhYyAOP
BDIG8s/dcpnFFWGB57FjSFdr0TuSzvU5NhufXVTu91XBWe2vzmmiD1COBe94CUri
Jfh87X/D4NlED2yTWfYeeUI1o2BlIwUFpjg7K8fvv2Mm0EAby9zNGyFAW5yDK/uc
XwrjDh0G8KQb/VmDzmdybWxw2LihmoaqkgEbsJhjTgvUsejADnciO/g1ZUCnKfRv
6fyvvPR+QyQQRfZbqa1UGMFBPDqLNpp62wXc3pAEzgzBHTggCNp/3ajSxPY2deQH
CYKp72OuSPdJSM08WNNTY13LGWnq+BwBPMrrSOFF+p8CSNXmzIqY54LH7Tw6/vW2
NW4KBC0QNLl04uyQAg2U
=LrII
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jan_2012_13_11_00_+1100_rVtmUsamD_=aXC27--
