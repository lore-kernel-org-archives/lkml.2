Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0HIBku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 21:40:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57359 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab0HIBkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 21:40:49 -0400
Date: Mon, 9 Aug 2010 11:40:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Rapoport <mike@compulab.co.il>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20100809114042.7beb076a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Aug_2010_11_40_42_+1000_kSIDUCSg5YQSeg8/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Aug_2010_11_40_42_+1000_kSIDUCSg5YQSeg8/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mfd/tps6586x.c: In function 'tps6586x_add_subdevs':
drivers/mfd/tps6586x.c:272: error: dereferencing pointer to incomplete type
drivers/mfd/tps6586x.c:273: error: dereferencing pointer to incomplete type
drivers/mfd/tps6586x.c:275: error: dereferencing pointer to incomplete type
drivers/mfd/tps6586x.c:275: error: dereferencing pointer to incomplete type
drivers/mfd/tps6586x.c:278: error: dereferencing pointer to incomplete type
drivers/mfd/tps6586x.c: In function 'tps6586x_i2c_probe':
drivers/mfd/tps6586x.c:324: warning: passing argument 2 of 'tps6586x_add_su=
bdevs' from incompatible pointer type
drivers/mfd/tps6586x.c:265: note: expected 'struct tps6586x_platform_data *=
' but argument is of type 'struct tps6586x_platform_data *'
drivers/mfd/tps6586x.c:330: error: dereferencing pointer to incomplete type

Caused by commit 8232c2794cf0e39b38d089eff49500461ecdbb8f ("mfd: Add
TPS6586x driver").  "struct tps6586x_platform_data" is not defined
anywhere ...

I have used the mfd tree from next-20100807 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Aug_2010_11_40_42_+1000_kSIDUCSg5YQSeg8/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMX1yaAAoJEDMEi1NhKgbs0xcH/0HG6jrkuUJheQ2G0tUYncGz
eLPqgV4GbVzhtG5nqNWoGGoHKZVMG5IkMVmZ7UZhpZe4/u3E8W5cF8CYGDF3fgFw
PJy3B8X83iecBtUkRP33TBb41wfS3/Zzbv3BN+EB7QClpqGjQehfkeaSePrf3sQk
/8gMSDt5gGeF3dICuwpk/PkJ6Pqdrg0lfJEEN2yvT8ttPG5LvEBwuLBJYRfulcks
qIDnHe2cRyWDHg31aIucIuqIhRRUC+NAIAiXYOKesW+8cckG8jsmC0Mw7oA4XfG/
IhfihvQ/0HctCR1DIgDI6t+f0Hl6SUl2fFMfgPA+NEZedvwn731Upg7GL9k9xVc=
=Do4V
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Aug_2010_11_40_42_+1000_kSIDUCSg5YQSeg8/--
