Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2IUG0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:26:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36601 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2IUG0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:26:23 -0400
Date: Fri, 21 Sep 2012 16:26:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120921162612.8e65fef4f07680d41717981c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Sep_2012_16_26_12_+1000_YDqsx3SM1GacIeo/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Sep_2012_16_26_12_+1000_YDqsx3SM1GacIeo/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/compat_binfmt_elf.c:22:53: fatal error: asm/sigframe.h: No such file or =
directory

Caused by commit "coredump: add a new elf note with siginfo of the
signal".  That include file only exists on the x86 and tile architectures.

I have reverted that commit (and "coredump: extend core dump note section
to contain file names of mapped files" and
"coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-fil=
es-checkpatch-fixes"
that follow it) for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Sep_2012_16_26_12_+1000_YDqsx3SM1GacIeo/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQXAiEAAoJEECxmPOUX5FEtykP/3ltch8HwjAz26PeFb3hCdJP
RcoRR1PGN2YPbnml6FUuCSSeeCZC0FAmQeKU05WUhmlZbghpIflSM/QvfwvVxkUW
10peWTlHni9IE2WFBCjzSLPBc5xkRwpqkNmyrFmVdLTBO3AvW7r9MVtUL0k89e9R
rA2TaC6u4D0qB6y0cM+ORWtcJKPgEDQE8UakjvgprYWqzGhO6ASzNZHwJHNe7h8L
ZszdSCzDjeQbGXzEpUPOIzUcLNTwqO5Opg15DJnr8AFgPvrH4yRoq8uxJofFSOnj
h6wCXcK3O6tjJWU9R5k6H+EtshQib6IK4Bs17rSpVRIOTJuYcDn4AA9Yw1n2EiFY
booOV+mVXOsskWoBzH57C1AuKpZoGNUuUwtMLV1hN6YTmKizofNj2xgZigcM3/sR
ZPkmWAWvv4wxCEOyBNwHwiEK/vbOZGyaqxsqpUObacLmt0K6KcD/TZvPAdkgGNi3
pDPes/05FhYv+BRCPIs4X1lJlUv08EHpSN3DquCVUe7xVDDCRULphI0EBjHo7wJP
Mp961klEL6KEKFT/lGmyr6X8+E9hGF+Dmix4RGoGi6/Oxwar5LV7NufGuKPO145P
l77z/Kjhy057jLOIBOKL4DPNU8DxwLNADs69psYhUDesvmOzmEFQh0IbIYWuwduk
o1G2gF17L/RnEjV0uR1+
=DfAi
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Sep_2012_16_26_12_+1000_YDqsx3SM1GacIeo/--
