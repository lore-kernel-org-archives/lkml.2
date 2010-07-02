Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0GBJas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:30:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62256 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab0GBJan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UA1DRJUMIa+T3JHdOFuS2lOXeBipAE/eNtKU0qYEGrOu0k5lANRKpaM1cxdtdElp5/
         x21P4m/cYOq8mlADI3CazpNslbCjrLwk6SE5Px5MgzgoiiFZRASAgolQ0dG+XtDNsICN
         H7SFj/NxwcMLmjgABYilyV1jbyosgUdHxdFO4=
Date: Fri, 2 Jul 2010 12:34:51 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: reiserfs locking (v2)
Message-ID: <20100702093451.GA3973@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I searched lkml and found the following report (titled reiserfs locking):
http://lkml.org/lkml/2010/4/15/389  (Fri, 16 Apr 2010)

I can see this backtrace while configuring emacs:

[ 6136.579013]=20
[ 6136.579015] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 6136.579021] [ INFO: possible circular locking dependency detected ]
[ 6136.579025] 2.6.35-rc3-dbg-git3-00350-g94d119f #61
[ 6136.579027] -------------------------------------------------------
[ 6136.579031] conftest/13950 is trying to acquire lock:
[ 6136.579034]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<c10f1cf6>] rei=
serfs_file_release+0x11d/0x344
[ 6136.579050]=20
[ 6136.579051] but task is already holding lock:
[ 6136.579054]  (&mm->mmap_sem){++++++}, at: [<c1091b87>] sys_munmap+0x26/0=
x42
[ 6136.579064]=20
[ 6136.579065] which lock already depends on the new lock.
[ 6136.579066]=20
[ 6136.579069]=20
[ 6136.579070] the existing dependency chain (in reverse order) is:
[ 6136.579073]=20
[ 6136.579074] -> #1 (&mm->mmap_sem){++++++}:
[ 6136.579081]        [<c104f53a>] lock_acquire+0x59/0x70
[ 6136.579089]        [<c108cf78>] might_fault+0x53/0x70
[ 6136.579094]        [<c11853b8>] copy_to_user+0x30/0x48
[ 6136.579101]        [<c10afaf9>] filldir64+0x95/0xc9
[ 6136.579106]        [<c10f2504>] reiserfs_readdir_dentry+0x35d/0x4d9
[ 6136.579112]        [<c10f2692>] reiserfs_readdir+0x12/0x17
[ 6136.579117]        [<c10afd17>] vfs_readdir+0x6d/0x92
[ 6136.579122]        [<c10afe91>] sys_getdents64+0x63/0xa2
[ 6136.579127]        [<c10027d3>] sysenter_do_call+0x12/0x32
[ 6136.579134]=20
[ 6136.579135] -> #0 (&sb->s_type->i_mutex_key#10){+.+.+.}:
[ 6136.579142]        [<c104ef30>] __lock_acquire+0x96d/0xbe1
[ 6136.579148]        [<c104f53a>] lock_acquire+0x59/0x70
[ 6136.579153]        [<c12c5614>] __mutex_lock_common+0x39/0x36b
[ 6136.579160]        [<c12c5980>] mutex_lock_nested+0x12/0x15
[ 6136.579165]        [<c10f1cf6>] reiserfs_file_release+0x11d/0x344
[ 6136.579171]        [<c10a580d>] fput+0xe0/0x16a
[ 6136.579177]        [<c1090ca6>] remove_vma+0x28/0x47
[ 6136.579182]        [<c1091a68>] do_munmap+0x1e8/0x200
[ 6136.579188]        [<c1091b93>] sys_munmap+0x32/0x42
[ 6136.579193]        [<c10027d3>] sysenter_do_call+0x12/0x32
[ 6136.579198]=20
[ 6136.579199] other info that might help us debug this:
[ 6136.579200]=20
[ 6136.579204] 1 lock held by conftest/13950:
[ 6136.579207]  #0:  (&mm->mmap_sem){++++++}, at: [<c1091b87>] sys_munmap+0=
x26/0x42
[ 6136.579216]=20
[ 6136.579217] stack backtrace:
[ 6136.579221] Pid: 13950, comm: conftest Not tainted 2.6.35-rc3-dbg-git3-0=
0350-g94d119f #61
[ 6136.579225] Call Trace:
[ 6136.579230]  [<c12c4893>] ? printk+0xf/0x11
[ 6136.579235]  [<c104dbdd>] print_circular_bug+0x8a/0x96
[ 6136.579241]  [<c104ef30>] __lock_acquire+0x96d/0xbe1
[ 6136.579247]  [<c104e436>] ? mark_lock+0x26/0x1b3
[ 6136.579254]  [<c104f53a>] lock_acquire+0x59/0x70
[ 6136.579259]  [<c10f1cf6>] ? reiserfs_file_release+0x11d/0x344
[ 6136.579265]  [<c12c5614>] __mutex_lock_common+0x39/0x36b
[ 6136.579270]  [<c10f1cf6>] ? reiserfs_file_release+0x11d/0x344
[ 6136.579276]  [<c1084375>] ? release_pages+0x55/0x116
[ 6136.579282]  [<c12c5980>] mutex_lock_nested+0x12/0x15
[ 6136.579287]  [<c10f1cf6>] ? reiserfs_file_release+0x11d/0x344
[ 6136.579293]  [<c10f1cf6>] reiserfs_file_release+0x11d/0x344
[ 6136.579299]  [<c10a57bd>] ? fput+0x90/0x16a
[ 6136.579304]  [<c10a580d>] fput+0xe0/0x16a
[ 6136.579309]  [<c1090ca6>] remove_vma+0x28/0x47
[ 6136.579314]  [<c1091819>] ? arch_unmap_area_topdown+0x0/0x18
[ 6136.579319]  [<c1091a68>] do_munmap+0x1e8/0x200
[ 6136.579325]  [<c1091b93>] sys_munmap+0x32/0x42
[ 6136.579330]  [<c10027d3>] sysenter_do_call+0x12/0x32



