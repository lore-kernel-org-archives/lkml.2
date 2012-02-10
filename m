Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091Ab2BJFvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:51:36 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34877 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899Ab2BJFve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:51:34 -0500
Date: Fri, 10 Feb 2012 16:50:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: linux-next: manual merge of the akpm with the security tree
Message-Id: <20120210165055.b12ec02e86249d32bc96af14@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Feb_2012_16_50_55_+1100_cZcdkVN0N9en7Gj/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Feb_2012_16_50_55_+1100_cZcdkVN0N9en7Gj/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the scsi-post-merge tree got a conflict in
include/linux/prctl.h between commit 2d514487faf1 ("security: Yama LSM")
from the security tree and commit "prctl: add PR_{SET,GET}
_CHILD_SUBREAPER to allow simple process supervision" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/prctl.h
index 4d0e5bc,b885c85..0000000
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@@ -114,10 -114,7 +114,13 @@@
  # define PR_SET_MM_START_BRK		6
  # define PR_SET_MM_BRK			7
 =20
+ #define PR_SET_CHILD_SUBREAPER 35
+ #define PR_GET_CHILD_SUBREAPER 36
+=20
 +/*
 + * Set specific pid that is allowed to ptrace the current task.
 + * A value of 0 mean "no process".
 + */
 +#define PR_SET_PTRACER 0x59616d61
 +
  #endif /* _LINUX_PRCTL_H */

--Signature=_Fri__10_Feb_2012_16_50_55_+1100_cZcdkVN0N9en7Gj/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPNLA/AAoJEECxmPOUX5FEChIP/i7wRitySdg7ykGz4rk+Z1Td
NG3JSFYSd/5Sn+dhlG9b7VmyZRa8e5b72kgMB2n8PaY30lfwSffUUGCgw3B+TfzG
tjMb7ssgHlDTKL7VzewsPFBg6ElKsc+s8Q2JcEb1GFEelp0xRpjJKLrWwUPfeXx1
GRUbuRffAYXW8mluzlMG2qBKoT24Xg4n1mensNUp7XthDanf4K0ZRbDoxx6dyckv
1qvxh2Zfvde+LYMdbTYVP9yXVjYxUBf1VAKddlLPbkBIlHoGbrXxEeWw1opMoUBd
Ab98nqhmiuP6mfw/WjTAhwlBTHMbrW8RLAJ96o60ayWTxj+TvSMQkAtIlMirZOoO
eMMeJxJso7RdCk67jrmNSyuXjM6kKbhLBtCJQtl1hE8hIp1r2QlbEU8wTAnHOiFu
t+mwitoGfhlRq4IgGazqEnHdY+e6gp4He7If5RvhcBhPgCtUwCfXQX/Ofy5Yv2WT
n3iDbqJDVjVFQ7FvwradOFEifBb3JiZtxvaqLGDeeM5XroVtTN/yI7O6Az6itJ0y
vYhIxnRqYvy1w3MupZ4uXomEOviDZge/AV+Lr3qSW5ufGR1TqwRexS3x8uf+b4kB
4NOc8YenVXkNcvOuZEV7oSTNVK9omRkhPWnhrpCRIiAGUEbq39pjsO2fcBA+7bND
m5hZ2AJyjcd+yYwBPemH
=kJNi
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Feb_2012_16_50_55_+1100_cZcdkVN0N9en7Gj/--
