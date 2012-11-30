Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2K3BW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:22:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34237 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2K3BW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:22:26 -0500
Date: Fri, 30 Nov 2012 12:22:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kelly Doran <kel.p.doran@gmail.com>, Ben Skeggs <bskeggs@redhat.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20121130122209.2df445e05e638738a0739f25@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Nov_2012_12_22_09_+1100_lPw6cKnKK1EIMc9q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Nov_2012_12_22_09_+1100_lPw6cKnKK1EIMc9q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/nouveau/core/engine/disp/nv50.c between commit
11d92561c81b ("drm/nvc0/disp: fix regression in vblank semaphore
release") from Linus' tree and commit 370c00f939c5 ("drm/nv50/disp:
initial implementation of the various channel object classes") from the
drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
index 15b182c,c6f8005..0000000
--- a/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c
@@@ -22,7 -22,10 +22,11 @@@
   * Authors: Ben Skeggs
   */
 =20
+ #include <core/object.h>
+ #include <core/parent.h>
+ #include <core/handle.h>
+ #include <core/class.h>
 +#include <subdev/bar.h>
 =20
  #include <engine/software.h>
  #include <engine/disp.h>

--Signature=_Fri__30_Nov_2012_12_22_09_+1100_lPw6cKnKK1EIMc9q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQuApBAAoJEECxmPOUX5FEW3MP/0ZoK1G7dqMC4fdjAEBuEYiP
ru4IsNdoGhrb/wRp52sP4UqPdYcptcOOkjQJs0lBx9VmXtL1tSWgLzGw2wNvoWTP
EYd0sLgwx5Rgr2yUsxCG6SPs9MtIzlL4X1p94SfJB/dfr/JllSauw6ESjTKN3EJC
cXB4CHSs0LqOvMtvUOVttMlXw43MfTocqQx2I0lWlUYPwMzzS/6TVBAqK8Ag9wxO
SLCNMIZ688chNGa0wlXaVk//ch70/sp/XHpEwxrpKaWl9digbt5MRO/ag4/SXzLV
iYrLzYCEK7p9vuVzV8KObisjiYiaGq1d8e5hCuQWkGp88KDVv3owgDgsRHV0XLZJ
Ytga58i0L4rFuRRZWOqP+6GdSFfyegDqGEAwLT97gIHk3HXkXqNpmCYzYzRZWD7N
6WX+hNgbr/GHevbqZKLUh9TNdXaj8y6zBYJHrokYDW0o7GRhPRVRJ3aeLXgPCetN
Pwu1JOz0E6jmcTkTPfGnMfJyDRk8RuN4JgMHD8OxxkcCnlSL9/xDsaxmlqlPforH
2krfqQUAuZVUBNHREIcgkHclJmes027aaD8M0KGpjEJp+6qsXt8I2Op12vR06NlM
RTxElcsnYvO4x2H8ekt3OB1S5BRydU6JiUvMutOwe0VXo7RdmDERPYgFMpwBAVWn
vGUM+eU+q1bLVO/QEaGx
=+RCo
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Nov_2012_12_22_09_+1100_lPw6cKnKK1EIMc9q--