So, below is the simple code which produces similar result:

[  573.405720]=20
[  573.405722] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  573.405728] [ INFO: possible circular locking dependency detected ]
[  573.405732] 2.6.35-rc3-dbg-git6-00502-g94feaba-dirty #65
[  573.405735] -------------------------------------------------------
[  573.405739] a.out/7287 is trying to acquire lock:
[  573.405742]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<c10f1d4e>] rei=
serfs_file_release+0x11d/0x344
[  573.405758]=20
[  573.405759] but task is already holding lock:
[  573.405762]  (&mm->mmap_sem){++++++}, at: [<c1092937>] sys_mmap_pgoff+0x=
a4/0xe7
[  573.405772]=20
[  573.405773] which lock already depends on the new lock.
[  573.405774]=20
[  573.405777]=20
[  573.405778] the existing dependency chain (in reverse order) is:
[  573.405781]=20
[  573.405782] -> #1 (&mm->mmap_sem){++++++}:
[  573.405789]        [<c104f566>] lock_acquire+0x59/0x70
[  573.405797]        [<c108cf70>] might_fault+0x53/0x70
[  573.405803]        [<c1185418>] copy_to_user+0x30/0x48
[  573.405809]        [<c10afaf9>] filldir64+0x95/0xc9
[  573.405815]        [<c10f255c>] reiserfs_readdir_dentry+0x35d/0x4d9
[  573.405821]        [<c10f26ea>] reiserfs_readdir+0x12/0x17
[  573.405827]        [<c10afd17>] vfs_readdir+0x6d/0x92
[  573.405831]        [<c10afe91>] sys_getdents64+0x63/0xa2
[  573.405836]        [<c10027d3>] sysenter_do_call+0x12/0x32
[  573.405843]=20
[  573.405843] -> #0 (&sb->s_type->i_mutex_key#10){+.+.+.}:
[  573.405851]        [<c104ef5c>] __lock_acquire+0x96d/0xbe1
[  573.405857]        [<c104f566>] lock_acquire+0x59/0x70
[  573.405862]        [<c12c5674>] __mutex_lock_common+0x39/0x36b
[  573.405869]        [<c12c59e0>] mutex_lock_nested+0x12/0x15
[  573.405874]        [<c10f1d4e>] reiserfs_file_release+0x11d/0x344
[  573.405880]        [<c10a5805>] fput+0xe0/0x16a
[  573.405886]        [<c1090c9e>] remove_vma+0x28/0x47
[  573.405892]        [<c1091a60>] do_munmap+0x1e8/0x200
[  573.405897]        [<c109230a>] mmap_region+0x6b/0x372
[  573.405902]        [<c109284d>] do_mmap_pgoff+0x23c/0x282
[  573.405908]        [<c1092950>] sys_mmap_pgoff+0xbd/0xe7
[  573.405913]        [<c10027d3>] sysenter_do_call+0x12/0x32
[  573.405919]=20
[  573.405920] other info that might help us debug this:
[  573.405921]=20
[  573.405925] 1 lock held by a.out/7287:
[  573.405928]  #0:  (&mm->mmap_sem){++++++}, at: [<c1092937>] sys_mmap_pgo=
ff+0xa4/0xe7
[  573.405937]=20
[  573.405938] stack backtrace:
[  573.405942] Pid: 7287, comm: a.out Not tainted 2.6.35-rc3-dbg-git6-00502=
-g94feaba-dirty #65
[  573.405946] Call Trace:
[  573.405951]  [<c12c48f3>] ? printk+0xf/0x11
[  573.405957]  [<c104dc09>] print_circular_bug+0x8a/0x96
[  573.405962]  [<c104ef5c>] __lock_acquire+0x96d/0xbe1
[  573.405969]  [<c104e462>] ? mark_lock+0x26/0x1b3
[  573.405975]  [<c104f566>] lock_acquire+0x59/0x70
[  573.405980]  [<c10f1d4e>] ? reiserfs_file_release+0x11d/0x344
[  573.405986]  [<c12c5674>] __mutex_lock_common+0x39/0x36b
[  573.405991]  [<c10f1d4e>] ? reiserfs_file_release+0x11d/0x344
[  573.405997]  [<c12c59e0>] mutex_lock_nested+0x12/0x15
[  573.406003]  [<c10f1d4e>] ? reiserfs_file_release+0x11d/0x344
[  573.406008]  [<c10f1d4e>] reiserfs_file_release+0x11d/0x344
[  573.406014]  [<c10a57b5>] ? fput+0x90/0x16a
[  573.406019]  [<c10a5805>] fput+0xe0/0x16a
[  573.406024]  [<c1090c9e>] remove_vma+0x28/0x47
[  573.406030]  [<c1091811>] ? arch_unmap_area_topdown+0x0/0x18
[  573.406035]  [<c1091a60>] do_munmap+0x1e8/0x200
[  573.406040]  [<c109230a>] mmap_region+0x6b/0x372
[  573.406046]  [<c109284d>] do_mmap_pgoff+0x23c/0x282
[  573.406052]  [<c1092950>] sys_mmap_pgoff+0xbd/0xe7
[  573.406058]  [<c10027d3>] sysenter_do_call+0x12/0x32


