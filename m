Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2LEXRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:17:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45873 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2LEXRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:17:12 -0500
Date: Thu, 6 Dec 2012 10:17:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the arm64 tree with Linus' tree
Message-Id: <20121206101703.6f2625b08d8e1a0640f04c40@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Dec_2012_10_17_03_+1100_lQr==KfINQH+CWL_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Dec_2012_10_17_03_+1100_lQr==KfINQH+CWL_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

Today's linux-next merge of the arm64 tree got a conflict in
arch/arm64/include/asm/unistd32.h between commit 9d73fc2d641f ("open*(2)
compat fixes (s390, arm64)") from Linus' tree and commit 18a80376ddb0
("arm64: compat for clock_adjtime(2) is miswired") from the arm64 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/include/asm/unistd32.h
index 656a6f2,e067f9d..0000000
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@@ -392,8 -392,8 +392,8 @@@ __SYSCALL(367, sys_fanotify_init
  __SYSCALL(368, compat_sys_fanotify_mark_wrapper)
  __SYSCALL(369, sys_prlimit64)
  __SYSCALL(370, sys_name_to_handle_at)
 -__SYSCALL(371, sys_open_by_handle_at)
 +__SYSCALL(371, compat_sys_open_by_handle_at)
- __SYSCALL(372, sys_clock_adjtime)
+ __SYSCALL(372, compat_sys_clock_adjtime)
  __SYSCALL(373, sys_syncfs)
 =20
  #define __NR_compat_syscalls		374

--Signature=_Thu__6_Dec_2012_10_17_03_+1100_lQr==KfINQH+CWL_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQv9XvAAoJEECxmPOUX5FECsUP/A6Gxpo9Ft9Ecq9LsHnpCaG0
i10VTh7Oe2JwbsUCa5b+85OYmmsLIpk7ZgPA8QSpzHEin3PwqifUdjJdOD3mwV2v
MtxSvPhOv8XmxHwV2oCzQqYjprcoK129R1fO4uTd22emJYSW10HXP/73VGLRRzVG
RCASp8Jhro14rEfS0icr7/lk5GZ8iinUYEwmKdjGzNouUkHTjlkqp1v8GXqN+ziV
XNy21JnEkw9huWul60f0Mgk5Y9PardTHwEVgTunoFRntpBrh+FltxOLA/SVKdtxG
jRTeFEZg4mXyqGX8aOJWVqdItBehD3NGcjplVQrEnkx8BgKfMj5c2iIVF3vUG7v5
mSRLc3eIg8Ra7nJgmhOhV7LP58Ynvkxn9v2N39sSFdswnpmLz5fs7Ff69lpuFDdm
AfzVVYsArrNDZdz/TZHRLqhwh9mIU2Bm04u2hnVgXSnZ1A6V3DKKaqki2c8WVkM/
BZ7Q1ABJvAJF1DeGcfv8xCVzBVSaVCnBm0IPo8EA/o6suplPKDgrWYJOCT1AqBkw
dA4rDteGl1WAtjAP0OabGBgVv40TcaEnB66qedHsQGObWJjB+fW+dATUD/El64cr
Ca7nIpYdXsDiXge2BFcsYf94zVErmi4J3yitEQ8fy3vIKb4fYR89AmlaPPcS/wit
zwz5EsIwoQsqzueW4PU2
=lYgA
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Dec_2012_10_17_03_+1100_lQr==KfINQH+CWL_--
