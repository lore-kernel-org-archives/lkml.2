Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab0LVTr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 14:47:29 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:53896 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0LVTr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 14:47:28 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fs@vger.kernel.org
Subject: 2.6.37-next problems with fs dcache patches.
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1293047238_7139P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Dec 2010 14:47:18 -0500
Message-ID: <19902.1293047238@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4D1255C9.0010,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1293047238_7139P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <19886.1293047227.1@localhost>

Wish I was able to bisect this down better, but a number of steps in the bisect
had to be skipped, this series is *not* bisect-clean.  Sorry I didn't do this
earlier, but I got detoured chasing the mlockall() issue which originally looked
like the culprit.

Symptoms:  My initramfs fails to mount the root filesystem, and gets
dropped down to a debug shell running off the initramfs.

Git bisect log so far:

git bisect start
# bad: [e935fc8e7828d083dde7b696ee5121cbbaadda07] Add linux-next specific files for 20101217
git bisect bad e935fc8e7828d083dde7b696ee5121cbbaadda07
# good: [e8a7e48bb248a1196484d3f8afa53bded2b24e71] Linux 2.6.37-rc4
git bisect good e8a7e48bb248a1196484d3f8afa53bded2b24e71
# bad: [e18448d78a4893a4714be343e0c8688a12a54e78] Merge remote branch 'net/master'
git bisect bad e18448d78a4893a4714be343e0c8688a12a54e78
# bad: [8698cfbb100845603f167fadb0432535122c453a] Merge branch 'quilt/kernel-doc'
git bisect bad 8698cfbb100845603f167fadb0432535122c453a
# good: [b4b604c1cd3e34a0bf03dd19e030b698a3438b05] Merge remote branch 'davinci/davinci-next'
git bisect good b4b604c1cd3e34a0bf03dd19e030b698a3438b05
# good: [752a83e8514ddc27c9767d235cb0858dec2a0266] Merge remote branch '52xx-and-virtex/next'
git bisect good 752a83e8514ddc27c9767d235cb0858dec2a0266
# good: [87fab72d587fe60a9d023e424a77a527e92781b3] Merge remote branch 'nilfs2/for-next'
git bisect good 87fab72d587fe60a9d023e424a77a527e92781b3
# bad: [493d590cb2ea1cef5a5b58bcce0f311f4c3f9efa] Merge remote branch 'pci/linux-next'
git bisect bad 493d590cb2ea1cef5a5b58bcce0f311f4c3f9efa
# bad: [68eb4446938b2ec9cb0b3e4c8e76f71940723f81] fs: dcache per-bucket dcache hash locking
git bisect bad 68eb4446938b2ec9cb0b3e4c8e76f71940723f81
# skip: [17e24aaaf2dd0fc305f19cc8c3a70dba5be3aeb7] fs: dcache avoid starvation in dcache multi-step operations
git bisect skip 17e24aaaf2dd0fc305f19cc8c3a70dba5be3aeb7
# good: [eb7fe777998ef1b46f650fe3b5a35eabb2854a82] fs: dcache reduce dput locking
git bisect good eb7fe777998ef1b46f650fe3b5a35eabb2854a82
# good: [d36c2a8e3deef473a74874a87a587807020879d8] kernel: optimise seqlock
git bisect good d36c2a8e3deef473a74874a87a587807020879d8
# skip: [27056795db2de7bfefc5ea5cbc4486ba8f3fe90d] fs: cache optimise dentry and inode for rcu-walk
git bisect skip 27056795db2de7bfefc5ea5cbc4486ba8f3fe90d
# skip: [c06020c90ab49382419e71f87ed341d28f87a166] fs: d_revalidate_rcu for rcu-walk
git bisect skip c06020c90ab49382419e71f87ed341d28f87a166
# skip: [40f9b00323a73859ac53d7d4f2f820c4c8d33165] fs: dcache remove d_mounted
git bisect skip 40f9b00323a73859ac53d7d4f2f820c4c8d33165
# bad: [0c259f9c9ee263a5d907030e29c52fd8d206c631] fs: provide rcu-walk aware permission i_ops
git bisect bad 0c259f9c9ee263a5d907030e29c52fd8d206c631
# skip: [1f42f4566770e4d7bda4be9bfc0f39a237685f54] fs: dcache reduce branches in lookup path
git bisect skip 1f42f4566770e4d7bda4be9bfc0f39a237685f54
# skip: [ff7f5c4c2c1542cd8a8c538b11441aac47d87709] fs: fs_struct use seqlock
git bisect skip ff7f5c4c2c1542cd8a8c538b11441aac47d87709
# skip: [3c884da2830985495ddbc8817871070cb6e9d86d] fs: rcu-walk for path lookup
git bisect skip 3c884da2830985495ddbc8817871070cb6e9d86d


The first 'skip' was due to a kernel that completely and totally failed immediately,
grub loaded it and *thud* it was dead, needed to hold down the power button for
5 seconds.

The later skips were all due to build failures:

  CC      security/security.o
security/security.c: In function 'security_inode_exec_permission':
security/security.c:520:6: error: 'flags' undeclared (first use in this function)
security/security.c:520:6: note: each undeclared identifier is reported only once for each function it appears in
make[1]: *** [security/security.o] Error 1

And we end with:

git bisect skip
There are only 'skip'ped commits left to test.
The first bad commit could be any of:
1f42f4566770e4d7bda4be9bfc0f39a237685f54
40f9b00323a73859ac53d7d4f2f820c4c8d33165
27056795db2de7bfefc5ea5cbc4486ba8f3fe90d
ff7f5c4c2c1542cd8a8c538b11441aac47d87709
3c884da2830985495ddbc8817871070cb6e9d86d
c06020c90ab49382419e71f87ed341d28f87a166
0c259f9c9ee263a5d907030e29c52fd8d206c631
We cannot bisect more!

Any ideas?  Patches that weren't in linux-next as of 12-17?








--==_Exmh_1293047238_7139P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNElXGcC3lWbTT17ARAk7HAKDAWbm6n2+KQcRqpO7t0Cl4iQummwCgwlLr
48zQ7rq2Qk8p+3z7kXB/WEk=
=aHyr
-----END PGP SIGNATURE-----

--==_Exmh_1293047238_7139P--

