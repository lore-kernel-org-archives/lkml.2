Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0K2CZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:25:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50068 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab0K2CZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:25:28 -0500
Date: Mon, 29 Nov 2010 13:25:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>
Subject: linux-next: build failure after merge of the final tree
 (security-testing tree related)
Message-Id: <20101129132520.6884a624.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Nov_2010_13_25_20_+1100_XarZDkbRp9Pev1+A"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Nov_2010_13_25_20_+1100_XarZDkbRp9Pev1+A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

security/keys/trusted_defined.c: In function 'init_sdesc':
security/keys/trusted_defined.c:52: error: implicit declaration of function=
 'ERR_PTR'
security/keys/trusted_defined.c:52: warning: return makes pointer from inte=
ger without a cast
security/keys/trusted_defined.c: In function 'TSS_sha1':
security/keys/trusted_defined.c:65: error: implicit declaration of function=
 'IS_ERR'
security/keys/trusted_defined.c:67: error: implicit declaration of function=
 'PTR_ERR'
make[3]: *** [security/keys/trusted_defined.o] Error 1
security/keys/encrypted_defined.c: In function 'aes_get_sizes':
security/keys/encrypted_defined.c:73: error: implicit declaration of functi=
on 'IS_ERR'
security/keys/encrypted_defined.c:74: error: implicit declaration of functi=
on 'PTR_ERR'
security/keys/encrypted_defined.c:74: warning: format '%ld' expects type 'l=
ong int', but argument 2 has type 'int'
security/keys/encrypted_defined.c: In function 'init_sdesc':
security/keys/encrypted_defined.c:270: error: implicit declaration of funct=
ion 'ERR_PTR'
security/keys/encrypted_defined.c:270: warning: return makes pointer from i=
nteger without a cast
security/keys/encrypted_defined.c: In function 'init_blkcipher_desc':
security/keys/encrypted_defined.c:351: warning: format '%ld' expects type '=
long int', but argument 3 has type 'int'
security/keys/encrypted_defined.c: In function 'encrypted_key_alloc':
security/keys/encrypted_defined.c:536: warning: return makes pointer from i=
nteger without a cast
security/keys/encrypted_defined.c:547: warning: return makes pointer from i=
nteger without a cast
security/keys/encrypted_defined.c:552: warning: return makes pointer from i=
nteger without a cast

Caused by commits d00a1c72f7f4661212299e6cb132dfa58030bcdb ("keys: add new
trusted key-type") and 7e70cb4978507cf31d76b90e4cfb4c28cad87f0c ("keys:
add new key-type encrypted").  Missing include(s).  See Rule 1 in
Documentation/SubmitChecklist.

I have reverted those commits for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Nov_2010_13_25_20_+1100_XarZDkbRp9Pev1+A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM8w8QAAoJEDMEi1NhKgbsjj8H+wWjM+ONwvB0GLI+ONqse+Cv
WayfXF5M03okqLGSPXfLoA72F3JXMlpLFSoz4pNBFXRNkWtBRwZxDXMd+ai//XUc
4dWgfc/Lp/StqC4ZgC0BWR2A3ikAfa3Ri3guRZ+oLwNLuK94iMLlkss0im2O7D2S
YFwALo75mip+QLU9atTBGF9CJVYVWWQNZ3xB1M3IFvVF8mN3kpXeALpRO/VX3BLL
RJo/li1eYUz7Bs/PXFJpjEUcg2U2oGpW2ZWTWnb5Iu6sASaDfs74Pq7dOMEXqcVT
/VVDOxSDCOCEgy9eAH3FtGVy2CJy9XbOezeKG0JR3vgpHw06itnjexSHNHrbRRg=
=2gfe
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Nov_2010_13_25_20_+1100_XarZDkbRp9Pev1+A--
