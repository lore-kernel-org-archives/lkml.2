Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1KAJaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:30:03 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47527 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1KAJaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:30:01 -0400
Date: Tue, 1 Nov 2011 20:29:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: linux-next: build failure after merge of the final tree
 (device-mapper and moduleh trees related)
Message-Id: <20111101202958.89f11454f4546b6abbfb18d6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_20_29_58_+1100_1WizZX3JEUOE3PBj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_20_29_58_+1100_1WizZX3JEUOE3PBj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/md/persistent-data/dm-space-map-checker.c:386:1: warning: data defi=
nition has no type or storage class [enabled by default]
drivers/md/persistent-data/dm-space-map-checker.c:386:1: warning: type defa=
ults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/persistent-data/dm-space-map-checker.c:386:1: warning: parameter=
 names (without types) in function declaration [enabled by default]
drivers/md/persistent-data/dm-space-map-checker.c:417:1: warning: data defi=
nition has no type or storage class [enabled by default]
drivers/md/persistent-data/dm-space-map-checker.c:417:1: warning: type defa=
ults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/persistent-data/dm-space-map-checker.c:417:1: warning: parameter=
 names (without types) in function declaration [enabled by default]

Caused by commit 661ae8a9604f ("The persistent-data library offers a
re-usable framework for the storage") interacting with the module.h split
up.

I added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 1 Nov 2011 20:27:43 +1100
Subject: [PATCH] device-mapper: using EXPORT_SYBOL in dm-space-map-checker.c
 needs export.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/md/persistent-data/dm-space-map-checker.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-checker.c b/drivers/md=
/persistent-data/dm-space-map-checker.c
index bb44a93..50ed53b 100644
--- a/drivers/md/persistent-data/dm-space-map-checker.c
+++ b/drivers/md/persistent-data/dm-space-map-checker.c
@@ -7,6 +7,7 @@
 #include "dm-space-map-checker.h"
=20
 #include <linux/device-mapper.h>
+#include <linux/export.h>
=20
 #ifdef CONFIG_DM_DEBUG_SPACE_MAPS
=20
--=20
1.7.7

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_20_29_58_+1100_1WizZX3JEUOE3PBj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr7wWAAoJEECxmPOUX5FEK3QP/1eDaUJlzLM6IGxv6ZKOeNzM
dEKrSigvhDlJoT7ND2IqwWMl874zPngYWLcrW0IMCiKlcS5cdu2VcKVT8dmQPTyr
IWfkIsYlJzyMBD2qf8+XaYBXATvgnBkFYV+OhizjftWJEyiM95PJky7+wxde0gaP
K1qtRwLQpSXMyC+icLe/Mf6aAnyY8xfqyCA7AT8sNge7GQHl6NpYQ7uzqcnQlef8
0hSbASFmlRYAVWBqqFUJpkv+udFFTRnkX5yvkYrBkuDikYuw0GwEZ/ZaN3aqoIRV
W/CXp42/a5vx22P4u71bJ8VgHac2A2JS4kWnzs7qg1HHmToVivRLn85gggv6KJ/Y
w3Bfn5llWM0xy92k69+Ouh4TDAHm0qei6qkoNxaEEXYXLbtQmAqml3/5R78XlJtW
wtnpEMorBWZuKM21CXn0hNOEzMFZqMB/P7xQn765173/vAzRw+QNXUEj2erFrdKi
iPdxZwkXd9Dptl9YMyj5ipUjSE8n4KiDQvPhtpA12tmO2fSDFRRrz89mrUZiPLo5
RQ3ApkfHUycOcr98Z8ylAgVJ17scAIyUSWQmv9mIvNY/hKm8jVd7N2zu4OtPO4Pw
ntrDVofoZY/5BHTBfEpjNBLHhxinWZ7IItoRjoe7esdVLhy+S0TfYz3saR3XVkl0
ZRzO3CkVf+IdWGTRDcwW
=DDFv
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_20_29_58_+1100_1WizZX3JEUOE3PBj--
