Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab1I1JWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:22:34 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38923 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1I1JWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:22:33 -0400
Date: Wed, 28 Sep 2011 19:22:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20110928192220.6d85ae23a2f2ef316139a310@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Sep_2011_19_22_20_+1000_RlgdBTOqj909DXmG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Sep_2011_19_22_20_+1000_RlgdBTOqj909DXmG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/boot/stdio.c:12:0:
arch/powerpc/boot/stdio.h:10:17: error: expected declaration specifiers or =
'...' before numeric constant
arch/powerpc/boot/stdio.h:10:20: error: expected declaration specifiers or =
'...' before numeric constant
arch/powerpc/boot/stdio.h:10:8: warning: return type defaults to 'int'
arch/powerpc/boot/stdio.h:10:8: warning: function declaration isn't a proto=
type
arch/powerpc/boot/stdio.h: In function '__printf':
arch/powerpc/boot/stdio.h:14:17: error: expected declaration specifiers or =
'...' before numeric constant
arch/powerpc/boot/stdio.h:14:20: error: expected declaration specifiers or =
'...' before numeric constant
arch/powerpc/boot/stdio.h:14:23: error: expected '=3D', ',', ';', 'asm' or =
'__attribute__' before 'int'
arch/powerpc/boot/stdio.h:16:12: error: storage class specified for paramet=
er 'vsprintf'

And went down hill from there (it produced hundreds of errors).

Caused by commit a52af697aaeb ("treewide: use __printf not __attribute__
((format(printf,...)))").  Maybe because some of these files are part of
the boot wrappers and are built (effectively) independently of the kernel
itself.  Notice that arch/powerpc/boot/stdio.h does not include any
kernel headers ...

I have reverted that commit (and the follup ones b31d03e43e56
"treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes"
and f43c361e2bd9 "kernel.h/checkpatch: mark strict_strto<foo> and
simple_strto<foo> as obsolete") for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Sep_2011_19_22_20_+1000_RlgdBTOqj909DXmG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgudMAAoJEDMEi1NhKgbscAAIAJQWo9Pf9LFIXFVVFUoMD3KZ
VpSdXcFC9maeTZGO71yuFOSoVlbUfQ1G6ttS2qJu3jqpFra9ScbU1P2RtJo2OM8z
3CTXzROqYACdUghQXwNWvM0CNHwFz3V8imnsHLHAIL3ZZAoafb5zpgelr6urXltW
yztsl89XII/k/MYcZR0wm4bdKu2zz2zBg44puHPRugqhnMxROVflOCzPRSkkVAfB
kw69ZhlB/CadyXJo6hVXL42Mq05N9+NgMfd5tWc6ouVBNwbEKlOSO8SwoOnM9FV/
il9s7dDn5WWZU2e6P4StDU/rsnv+IKru1bEQQ3xOqUm82Hh89YzXLoBBzuDPrEA=
=h6wU
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Sep_2011_19_22_20_+1000_RlgdBTOqj909DXmG--
