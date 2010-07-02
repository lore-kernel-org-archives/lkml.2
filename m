Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab0GBJtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:49:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab0GBJtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nxTi1i+WcOESdrTzuGNtOBNoWIhKynmLtHZwtICR0EVQK2RlLddWFHrj7yVcxgIqR8
         I3RKp7zSauKgj/DRGakX3a6H9MkIe9Nk+DOyxMQE+KAYPdHxbl2z685ZEKaXspWkhimL
         Vx1Zbc45sPjDySd9cKiKkIhudFJyOL74bzZW4=
Date: Fri, 2 Jul 2010 12:53:22 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: reiserfs locking (v2)
Message-ID: <20100702095322.GB5103@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Code with munmap produces:

[   54.152356]=20
[   54.152358] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   54.152363] [ INFO: possible circular locking dependency detected ]=20
[   54.152367] 2.6.35-rc3-dbg-git6-00502-g94feaba-dirty #65
[   54.152371] -------------------------------------------------------
[   54.152374] a.out/4044 is trying to acquire lock:                 =20
[   54.152378]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<c10f1d4e>] rei=
serfs_file_release+0x11d/0x344
[   54.152394]                  =20
[   54.152395] but task is already holding lock:
[   54.152398]  (&mm->mmap_sem){++++++}, at: [<c1091b7f>] sys_munmap+0x26/0=
x42
[   54.152408]=20
[   54.152409] which lock already depends on the new lock.
[   54.152410]=20
[   54.152413]=20
[   54.152414] the existing dependency chain (in reverse order) is:
[   54.152417]=20
[   54.152418] -> #1 (&mm->mmap_sem){++++++}:
[   54.152425]        [<c104f566>] lock_acquire+0x59/0x70
[   54.152433]        [<c108cf70>] might_fault+0x53/0x70
[   54.152439]        [<c1185418>] copy_to_user+0x30/0x48   =20
[   54.152445]        [<c10afaf9>] filldir64+0x95/0xc9
[   54.152451]        [<c10f255c>] reiserfs_readdir_dentry+0x35d/0x4d9
[   54.152457]        [<c10f26ea>] reiserfs_readdir+0x12/0x17        =20
[   54.152463]        [<c10afd17>] vfs_readdir+0x6d/0x92    =20
[   54.152468]        [<c10afe91>] sys_getdents64+0x63/0xa2 =20
[   54.152473]        [<c10027d3>] sysenter_do_call+0x12/0x32
[   54.152480]=20
[   54.152481] -> #0 (&sb->s_type->i_mutex_key#10){+.+.+.}:  =20
[   54.152488]        [<c104ef5c>] __lock_acquire+0x96d/0xbe1
[   54.152494]        [<c104f566>] lock_acquire+0x59/0x70   =20
[   54.152500]        [<c12c5674>] __mutex_lock_common+0x39/0x36b
[   54.152507]        [<c12c59e0>] mutex_lock_nested+0x12/0x15  =20
[   54.152512]        [<c10f1d4e>] reiserfs_file_release+0x11d/0x344
[   54.152518]        [<c10a5805>] fput+0xe0/0x16a
[   54.152524]        [<c1090c9e>] remove_vma+0x28/0x47
[   54.152529]        [<c1091a60>] do_munmap+0x1e8/0x200
[   54.152535]        [<c1091b8b>] sys_munmap+0x32/0x42=20
[   54.152540]        [<c10027d3>] sysenter_do_call+0x12/0x32
[   54.152546]=20
[   54.152546] other info that might help us debug this:
[   54.152548]                                         =20
[   54.152552] 1 lock held by a.out/4044:
[   54.152554]  #0:  (&mm->mmap_sem){++++++}, at: [<c1091b7f>] sys_munmap+0=
x26/0x42
[   54.152563]=20
[   54.152564] stack backtrace:
[   54.152569] Pid: 4044, comm: a.out Not tainted 2.6.35-rc3-dbg-git6-00502=
-g94feaba-dirty #65
[   54.152572] Call Trace:                 =20
[   54.152577]  [<c12c48f3>] ? printk+0xf/0x11
[   54.152583]  [<c104dc09>] print_circular_bug+0x8a/0x96
[   54.152589]  [<c104ef5c>] __lock_acquire+0x96d/0xbe1
[   54.152595]  [<c104e462>] ? mark_lock+0x26/0x1b3   =20
[   54.152601]  [<c104f566>] lock_acquire+0x59/0x70
[   54.152607]  [<c10f1d4e>] ? reiserfs_file_release+0x11d/0x344
[   54.152612]  [<c12c5674>] __mutex_lock_common+0x39/0x36b    =20
[   54.152618]  [<c10f1d4e>] ? reiserfs_file_release+0x11d/0x344
[   54.152624]  [<c12c59e0>] mutex_lock_nested+0x12/0x15       =20
[   54.152629]  [<c10f1d4e>] ? reiserfs_file_release+0x11d/0x344
[   54.152634]  [<c10f1d4e>] reiserfs_file_release+0x11d/0x344 =20
[   54.152640]  [<c108d77d>] ? free_pgd_range+0x96/0x12f
[   54.152646]  [<c10a57b5>] ? fput+0x90/0x16a
[   54.152651]  [<c10a5805>] fput+0xe0/0x16a
[   54.152656]  [<c1090c9e>] remove_vma+0x28/0x47
[   54.152661]  [<c1091811>] ? arch_unmap_area_topdown+0x0/0x18
[   54.152666]  [<c1091a60>] do_munmap+0x1e8/0x200            =20
[   54.152672]  [<c1091b8b>] sys_munmap+0x32/0x42=20
[   54.152677]  [<c10027d3>] sysenter_do_call+0x12/0x32



	Sergey

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwttxIACgkQfKHnntdSXjQiKgQA30woUy7ugKZnMgS2aPUZb3ip
VTYws9npRywPgbGJo9x80odpjWEjKDBUNExo1QSE3cPO+LFvNZ3TLcJDQ4G4z/4o
0SjFqcGMZ2GajMz2uSgyVHIMmnm1zZPjIoFMcwX5qXYdU3WdY4aXslQEhytSArzc
DZkeZTSO015+D00ibCE=
=4kE/
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