As well as this:

[  202.300464] REISERFS error (device sda9): vs-2100 add_save_link:
search_by_key ([-1 7812832 0x1 IND]) returned 1
[  202.300473] REISERFS (device sda9): Remounting filesystem read-only
[  202.301603] ------------[ cut here ]------------
[  202.301615] WARNING: at fs/reiserfs/journal.c:3436
journal_end+0x5b/0xaf()
[  202.301619] Hardware name: F3JC               =20
[  202.301622] Modules linked in: snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_hda_codec_si3054
snd_hda_codec_realtek snd_hwdep snd_pcm_oss snd_mixer_oss asus_laptop
sparse_keymap sdhci_pci sdhci snd_hda_intel mmc_core led_class snd_hda_codec
rng_core snd_pcm snd_timer snd_page_alloc snd i2c_i801 soundcore psmouse sg
evdev serio_raw r8169 mii usbhid hid uhci_hcd ehci_hcd sr_mod usbcore cdrom
sd_mod ata_piix
[  202.301689] Pid: 5055, comm: a.out Not tainted
2.6.35-rc3-dbg-git6-00502-g94feaba-dirty #65
[  202.301693] Call Trace:
[  202.301701]  [<c102e3a2>] warn_slowpath_common+0x65/0x7a
[  202.301707]  [<c1102d95>] ? journal_end+0x5b/0xaf
[  202.301712]  [<c102e3c6>] warn_slowpath_null+0xf/0x13
[  202.301718]  [<c1102d95>] journal_end+0x5b/0xaf
[  202.301725]  [<c10eebaa>] reiserfs_truncate_file+0x19f/0x233
[  202.301733]  [<c10f1ba1>] reiserfs_vfs_truncate_file+0xd/0xf
[  202.301738]  [<c1084883>] vmtruncate+0x23/0x29
[  202.301745]  [<c10b4ad4>] inode_setattr+0x47/0x68
[  202.301751]  [<c10f1b3f>] reiserfs_setattr+0x242/0x297
[  202.301758]  [<c12c5d05>] ? down_write+0x22/0x2a
[  202.301764]  [<c10b4d6f>] notify_change+0x15c/0x26b
[  202.301770]  [<c10a35c7>] do_truncate+0x64/0x7d
[  202.301776]  [<c12c69b0>] ? _raw_spin_unlock+0x33/0x3f
[  202.301783]  [<c10ad892>] do_last+0x450/0x459
[  202.301789]  [<c10ada5b>] do_filp_open+0x1c0/0x41a
[  202.301798]  [<c1029081>] ? get_parent_ip+0xb/0x31
[  202.301804]  [<c1029123>] ? sub_preempt_count+0x7c/0x89
[  202.301810]  [<c10b5746>] ? alloc_fd+0xb4/0xbf
[  202.301816]  [<c10a3f46>] do_sys_open+0x48/0xdf
[  202.301821]  [<c10a3ffb>] sys_open+0x1e/0x26
[  202.301827]  [<c10027d3>] sysenter_do_call+0x12/0x32
[  202.301833] ---[ end trace c4e3312bdadd2dc5 ]---
[  202.301864] REISERFS warning (device sda9): clm-6006
reiserfs_dirty_inode: writing inode 7812832 on readonly FS
[  202.302011] REISERFS warning (device sda9): clm-6006
reiserfs_dirty_inode: writing inode 7812832 on readonly FS
[  202.302396] ------------[ cut here ]------------
[  202.302403] WARNING: at fs/reiserfs/journal.c:3436
journal_end+0x5b/0xaf()
[  202.302406] Hardware name: F3JC               =20
[  202.302409] Modules linked in: snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_hda_codec_si3054
snd_hda_codec_realtek snd_hwdep snd_pcm_oss snd_mixer_oss asus_laptop
sparse_keymap sdhci_pci sdhci snd_hda_intel mmc_core led_class snd_hda_codec
rng_core snd_pcm snd_timer snd_page_alloc snd i2c_i801 soundcore psmouse sg
evdev serio_raw r8169 mii usbhid hid uhci_hcd ehci_hcd sr_mod usbcore cdrom
sd_mod ata_piix
[  202.302466] Pid: 4951, comm: a.out Tainted: G        W
2.6.35-rc3-dbg-git6-00502-g94feaba-dirty #65
[  202.302470] Call Trace:
[  202.302476]  [<c102e3a2>] warn_slowpath_common+0x65/0x7a
[  202.302481]  [<c1102d95>] ? journal_end+0x5b/0xaf
[  202.302487]  [<c102e3c6>] warn_slowpath_null+0xf/0x13
[  202.302492]  [<c1102d95>] journal_end+0x5b/0xaf
[  202.302497]  [<c10fd687>] ? reiserfs_delete_object+0x29/0x60
[  202.302503]  [<c10ee1ee>] reiserfs_delete_inode+0xc4/0x100
[  202.302510]  [<c10b4265>] generic_delete_inode+0x72/0xc2
[  202.302515]  [<c10b42c6>] generic_drop_inode+0x11/0x4c
[  202.302520]  [<c10b37ff>] iput+0x49/0x4c
[  202.302525]  [<c10b165e>] dentry_iput+0x9a/0xb3
[  202.302530]  [<c10b16a4>] d_kill+0x2d/0x47
[  202.302534]  [<c10b1c94>] dput+0xdf/0xe8
[  202.302540]  [<c10a5872>] fput+0x14d/0x16a
[  202.302546]  [<c1090c9e>] remove_vma+0x28/0x47
[  202.302551]  [<c1091c29>] exit_mmap+0x8e/0xa6
[  202.302556]  [<c102c4b3>] mmput+0x24/0xab
[  202.302561]  [<c102fd83>] exit_mm+0xe8/0xf0
[  202.302567]  [<c1031295>] do_exit+0x1b7/0x5cb
[  202.302573]  [<c10434a6>] ? up_read+0x1d/0x23
[  202.302578]  [<c10318b3>] do_group_exit+0x60/0x83
[  202.302584]  [<c10318e9>] sys_exit_group+0x13/0x17
[  202.302589]  [<c10027d3>] sysenter_do_call+0x12/0x32
[  202.302594] ---[ end trace c4e3312bdadd2dc6 ]---



