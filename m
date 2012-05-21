Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2EUI3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:29:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34615 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2EUI3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:29:19 -0400
Date: Mon, 21 May 2012 18:29:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120521182911.219bd7779a4bfd38de625df4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_18_29_11_+1000_y8pc2McsCcfbZnH4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_18_29_11_+1000_y8pc2McsCcfbZnH4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in
arch/x86/syscalls/syscall_64.tbl and arch/x86/syscalls/syscall_32.tbl
between commit a2dae61eb839 ("sched/numa: Introduce sys_numa_{t,m}bind()")
from the tip tree and commit "syscalls, x86: add __NR_kcmp syscall"
from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/syscalls/syscall_32.tbl
index 38954c5,7a35a6e..0000000
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@@ -355,5 -355,4 +355,6 @@@
  346	i386	setns			sys_setns
  347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_rea=
dv
  348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_w=
ritev
 -349	i386	kcmp			sys_kcmp
 +349	i386	numa_mbind		sys_numa_mbind			compat_sys_numa_mbind
 +350	i386	numa_tbind		sys_numa_tbind			compat_sys_numa_tbind
++351	i386	kcmp			sys_kcmp
diff --cc arch/x86/syscalls/syscall_64.tbl
index 63c5285,f1dd014..0000000
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@@ -318,8 -318,7 +318,9 @@@
  309	common	getcpu			sys_getcpu
  310	64	process_vm_readv	sys_process_vm_readv
  311	64	process_vm_writev	sys_process_vm_writev
 -312	64	kcmp			sys_kcmp
 +312	64	numa_mbind		sys_numa_mbind
 +313	64	numa_tbind		sys_numa_tbind
++314	64	kcmp			sys_kcmp
  #
  # x32-specific system call numbers start at 512 to avoid cache impact
  # for native 64-bit operation.

--Signature=_Mon__21_May_2012_18_29_11_+1000_y8pc2McsCcfbZnH4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPufzXAAoJEECxmPOUX5FEHWYQAIE+mpTQ993374Gemg2wQ1y0
VjFOiJYEcXHRI0xyTP2SNt4KAzzJ042N/JHwrZQH+WhaqRVjgoMABETESMNRYORT
OnVvAJGB0AaSJp+LF4/HqLiQL1GTP+q24VUOcuoyuOYnfXJCAohUBXMSZ/Lo8fHR
z8I4TlAGWi2J5dnzZo0/ruopyCJ/Hw+LPVQ8DWMcsbcomJrUuFxfqHZ84taWowzu
B2mLv3kR055JITAsEYMXxn1yzzjrsmsno4V6LRzYUVwtrXxGu+y02FaHlu/0oNml
GUKSuasnRqC8BnkccmbuVO6EUm8juyYWq46QRYjt6xc+2hoExHmp5R7HjcbGlGNV
qh4snc5N8BBvXiw53NqN5NvC35vEP6p4Ap6E6ATlaB/BBGleZLzwPLDa3vWFmU2u
qIbfJeHN07gs0ryxUbtcnPzkZZi8mpX3lNl8dAfg+TuSWxMA2xHhr32C/2PGb16d
xjyJJkcMo3f54wySfuW5w1TQtNDVouvFq2uKAa8liDxsg/u1rMQjuSMhJjtP43vz
9zURslx0H6yZ+u5yPP6sswmgub5MG9Q8pHEYaTniLsXwr9TaqF1pA96zd4Q+fMX4
4zMn+q8IiE/de1XJv6T9fryDKd8lZqXtnGXmxNNnjyf/wB9CvGgmiUif7Uiurz3a
iTGWtK5KqduS9e8aS5y2
=EoYn
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_18_29_11_+1000_y8pc2McsCcfbZnH4--
