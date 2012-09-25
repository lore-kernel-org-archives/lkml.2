Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2IYBwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:52:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56480 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2IYBwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:52:14 -0400
Date: Tue, 25 Sep 2012 11:52:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the vfs tree
Message-Id: <20120925115204.f504d9841eb3aca34a1f0b8c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_11_52_04_+1000_gLsVtO=9AkSs1pAQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_11_52_04_+1000_gLsVtO=9AkSs1pAQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/events/core.c: In function 'perf_ioctl':
kernel/events/core.c:3285:17: warning: 'output.file' may be used uninitiali=
zed in this function [-Wuninitialized]
include/linux/file.h:36:5: warning: '*((void *)&output+8)' may be used unin=
itialized in this function [-Wuninitialized]
kernel/events/core.c:3281:14: note: '*((void *)&output+8)' was declared here

Introduced by commit 19ba95358327 ("switch simple cases of fget_light to
fdget").  perf_fget_light() takes the address of a struct fd * but does
not do anything with it ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_11_52_04_+1000_gLsVtO=9AkSs1pAQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYQ5EAAoJEECxmPOUX5FE6LQP/3YpHbO1az+Ne1h+lONkxlAo
nc9ZtvWJId729qBID1tyRWHfk3UM1Wq3lZ24zdzTPDB+lCywdSfcueoHjrDRaHiJ
+G+63VDSowQcSPL9NAPc9E+NnqLESA7tVJwUaxkvu15/gBA7wS226l9rysUSz2I3
NPGsT1EKhr9XoWAUidhvfGJG2sHzKLWcL/BPK6QiSxTEDz3VK3PeQzFjSNZ1lPA0
nRoSaVfg6Ze2YJTKg78J8oPXQhR5FMHi++T0R98J9PoxuO7SA84rE1w/wBp3nsYM
sN+vC+H1Ot0dMa0q48yqG7V8RVnUzPFK0UiT1bpYzQLc6XvjQveOyEmaNafSaRRx
3cOKSnZLsMsgcWG4i/NrfBQTuGvw2Ewwfxpky+rPHU6QDm1lER1cbEACzQJx6iKK
cbSQ9CG7zNpcZctfK+kAwPHPtSATEW6sEEia9sO3jfn7H/8zmKewiwxtML9NfCHg
3670rHTwaH8ZNhlH12eB53vIYNycXfumT3y0lde/1ahw7ItexqfpJxENFF35oprj
QUu2MEyvD3aiOOs4UhNtGPm/Cp+oOkArjQsOYV3LMfFjCRL69egGwU97WBdhMC2N
bRV36sSQjRtGNC8hjkQOUsCuK6y/gbgyhutjBfYamd3lfCIUdfa24JK3vUAEycYj
VOdjIhzm200ELzY4JKzN
=0o2d
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_11_52_04_+1000_gLsVtO=9AkSs1pAQ--
