Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637Ab2KBB51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:57:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44760 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762593Ab2KBB5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:57:24 -0400
Date: Fri, 2 Nov 2012 12:57:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Leach <matthew@mattleach.net>
Subject: linux-next: build failure after merge of the modules tree
Message-Id: <20121102125711.6cca854164da5372700db109@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__2_Nov_2012_12_57_11_+1100_oA69JlYjEyegoC0G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Nov_2012_12_57_11_+1100_oA69JlYjEyegoC0G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the modules tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/pasemi/idle.c:88:1: error: macro "__define_initcall"=
 passed 3 arguments, but takes just 2
arch/powerpc/platforms/pasemi/idle.c:88:1: error: data definition has no ty=
pe or storage class [-Werror]
arch/powerpc/platforms/pasemi/idle.c:88:1: error: type defaults to 'int' in=
 declaration of '__define_initcall' [-Werror=3Dimplicit-int]
arch/powerpc/platforms/pasemi/idle.c:88:1: error: '__machine_initcall_pasem=
i_pasemi_idle_init' defined but not used [-Werror=3Dunused-function]

And several more similar.

Caused (again - a fixed version of this patch is in the akpm tree) by
commit 9f859bf82c1d ("init: Use the stringify operator for the
__define_initcall macro").

I have use the modules tree from next-20121101 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__2_Nov_2012_12_57_11_+1100_oA69JlYjEyegoC0G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQkyh3AAoJEECxmPOUX5FEoYIP/AsnuQREXzJVur98NiezkkRA
QQ6R38doRm0CYl0wfrwiJd0vpzPWv+4OHL20QqUWPXn9RMy0Ptr7fs4Ifp9GZTju
pCLRI7cBJG7nPYNl98zDOBZUp1O5olZidcjTBW3NwYLlmqqAZb/3RPqBPUp9Ah07
9VwnowPo3r7wKeINYBpi5Ch3m4R63K7NOCaGx2ChSS+g+S2Anjn1QfiDU/B9PZnt
GClQWlX/qu6zyRLUQtLdIe69xLkxaZcq0T4BZYK4bIxDKe5F3ICNMXl3sWmx7EKu
P6+6jT3snhEN8BVEhNOGtNsdLGherQnWYDoD9QJgaPN0Xjiy2Q6VjEZF4TTFIZhL
QLP4D7rVvZGrEeELx4+nuUxk5dGcrsAnpaO057a4ha7ElBYj2AtXdsRN0FusLlvF
Be3ZellHbZ5g/Y57Uo2fpog5HYpEP6Ek8npVRuTtkalw0tq6YayKLiO/ql+RzAQA
N9n87Tc62gJllqApVsZvv7IQpxB5ESH5Co6niuu1KFOJt8VY4Y2c/ZF2maRL1/pQ
ye2hroDn7o4qe9osCZat8iNKP4z0BFK4PCtCVyw1buZC3jGXrxC7AjYbkL2LnsGW
Fan7SkQKzb0+g3xSRoSnPE/2KjjGtXRPW1nbO9PHc7+XdQeMub7yk66cOmCVgwTz
Qt2xGnu4npTfgOoPzBTt
=Lmbi
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Nov_2012_12_57_11_+1100_oA69JlYjEyegoC0G--
