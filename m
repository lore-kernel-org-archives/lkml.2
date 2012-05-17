Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973Ab2EQDV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:21:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36631 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760940Ab2EQDV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:21:26 -0400
Date: Thu, 17 May 2012 13:21:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Westin <andreas.westin@stericsson.com>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the crypto tree with the powerpc tree
Message-Id: <20120517132116.8a5378bce254fc39d20cb08a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_May_2012_13_21_16_+1000_/sEcRREOlI8vjD_8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_May_2012_13_21_16_+1000_/sEcRREOlI8vjD_8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
drivers/crypto/Kconfig between commit aef7b31c8833 ("powerpc/crypto:
Build files for the nx device driver") from the powerpc tree and commit
2789c08fffea ("crypto: ux500 - Add driver for CRYP hardware") from the
crypto tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/crypto/Kconfig
index f1ceeef,69fdf18..0000000
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@@ -296,21 -295,15 +296,32 @@@ config CRYPTO_DEV_TEGRA_AE
  	  To compile this driver as a module, choose M here: the module
  	  will be called tegra-aes.
 =20
 +config CRYPTO_DEV_NX
 +	tristate "Support for Power7+ in-Nest cryptographic accleration"
 +	depends on PPC64 && IBMVIO
 +	select CRYPTO_AES
 +	select CRYPTO_CBC
 +	select CRYPTO_ECB
 +	select CRYPTO_CCM
 +	select CRYPTO_GCM
 +	select CRYPTO_AUTHENC
 +	select CRYPTO_XCBC
 +	select CRYPTO_SHA256
 +	select CRYPTO_SHA512
 +	help
 +	  Support for Power7+ in-Nest cryptographic acceleration. This
 +	  module supports acceleration for AES and SHA2 algorithms. If you
 +	  choose 'M' here, this module will be called nx_crypto.
 +
+ config CRYPTO_DEV_UX500
+ 	tristate "Driver for ST-Ericsson UX500 crypto hardware acceleration"
+ 	depends on ARCH_U8500
+ 	select CRYPTO_ALGAPI
+ 	help
+ 	  Driver for ST-Ericsson UX500 crypto engine.
+=20
+ if CRYPTO_DEV_UX500
+ 	source "drivers/crypto/ux500/Kconfig"
+ endif # if CRYPTO_DEV_UX500
+=20
  endif # CRYPTO_HW

--Signature=_Thu__17_May_2012_13_21_16_+1000_/sEcRREOlI8vjD_8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPtG6sAAoJEECxmPOUX5FEFEgQAI1qOAHHihjLGrD8PfMXzsrr
g+RdMp/oFMunkyeMRH/o3f9zPg+UNanbMAbZRpwMl/x13kgDNQd+XnJecmioy6Q3
W0uqga3+G+9nCPyQQxl2cHrOeLx3O+kuG4DTAr7JY8An6S6JV1EdkaXvFaqHnwDJ
qv6TaHQuenPFTwwJ2i7Qn9cZfP0EHpFyA0YHaNdKjEV2HOTO3B/TPRRxrrdzxIGL
R+Q8oUwhW9fWYweXvu4MTr8BMKPuAtFzNjIgJvqHDj0xbUXwN7u9jH9ccKFlPfMa
k1e1/jQ75Pywv3h08b427d4gRnrsX4ejCaoOfzNSUjdNlxonmVntEX2cVvrrFQud
wXibRUXuaKdDxtw36zvyDM9oL6BsWmjIxvgsRKK5/3H+o6zxRhYzwq8nP4yXczb7
rIv9I0HR15Az+Nc0cylpVHK1ptliRHZNR6W0J9PQrfB/s1+Yjr7vaPmMcFwmiARp
Sc1FoCrJ0it4sCyegiP8W/yhPOfCWp4zbxZePAiuVz3f+v5JtNfZgYz6sfQEXLQa
j+EwCvmROMRIAeqju9GaDwq43oFOZsKmM4DFpX9IFeqnCFvw4M2bVrnw55WZARqS
gRQHxwOkuu100cJYqGLT+6Cxj72qZPlqAKS60anCMcw3twSZeDmXv6LKIR/qROHK
fhdMdjWx7yY675EvIfFR
=MUwW
-----END PGP SIGNATURE-----

--Signature=_Thu__17_May_2012_13_21_16_+1000_/sEcRREOlI8vjD_8--
