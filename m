Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1ESDTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:19:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49936 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab1ESDTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:19:23 -0400
Date: Thu, 19 May 2011 13:19:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the powerpc tree
Message-Id: <20110519131913.79c14fe7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_May_2011_13_19_13_+1000_4LoZgqk+29JvW/Pz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_May_2011_13_19_13_+1000_4LoZgqk+29JvW/Pz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the powerpc tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

WARNING: arch/powerpc/sysdev/built-in.o(.text+0x10eb8): Section mismatch in=
 reference from the function .ics_rtas_init() to the function .init.text:.x=
ics_register_ics()
The function .ics_rtas_init() references
the function __init .xics_register_ics().
This is often because .ics_rtas_init lacks a __init=20
annotation or the annotation of .xics_register_ics is wrong.

Introduced by commit 0b05ac6e2480 ("powerpc/xics: Rewrite XICS driver").

ics_rtas_init() is only called from xics_init() which is marked __init,
so ics_rtas_init() should be as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_May_2011_13_19_13_+1000_4LoZgqk+29JvW/Pz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN1IwxAAoJEDMEi1NhKgbsPH8IAIW5jLyxW5D1Q8J3j52PpFAB
yDgDtCSQ675W8NrKydXzCgk0pnwb4lXHidy/cK4xgvl6RswtSvwgeMQTRHG60hkl
fM6/8LsMtxfptClMb/6SATqblAxXkZn1l34LaQhJQ9/+LobvhkXZTaFqx1GZNMu2
RovOuhzsolWrmkNr+jYYbaHNV1eJ+gh3kVFej5gJ270HmLMA1/mxAXVjSJ01+zMe
7MGhr3+SurwNXJF7Py4VCqrUMFt/alyMlh2tCY0o/smYqTtV9/pYnRdeUsGbBYJQ
5j2cahrbK8f50nBqh3fNhJsOUloHl4FsHb84bnFq17LCxFoq6b3CXHy1LWsNQuA=
=v/Uj
-----END PGP SIGNATURE-----

--Signature=_Thu__19_May_2011_13_19_13_+1000_4LoZgqk+29JvW/Pz--
