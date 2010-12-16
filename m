Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0LPDaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 22:30:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33654 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0LPDaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 22:30:13 -0500
Date: Thu, 16 Dec 2010 14:29:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
Message-Id: <20101216142958.e4f463ee.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Dec_2010_14_29_58_+1100_BnY1uiIi86XHkwkI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Dec_2010_14_29_58_+1100_BnY1uiIi86XHkwkI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c: In function 'rtl92c_i=
nit_sw_vars':
drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c:76: error: implicit de=
claration of function 'vmalloc'
drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c:76: warning: cast to p=
ointer from integer of different size
drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c: In function 'rtl92c_d=
einit_sw_vars':
drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c:91: error: implicit de=
claration of function 'vfree'

Caused by commit 0c8173385e549f95cd80c3fff5aab87b4f881d8d ("rtl8192ce:
Add new driver").  Rule 1 from Documentation/SubmitChecklist.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Dec_2010_14_29_58_+1100_BnY1uiIi86XHkwkI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCYe2AAoJEDMEi1NhKgbsv7EH/RkzlXH4Ltxgzi/B+H/pyjq4
tcea7jfE8AonbgyGDRrsn7a9aCc7ffH6JT/vR6MZwWbJheqZDTvByFTB66+RAcMR
QhvGjbB+05uJJxouaXFrObENxKXrsPSwqLSVYlY7xj+BluQVAPtj5ZB6xjKPqYFl
ns7ME3OGDpYyiUBod9QLBtvB7Mxt4VKqJG670TaYpAsz2qPqX2u1nVYPOpSseg72
wb+nfilv1reiIUuYTczsMbQyW/1/OKx1I1wZwjBwJndm35PJP5kZ9m+JxcxbtzE1
LSVD+9C9iJGLXBER8ZpJwSJ5lz/l8VwCDmJD+Rwe4LJEgvM0BWHBAg6wZq4p3pU=
=5dDT
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Dec_2010_14_29_58_+1100_BnY1uiIi86XHkwkI--
