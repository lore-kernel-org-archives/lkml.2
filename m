Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2HFDOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 23:14:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33499 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab2HFDOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 23:14:05 -0400
Date: Mon, 6 Aug 2012 13:13:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the signal tree with the rcu tree
Message-Id: <20120806131355.e3d3e892fe26b4832e752692@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Aug_2012_13_13_55_+1000_zMXOBGB6jjKkXO_3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Aug_2012_13_13_55_+1000_zMXOBGB6jjKkXO_3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/x86/kernel/signal.c between commit 1ea856be75ce ("x86: Exit RCU
extended QS on notify resume") from the rcu tree and commit 02bf6b04fcd5
("x86: switch uses of TIF_IRET to TIF_NOTIFY_RESUME, kill TIF_IRET") from
the signal tree.

Just context changes.  I have fixed it up (see below) and can carry the
fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/signal.c
index bca0ab9,16f61c4..0000000
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@@ -802,12 -797,6 +802,8 @@@ do_notify_resume(struct pt_regs *regs,=20
  	}
  	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
  		fire_user_return_notifiers();
 +
- #ifdef CONFIG_X86_32
- 	clear_thread_flag(TIF_IRET);
- #endif /* CONFIG_X86_32 */
-=20
 +	rcu_user_enter();
  }
 =20
  void signal_fault(struct pt_regs *regs, void __user *frame, char *where)

--Signature=_Mon__6_Aug_2012_13_13_55_+1000_zMXOBGB6jjKkXO_3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQHzZzAAoJEECxmPOUX5FE+kcQAIdghI9SHdntej/Xa4W91ROv
9g+hSlwMDMUHgP9cOb9nLXMpbdxPX71OEqX9p+DLYBgWVFue0kddifcQb+nuY/uT
ijld8dM3gYYDpQanNPV1ePPqy6jy2CZGlciB3eOMRxKSBuGpYKQjwA84kazG7ZAw
8w7hGkTqGMI863Hu2pzDXCyhGBy8zB2z75lmkhH7reKUp0OHNkQrlIWZEvTIkwJQ
mtzQFSY4dgwShnJQRbVc22dpIykcMQVyKS5qZSZsdhBubDvM06o2eNHwd/x1gK6a
fXE/klZyX7Ke+daLJNFlIevJsMZqHBKU+BiaPVNyI/QVMBscP2YPJZT6NTE0vD3H
UtnTPH4JRVc8R5BeGrf1/x8218g9Axp4fM2U8ULeKNPLyb04by3sYFklq+/BXyv3
zitZIVxK1ZhIaW2bcrqa8+sztSL2NuuoTAQanQCyCCU9YqyORWZLxGXZydeJJVce
V1kp8sQiHSCSGQrU/jK99zZ+tlfBkemXX9omXE3cHCAJ7C0Q5hOnGujpKryLU9I3
8nUxMzznppMiwCHbcbALGRrwLjSTMk6YG43SJao5FKrYYtK+2s7fySbf3dLg1iqm
yjGCQz/gEj0E296mDiZo+Owp/s3OCFe8DXyoXOxmZADg6AHet/z1RfPhta8rU9EX
6DP4zd4NR+IfgipKItdS
=aEoY
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Aug_2012_13_13_55_+1000_zMXOBGB6jjKkXO_3--
