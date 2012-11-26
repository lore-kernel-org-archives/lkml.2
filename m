Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2KZAbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 19:31:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47614 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2KZAbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 19:31:51 -0500
Date: Mon, 26 Nov 2012 11:31:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: linux-next: manual merge of the ia64 tree with Linus' tree
Message-Id: <20121126113141.3b624dc9e729039b54c51881@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_11_31_41_+1100_IwhEyeVJS/FUeK0u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_11_31_41_+1100_IwhEyeVJS/FUeK0u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ia64 tree got a conflict in
fs/pstore/platform.c between commit 70a6f46d7b0e ("pstore: Fix NULL
pointer dereference in console writes") from Linus' tree and commit
faa338315985 ("efi_pstore: Add a sequence counter to a variable name")
from the ia64 tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/pstore/platform.c
index 947fbe0,e518f43..0000000
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@@ -173,7 -172,7 +173,7 @@@ static void pstore_console_write(struc
  			spin_lock_irqsave(&psinfo->buf_lock, flags);
  		}
  		memcpy(psinfo->buf, s, c);
- 		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, c, psinfo);
 -		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, 0, c, psinfo);
++		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, 0, c, psinfo);
  		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
  		s +=3D c;
  		c =3D e - s;

--Signature=_Mon__26_Nov_2012_11_31_41_+1100_IwhEyeVJS/FUeK0u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsrhtAAoJEECxmPOUX5FEVdUP/AwaogrsvpcjVQL6ASE+oS7l
5flKs1YZTQnJrJ0CusAyQ+c0S41U8HxRS4cNsP2e4MJRtHr3kmGivjgSw2TfzN38
dQH5MRN5wS8O3Ug6ljj4a5ZR/oomFBqxMYOotdJ32gcZL7VYbtXsbZeSqnQBM2rC
FyLfoqFqMI02uFfbfJcSwSF1Qsa4LNfsT0u3OvxNSt64k87LjtDxGpHz7JDVOqGN
Bddhvdsl9gV5OMzVVhlljueW5NWxNmhKGgbG/dEU089gJfBD6XMa6hnN/bOR2zhQ
XEC4CL5v9x5k2I7oPRJKyFBFIGyz08ubXYJV6KmU4fpU2ZC2kbv1OyDdTlHeOpYc
yjQAXQ9pCt7kK2p39BBJQ1QndW8xVPpoqq4UhNqxF0a9AnOZRcXyMURIfJGggYdR
1nX4D38ldBOxVk8YErjjSBtAqOxQ0pxdeDuwfygUhZB16DZv8oQ0F6Hg0x4Q/kG6
oUA/oNFj7QqUb95fH9yZt66B/MYS4GdGfXFjMWzgEvM83EiJOjSIcuO0Eu9BltSr
AooTAge1ckkWYoyxraQUQbdN77JI4gLRcBgIne03mt7inkLM19PYpRlDjIlfh+S8
XYYRwJT9vYA4ceYatDd7jvGwjVJ0pJg2+m8RTUyFc9M+JO9oBXOIY/lj+JdEMG90
7eNC8GVomoqvucbPnVEe
=M9R4
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_11_31_41_+1100_IwhEyeVJS/FUeK0u--
