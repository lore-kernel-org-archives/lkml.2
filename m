Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2JPCxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:53:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59155 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2JPCx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:53:29 -0400
Date: Tue, 16 Oct 2012 13:53:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with the signal tree
Message-Id: <20121016135322.997c84c8e3128a8a1ab3ef7d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Oct_2012_13_53_22_+1100_32I9w20g7hoW2Lni"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Oct_2012_13_53_22_+1100_32I9w20g7hoW2Lni
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/arm64/kernel/sys_compat.c between commit 0fe8f08036a2 ("arm64: Use
generic sys_execve() implementation") from the signal tree and commit
"compat: generic compat_sys_sched_rr_get_interval implementation" from
the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/kernel/sys_compat.c
index d140b73,fd8ae6e..0000000
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@@ -49,21 -49,24 +49,6 @@@ asmlinkage int compat_sys_vfork(struct=20
  		       regs, 0, NULL, NULL);
  }
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
 -asmlinkage int compat_sys_execve(const char __user *filenamei,
 -				 compat_uptr_t argv, compat_uptr_t envp,
 -				 struct pt_regs *regs)
 -{
 -	int error;
 -	struct filename *filename;
 -
 -	filename =3D getname(filenamei);
 -	error =3D PTR_ERR(filename);
 -	if (IS_ERR(filename))
 -		goto out;
 -	error =3D compat_do_execve(filename->name, compat_ptr(argv),
 -					compat_ptr(envp), regs);
 -	putname(filename);
 -out:
 -	return error;
 -}
 -
  static inline void
  do_compat_cache_op(unsigned long start, unsigned long end, int flags)
  {

--Signature=_Tue__16_Oct_2012_13_53_22_+1100_32I9w20g7hoW2Lni
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQfMwiAAoJEECxmPOUX5FE5kQP/2roERhSTUIEnD7l/ohQPXXh
5tQLrw3tcZHnvYziNWXv+tYGMd/oR6ImwVymypsoRDrj3DAQhi3Eo8HD2O9QDY2Y
BLB/bw4Rz1ksd5K88o3/QHCyumQpMRM2sS4tCb6g5FbYXIgSpwAXSTnBuspPzCFl
G9glz15DiVJxEXelynmOhVJASPdQJ0XnEa32IPl8jr4vpS6VoUDVgHcLBAeJgxOp
SX1xrrzK9TY2+5xhQrK77NTM37v06fowPSelgieuK1FLvkH+A1ugm+0hBAc2/lbF
WXG0Ih1BCYlUU6WXjeHdvR03qJeZt+0uh+0YJQXzFN2e9wyTlz5Tnea2pTbX2xEn
EhOLZ/13JXtag9N9WAN4BCrHsmeXlLhjtVwwp0rD00jor0biIPZBUQnmRKr52SLf
CLkAwYFkhm28SkDt4TM6cpfye3g2aE+FNku9tSYQALMVW9TFrio0aow1kOzhrG0A
PvPgqL7tKa1XDGbtCVIW/+04UrFhRbvEneyP3VlbIBsC8JAgKLeis5z1P26v1Gtj
usbh2+hziyvN1TGTEf2mPkHDWhfJTU9vZtavOiNX4oYFHLs+S9huVZCSIh+M6EbU
BlFuck33qDpFyFuuHoKeFWOwRYJRNw7DFBVoloxgXldG69aQRUS11hBecoLjmq4C
PRIcfteDc5ZajPl3SgIG
=YxiE
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Oct_2012_13_53_22_+1100_32I9w20g7hoW2Lni--
