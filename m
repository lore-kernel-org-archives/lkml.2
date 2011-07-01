Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1GAFTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:19:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51095 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab1GAFTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:19:40 -0400
Date: Fri, 1 Jul 2011 15:19:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amerigo Wang <amwang@redhat.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20110701151931.4c2d78b5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Jul_2011_15_19_31_+1000_PMJHlWtwDVwqi_rX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jul_2011_15_19_31_+1000_PMJHlWtwDVwqi_rX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/kernel/rtas.c: In function 'rtas_restart':
arch/powerpc/kernel/rtas.c:655:24: error: 'SYS_RESTART' undeclared (first u=
se in this function)
arch/powerpc/kernel/rtas.c: In function 'rtas_power_off':
arch/powerpc/kernel/rtas.c:664:24: error: 'SYS_POWER_OFF' undeclared (first=
 use in this function)
arch/powerpc/kernel/rtas.c: In function 'rtas_halt':
arch/powerpc/kernel/rtas.c:674:24: error: 'SYS_HALT' undeclared (first use =
in this function)

Caused by commit ac050ff2a176 ("It is not necessary to share the same
notifier.h").

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Jul_2011_15_19_31_+1000_PMJHlWtwDVwqi_rX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJODVjjAAoJEDMEi1NhKgbsnHIIAJqhmjcnBt1b4xKb0mYM8765
dfMCx5grrG8c0xI7O06nRkwhq0Zc5ZMFoqfh9AJ7GMaFfXLHQTBASJA5Hfl94nRb
EXUh999E+W7vOL5+2wvHhirY4n4cpfYYv9LNCYd3KvuKPqH5g03Ml0w4GsJlAtej
tdLrfTHhW+NI2TP2I1KdAlZ8vbXtD7wOmWaLIDDcLPdYlrK1WGWufTFRhlr+YKYw
EKDhIfppLoIq33/GXYFcsrVLL9969XPTe0qCJJldbIPk0/lvrJstMyL79gBiud3l
El/rPd8Id9v0sofvWPRWUMQbrBITX8xxpaL2Xs5GOGbQ0ewYRahzoPcnXhaBz2U=
=DOQj
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jul_2011_15_19_31_+1000_PMJHlWtwDVwqi_rX--