=3D=3D=3D=3D code =3D=3D=3D=3D

conftest.c


/*

2010, Sergey Senozhatsky. GPLv2

Description:
We have several PIDs working with conftest.mmap.
Actually this is (seems) what hapenning during emacs configure.

traced emacs configure:

vfork() ...
=3D=3D=3D=3D
=2E.. PID 5446

5446 open("conftest.mmap", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0600) =3D 3
write(3,
"g\306isQ\377J\354)\315\272\253\362\373\343F|\302T\370\33\350\347\215vZ.c3\=
237\311\232"...,=20
4096) =3D 4096
close(3)                          =3D 0
open("conftest.txt", O_RDWR|O_CREAT|O_TRUNC|O_LARGEFILE, 0600) =3D 3
write(3, "\0", 1)                 =3D 1
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) =3D 0xb78a8000
close(3)                          =3D 0
munmap(0xb78a8000, 4096)          =3D 0
open("conftest.mmap", O_RDWR|O_LARGEFILE) =3D 3
mmap2(0xb78a8000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, =20
3, 0) =3D 0xb78a8000
read(3,
"*****"...,=20
4096) =3D 4096
close(3)                          =3D 0

open(".", O_RDONLY|O_LARGEFILE)   =3D 3
close(3)                          =3D 0
fstatat64(AT_FDCWD, "conftest.mmap", {st_mode=3DS_IFREG|0600,
st_size=3D4096, ...}, AT_SYMLINK_NOFOLLOW) =3D 0
unlinkat(AT_FDCWD, "conftest.mmap", 0) =3D 0

=3D=3D=3D=3D
=2E.. PID 5449
5449  fstatat64(AT_FDCWD, "conftest.mmap", {st_mode=3DS_IFREG|0600, st_size=
=3D4096, ...}, AT_SYMLINK_NOFOLLOW) =3D 0
5449  unlinkat(AT_FDCWD, "conftest.mmap", 0) =3D 0
5449  execve("/bin/rm", ["rm", "-f", "conftest.mmap", "conftest.txt"]
=2E.
*/

