Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab2JLFHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:07:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46146 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2JLFHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:07:13 -0400
Date: Fri, 12 Oct 2012 16:06:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the vfs tree
Message-Id: <20121012160658.f7fa4fdaf9759dd1b0a055d1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_16_06_58_+1100_VMP1ngXvPflB7XSc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_16_06_58_+1100_VMP1ngXvPflB7XSc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc allnoconfig)
produced this warning:

fs/namespace.c: In function 'do_mount':
fs/namespace.c:2219:8: warning: passing argument 3 of 'security_sb_mount' d=
iscards 'const' qualifier from pointer target type [enabled by default]
include/linux/security.h:1967:19: note: expected 'char *' but argument is o=
f type 'const char *'

Introduced by commit 5804bc88667e ("consitify do_mount() arguments").
The prototype of the !CONFIG_SECURITY version was not completely updated.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Oct_2012_16_06_58_+1100_VMP1ngXvPflB7XSc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd6VyAAoJEECxmPOUX5FEJaYP/AmcpaTH5RUWOA4b+lhqwvb2
T5FY7AWMiNKe+DeyMFewtaJWbUHvwoVvCt05uOz4PILf1tSjd9VZM2vl9NWCuvO5
viv7F1F/h5Znjf2dd0kVcNc4AGZGSQ6FGwp/GQz15MWGWeHMOipRSMi/gG0vg5gc
pzgLW8nHtj/AEA2KO8px/Pu9ZMPRA4sPMH2yPuJubwtctU5ygzzNuY4XJPuYdQVt
Uu+uJShpDe9dEQvP3SWXBAiIeW8JOhQv1cJ2I4Ul3HydqpEX6nYQwYkhkgld3VbZ
8Q2LqUIFco86iyP3Um5jc0gzhyjsbh7uTVoW+j+kw9uhwV7eoS88QKO3eXPPgrCV
UbhMLX/shQX2A/hXMNEdG2cNsRGOcAFcI97QKndvcsTTl2gSf3x/4ZxP99DIkr8h
60Yltz24BNPnJU5glOMO+jg82Vi4IZ4NqB6ecmjp9nGWaX5eh5/Ia6EAcH3mmYAe
7XPrh+8SNe7wcXujv8/wTJSY0sOpaaUoDwxo5tKkhw0kXtlGUyHTYgX3Ze0xcQH8
tCkVfy2ch8jTQL8Wjer+N/HEEfhporL0Ipqt60OaQnJm0t8q+6NNog0gurpvLw0V
4qKtQVtPYXcOPdUxgD0VfV2WdqJTgBUJ4kwIIO+zsTbFkvh4O4jcsjfde2knIYoj
y1uITUmmcSnqgpne2PLa
=cABr
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_16_06_58_+1100_VMP1ngXvPflB7XSc--
