Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1HJBNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:13:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32912 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1HJBNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:13:30 -0400
Date: Wed, 10 Aug 2011 11:13:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Subject: linux-next: build warnings after merge of the security-testing tree
 (cifs tree related)
Message-Id: <20110810111322.89faa11b60c672d9605c1876@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Aug_2011_11_13_22_+1000_LFFemVZlO+G4ug6i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Aug_2011_11_13_22_+1000_LFFemVZlO+G4ug6i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security-testing tree, today's linux-next build
(powerpc ppc64_defconfig) produced these warnings:

fs/cifs/xattr.c:39:0: warning: "XATTR_TRUSTED_PREFIX_LEN" redefined
include/linux/xattr.h:27:0: note: this is the location of the previous defi=
nition
fs/cifs/xattr.c:40:0: warning: "XATTR_SECURITY_PREFIX_LEN" redefined
include/linux/xattr.h:21:0: note: this is the location of the previous defi=
nition

Probably caused by commit 9d8f13ba3f48 ("security: new
security_inode_init_security API adds function callback") which included
linux/xattr.h in linux/security.h.  Though I don't understan why these
defines are duplicated anyway.

[Steve, the above commit is *not* in linux-next today due to other
problems.]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Aug_2011_11_13_22_+1000_LFFemVZlO+G4ug6i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQdsyAAoJEDMEi1NhKgbsPdgH/Az8s/MgXsTLIcHWEVu/35wT
SOSVTIacv+/9aHYf88uzQ0KNBaK41s3fF8rMRi+IO/m3/h4Af4FI1oRgjDeByuSa
1CYh7+BNcKtCud/IxMBLMeYUmeYShwJ483lo/2VegivbWBy9He74K/CMjlgAADOy
rN+c18CDN7Wvf/1d+eyhQSkAGJSUws1kyWLKNFRvBLpV+K/y7H6bBs8WUXghAAuk
3o1kuhYjh0OxU6NpbcUARnZfnAo7gDE/IxLQkiMfaG4FI3UssQadQu0WT4TMqkru
b1HcWfPny4gyNbQcnpDbVFFm8YhlbFPW7m7JOTX+Ul9FCiznFPKeQ1MT5n6fglI=
=yzsZ
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Aug_2011_11_13_22_+1000_LFFemVZlO+G4ug6i--