/*
  The code below produces:
[   46.727489] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   46.727495] [ INFO: possible circular locking dependency detected ]
[   46.727499] 2.6.35-rc3-dbg-git5-00446-g36336bc-dirty #64
[   46.727503] -------------------------------------------------------
[   46.727506] a.out/5840 is trying to acquire lock:
[   46.727510]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<c10f1d5c>] rei=
serfs_file_release+0x12b/0x367
[   46.727526]=20
[   46.727527] but task is already holding lock:
[   46.727530]  (&mm->mmap_sem){++++++}, at: [<c1092937>] sys_mmap_pgoff+0x=
a4/0xe7
[   46.727540]=20
[   46.727541] which lock already depends on the new lock.
[   46.727543]=20
[   46.727546]=20
[   46.727546] the existing dependency chain (in reverse order) is:
[   46.727550]=20
[   46.727551] -> #1 (&mm->mmap_sem){++++++}:
[   46.727557]        [<c104f566>] lock_acquire+0x59/0x70
[   46.727565]        [<c108cf70>] might_fault+0x53/0x70
[   46.727571]        [<c1185438>] copy_to_user+0x30/0x48
[   46.727578]        [<c10afaf9>] filldir64+0x95/0xc9
[   46.727584]        [<c10f257c>] reiserfs_readdir_dentry+0x35d/0x4d9
[   46.727590]        [<c10f270a>] reiserfs_readdir+0x12/0x17
[   46.727596]        [<c10afd17>] vfs_readdir+0x6d/0x92
[   46.727600]        [<c10afe91>] sys_getdents64+0x63/0xa2
[   46.727606]        [<c10027d3>] sysenter_do_call+0x12/0x32
[   46.727612]=20
[   46.727613] -> #0 (&sb->s_type->i_mutex_key#10){+.+.+.}:
[   46.727621]        [<c104ef5c>] __lock_acquire+0x96d/0xbe1
[   46.727626]        [<c104f566>] lock_acquire+0x59/0x70
[   46.727632]        [<c12c5694>] __mutex_lock_common+0x39/0x36b
[   46.727639]        [<c12c5a00>] mutex_lock_nested+0x12/0x15
[   46.727644]        [<c10f1d5c>] reiserfs_file_release+0x12b/0x367
[   46.727650]        [<c10a5805>] fput+0xe0/0x16a
[   46.727657]        [<c1090c9e>] remove_vma+0x28/0x47
[   46.727662]        [<c1091a60>] do_munmap+0x1e8/0x200
[   46.727667]        [<c109230a>] mmap_region+0x6b/0x372
[   46.727672]        [<c109284d>] do_mmap_pgoff+0x23c/0x282
[   46.727678]        [<c1092950>] sys_mmap_pgoff+0xbd/0xe7
[   46.727683]        [<c10027d3>] sysenter_do_call+0x12/0x32
[   46.727689]=20
[   46.727690] other info that might help us debug this:
[   46.727691]=20
[   46.727695] 1 lock held by a.out/5840:
[   46.727698]  #0:  (&mm->mmap_sem){++++++}, at: [<c1092937>] sys_mmap_pgo=
ff+0xa4/0xe7
[   46.727707]=20
[   46.727708] stack backtrace:
[   46.727713] Pid: 5840, comm: a.out Not tainted 2.6.35-rc3-dbg-git5-00446=
-g36336bc-dirty #64
[   46.727717] Call Trace:
[   46.727722]  [<c12c4913>] ? printk+0xf/0x11
[   46.727728]  [<c104dc09>] print_circular_bug+0x8a/0x96
[   46.727734]  [<c104ef5c>] __lock_acquire+0x96d/0xbe1
[   46.727740]  [<c104ccc8>] ? look_up_lock_class+0x6c/0x7b
[   46.727746]  [<c104e462>] ? mark_lock+0x26/0x1b3
[   46.727752]  [<c104f566>] lock_acquire+0x59/0x70
[   46.727758]  [<c10f1d5c>] ? reiserfs_file_release+0x12b/0x367
[   46.727764]  [<c12c5694>] __mutex_lock_common+0x39/0x36b
[   46.727769]  [<c10f1d5c>] ? reiserfs_file_release+0x12b/0x367
[   46.727775]  [<c12c5a00>] mutex_lock_nested+0x12/0x15
[   46.727781]  [<c10f1d5c>] ? reiserfs_file_release+0x12b/0x367
[   46.727786]  [<c10f1d5c>] reiserfs_file_release+0x12b/0x367
[   46.727792]  [<c108d77d>] ? free_pgd_range+0x96/0x12f
[   46.727798]  [<c10a57b5>] ? fput+0x90/0x16a
[   46.727803]  [<c10a5805>] fput+0xe0/0x16a
[   46.727808]  [<c1090c9e>] remove_vma+0x28/0x47
[   46.727814]  [<c1091811>] ? arch_unmap_area_topdown+0x0/0x18
[   46.727819]  [<c1091a60>] do_munmap+0x1e8/0x200
[   46.727825]  [<c109230a>] mmap_region+0x6b/0x372
[   46.727831]  [<c109284d>] do_mmap_pgoff+0x23c/0x282
[   46.727837]  [<c1092950>] sys_mmap_pgoff+0xbd/0xe7
[   46.727842]  [<c10027d3>] sysenter_do_call+0x12/0x32

 =20
 */

