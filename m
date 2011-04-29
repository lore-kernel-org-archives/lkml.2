Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab1D2DEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 23:04:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41116 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390Ab1D2DEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 23:04:21 -0400
Date: Fri, 29 Apr 2011 13:04:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the final tree (powercp
 tree related)
Message-Id: <20110429130410.3e6221ad.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Apr_2011_13_04_10_+1000_7lAyL36NJRb7Lhr+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Apr_2011_13_04_10_+1000_7lAyL36NJRb7Lhr+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc64
allnoconfig) produced this warning:

WARNING: vmlinux.o(.text+0x907a): Section mismatch in reference from the va=
riable generic_secondary_common_init to the variable .init.data:boot_cpu_co=
unt
The function generic_secondary_common_init() references
the variable __initdata boot_cpu_count.
This is often because generic_secondary_common_init lacks a __initdata=20
annotation or the annotation of boot_cpu_count is wrong.

Caused by commit 9d07bc841c97 ("powerpc: Properly handshake CPUs going
out of boot spin loop").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Apr_2011_13_04_10_+1000_7lAyL36NJRb7Lhr+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNuiqqAAoJEDMEi1NhKgbs3IoH/iAr9ico38i0LP9rUhQ1LmNs
qQvds3iqG7PtOmChVxNnCJz9b08DuJxVnH/ugbV4iVH26+p3kFSsDHdQEqlrb1m9
OFRbvm4v/CWvTDjQhk1OUX5ynbzmKFYg+32PRHjD1SZMDvpLjyqPKJSl6YJwCdB2
2GUQipxR7YYrr/n1hXZ8I4Jlcq+LO+MVVXzTvsodo3EwPl6yKB4rNpkrP5C7YwFX
kPV2idaeQ3wLj8SC2T9ol3zGKPDquLhQ+dlaYkrT6TpXSqbPFeVsOpwN8mkEwPIh
eIWxbXySGlwvNYiVmXMi7+8PwRWR+GUOODVo+yFzm8SOXuLwtWiBy8z5ywgxyOw=
=mt0M
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Apr_2011_13_04_10_+1000_7lAyL36NJRb7Lhr+--
