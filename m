Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2BXDGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:06:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35213 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2BXDGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:06:38 -0500
Date: Fri, 24 Feb 2012 14:06:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>, James Morris <jmorris@namei.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the tip tree with the security tree
Message-Id: <20120224140616.1b59431e58fe8a719b415eef@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Feb_2012_14_06_16_+1100_UcCmqgtgj/UV/DN_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Feb_2012_14_06_16_+1100_UcCmqgtgj/UV/DN_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/net/sock.h between commit 404015308747 ("security: trim
security.h") from the security tree and commit 77a73e5383a9 ("static
keys: Introduce 'struct static_key', very_[un]likely(), static_key_slow_
[inc|dec]()") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/net/sock.h
index 7b195a8,907bbe0..0000000
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@@ -55,9 -55,7 +55,9 @@@
  #include <linux/uaccess.h>
  #include <linux/memcontrol.h>
  #include <linux/res_counter.h>
- #include <linux/jump_label.h>
+ #include <linux/static_key.h>
 +#include <linux/aio.h>
 +#include <linux/sched.h>
 =20
  #include <linux/filter.h>
  #include <linux/rculist_nulls.h>

--Signature=_Fri__24_Feb_2012_14_06_16_+1100_UcCmqgtgj/UV/DN_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPRv6oAAoJEECxmPOUX5FE7HIP+wVrRpjps6wu53LqkzdT8orT
sP+wYr5Pa03x35D4ulVg7BJM0qcyMXKY2rQvBYgs20yysc77oAIVIL6xliDHl0RN
zwk2HiH8QnIz/Tx+Vc5/N7QK0+bhNn/g5/hprgXOuOIoQeYTwsygZtqSXmbz+cwG
oZ25xk+xn5hoRi89gxonH63dzv8oMlgLCNfad4PkRnWEeajn0Gi+fiecqoAr2grP
/b8koGryeDRvqHxOSBAdmmDtuuLf2+BvP3s1MQCN836BVo/i0LYlTkCfaOwd1YhU
uupwy/C+4/G3kfJmLTmD5N2QjIbHDyGvbUqNsmQHPjAh1aXi8KFGnI0qrsSBLske
F4IhJeHlqVMgNCvfyZLAIu8z3mAKzRkJ9QXPRZ7gt8SokJ1PzE0KoEsxArqG3knb
660x1RDAG+3V1z2umyh4caem/ZTCWMLNWzlvP496DKCwP3nI5knVLxMbylMLbiBO
cSfbMyyM90MqWkPdfPR2ktnwujs/g8FABQrtinOVmSTd6GuIb2/w32sg1Up8xbXf
abHha5+U4R5ZeqPFwYvV61Ab1xpAsYt/OzSUzkQ3Y8GcGpJflRVWwpI6yCb3fldL
bb37EXsLcbeAxzlL7lvdgVn9ImGBk2DNQ3DmEUhQLAXPzgBYCHxkUQgvqLRq5HlQ
VkWkbXzeq8XbSQ5ObWm+
=0AMz
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Feb_2012_14_06_16_+1100_UcCmqgtgj/UV/DN_--