#define _GNU_SOURCE

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

int main()
{
	char buf[4096];
	int i =3D 0;
	/* we don't really care */
	for (; i < 4096; i++)
		buf[i] =3D (i + 65) % 255;

	for (i =3D 0; i < 10; i++) {

		int pid =3D fork();
		if (pid > 0 ) {
			printf("parent...");
		} else if (pid =3D=3D 0) {
		=09
			printf("child...\n");
			int fd =3D open("conftest.mmap", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0=
600);
			if (fd > 0) {
				printf("OPEN ok %d\n", fd);
				if (write(fd, buf, 4096) < 0)
					printf("WRITE error\n");
				else
					printf("WRITE ok\n");
			=09
				close(fd);
			} else {
				printf("OPEN error\n");
			}
		=09
			fd =3D open("conftest.mmap", O_RDWR|O_LARGEFILE);
			if (fd > 0) {
				printf("OPEN conftest.mmap %d\n", fd);
			=09
				void *map =3D mmap((void*)0xb78a8000, 4096, PROT_READ|PROT_WRITE, MAP_P=
RIVATE|MAP_FIXED, fd, 0);
				if (map =3D=3D MAP_FAILED) {
					printf("MMAP failed\n");
					goto out;
				} else {
					printf("MMAP ok\n");
				}
			=09
				if (read(fd, buf, 4096) < 0)
					printf("READ failed\n");
				else
					printf("READ ok\n");
				close(fd);
			=09
			} else {
				printf("Error: can't open conftest.mmap\n");
			}
		=09
		out:
			fd =3D open(".", O_RDONLY|O_LARGEFILE);
			if (fd > 0) {
				printf("OPEN . ok %d... closing\n", fd);
				close(fd);
			} else {
				printf("OPEN error\n");
			}
		=09
			struct stat _stat;
			if (fstatat(AT_FDCWD, "conftest.mmap", &_stat, AT_SYMLINK_NOFOLLOW) < 0)
				printf("FSTATAT error\n");
			else
				printf("FSTATAT ok\n");
		=09
			if (unlinkat(AT_FDCWD, "conftest.mmap", 0) < 0)
				printf("UNLINKAT error\n");
			else
				printf("UNLINKAT ok\n");

		} else {
			printf("FORK error\n");
		}
	}
=09
	return 0;
}



--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwtsrsACgkQfKHnntdSXjS/XgP/RDUTYRfk/jND28ELEYJVE04K
LIWSlWMqw6HsYvsA19udbwzAgrdW5gw99YYohGCe4h6BWEePXdFJsnhu5jKM3DpP
qVovMonREkNutq3LmSUK3eOXcIvvzMQqcd4zdPlqyagP54fwQJov3B6b8ucSIM0Z
asZ5sUyTyWeakvqzgbc=
=wuEV
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
