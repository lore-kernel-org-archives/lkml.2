Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1LTFLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:11:37 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60792 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1LTFLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:11:30 -0500
Date: Tue, 20 Dec 2011 16:11:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the cputime tree with the powerpc tree
Message-Id: <20111220161113.3724f901fae728fb26f90407@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_16_11_13_+1100_/89oeNuyWBR0m+qb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_16_11_13_+1100_/89oeNuyWBR0m+qb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Today's linux-next merge of the cputime tree got a conflict in
arch/powerpc/include/asm/cputime.h between commit 9f5072d4f63f ("powerpc:
Fix wrong divisor in usecs_to_cputime") from the powerpc tree and commit
648616343cdb ("[S390] cputime: add sparse checking and cleanup") from the
cputime tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/include/asm/cputime.h
index 33a3580,e94935c..0000000
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@@ -130,7 -114,7 +114,7 @@@ extern u64 __cputime_usec_factor
 =20
  static inline unsigned long cputime_to_usecs(const cputime_t ct)
  {
- 	return mulhdu(ct, __cputime_usec_factor);
 -	return mulhdu((__force u64) ct, __cputime_msec_factor) * USEC_PER_MSEC;
++	return mulhdu((__force u64) ct, __cputime_usec_factor);
  }
 =20
  static inline cputime_t usecs_to_cputime(const unsigned long us)

--Signature=_Tue__20_Dec_2011_16_11_13_+1100_/89oeNuyWBR0m+qb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8BjxAAoJEECxmPOUX5FEVCQQAJJtD3EOXNIzf2H3Ma3OnCHs
tGsBsCiKP8a7nhuFel87pGf6bKsJa/0Zjwe29FLoS1VHIci91qniEyopEmX/MOjo
l+YDaoSnwUpspixmOLd/MEaIil5VuQnfyoRfUpc5Vh3hTa//xDdKGsmTn7ZEIx6f
iiB7DYrcoOEJLP1I8GDAjOZTe4UYpJAVwokRfaUCgDXNwAAZliKxI+UBjYFpAWPd
zMtzQA9wbY0eWG96pfbIQkYQDmqE8hyGxRl16DV8uIo0+udpZ8qC+agAPZZt65IX
xAwJvXP3ihiQus3Z+aeAgur75n1ByScI1G3PKVW1TnG/xzprJtmB/15RIu4scGA2
uYugXq1l9BWv5etvdiXBG4CfcxUswQaYNgCP3qaNKw9HmzUhpEjdHew+/mKcZ2xB
XSSvCZcX4WVp+jdZL5vusftP2sGzD3oCrn3gQoUKBbJekXDw9zBeJIC8tSuHxLl2
l+dF5lYy5tYsogX/SHWvHAQ5ZtoP+QirhT70i7wJXalWD8BkWg7ykQnPvbJfsTf+
elMjFGUMvMbOEStr8zTC0zX5zAlNAwKZ7f6LxnYxzFkbYbXL6P5VparLAh9XhA77
Ed3tZo0FS8b+zncWDFNOrUj5Y694kywwhe9kviuL35Ewn0kC78T+MsrZusZKfWRc
6hJwOOTUVKvtmbFduS0c
=cdFm
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_16_11_13_+1100_/89oeNuyWBR0m+qb--
