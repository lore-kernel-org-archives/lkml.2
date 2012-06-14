Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2FNBrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:47:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52467 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab2FNBrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:47:35 -0400
Date: Thu, 14 Jun 2012 11:47:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: build failure in Linus' tree
Message-Id: <20120614114722.0fd16fb906b6a5503cfbc51a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Jun_2012_11_47_22_+1000_GcgnIJp1SIw_Bh3q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Jun_2012_11_47_22_+1000_GcgnIJp1SIw_Bh3q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

While building Linus' tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/asm-generic/bug.h:5:0,
                 from arch/powerpc/include/asm/bug.h:127,
                 from arch/powerpc/kernel/head_64.S:31:
include/linux/kernel.h:44:0: warning: "ALIGN" redefined [enabled by default]
include/linux/linkage.h:57:0: note: this is the location of the previous de=
finition
include/linux/sysinfo.h: Assembler messages:
include/linux/sysinfo.h:7: Error: Unrecognized opcode: `struct'
include/linux/sysinfo.h:8: Error: Unrecognized opcode: `__kernel_long_t'

And it went downhill from there :-(

Caused by commit 3777808873b0 ("bug.h: need linux/kernel.h for
TAINT_WARN") which, unfortunately never made it into linux-next.

I have reverted that commit for today (which presumably means that sh
builds will be broken again).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__14_Jun_2012_11_47_22_+1000_GcgnIJp1SIw_Bh3q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP2UKqAAoJEECxmPOUX5FEfgQP/19m4T0/2HwE1O37rPF7PTCN
c8Y9fxNnfXXwUQXFTk38vPQOs+h0DOY+Prnd1JT4a5N08iG3qniTSik3Gn4nCq3N
cI7sE2DuXfSZguCph7CMpTevF5Ng6O0pXBZkgkhTLyoGDFoS8VLeMTs5PBxXgJjX
gaO4P61PKt9yTkTHjf2H/H+oj9sjwJfwJx8+8haObX8aCycN5FjewEHgblf/Ymkl
+x57boRXEEJNFBqXegHrb9X+ssrQSpVrpQzPh9pLnojGVITqjA0FWiCTfQiN329L
yjWBKW/CibY0cJoJSFvQJ3cRBkxrTCpo03JX0qlZ3UU1Kv7RECE9exeUn8wxTaLY
dzZ+PgKvuintBs3KQHlHgcLUqN7tMa6iT4u6N8boxs3omdh51MlPFroVCUDal+1w
HYDhjq6FWDEi7UqS3OCpujIXJA6IN4TM8lvlGr8T2m3D+GDW3MFfON+GIsL7Gwgc
e4bQD8j25RQ9Z0bwIzPCJ1PNKKH1BmTyUpPVlKR3WH0mV775YU403N51PoMCmeKr
Vfr2/DEZH80hx8jRM43YYaB9VvmzOGc5IaOEnugaZW92va0B148LMbPrXNk2uZ1U
B4shA3YpS5TIaLlWwflHRiUAOjOndWiXIG3g9gaZD8eI0P6GrG9zpDAScOowsaDk
KxgRcgz39wYLt3ljanq7
=WBwK
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Jun_2012_11_47_22_+1000_GcgnIJp1SIw_Bh3q--
