Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab2LUCdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:33:31 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34741 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2LUCdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:33:23 -0500
Date: Fri, 21 Dec 2012 13:33:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the signal tree with Linus' tree
Message-Id: <20121221133314.38cb2860dbaff359a912e444@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Dec_2012_13_33_14_+1100_qm_vbMrUCelUI71/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Dec_2012_13_33_14_+1100_qm_vbMrUCelUI71/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/h8300/include/asm/ptrace.h between commit 1ec94e75def5 ("UAPI:
(Scripted) Disintegrate arch/h8300/include/asm") from Linus' tree and
commit 1ca97bb541a1 ("new helper: current_user_stack_pointer()") from the
signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/h8300/include/asm/ptrace.h
index 79c9a91,6183371..0000000
--- a/arch/h8300/include/asm/ptrace.h
+++ b/arch/h8300/include/asm/ptrace.h
@@@ -28,5 -63,7 +28,6 @@@
  #define current_pt_regs() ((struct pt_regs *) \
  	(THREAD_SIZE + (unsigned long)current_thread_info()) - 1)
  #define signal_pt_regs() ((struct pt_regs *)current->thread.esp0)
+ #define current_user_stack_pointer() rdusp()
 -#endif /* __KERNEL__ */
  #endif /* __ASSEMBLY__ */
  #endif /* _H8300_PTRACE_H */

--Signature=_Fri__21_Dec_2012_13_33_14_+1100_qm_vbMrUCelUI71/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ08pqAAoJEECxmPOUX5FEtUIP/1R18++PScuoldg5FapxFhp9
KT5IgUtOndJYkE7mHXkHVbriEhwAFtgXPMQrwf+PwENhJx8X+3DriJ4XSP9AAOYp
ellnbOR5ecygJK2MR1MXKIU1TySaUDpoNNgoC75qIGIGBiwZvbB+Nbbea3ByP8Rp
U/ygDS5fAOQKQ5UgOYMcy+wGW4Jq68iLsPTiNVswjNzebKIl6rXj4xK/BqUY5kKD
R4ER7OnCYwPbg/t8oN3K5s4AcHG4X1k/83CScGhWgyV9nxBealD0vaMXqf4phhWG
judi0cICEmaAXmVnrxgggDJpJ2vfbOSL8kE6imk97WQnH/r08MuR6j+SFk6ZSCIt
LJo6x2e/bnMQe4vgvW7xhnohb+s6YS+XzpMjZub4LGO9+2N6huw6N46M39f1iGih
rj+gTxKI5FEWZ5sjYo+VSUebyzGTUNgBpSuatb/0BMQX3fkvNqJ8PxW0K5mvV4E5
m41p/AuqKwe72bJaHUB4fDezlzUY7p4DrYudwIp16eO1TbyIpYKz1ZimhjlnCE/V
jmCbKZvF/iHiN6TO4kY9ke7XMNpxybzGxOkkIKaZ7kHq9YlU06y6hpOltRnRWnh/
WCh8GHyeynwN6EluVZ18JoD4JU2DZ8X4g2YyUhe2rqzX+GUVA/GOIq1x5edkRxg9
p85teee4NnFC9JMw6Tfe
=Qyzb
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Dec_2012_13_33_14_+1100_qm_vbMrUCelUI71/--
