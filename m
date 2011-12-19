Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1LSEL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:11:58 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46886 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1LSEL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:11:56 -0500
Date: Mon, 19 Dec 2011 15:11:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Eric Sandeen <sandeen@sandeen.net>,
        Ben Myers <bpm@sgi.com>, David Chinner <david@fromorbit.com>,
        xfs-masters@oss.sgi.com
Subject: linux-next: manual merge of the pm tree with the xfs tree
Message-Id: <20111219151145.dba82854f65671a877db8ed3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_15_11_45_+1100_6iI2M+Y0xIbf.Qx8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_15_11_45_+1100_6iI2M+Y0xIbf.Qx8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
fs/xfs/xfs_buf.c between commit 687d1c5e8e26 ("xfs: remove unused
XBT_FORCE_SLEEP bit") from the xfs tree and commit a0acae0e886d
("freezer: unexport refrigerator() and update try_to_freeze() slightly")
from the pm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/xfs_buf.c
index f84777e,0188299..0000000
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@@ -1701,8 -1701,12 +1701,8 @@@ xfsbufd
  		struct list_head tmp;
  		struct blk_plug plug;
 =20
 -		if (unlikely(freezing(current))) {
 -			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
 +		if (unlikely(freezing(current)))
- 			refrigerator();
+ 			try_to_freeze();
 -		} else {
 -			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
 -		}
 =20
  		/* sleep for a long time if there is nothing to do. */
  		if (list_empty(&target->bt_delwri_queue))

--Signature=_Mon__19_Dec_2011_15_11_45_+1100_6iI2M+Y0xIbf.Qx8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7rmBAAoJEECxmPOUX5FE3hsP/iNa2Xb+aB972p+nubbarcY/
n8vEBDU4K8DVJG00AxQFxDERiQB3HyCd2EBGZ68BnRzm/bcUIHs0MHca7F5a0s+H
eV8c6eq38SjEir1/vGrNNK9fXG1/L7rKii/rW0dRKXs6UKHWh6CZlry8ZNfXXyhP
La/bwBE+INK2KboasTNLYEOyD6nWl5A6ziZ0gLfevM4ujTpHowBrF2tmwzIj/1jY
Csg6tSpNWewJquez86RqqBH1Z9EzHMJX67jVUOD2DpMj/DnMSSwAc4LqFhM+/znL
k5W8YURgJChAA6VCoIhHDO4/XgRZbVMFMMr2mRNRojSxJb3lvqMXy78WuOMLDMit
so9vydZSRGGaeiPLoRs+DQP67f/2Zj+1pPnwq1bIK1ajwcF9Ijy8oe2lEXNdm23q
1jugNlocBrstsh1ErN0tQh/qR4afVoNAVZpn99nK2EKwInxgYTQrNHtQImolJw7D
7xigl9RDzvMrOfnGoe99bVGn+ct1sVQKF3724Dy91lf4lHQPdxZwxgXWmOg5PNn/
p8SCgcmplQLz4MjE+SsVbbAqfCiddcjBMu5K67CtdKsOyCZxzCfAfO3L54ZTz/P1
07BMoQe4kpXTtQx+HETug5RCGO9QSkjwLdQ5SP12Ykn30EhLRm8j+scnVnJJbG9l
NBI8nHdkMCQhV0LEsqBO
=r0dB
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_15_11_45_+1100_6iI2M+Y0xIbf.Qx8--
