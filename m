Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2IFDXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:23:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47801 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2IFDXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:23:12 -0400
Date: Thu, 6 Sep 2012 13:23:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the trivial tree with the powerpc tree
Message-Id: <20120906132302.030566cf4f8ee90cc1191f46@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Sep_2012_13_23_02_+1000_s7JfF4q8PgIZ=gxe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Sep_2012_13_23_02_+1000_s7JfF4q8PgIZ=gxe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/scsi/ipr.c between commit d3dbeef657fd ("powerpc: Rename 64-bit
PVR constants to PVR_foo") from the powerpc tree and commit 203fa3fe9c9d
("ipr: fix small coding style issues") from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary (no action required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/ipr.c
index cff6503,1059c99..0000000
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@@ -6398,8 -6330,8 +6398,8 @@@ static int ipr_invalid_adapter(struct i
  	int i;
 =20
  	if ((ioa_cfg->type =3D=3D 0x5702) && (ioa_cfg->pdev->revision < 4)) {
- 		for (i =3D 0; i < ARRAY_SIZE(ipr_blocked_processors); i++){
+ 		for (i =3D 0; i < ARRAY_SIZE(ipr_blocked_processors); i++) {
 -			if (__is_processor(ipr_blocked_processors[i]))
 +			if (pvr_version_is(ipr_blocked_processors[i]))
  				return 1;
  		}
  	}

--Signature=_Thu__6_Sep_2012_13_23_02_+1000_s7JfF4q8PgIZ=gxe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSBcWAAoJEECxmPOUX5FECWQQAJV+7SKuVNcZGvtiUOfQ3OnR
U6lsaNlglVKcvz6tp9PsrTnZGVc2j++7Ik1Q3j5+rMV6GKPYddli/jAhN9ryq8rW
ao3dF1mH8zdwcDxRPHUkTVlA6ccdfj4qF7YGhHlSxzFVHaRWirJm8BFIjpOViI+g
kiseBug8SGniCUAC3gmMLdQFKtqH5TG7iMFSqQ9tPTJuX73hJlt7hncmLb3BR0lY
VIA8VG6wlC1ygfiQ7zq5JglubwgkA1i8+1gUaWW85L7p7cvnxLGzYd0MFK1XBvH6
IstqKqVvSx2VhYXmVuSzePtTsAKNLQyy9gPrbuzN994zdB2P54QNV1dTNU5txdUc
LcbAdyQ1DfmriGYbPnd+UvuldksdD1v5XAYanh3CrWHSsSLl/SKw9Ei/potPcsxs
3VRsir+aR2hZV67nM0PONSazn4whHZRfUgjrbVwBeMipoJXx47QmMBSZJGkJRxbN
tKLxhS19VOhfvNqEIbUPVMaja9NJrm2KVkZs7CcCMhMuZOtmPkTgB197zfSRIiHF
tfzoxX1x2dxkIecuyEZPtUALAdu09JaxY8ZRpk3AO3xytmUTyW9YzsI8NBoDapvo
EZ+efgMLvBz5BQ7dGtmuMAjaoM0AV7i6FGR/agl39CeLak+lsuFCIW8sG+j+kDOG
HavNaxcqllsHK+rBM7sa
=MYgK
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Sep_2012_13_23_02_+1000_s7JfF4q8PgIZ=gxe--
