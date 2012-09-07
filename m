Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005Ab2IGCvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:51:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56084 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446Ab2IGCvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:51:14 -0400
Date: Fri, 7 Sep 2012 12:51:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David McCullough <david_mccullough@mcafee.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the crypto tree with the sparc-next
 tree
Message-Id: <20120907125104.f9adc5ba55907e802cc8329b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Sep_2012_12_51_04_+1000_tID0pQtN=WYVzHw9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Sep_2012_12_51_04_+1000_tID0pQtN=WYVzHw9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got conflicts in
crypto/Kconfig between commits 4ff28d4ca93b ("sparc64: Add SHA1 driver
making use of the 'sha1' instruction") and 9bf4852d3d19 ("sparc64: Add
AES driver making use of the new aes opcodes") from the sparc-next tree
and commit f0be44f4fb1f ("arm/crypto: Add optimized AES and SHA1
routines") from the crypto tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc crypto/Kconfig
index 94f232f,2730798..0000000
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@@ -451,15 -433,15 +451,24 @@@ config CRYPTO_SHA1_SSSE
  	  using Supplemental SSE3 (SSSE3) instructions or Advanced Vector
  	  Extensions (AVX), when available.
 =20
+ config CRYPTO_SHA1_ARM
+ 	tristate "SHA1 digest algorithm (ARM-asm)"
+ 	depends on ARM
+ 	select CRYPTO_SHA1
+ 	select CRYPTO_HASH
+ 	help
+ 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
+ 	  using optimized ARM assembler.
+=20
 +config CRYPTO_SHA1_SPARC64
 +	tristate "SHA1 digest algorithm (SPARC64)"
 +	depends on SPARC64
 +	select CRYPTO_SHA1
 +	select CRYPTO_HASH
 +	help
 +	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
 +	  using sparc64 crypto instructions, when available.
 +
  config CRYPTO_SHA256
  	tristate "SHA224 and SHA256 digest algorithm"
  	select CRYPTO_HASH
@@@ -633,34 -599,30 +644,58 @@@ config CRYPTO_AES_NI_INTE
  	  ECB, CBC, LRW, PCBC, XTS. The 64 bit version has additional
  	  acceleration for CTR.
 =20
+ config CRYPTO_AES_ARM
+ 	tristate "AES cipher algorithms (ARM-asm)"
+ 	depends on ARM
+ 	select CRYPTO_ALGAPI
+ 	select CRYPTO_AES
+ 	help
+ 	  Use optimized AES assembler routines for ARM platforms.
+=20
+ 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+ 	  algorithm.
+=20
+ 	  Rijndael appears to be consistently a very good performer in
+ 	  both hardware and software across a wide range of computing
+ 	  environments regardless of its use in feedback or non-feedback
+ 	  modes. Its key setup time is excellent, and its key agility is
+ 	  good. Rijndael's very low memory requirements make it very well
+ 	  suited for restricted-space environments, in which it also
+ 	  demonstrates excellent performance. Rijndael's operations are
+ 	  among the easiest to defend against power and timing attacks.
+=20
+ 	  The AES specifies three key sizes: 128, 192 and 256 bits
+=20
+ 	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+=20
 +config CRYPTO_AES_SPARC64
 +	tristate "AES cipher algorithms (SPARC64)"
 +	depends on SPARC64
 +	select CRYPTO_CRYPTD
 +	select CRYPTO_ALGAPI
 +	help
 +	  Use SPARC64 crypto opcodes for AES algorithm.
 +
 +	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 +	  algorithm.
 +
 +	  Rijndael appears to be consistently a very good performer in
 +	  both hardware and software across a wide range of computing
 +	  environments regardless of its use in feedback or non-feedback
 +	  modes. Its key setup time is excellent, and its key agility is
 +	  good. Rijndael's very low memory requirements make it very well
 +	  suited for restricted-space environments, in which it also
 +	  demonstrates excellent performance. Rijndael's operations are
 +	  among the easiest to defend against power and timing attacks.
 +
 +	  The AES specifies three key sizes: 128, 192 and 256 bits
 +
 +	  See <http://csrc.nist.gov/encryption/aes/> for more information.
 +
 +	  In addition to AES cipher algorithm support, the acceleration
 +	  for some popular block cipher mode is supported too, including
 +	  ECB and CBC.
 +
  config CRYPTO_ANUBIS
  	tristate "Anubis cipher algorithm"
  	select CRYPTO_ALGAPI

--Signature=_Fri__7_Sep_2012_12_51_04_+1000_tID0pQtN=WYVzHw9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSWEYAAoJEECxmPOUX5FEUXsP/jnVApPfve2sZ2mmvp+d2cXR
D3PG1vaQhYulziY+PC9YZ+y4783/vid34sGvXyZeG1Hdmm91cPj1lK/vUSnqbTzy
/iOmiSa/UTAGyS6J9II44BWNkXdQVLiHt9RrzG6/jmlKBZVy4bQhf9dc2NECSEvO
j1QwyqzThpHQ2zYtw95WMCax2NkflhUDrzZ+V8L0qBhe7YOy0KSDVv/fRR//StUO
M+aMrZJBSew+NAyjMh6lkDwt/OwrrSAZ8MUedDEECVWHmTk6GfkZQuVJrEfmsZpI
Tm5rCNZhFn8xQg1V/CKm96a96enKf8mdg9ju7nZRnNYOQXD9m4+24ifD6E8qTdgt
eKb3H3X0lHJv04/wsiGSEQ+U0etgSP9lg6e0Yk87mwZAvrizrHzPYE+kKN9IFtsa
1X0Iif995XVSs0RJxT98gusfF8vR1JTEKRLsYmZY8VRf1WCUnOPUnntlyGSXFcqK
ZPbpF6gIm77xVoglHcetqXL3Qqd+7svsj36DegwWxArLDOdaCaUZzaC42u05UMxX
3l1mOugevgVKyxoKHfj1s2winVXd9BaA9nP+OnAaSz8QYZssfexJpeJvgmSw4b/w
KtI+dc4mWDjXPZvzJS0ANAlAd7I46+zI2E0ijH6++pbkgeMKb57e4BDFOATKW0Fz
7NJtc5ysnSWGWD+drIE/
=QANv
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Sep_2012_12_51_04_+1000_tID0pQtN=WYVzHw9--
