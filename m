Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab1F3GhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:37:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49433 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab1F3GhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:37:10 -0400
Date: Thu, 30 Jun 2011 16:36:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (powerpc
 tree related)
Message-Id: <20110630163659.374db7f9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jun_2011_16_36_59_+1000_cTItxjKQG0jtDPaA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jun_2011_16_36_59_+1000_cTItxjKQG0jtDPaA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/tty/hvc/hvsi.c:701:12: error: conflicting types for 'hvsi_put_chars'
arch/powerpc/include/asm/hvsi.h:92:12: note: previous declaration of 'hvsi_=
put_chars' was here
drivers/tty/hvc/hvsi.c:736:12: error: conflicting types for 'hvsi_open'
arch/powerpc/include/asm/hvsi.h:86:12: note: previous declaration of 'hvsi_=
open' was here
drivers/tty/hvc/hvsi.c:802:13: error: conflicting types for 'hvsi_close'
arch/powerpc/include/asm/hvsi.h:87:13: note: previous declaration of 'hvsi_=
close' was here
drivers/tty/hvc/hvsi.c:1083:19: error: conflicting types for 'hvsi_init'
arch/powerpc/include/asm/hvsi.h:81:13: note: previous declaration of 'hvsi_=
init' was here

Caused by commit 17bdc6c0e979 ("powerpc/pseries: Move hvsi support into a
library").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jun_2011_16_36_59_+1000_cTItxjKQG0jtDPaA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJODBmLAAoJEDMEi1NhKgbsjlYIAIGttKm9UOuT6VyjtGz4hCWR
DI4glgK+BT7RvNXUt8pOcYNJR7YEaGNdCz9E48JUaWioraSy9vY/KWjhQXteTv3R
vf5LiyTnpIxdK0l/GR1bzo2V2vhoyM5IFDnoesrkR7VJvrkIV/AWkksVGSq3swnx
vQTAJ+i9dRpMkN/txtFfKZK/+I+ep8LcGU/OZrcjbH0r7Cab1NiWax5BOWzbZIcT
hUgSaqnwQp7K9rXqwVVE8zUoNxekUAQKi56xLFcTh+lqroeIkQ6W3veWK1h2okHh
nChwMFrSOYqCyT/X4X7ZhQQu55GpecO7Udf+rcSHu2f3UbsYLVOOEtLj2/Dkk0A=
=EX7t
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jun_2011_16_36_59_+1000_cTItxjKQG0jtDPaA--
