Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1H2CJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 22:09:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46505 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1H2CJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 22:09:13 -0400
Date: Mon, 29 Aug 2011 12:09:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>
Subject: linux-next: build failure after merge of the scsi tree
Message-Id: <20110829120902.f95a92022c2d9170defdc083@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Aug_2011_12_09_02_+1000_K_pijKcOfQ0asW99"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Aug_2011_12_09_02_+1000_K_pijKcOfQ0asW99
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/qla2xxx/qla_nx.c: In function 'qla82xx_md_alloc':
drivers/scsi/qla2xxx/qla_nx.c:4815:2: error: implicit declaration of functi=
on 'vmalloc'
drivers/scsi/qla2xxx/qla_nx.c:4815:14: warning: assignment makes pointer fr=
om integer without a cast
drivers/scsi/qla2xxx/qla_nx.c: In function 'qla82xx_md_free':
drivers/scsi/qla2xxx/qla_nx.c:4845:3: error: implicit declaration of functi=
on 'vfree'

Caused by commit b60bb5832c00 ("[SCSI] qla2xxx: Add support for ISP82xx
to capture dump (minidump) on failure").  Missing include of
linux/vmalloc.h.  See Rule 1 in Documentation/SubmitChecklist.

I have used the scsi tree from next-20110826 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Aug_2011_12_09_02_+1000_K_pijKcOfQ0asW99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOWvS+AAoJEDMEi1NhKgbsRnIH/Ru+c6HpieAwS7tb7VtLo9Gq
OVXTfaIuK3TWH//TTAgWVRWLM7prxDZWeE11EwNDMrD4t6fi4wSLq63ZS6YHOyDD
LGZHjOYPLcRjrRCq33iCKwsWN8k4FJuwjKziNrsdp4pUyg/fyR2pXReRmHXy4gKh
4cInG/bv6/DGERkaLewB4ntk+U8yFnXI8AygWj1ChGsSPAiCnCUO0n/1c9NTiGq0
/me0I6QSlbbhUk9JhTW/KHEbdrNAlfGcdSiiD3OilLVcFuCHmZw92WtSMMOup5PT
9Qtprcm4FlENTkyJJeQQoxczvL8pSPuIvaspAJm/LLOy1WJ3fUGSXwOkUZPqZPo=
=QajH
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Aug_2011_12_09_02_+1000_K_pijKcOfQ0asW99--
