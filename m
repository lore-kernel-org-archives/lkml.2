Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab2LTBg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:36:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55547 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2LTBgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:36:23 -0500
Date: Thu, 20 Dec 2012 12:36:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the signal tree with Linus' tree and
 the cris tree
Message-Id: <20121220123612.a2118f0f156af2d951bcbca1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Dec_2012_12_36_12_+1100_8jyj3=jowsoTv9Wn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Dec_2012_12_36_12_+1100_8jyj3=jowsoTv9Wn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got conflicts in
arch/alpha/include/asm/signal.h, arch/x86/include/asm/signal.h and
arch/cris/include/asm/signal.h between commits 96433f6ee490 ("UAPI:
(Scripted) Disintegrate arch/alpha/include/asm"), af170c5061dd ("UAPI:
(Scripted) Disintegrate arch/x86/include/asm") from Linus' tree,  commit
e717abac8a9f ("UAPI: (Scripted) Disintegrate arch/cris/include/asm") from
the cris treeand commit 031b6566983a ("unify SS_ONSTACK/SS_DISABLE
definitions") from the signal tree.

I fixed it up (the former moved the sections of the files modified by the
latter to other files, so I just removed those sections and then applied
the following patch) and can carry the fix as necessary (no action
is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 20 Dec 2012 12:24:24 +1100
Subject: [PATCH] fix up for unify SS_ONSTACK/SS_DISABLE definitions

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

---
 arch/alpha/include/uapi/asm/signal.h |    6 ------
 arch/cris/include/uapi/asm/signal.h  |    6 ------
 arch/x86/include/uapi/asm/signal.h   |    6 ------
 3 files changed, 18 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/signal.h b/arch/alpha/include/uapi=
/asm/signal.h
index 965bbfa..dd4ca4b 100644
--- a/arch/alpha/include/uapi/asm/signal.h
+++ b/arch/alpha/include/uapi/asm/signal.h
@@ -84,12 +84,6 @@ typedef unsigned long sigset_t;
 #define SA_ONESHOT	SA_RESETHAND
 #define SA_NOMASK	SA_NODEFER
=20
-/*=20
- * sigaltstack controls
- */
-#define SS_ONSTACK	1
-#define SS_DISABLE	2
-
 #define MINSIGSTKSZ	4096
 #define SIGSTKSZ	16384
=20
diff --git a/arch/cris/include/uapi/asm/signal.h b/arch/cris/include/uapi/a=
sm/signal.h
index 2162494..ce42fa7 100644
--- a/arch/cris/include/uapi/asm/signal.h
+++ b/arch/cris/include/uapi/asm/signal.h
@@ -83,12 +83,6 @@ typedef unsigned long sigset_t;
=20
 #define SA_RESTORER	0x04000000
=20
-/*=20
- * sigaltstack controls
- */
-#define SS_ONSTACK	1
-#define SS_DISABLE	2
-
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
=20
diff --git a/arch/x86/include/uapi/asm/signal.h b/arch/x86/include/uapi/asm=
/signal.h
index 0818f9a..aa7d6ae 100644
--- a/arch/x86/include/uapi/asm/signal.h
+++ b/arch/x86/include/uapi/asm/signal.h
@@ -87,12 +87,6 @@ typedef unsigned long sigset_t;
=20
 #define SA_RESTORER	0x04000000
=20
-/*
- * sigaltstack controls
- */
-#define SS_ONSTACK	1
-#define SS_DISABLE	2
-
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Dec_2012_12_36_12_+1100_8jyj3=jowsoTv9Wn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ0muMAAoJEECxmPOUX5FEphsP/00EtROb8B1jWBdkvjJ+RWGs
bvsPJ7qLtqhnC+Gy7OkztDARihKpU795Cvc9Hcrzd9YPBANOiAXAyEYqMa3cCNKa
A0qCZYQk86lFTpUdUKKumbQDAxlu4aAoQDrOEh33fOLHkzY9LXfwx4r1JPnec2qY
NfHSpa6JsmhXMkUPkLjLsUEFP9735NMDeT5dXP90znWrBPsiN7d+NBqZUXKIfDo8
MpIAxP2JNuzM22rLIXHH+WHS2RQYBVOj+p2QzsH+oMxot3fCkiZ+zMLiMKB8kyix
umzsR0yBTqQSxa72hkMuCYYfLvgk1kG+TvaB98WyjveM8wVax4H05Bu2QNCnOeqU
7p0EapZFQIaQFBj1NcUxxT6ZG8/ACSAwXEJ8V8jnvvQMnj2FEW+utPLwbVs/uxD2
nWPjdE04cCujyYz0ph/5+Ke6auStxzv9BS7IZM57cOAWQYGaiCtqsvoLxWdqYYlT
0VIg7kBPDhKdpSk9HT2S1uPhx+sTA0PqZQtzBczUBEdCpLAyqLOlPQaUWHvZhl7e
zITLDxrJqaahrjKrRHpJEXMOpY9PE54hlNGODtDrdVeWzgJj1Fv6J/kYxs3zc4j2
da3fz6lhgSmMHnAT4+ybEHo8lSiL2VL7C1dUdi+oqij0V6wvUKrL+hIW5B1MOqLL
5bknTMNY8FDzU8utloTJ
=nxMN
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Dec_2012_12_36_12_+1100_8jyj3=jowsoTv9Wn--
