Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2JDBkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:40:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36831 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2JDBkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:40:41 -0400
Date: Thu, 4 Oct 2012 11:40:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Bob Moore <robert.moore@intel.com>, Feng Tang <feng.tang@intel.com>
Subject: linux-next: manual merge of the acpi tree with Linus' tree
Message-Id: <20121004114030.f865899893be54df3105a872@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_11_40_30_+1000_GJZTsB9WMD8j77Wl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_11_40_30_+1000_GJZTsB9WMD8j77Wl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
include/acpi/acpixf.h between commit a1ce39288e6f ("UAPI: (Scripted)
Convert #include "..." to #include <path/...> in kernel system headers")
from Linus' tree and commit be030a576854 ("ACPICA: Add support for
complex _PLD buffers") from the acpi tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/acpi/acpixf.h
index 51405d3,267bfc4..0000000
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@@ -47,11 -47,12 +47,12 @@@
 =20
  /* Current ACPICA subsystem version in YYYYMMDD format */
 =20
- #define ACPI_CA_VERSION                 0x20120711
+ #define ACPI_CA_VERSION                 0x20120913
 =20
 -#include "acconfig.h"
 -#include "actypes.h"
 -#include "actbl.h"
 -#include "acbuffer.h"
 +#include <acpi/acconfig.h>
 +#include <acpi/actypes.h>
 +#include <acpi/actbl.h>
++#include <acpi/acbuffer.h>
 =20
  extern u8 acpi_gbl_permanent_mmap;
 =20

--Signature=_Thu__4_Oct_2012_11_40_30_+1000_GJZTsB9WMD8j77Wl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbOkOAAoJEECxmPOUX5FEhR4P/3gFmZRfivJUoYmNvgumGtRn
97ZKtEjUe1wjrAPqKJc2lNpFkFFS8BT0dszli2FUjyqLES627cU9/ENe3duKDuZ1
4Hbb/yTlH7+WlROpXYMVFH2ynYMXVcGDQwnHG3ZbTRUqu5LPhWxNR4sUJSeGmna4
J10YC6FHRDkoJotJHSZMnH9lIXLnF4CKPCb/jBpDH71YFXqZ5AVQ58VEkBVBzMUM
LIy0ATL8NrvyPhEkejHi7WjyTTR6GmP83MiwOz1uhyzjugfflTU7gN9UDKqlp5qD
+3RRURfHGeG4poL0QNzEaNCV0mZINT1Z1znag99plW2vMsZXSsZyX2fnee3wmkq1
N9Ha0RBcZlWzyd3Ya9yOolRgpismgBHs4UXVYzkGZCPoQ7HLjz9vpUcNGseAwkyM
lht42kMt3ERiMnt7xeeGlDfdYU3M5PVufUeO+26Cd3mjxvc1iNbyj+QzdIu+kXy8
1hmrw+b1V0Dzpe+JEyiBllOGZpmO6PHG6kRj35YuZw+7Pi12XGR9xlZR/ZfrHmmI
Xjya0hGAJey8XNBl+28mlNDLx1ilE5iAMHHRZzeNhX2/M+B21OEyHkoQ9MVFGe4J
Xs2n3hlAxEg+VJtNuPNAPJv3a3NRa9nLMIcnW+a5mkymhlL0O2I/qN9Kd2EOz1M1
MXeDISjLpFv546jAbY95
=TKOY
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_11_40_30_+1000_GJZTsB9WMD8j77Wl--
