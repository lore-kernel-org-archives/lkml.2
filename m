Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1HYGSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:18:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50622 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab1HYGSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:18:46 -0400
Date: Thu, 25 Aug 2011 16:18:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure after merge of the final tree (tty tree
 related)
Message-Id: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Aug_2011_16_18_43_+1000_461x9SfRP_2g7gmf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Aug_2011_16_18_43_+1000_461x9SfRP_2g7gmf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/tty/ehv_bytechan.c: In function 'udbg_init_ehv_bc':
drivers/tty/ehv_bytechan.c:230:18: error: 'MSR_GS' undeclared (first use in=
 this function)
drivers/tty/ehv_bytechan.c: In function 'ehv_bc_console_write':
drivers/tty/ehv_bytechan.c:289:24: warning: cast from pointer to integer of=
 different size
drivers/tty/ehv_bytechan.c: In function 'ehv_bc_console_init':
drivers/tty/ehv_bytechan.c:355:24: warning: cast to pointer from integer of=
 different size

Caused by commit dcd83aaff1c8 ("tty/powerpc: introduce the ePAPR embedded
hypervisor byte channel driver").

MSR_GS is defined in arch/powerpc/include/asm/reg_booke.h which is
included by arch/powerpc/include/asm/reg.h but only when defined
(CONFIG_BOOKE) || defined(CONFIG_40x).

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__25_Aug_2011_16_18_43_+1000_461x9SfRP_2g7gmf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVelDAAoJEDMEi1NhKgbsuYQIAIFHOnADLgJPd58D0ZV+DHi8
JNJ1kWsdrgp2AHNQwD7i2sRmrrlHYPeCVXZmKxfgHwek7uE4uFrgT8YkuHaRWL1+
Tj0B2B+CJovyt5kXAvmzA1R2L+VUR6JlXgLO7nJ1nJGvEcB5tUa2ABA1a86tRNVO
a0br8NYvZ+xShU/X1nFQ6MeAdK1T4nlY9FdudxdTKJoXUr4h0rNwEZOZZC90GdZG
wPAqszMy0fZkgXwwwUAS+RgBsmRqgztbKvE95Z/7XZkCz0xC7HTOtslgoOP8P7nD
7+inKEdc49Oh4FFnRCLq3YSc5HzQEsTToli3R6GbLEnoSLZaJUpqZBsCsEUkMvI=
=0N4I
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Aug_2011_16_18_43_+1000_461x9SfRP_2g7gmf--
