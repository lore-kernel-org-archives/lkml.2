Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2JQAmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 20:42:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44073 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab2JQAl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 20:41:59 -0400
Date: Wed, 17 Oct 2012 11:41:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: linux-next: manual merge of the security tree with Linus' tree
Message-Id: <20121017114157.6abc8a3e1e6a62048addd52d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__17_Oct_2012_11_41_57_+1100_69xoKXjy7+EYowa2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Oct_2012_11_41_57_+1100_69xoKXjy7+EYowa2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
net/dns_resolver/dns_key.c between commit c6089735e724 ("userns: net:
Call key_alloc with GLOBAL_ROOT_UID, GLOBAL_ROOT_GID instead of 0, 0")
from Linus' tree and commit f8aa23a55f81 ("KEYS: Use keyring_alloc() to
create special keyrings") from the security tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/dns_resolver/dns_key.c
index 8aa4b11,b53bb4a..0000000
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@@ -259,11 -259,10 +259,11 @@@ static int __init init_dns_resolver(voi
  	if (!cred)
  		return -ENOMEM;
 =20
- 	keyring =3D key_alloc(&key_type_keyring, ".dns_resolver",
 -	keyring =3D keyring_alloc(".dns_resolver", 0, 0, cred,
 -				(KEY_POS_ALL & ~KEY_POS_SETATTR) |
 -				KEY_USR_VIEW | KEY_USR_READ,
 -				KEY_ALLOC_NOT_IN_QUOTA, NULL);
++	keyring =3D keyring_alloc(".dns_resolver",
 +			    GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
 +			    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
 +			    KEY_USR_VIEW | KEY_USR_READ,
 +			    KEY_ALLOC_NOT_IN_QUOTA);
  	if (IS_ERR(keyring)) {
  		ret =3D PTR_ERR(keyring);
  		goto failed_put_cred;

--Signature=_Wed__17_Oct_2012_11_41_57_+1100_69xoKXjy7+EYowa2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQff7VAAoJEECxmPOUX5FE/ScP/ioG/CW8eESqEQWHjjTWG+rG
FuJaAzJdKu3LDtRTCiICh1fzPayFMhGcZIp3yQyGJgxanGVWyCohnwpoAPH22JTB
K2Iem80iWYrz8HpTMs4da9Dgjx4KCD7CpQ7UWo52ElG1dI6QJCnrFWFy4mIHNspB
NgXbp2nF+YEDS447Fd1pHx+aclqudTZNS4nNczxJH+HGM4DCgcIScVwIb3ehN5N5
F4ZhvOf1sz2vcGdkDAfeT95NmlRojCE/tXkY7pLvl4Zxn/KanfCcZwyY8gOx4haQ
WrfAHtfHcHzxCcru0M3Owt/ZzDtlyQNl95iChdFBbK7E1RXzAoh8vGvi6pjz6Gcg
jB1zkhffQBYiQRmiiRRcvWxP/NxJgtY7cQ66HLTD/CSXTzvOhtZPmarpS/FaUJUA
ptTy8c1T19wVmGdr9BQzyfyfLOjuRAOeul32LWJOQvrBN90hr/XynHqPu8/Agag8
KxKhdP1tJcrLF37AW6uIxssqnbTydDiQ+vUYkYYna4Oho3Oey/at+/GPNfSU6eLj
m0AYQXGDz3U+M1jx8Ia30TxmIxop+zQvE5DEZ3VUaCSXyojNjOiLloH5DuHfq0jC
a5zgHnsvCkaNEyP/XpYa1EKAmT7Xk6HVnVawu3l29gle4qF9EuK4yyQhH3yKf0z3
YOZkVUTVPnoqPUMu62Z+
=JX/V
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Oct_2012_11_41_57_+1100_69xoKXjy7+EYowa2--
