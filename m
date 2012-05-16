Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966736Ab2EPJhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:37:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50708 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966601Ab2EPJhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:37:19 -0400
Date: Wed, 16 May 2012 19:37:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: linux-next: manual merge of the akpm tree with the userns tree
Message-Id: <20120516193712.32157bcdc435465c27183baf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_19_37_12_+1000_xVn57OXaeSin6n3W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_19_37_12_+1000_xVn57OXaeSin6n3W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/signal.c between commit 54ba47edac90 ("userns: signal remove
unnecessary map_cred_ns") from the userns tree and commit "pidns: use
task_active_pid_ns in do_notify_parent" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/signal.c
index c5100ad,d9bcff9..0000000
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@@ -1668,9 -1677,9 +1667,9 @@@ bool do_notify_parent(struct task_struc
  	 * correct to rely on this
  	 */
  	rcu_read_lock();
- 	info.si_pid =3D task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+ 	info.si_pid =3D task_pid_nr_ns(tsk, task_active_pid_ns(tsk->parent));
 -	info.si_uid =3D map_cred_ns(__task_cred(tsk),
 -			task_cred_xxx(tsk->parent, user_ns));
 +	info.si_uid =3D from_kuid_munged(task_cred_xxx(tsk->parent, user_ns),
 +				       task_uid(tsk));
  	rcu_read_unlock();
 =20
  	info.si_utime =3D cputime_to_clock_t(tsk->utime + tsk->signal->utime);

--Signature=_Wed__16_May_2012_19_37_12_+1000_xVn57OXaeSin6n3W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs3VIAAoJEECxmPOUX5FEkOwP/3PCGNlx71D6SBIPCtfPp6DU
FeZshHXt57T3XF3WBZ/c1sMN5qDhoaRvGXkpgiQf/diQLzLfuqhQQd7V8Kbhc4jo
6BNo1ThuzaZHXR3+wDC+rgT+1mVklMCechFVAnprHXFbJdqkrNC/xWLg30IZNZ23
CrXkBndXDumAj6ksBzld9N/AWrnGxFez0qFX9zLZ3UKQpWul93KAs13W0rV/rw9W
5AnTFKjNRqZjkIXsjzonF5sB3KWgU8btX2KJaEMvlYlNU66thWA2KtKXyQxtc0EM
tmNeWSyg07ti2kuv6w50o5scinG1CWBkN/C8Nx4ANsmhph269IuAYcsvu3mliGc7
HlaQR3YcfOi9Hv9/U4FN9Kda7R5REK6RHmQK9pu0C9ShxASuOMniQ7LPTtJJ2Xn2
7Ybm8FtuDiEtoNGm6Zc0h4LDbnAOImwWG3ostjeGWr+/pFMyNryKtOO6pwHzB3e4
GtfntT2dKrbo6mZQoMnk0njx73WEK81Aoh95y92yuvjs22+Wrb2rwXeUR/x5Nu7U
Xh+RXBMMcafaQPOBz7g0rCNqp0VVHCG+BOag7lymoQp/p80ukFrsrxDCud1gWRYz
1Bf6lJ7msCsfUPmkxwzwduKuIMYY9s38lV1RUIlJip3oH2DarMxTmBKtnJjSoByD
LpLzXB6r0YMJAS6kWXSB
=zLVH
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_19_37_12_+1000_xVn57OXaeSin6n3W--
