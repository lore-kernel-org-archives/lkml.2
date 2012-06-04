Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2FDDwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 23:52:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37830 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab2FDDwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 23:52:44 -0400
Date: Mon, 4 Jun 2012 13:52:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20120604135232.d9f9526135423f6c25da8f33@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Jun_2012_13_52_32_+1000_5lCVw4tRpEw6YSED"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jun_2012_13_52_32_+1000_5lCVw4tRpEw6YSED
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/syscalls/syscall_32.tbl arch/x86/syscalls/syscall_64.tbl between
commit d97b46a64674 ("syscalls, x86: add __NR_kcmp syscall") from Linus'
tree and commit a2dae61eb839 ("sched/numa: Introduce sys_numa_{t,m}bind()")
from the tip tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/syscalls/syscall_32.tbl
index 7a35a6e,38954c5..0000000
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@@ -355,4 -355,5 +355,6 @@@
  346	i386	setns			sys_setns
  347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_rea=
dv
  348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_w=
ritev
 -349	i386	numa_mbind		sys_numa_mbind			compat_sys_numa_mbind
 -350	i386	numa_tbind		sys_numa_tbind			compat_sys_numa_tbind
 +349	i386	kcmp			sys_kcmp
++350	i386	numa_mbind		sys_numa_mbind			compat_sys_numa_mbind
++351	i386	numa_tbind		sys_numa_tbind			compat_sys_numa_tbind
diff --cc arch/x86/syscalls/syscall_64.tbl
index 51171ae,63c5285..0000000
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@@ -318,8 -318,8 +318,10 @@@
  309	common	getcpu			sys_getcpu
  310	64	process_vm_readv	sys_process_vm_readv
  311	64	process_vm_writev	sys_process_vm_writev
 -312	64	numa_mbind		sys_numa_mbind
 -313	64	numa_tbind		sys_numa_tbind
 +312	64	kcmp			sys_kcmp
++313	64	numa_mbind		sys_numa_mbind
++314	64	numa_tbind		sys_numa_tbind
 +
  #
  # x32-specific system call numbers start at 512 to avoid cache impact
  # for native 64-bit operation.

--Signature=_Mon__4_Jun_2012_13_52_32_+1000_5lCVw4tRpEw6YSED
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPzDEAAAoJEECxmPOUX5FErusP/0JWprMir1Sy/Jv37fEYDtKD
dtBCygPirAT+PTjxrQhfbOP8ALNma3b8reA7pTHD0Y4A0xktMiaPeb9Nmx419/qu
GSgLYE9YweroVyAQIhkRQX7drEKMi/nUnHhnkTUi9sr+ZURxihIgyETJ5Y+PETWt
iiKfTTos/IRZRW9RHdwlprjdNZNVek9Pbie2NncOaCahM5YoaGilL3TZVDfcLTld
wkbNBxMb6rYNYZi9r8AHJbyk+ftDf7uY/Drh46xmXY0TN7fxZqaFONx3ACfFlMcX
JC52ehljyDEGSMpsvu8cuHwBnRkXE48Iso2A+Ubv3dCJbw2+GP//OcdpiDIMenF6
qN12kAqQyjKCi2M29ghhSdBPa6wi4WBTCE4oOnBxnFfiFPPz6KslIHpbqvwZkH2/
zdcz71PBOI6ZgUGEFwBTu8TNPJXxSJvhTxzawPae0tWHMSTguR9BI+RHj5juAN7Y
tuOZauonw8sQpcpaLvRFP3PxCzrUMvOoh8F0MP2upzIp9pHETTxD6zSgj21+XdF1
9A7PNnc/L7DSr5I9G+VyM1JuhZ1+xP9NYVARkO4Kqz3MzpFUsuLJdhMfxUZixXf+
kHj2L5DpfuB+LFVYsAGhivr7re+ox3FbSB9WhN/mMeQvlgkSpmvm0rPcwtJsu/2X
Ph8GTjC12CHWB9U2yaW6
=fLFv
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jun_2012_13_52_32_+1000_5lCVw4tRpEw6YSED--
