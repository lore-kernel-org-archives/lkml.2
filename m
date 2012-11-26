Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2KZNIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:08:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46937 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2KZNIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:08:02 -0500
Date: Tue, 27 Nov 2012 00:08:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with the signal tree
Message-Id: <20121127000800.660793d8fa6a28b79a61110b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_00_08_00_+1100_Axq8tNEjiOzk/zIi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_00_08_00_+1100_Axq8tNEjiOzk/zIi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/arm64/kernel/sys_compat.c arch/arm64/include/asm/unistd.h between
commit 8709876911bd ("arm64: sanitize copy_thread(), switch to generic
fork/vfork/clone") from the signal tree and commit "compat: generic
compat_sys_sched_rr_get_interval() implementation" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/include/asm/unistd.h
index d69aeea,1a7c88c..0000000
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@@ -24,9 -24,7 +24,10 @@@
  #define __ARCH_WANT_SYS_SIGPROCMASK
  #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
  #define __ARCH_WANT_COMPAT_SYS_SENDFILE
 +#define __ARCH_WANT_SYS_FORK
 +#define __ARCH_WANT_SYS_VFORK
+ #define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
  #endif
  #define __ARCH_WANT_SYS_EXECVE
 +#define __ARCH_WANT_SYS_CLONE
  #include <uapi/asm/unistd.h>
diff --cc arch/arm64/kernel/sys_compat.c
index f7b05ed,c34c81d..0000000
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@@ -28,21 -28,17 +28,6 @@@
  #include <asm/cacheflush.h>
  #include <asm/unistd32.h>
 =20
- asmlinkage int compat_sys_sched_rr_get_interval(compat_pid_t pid,
- 						struct compat_timespec __user *interval)
- {
- 	struct timespec t;
- 	int ret;
- 	mm_segment_t old_fs =3D get_fs();
-=20
- 	set_fs(KERNEL_DS);
- 	ret =3D sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
- 	set_fs(old_fs);
- 	if (put_compat_timespec(&t, interval))
- 		return -EFAULT;
- 	return ret;
- }
-=20
 -asmlinkage int compat_sys_fork(void)
 -{
 -	return do_fork(SIGCHLD, 0, current_pt_regs(), 0, NULL, NULL);
 -}
 -
 -asmlinkage int compat_sys_vfork(void)
 -{
 -	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 0,
 -		       current_pt_regs(), 0, NULL, NULL);
 -}
 -
  static inline void
  do_compat_cache_op(unsigned long start, unsigned long end, int flags)
  {

--Signature=_Tue__27_Nov_2012_00_08_00_+1100_Axq8tNEjiOzk/zIi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs2mwAAoJEECxmPOUX5FE21gP/RUUOr6+fm+jwe3cldJKCnjJ
BALjE2Vws3WnthYkk+XJmtr0cmtqHDNXJTWuxX0NajSlBTOdIsQOZbVxnEgnUiZ3
RZlRAoP7IfNyz4tP0eKrOm4cjUToGmfd+g7YJWM9pi8Vl5wrAfEWGAW73HpfMCQ2
CQ44A71QZcTn4UJNOx6co2R2A5Pypdwx/8kYs6F4f5wjTPwLkaeYXLMC4Y/LInf4
OOthMMawGFqvPPZVikaZmtbnD4aDgltzQltGzUj+qBudbvHYAyzX9lycSUU7Nxkc
DIk/5mrxa+epON9WyNK6MigAaeQHuhKALCmTgevwRHvxhUEBukWwC0TqqkPI+w2j
XvqEscm8jfyAhqtb6D4PW+XRjRVtpe2D0vz6j0KTu2cykkF0ToLVPa+P5L923Svo
rbZ7ygQzx5P2OBLNBi3bOw9m7xou07qzi12hBea3F93QuJQOi3imbT8Ay9/Svq73
91ejO7aBraJnNjdNFsq49bzi+aJSZNi31AjwzW+s8EZY0udVHi2nHLvhy/RFroxr
NXtaBjKcv+G8nxWcpniQgl7APNybu1Yu15Z/M4eeMXkjZr4XRr0ja2jqJLIRYFZd
TG6oge8orGOZB6KZSMA93rwPnUism+IXZ0XGSBfcwI4ePj0PcPHJG7Kr8slhaeNm
hjyRdlACg45VPKfUDkfK
=Y9AE
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_00_08_00_+1100_Axq8tNEjiOzk/zIi--
