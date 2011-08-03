Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1HCEQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 00:16:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50395 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1HCEQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 00:16:48 -0400
Date: Wed, 3 Aug 2011 14:16:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110803141641.00402b8e49dd68aa58c458ac@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Aug_2011_14_16_41_+1000_H/abPUlmXWon0.EX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Aug_2011_14_16_41_+1000_H/abPUlmXWon0.EX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/zcache/zcache-main.c:57:16: error: expected declaration spe=
cifiers or '...' before string constant
drivers/staging/zcache/zcache-main.c:57:1: warning: data definition has no =
type or storage class
drivers/staging/zcache/zcache-main.c:57:1: warning: type defaults to 'int' =
in declaration of 'MODULE_LICENSE'
drivers/staging/zcache/zcache-main.c:57:16: warning: function declaration i=
sn't a prototype

Caused by commit fd6b68bbac9f ("staging: zcache: module is GPL")
interacting with the module.h split up.

Greg, this file needs module.h even in upstream.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Aug_2011_14_16_41_+1000_H/abPUlmXWon0.EX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOMupAAoJEDMEi1NhKgbsXJoH/1VjqbkwYaOBZEsz4N4rO3Vl
eVZvGgBXiXhOyBRlq2cC5hh2fZBYGquGeKkb+2sPO+ntBLDT7bOEsY1XmZkhVzDM
OjIpavMI4ZKLmV5QwDzepyzTjga+E0VuZmQIp0v+qTXqzMygpF3OK6WKV0NdJqct
B+v1+MtHqbgnGW5GjKzE43aCbGGS1A1RYCXPdf7tr0bO+BcnzhqqJPogH5vb/ZGw
kNIWVI8LPNLmnVkRHlJ8uXSyedzVRQ+57UrP90pe9u7Wjg8sgThySKsA0J++IspC
uhbUyzx4aA6Gq4dktXPc+Depfk0zVYrSeTH27VlRErY8jCAJr7xU9dueoEW3IGQ=
=vPEd
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Aug_2011_14_16_41_+1000_H/abPUlmXWon0.EX--
