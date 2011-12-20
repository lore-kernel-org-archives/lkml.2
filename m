Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab1LTAbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:31:24 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42471 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1LTAbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:31:22 -0500
Date: Tue, 20 Dec 2011 11:31:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20111220113112.7db5cb344aa1f7fc33734cc8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_11_31_12_+1100_nD=0XLQ1PYwJ2XkW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_11_31_12_+1100_nD=0XLQ1PYwJ2XkW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from ipc/util.c:28:0:
include/linux/security.h: In function 'security_real_capable':
include/linux/security.h:1885:2: error: implicit declaration of function '_=
_task_cred' [-Werror=3Dimplicit-function-declaration]
include/linux/security.h:1885:2: warning: passing argument 2 of 'cap_capabl=
e' makes pointer from integer without a cast [enabled by default]
include/linux/security.h:69:12: note: expected 'const struct cred *' but ar=
gument is of type 'int'
include/linux/security.h: In function 'security_real_capable_noaudit':
include/linux/security.h:1897:11: warning: passing argument 2 of 'cap_capab=
le' makes pointer from integer without a cast [enabled by default]
include/linux/security.h:69:12: note: expected 'const struct cred *' but ar=
gument is of type 'int'
In file included from kernel/groups.c:7:0:

So security.h needs to include linux/cred.h ...

include/linux/security.h: In function 'security_real_capable':
include/linux/security.h:1885:25: error: dereferencing pointer to incomplet=
e type
include/linux/security.h:1885:25: error: dereferencing pointer to incomplet=
e type
include/linux/security.h:1885:25: error: dereferencing pointer to incomplet=
e type
include/linux/security.h:1885:25: error: dereferencing pointer to incomplet=
e type
include/linux/security.h:1885:25: error: dereferencing pointer to incomplet=
e type

And linux/cred.h needs to include linux/sched.h :-(

Caused by commit ae1a442f9d95 ("trim security.h").

I have used the vfs tree form next-20111216 again today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Dec_2011_11_31_12_+1100_nD=0XLQ1PYwJ2XkW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO79dQAAoJEECxmPOUX5FECy8P/2DU1Koku2Iet7DXxjdDsUP0
r8Vuu95CXCahj2iFC9SmKEIUHkFOFSL0wAhIB4PMzs7ZKkLkE9lDNN8v04i7Rkqf
0A5ms3lShf/UxLZmaiaeJvTcbl3w8aSAWvBgfcojXzpee7dqfZtrSok3Iey5b6cT
4BMGCOU2+40T8SWe3/nZpOzdxyyPsWQFPDzxSDKUdzSQs/hc7Xl/937/gJinUwXw
JJsEmtPlcXj7eb7s7UvgIF85698avJwfnl8B6uhp/1gi/1imdkx1olkRqclIr6sp
fFLrwTqfZBuJrdVwIY0JGu1JKaoxLpclHUWXpXJhES4BuJ4g1bijiEMVa6BKOMnY
AwVfBxg9u2wwztqfNIj8lLwMAcLelgQXzvsPJyzzAoNJg9f1tkUp1TGruGye0GUv
zzSCCUiZX8h2eeHvgDFLoXChbJbsEybo9Oi41jdP7ndEvAdsUIESTIg0Zv5AJDBd
3F1/yoiVRiXWXC7A8GYnifQe9tUow1FT3+eWEmsjKXNOE850JRJygeMv1Bve7jOI
KjcVjhEGCRrXKQPxooknEB1Q0qxnizT7MF5R1mA1uhFqT2PySSermbfj9Exg7/Py
zLTwlX3Z+W12BlumfWP4+AKA7gio9V/VJ65Ly0Nx7YOpmepEjMhBuCTKCdwqFF/8
HYX0Jt9aM/danBjpdVgB
=JpmC
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_11_31_12_+1100_nD=0XLQ1PYwJ2XkW--
