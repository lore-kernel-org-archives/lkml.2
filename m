Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2FYFBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 01:01:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37202 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2FYFBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 01:01:44 -0400
Date: Mon, 25 Jun 2012 15:01:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, Jean Delvare <khali@linux-fr.org>
Subject: linux-next: manual merge of the tip tree with the jdelvare-hwmon
 tree
Message-Id: <20120625150130.5fd1716cabf02aed85918c20@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Jun_2012_15_01_30_+1000_5dLG1ccvbPTofU5e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jun_2012_15_01_30_+1000_5dLG1ccvbPTofU5e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/hwmon/coretemp.c between commit 3c1aae21b09d ("hwmon: struct
x86_cpu_id arrays can be __initconst") from the jdelvare-hwmon tree and
commit 3bac8715443f ("x86, cpufeature: Rename X86_FEATURE_DTS to
X86_FEATURE_DTHERM") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

P.S. that tip tree commit has no Signed-off-by line at all :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hwmon/coretemp.c
index b405781,637c51c..0000000
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@@ -793,8 -793,8 +793,8 @@@ static struct notifier_block coretemp_c
  	.notifier_call =3D coretemp_cpu_callback,
  };
 =20
 -static const struct x86_cpu_id coretemp_ids[] =3D {
 +static const struct x86_cpu_id __initconst coretemp_ids[] =3D {
- 	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTS },
+ 	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTHERM },
  	{}
  };
  MODULE_DEVICE_TABLE(x86cpu, coretemp_ids);

--Signature=_Mon__25_Jun_2012_15_01_30_+1000_5dLG1ccvbPTofU5e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP5/CqAAoJEECxmPOUX5FEBdQP/2giYJ+4DORYRWNbl5YfLUGj
paUVtWHMLyHPlaKv+z+VS+SzRvHYsfC+SIgRGlAPGxD+WkobIP7z0BeUAQhbOTXx
mct7AkPZfERdVa4HGaPFpZsbwYcxayuM/u6ytSYu0JV2wE4Gukq6b3xdskNwtCJc
8+1rzG1+vDtRmQKw8C+wPpVM/p3GBWG8JbDIWYqT368WjnHcBpv0KkPZxSrlu3jD
XLKvBLrqUV7ZI4xrYTHh5xNBmpDX02ORXOT1CDY7VXJtkxIpbkDRUk1TTwADvUSD
ysql3cleVWu72980bGq6G/eZVOZSww3GZmuqXMLtuNzrCG5j4+dbrCn4FP1DVKbE
2RBsiPoJ0gqr2J3NEbwIVW4AcCLzAcQER9c/oXPnUCYXcT/5QnRy8qxI59JS+tZ7
INDXL3akcrnL2BCQpTo7Ga9nwSc4ZxqwsyMV57UTOTxH8Bq2FwwO8x10hqKN6Smu
81k029Fta6hh/OeydIbOfDTXspk7jcsbVPDbzgJrJj6CdsVJDoRI4kDSNMW4J0dT
hqhsepRG1CRTox0nE2qbxgkFkpOEYj53MAIh6h3jUDaPCaItIbg9lEKLIdioTVKU
b64m3rI8lSD4csj6oP1ohNwlOh5D51GC4wAz0k1/6eWIDjj6FwfpS701W4gNPGca
bieBW6X2aK7zQSplONno
=SnMZ
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jun_2012_15_01_30_+1000_5dLG1ccvbPTofU5e--
