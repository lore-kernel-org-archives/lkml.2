Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2JQAlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 20:41:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45815 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab2JQAls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 20:41:48 -0400
Date: Wed, 17 Oct 2012 11:41:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the security tree with Linus' tree
Message-Id: <20121017114146.a6054d579a7a4e345aad690b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__17_Oct_2012_11_41_46_+1100_PEfHlvhx8YScpF3D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Oct_2012_11_41_46_+1100_PEfHlvhx8YScpF3D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
security/keys/keyctl.c between commit 9a56c2db49e7 ("userns: Convert
security/keys to the new userns infrastructure") from Linus' tree and
commit 3a50597de863 ("KEYS: Make the session and process keyrings
per-thread") from the security tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc security/keys/keyctl.c
index 5d34b4e,6d9d0c7..0000000
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@@ -1535,9 -1527,9 +1536,9 @@@ long keyctl_session_to_parent(void
  		goto unlock;
 =20
  	/* the keyrings must have the same UID */
- 	if ((pcred->tgcred->session_keyring &&
- 	     !uid_eq(pcred->tgcred->session_keyring->uid, mycred->euid)) ||
- 	    !uid_eq(mycred->tgcred->session_keyring->uid, mycred->euid))
+ 	if ((pcred->session_keyring &&
 -	     pcred->session_keyring->uid !=3D mycred->euid) ||
 -	    mycred->session_keyring->uid !=3D mycred->euid)
++	     !uid_eq(pcred->session_keyring->uid, mycred->euid)) ||
++	    !uid_eq(mycred->session_keyring->uid, mycred->euid))
  		goto unlock;
 =20
  	/* cancel an already pending keyring replacement */

--Signature=_Wed__17_Oct_2012_11_41_46_+1100_PEfHlvhx8YScpF3D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQff7KAAoJEECxmPOUX5FE0P0P/3Rr5amfX31oUyjF9K7DYrJ1
Tp8qKux1HazuIpuZyi6EGwjN91YsfnBwRmp+kDdOfZQuQAhb/dx4GqCpNkxlcAJv
mbHvCVb1DDxe4nutQDow+iKekASKnKecomqzFFokUfMRQYAMRgM3CS1PaDxXM2g9
9+BgVVm3iTJ6gu4J/Bma+FJhyVIdNgOYFKuptlAtdJH2kCO9d1Er8QCQCEUKAqbo
mevqaop/Opr9Gpd0HpNB2FywfLTi/J5jxP0sDlQj07yFqdZbtYoyjgWeKHuWh123
DkUBCUYlx4RNNSsc9Z1uLGgqu0AjkSaQVizTN395jsrpdDw/wzGev0tN308dh7z6
EeAfviJDH+1iriHXhfghAdjrg0lzr4IH23p67bIu8tvDuqr6aScg7BfLdwyLjYH8
Q/4ry92OAiSoBwQL6jYc/KxofySqkHvvdHfOxAhb1gkuWtBsrxYYS9UuEZ/psI2D
bnsPwcVbqtE+Uj73id4HkcCGlsvK+B1SuzCRn+Ezu/zMxHUi1v9cyOsCFfBcRweS
r44LgxFV+HIXzmnTnGuqrlLTa5HVFhnses7UCWOKCJ1Bjpk+SAFqrBgCexOQMsLT
KpOz3BddaD7CKWX59Vw3hBAEKaou0gMnPBWsHO6OhPfLUWwREt2oW7fDlxnTo/zY
3nGzX5nWjRCXmhnkcjuu
=n9yB
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Oct_2012_11_41_46_+1100_PEfHlvhx8YScpF3D--
