Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1CaCBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:01:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52884 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab1CaCBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:01:36 -0400
Date: Thu, 31 Mar 2011 13:01:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Hellstrom <daniel@gaisler.com>
Subject: linux-next: build failure after merge of the final tree
 (sparc-current tree related)
Message-Id: <20110331130127.1d60ba11.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__31_Mar_2011_13_01_27_+1100_rYC.UpotZxCOWVXp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Mar_2011_13_01_27_+1100_rYC.UpotZxCOWVXp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/tty/serial/apbuart.c: In function 'apbuart_probe':
drivers/tty/serial/apbuart.c:568: error: 'struct pdev_archdata' has no memb=
er named 'irqs'

Caused by commit 10544f128c33 ("sparc32, leon: APBUART driver must use
archdata to get IRQ number").

I have reverted that commit for today (and commit c897dcf6311e
"sparc32,leon: Fixed APBUART frequency detection" that conflicts with the
revert).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__31_Mar_2011_13_01_27_+1100_rYC.UpotZxCOWVXp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNk+B3AAoJEDMEi1NhKgbs1RQH/i55b7MhF3F3PaFMWKAUmBvZ
AL3zEC0CLVICWx/tpIbelZ1S7QTFnwcro97NtWhrX5W7xushI5BKClqyShSol3cR
Lny4btVCO27u0wdqGDN1MXWmGEy01+PWK7VL4xoTzlkkY4gtaySEg0Zri4hV4Eu9
e8H60bZ+GEPw/Ky+N8w0tMmndmmE8KAWvZCkpBtsvnsHGGiw7yyB6fo826YUCmHU
VjnHgOexd/4/7SyV4hcnh7aLhxXDvCPUoks73SYNxuQPF4KSuqQ1OkR06H0JQt+t
GfoFYRd8cyE4vhv61VAKcTzVcWn0KFX2sDEPXt0kgxzGBDwKZ+p9D7I1uTdGZ4A=
=bAu/
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Mar_2011_13_01_27_+1100_rYC.UpotZxCOWVXp--
