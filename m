Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab0J1Pdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:33:39 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58346 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab0J1Pdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:33:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: mmotm 2010-10-22 - lockdep splat in quota code
In-Reply-To: Your message of "Fri, 22 Oct 2010 16:36:58 PDT."
             <201010230008.o9N08f3E015576@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201010230008.o9N08f3E015576@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1288279966_4975P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Oct 2010 11:32:46 -0400
Message-ID: <83857.1288279966@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4CC997A3.00FE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1288279966_4975P
Content-Type: text/plain; charset=us-ascii

On Fri, 22 Oct 2010 16:36:58 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-10-22-16-36 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

I turned on quotas on some ext4 filesystems, and the next boot, shortly after
the 'quotaon -a', I got:

[   40.163251] =======================================================
[   40.163558] [ INFO: possible circular locking dependency detected ]
[   40.164019] 2.6.36-mmotm1022 #3
[   40.164019] -------------------------------------------------------
[   40.164019] dd/2915 is trying to acquire lock:
[   40.164019]  (&s->s_dquot.dqio_mutex){+.+...}, at: [<ffffffff8113fec8>] dquot_commit+0x26/0xda
[   40.164019] 
[   40.164019] but task is already holding lock:
[   40.164019]  (&s->s_dquot.dqptr_sem){++++..}, at: [<ffffffff81140c1c>] __dquot_free_space+0x66/0x16b
[   40.164019] 
[   40.164019] which lock already depends on the new lock.
[   40.164019] 
[   40.164019] 
[   40.164019] the existing dependency chain (in reverse order) is:
[   40.164019] 
[   40.164019] -> #2 (&s->s_dquot.dqptr_sem){++++..}:
[   40.164019]        [<ffffffff8106b270>] lock_acquire+0x100/0x126
[   40.164019]        [<ffffffff8156159c>] down_read+0x42/0x51
[   40.164019]        [<ffffffff81140c1c>] __dquot_free_space+0x66/0x16b
[   40.164019]        [<ffffffff81197030>] dquot_free_block+0x19/0x2a
[   40.164019]        [<ffffffff8119d499>] ext4_free_blocks+0x7eb/0x8a2
[   40.164019]        [<ffffffff811948b6>] ext4_ext_truncate+0x3af/0x853
[   40.164019]        [<ffffffff81179347>] ext4_truncate+0x98/0x51a
[   40.164019]        [<ffffffff810c452e>] vmtruncate+0x3f/0x4b
[   40.164019]        [<ffffffff8117a27c>] ext4_setattr+0x313/0x397
[   40.164019]        [<ffffffff8110be41>] notify_change+0x1a1/0x2a1
[   40.164019]        [<ffffffff810f44e6>] do_truncate+0x67/0x84
[   40.164019]        [<ffffffff81102680>] do_last+0x4c6/0x5a6
[   40.164019]        [<ffffffff811029b2>] do_filp_open+0x252/0x655
[   40.164019]        [<ffffffff810f4f61>] do_sys_open+0x60/0x101
[   40.164019]        [<ffffffff810f501d>] sys_open+0x1b/0x1d
[   40.164019]        [<ffffffff810027eb>] system_call_fastpath+0x16/0x1b
[   40.164019] 
[   40.164019] -> #1 (&ei->i_data_sem){++++..}:
[   40.164019]        [<ffffffff8106b270>] lock_acquire+0x100/0x126
[   40.164019]        [<ffffffff8156159c>] down_read+0x42/0x51
[   40.164019]        [<ffffffff8117869c>] ext4_map_blocks+0x3e/0x20e
[   40.164019]        [<ffffffff81179124>] ext4_getblk+0x71/0x19b
[   40.164019]        [<ffffffff8117925f>] ext4_bread+0x11/0x61
[   40.164019]        [<ffffffff81188778>] ext4_quota_read+0x86/0xf0
[   40.164019]        [<ffffffff81143681>] v2_read_header+0x1e/0x4f
[   40.164019]        [<ffffffff81143b2e>] v2_read_file_info+0x20/0x2ae
[   40.164019]        [<ffffffff8114292f>] vfs_load_quota_inode+0x295/0x44b
[   40.164019]        [<ffffffff81142d18>] dquot_quota_on_path+0x4c/0x55
[   40.164019]        [<ffffffff8118918d>] ext4_quota_on+0x123/0x175
[   40.164019]        [<ffffffff811452f2>] do_quotactl+0x1d1/0x465
[   40.164019]        [<ffffffff81145683>] sys_quotactl+0xfd/0x11a
[   40.164019]        [<ffffffff810027eb>] system_call_fastpath+0x16/0x1b
[   40.164019] 
[   40.164019] -> #0 (&s->s_dquot.dqio_mutex){+.+...}:
[   40.164019]        [<ffffffff8106aa5c>] __lock_acquire+0xa53/0xd55
[   40.164019]        [<ffffffff8106b270>] lock_acquire+0x100/0x126
[   40.164019]        [<ffffffff81560b46>] __mutex_lock_common+0x5d/0x56c
[   40.164019]        [<ffffffff815610fb>] mutex_lock_nested+0x34/0x39
[   40.164019]        [<ffffffff8113fec8>] dquot_commit+0x26/0xda
[   40.164019]        [<ffffffff8118ab0e>] ext4_write_dquot+0x65/0x87
[   40.164019]        [<ffffffff8118ab6e>] ext4_mark_dquot_dirty+0x3e/0x49
[   40.164019]        [<ffffffff8113fb9c>] mark_all_dquot_dirty+0x22/0x48
[   40.164019]        [<ffffffff81140cef>] __dquot_free_space+0x139/0x16b
[   40.164019]        [<ffffffff81197030>] dquot_free_block+0x19/0x2a
[   40.164019]        [<ffffffff8119d499>] ext4_free_blocks+0x7eb/0x8a2
[   40.164019]        [<ffffffff811948b6>] ext4_ext_truncate+0x3af/0x853
[   40.164019]        [<ffffffff81179347>] ext4_truncate+0x98/0x51a
[   40.164019]        [<ffffffff810c452e>] vmtruncate+0x3f/0x4b
[   40.164019]        [<ffffffff8117a27c>] ext4_setattr+0x313/0x397
[   40.164019]        [<ffffffff8110be41>] notify_change+0x1a1/0x2a1
[   40.684030]        [<ffffffff810f44e6>] do_truncate+0x67/0x84
[   40.684030]        [<ffffffff81102680>] do_last+0x4c6/0x5a6
[   40.684030]        [<ffffffff811029b2>] do_filp_open+0x252/0x655
[   40.684030]        [<ffffffff810f4f61>] do_sys_open+0x60/0x101
[   40.684030]        [<ffffffff810f501d>] sys_open+0x1b/0x1d
[   40.684030]        [<ffffffff810027eb>] system_call_fastpath+0x16/0x1b
[   40.684030] 
[   40.684030] other info that might help us debug this:
[   40.684030] 
[   40.684030] 5 locks held by dd/2915:
[   40.684030]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff810f44da>] do_truncate+0x5b/0x84
[   40.684030]  #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff8110be29>] notify_change+0x189/0x2a1
[   40.684030]  #2:  (jbd2_handle){+.+...}, at: [<ffffffff811aa8f4>] start_this_handle+0x57a/0x605
[   40.684030]  #3:  (&ei->i_data_sem){++++..}, at: [<ffffffff81194598>] ext4_ext_truncate+0x91/0x853
[   40.684030]  #4:  (&s->s_dquot.dqptr_sem){++++..}, at: [<ffffffff81140c1c>] __dquot_free_space+0x66/0x16b
[   40.684030] 
[   40.684030] stack backtrace:
[   40.684030] Pid: 2915, comm: dd Not tainted 2.6.36-mmotm1022 #3
[   40.684030] Call Trace:
[   40.684030]  [<ffffffff810693b9>] print_circular_bug+0xa8/0xb7
[   40.684030]  [<ffffffff8106aa5c>] __lock_acquire+0xa53/0xd55
[   40.684030]  [<ffffffff8113fec8>] ? dquot_commit+0x26/0xda
[   40.684030]  [<ffffffff8106b270>] lock_acquire+0x100/0x126
[   40.684030]  [<ffffffff8113fec8>] ? dquot_commit+0x26/0xda
[   40.684030]  [<ffffffff81560b46>] __mutex_lock_common+0x5d/0x56c
[   40.684030]  [<ffffffff8113fec8>] ? dquot_commit+0x26/0xda
[   40.684030]  [<ffffffff811401d9>] ? dquot_mark_dquot_dirty+0x27/0x7a
[   40.684030]  [<ffffffff8113fec8>] ? dquot_commit+0x26/0xda
[   40.684030]  [<ffffffff815610fb>] mutex_lock_nested+0x34/0x39
[   40.684030]  [<ffffffff8113fec8>] dquot_commit+0x26/0xda
[   40.684030]  [<ffffffff8118ab0e>] ext4_write_dquot+0x65/0x87
[   40.684030]  [<ffffffff8118ab6e>] ext4_mark_dquot_dirty+0x3e/0x49
[   40.684030]  [<ffffffff8113fb9c>] mark_all_dquot_dirty+0x22/0x48
[   40.684030]  [<ffffffff81140cef>] __dquot_free_space+0x139/0x16b
[   40.684030]  [<ffffffff81197030>] dquot_free_block+0x19/0x2a
[   40.684030]  [<ffffffff8119d499>] ext4_free_blocks+0x7eb/0x8a2
[   40.684030]  [<ffffffff811aad5d>] ? jbd2_journal_extend+0x5d/0xb8
[   40.684030]  [<ffffffff811948b6>] ext4_ext_truncate+0x3af/0x853
[   40.684030]  [<ffffffff810a54dd>] ? trace_preempt_on+0x15/0x28
[   40.684030]  [<ffffffff810d6416>] ? unmap_mapping_range+0x279/0x288
[   40.684030]  [<ffffffff81179347>] ext4_truncate+0x98/0x51a
[   40.684030]  [<ffffffff810d6416>] ? unmap_mapping_range+0x279/0x288
[   40.684030]  [<ffffffff8106b691>] ? trace_hardirqs_on_caller+0x117/0x13b
[   40.684030]  [<ffffffff8106b6c2>] ? trace_hardirqs_on+0xd/0xf
[   40.684030]  [<ffffffff810c452e>] vmtruncate+0x3f/0x4b
[   40.684030]  [<ffffffff8117a27c>] ext4_setattr+0x313/0x397
[   40.684030]  [<ffffffff8110be41>] notify_change+0x1a1/0x2a1
[   40.684030]  [<ffffffff810f44e6>] do_truncate+0x67/0x84
[   40.684030]  [<ffffffff810ff595>] ? get_write_access+0x49/0x50
[   40.684030]  [<ffffffff8156271c>] ? _raw_spin_unlock+0x30/0x69
[   40.684030]  [<ffffffff81565fbb>] ? sub_preempt_count+0x35/0x48
[   40.684030]  [<ffffffff811dd86a>] ? security_path_truncate+0x48/0x4d
[   40.684030]  [<ffffffff81102680>] do_last+0x4c6/0x5a6
[   40.684030]  [<ffffffff811029b2>] do_filp_open+0x252/0x655
[   40.684030]  [<ffffffff810a54dd>] ? trace_preempt_on+0x15/0x28
[   40.684030]  [<ffffffff8110d026>] ? alloc_fd+0x17c/0x18e
[   40.684030]  [<ffffffff8156271c>] ? _raw_spin_unlock+0x30/0x69
[   40.684030]  [<ffffffff81565fbb>] ? sub_preempt_count+0x35/0x48
[   40.684030]  [<ffffffff8110d026>] ? alloc_fd+0x17c/0x18e
[   40.684030]  [<ffffffff810f4f61>] do_sys_open+0x60/0x101
[   40.684030]  [<ffffffff81561f65>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   40.684030]  [<ffffffff810f501d>] sys_open+0x1b/0x1d
[   40.684030]  [<ffffffff810027eb>] system_call_fastpath+0x16/0x1b



--==_Exmh_1288279966_4975P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMyZeecC3lWbTT17ARAuaNAJoDMgUNwLSlg2UxeWr0tS7Mur3coQCfU1Hy
F/sslLJI1tGOgM++Yx7XRT8=
=cd9K
-----END PGP SIGNATURE-----

--==_Exmh_1288279966_4975P--

