Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1KEQyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 12:54:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48177 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1KEQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 12:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ70YRAtuPXM=8Wcc_W6_RyZsNgHMfUGBR81pBD-xhJsEYtM-Q@mail.gmail.com>
References: <CAJ70YRAtuPXM=8Wcc_W6_RyZsNgHMfUGBR81pBD-xhJsEYtM-Q@mail.gmail.com>
From: Madura Anushanga <madura.x86@gmail.com>
Date: Sat, 5 Nov 2011 22:24:17 +0530
Message-ID: <CAJ70YRBHm+3OKE_vFCUYEfNcsuWBguJeQozvAvszBg142fr_cg@mail.gmail.com>
Subject: Re: Linux dead lock on asus notebook
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm using an Asus K42Jc notebook, which freezes up randomly(after
about 5-6hrs of usage). I compiled a kernel with debugging on and got
this message on dmesg,
[  226.687892] =======================================================
[  226.687896] [ INFO: possible circular locking dependency detected ]
[  226.687899] 3.0.4-custom #4
[  226.687900] -------------------------------------------------------
[  226.687902] apt-get/2166 is trying to acquire lock:
[  226.687904]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at:
[<ffffffff8122cd26>] ext4_evict_inode+0x26/0x3a0
[  226.687916]
[  226.687917] but task is already holding lock:
[  226.687919]  (&mm->mmap_sem){++++++}, at: [<ffffffff8114c7d8>]
sys_munmap+0x48/0x80
[  226.687924]
[  226.687925] which lock already depends on the new lock.
[  226.687925]
[  226.687927]
[  226.687927] the existing dependency chain (in reverse order) is:
[  226.687929]
[  226.687929] -> #1 (&mm->mmap_sem){++++++}:
[  226.687933]        [<ffffffff810a126a>] check_prevs_add+0xfa/0x160
[  226.687939]        [<ffffffff810a18c0>] validate_chain.isra.38+0x5f0/0x720
[  226.687943]        [<ffffffff810a22c8>] __lock_acquire+0x458/0x990
[  226.687946]        [<ffffffff810a2d7f>] lock_acquire+0x9f/0x140
[  226.687949]        [<ffffffff81141fc9>] might_fault+0x89/0xb0
[  226.687954]        [<ffffffff81195ca7>] filldir+0x77/0xe0
[  226.687960]        [<ffffffff8121ff0a>] call_filldir+0x9a/0xd0
[  226.687963]        [<ffffffff812200c2>] ext4_dx_readdir+0x182/0x240
[  226.687966]        [<ffffffff81220362>] ext4_readdir+0x72/0x400
[  226.687969]        [<ffffffff81195f70>] vfs_readdir+0xb0/0xe0
[  226.687971]        [<ffffffff81196099>] sys_getdents+0x89/0x100
[  226.687974]        [<ffffffff81684a82>] system_call_fastpath+0x16/0x1b
[  226.687980]
[  226.687980] -> #0 (&sb->s_type->i_mutex_key#13){+.+.+.}:
[  226.687984]        [<ffffffff810a1168>] check_prev_add+0x6b8/0x6c0
[  226.687987]        [<ffffffff810a126a>] check_prevs_add+0xfa/0x160
[  226.687990]        [<ffffffff810a18c0>] validate_chain.isra.38+0x5f0/0x720
[  226.687993]        [<ffffffff810a22c8>] __lock_acquire+0x458/0x990
[  226.687996]        [<ffffffff810a2d7f>] lock_acquire+0x9f/0x140
[  226.687999]        [<ffffffff81679635>] mutex_lock_nested+0x55/0x330
[  226.688004]        [<ffffffff8122cd26>] ext4_evict_inode+0x26/0x3a0
[  226.688007]        [<ffffffff8119e95b>] evict+0x8b/0x170
[  226.688011]        [<ffffffff8119eb68>] iput_final+0xd8/0x1b0
[  226.688014]        [<ffffffff8119ec78>] iput+0x38/0x50
[  226.688016]        [<ffffffff811984b8>] dentry_iput+0x98/0xe0
[  226.688019]        [<ffffffff8119b61e>] dput+0x14e/0x280
[  226.688022]        [<ffffffff811836a0>] __fput+0x160/0x220
[  226.688027]        [<ffffffff81183785>] fput+0x25/0x30
[  226.688030]        [<ffffffff81149be6>] remove_vma+0x56/0xa0
[  226.688034]        [<ffffffff8114b063>] do_munmap+0x1f3/0x2f0
[  226.688037]        [<ffffffff8114c7e6>] sys_munmap+0x56/0x80
[  226.688039]        [<ffffffff81684a82>] system_call_fastpath+0x16/0x1b
[  226.688043]
[  226.688043] other info that might help us debug this:
[  226.688044]
[  226.688045]  Possible unsafe locking scenario:
[  226.688046]
[  226.688047]        CPU0                    CPU1
[  226.688048]        ----                    ----
[  226.688050]   lock(&mm->mmap_sem);
[  226.688052]                                lock(&sb->s_type->i_mutex_key);
[  226.688055]                                lock(&mm->mmap_sem);
[  226.688057]   lock(&sb->s_type->i_mutex_key);
[  226.688059]
[  226.688060]  *** DEADLOCK ***
[  226.688060]
[  226.688062] 1 lock held by apt-get/2166:
[  226.688064]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8114c7d8>]
sys_munmap+0x48/0x80
[  226.688068]
[  226.688069] stack backtrace:
[  226.688071] Pid: 2166, comm: apt-get Tainted: G         C  3.0.4-custom #4
[  226.688074] Call Trace:
[  226.688079]  [<ffffffff816619e2>] print_circular_bug+0xd3/0xe4
[  226.688082]  [<ffffffff810a1168>] check_prev_add+0x6b8/0x6c0
[  226.688085]  [<ffffffff8109dc53>] ? __bfs+0x23/0x270
[  226.688088]  [<ffffffff810a126a>] check_prevs_add+0xfa/0x160
[  226.688091]  [<ffffffff810a18c0>] validate_chain.isra.38+0x5f0/0x720
[  226.688094]  [<ffffffff810a22c8>] __lock_acquire+0x458/0x990
[  226.688097]  [<ffffffff810a2d7f>] lock_acquire+0x9f/0x140
[  226.688100]  [<ffffffff8122cd26>] ? ext4_evict_inode+0x26/0x3a0
[  226.688103]  [<ffffffff81679635>] mutex_lock_nested+0x55/0x330
[  226.688106]  [<ffffffff8122cd26>] ? ext4_evict_inode+0x26/0x3a0
[  226.688108]  [<ffffffff8119e916>] ? evict+0x46/0x170
[  226.688111]  [<ffffffff8122cd26>] ext4_evict_inode+0x26/0x3a0
[  226.688114]  [<ffffffff8119e95b>] evict+0x8b/0x170
[  226.688116]  [<ffffffff8119eb68>] iput_final+0xd8/0x1b0
[  226.688119]  [<ffffffff8119ec78>] iput+0x38/0x50
[  226.688121]  [<ffffffff811984b8>] dentry_iput+0x98/0xe0
[  226.688123]  [<ffffffff8119b61e>] dput+0x14e/0x280
[  226.688126]  [<ffffffff811836a0>] __fput+0x160/0x220
[  226.688129]  [<ffffffff81183785>] fput+0x25/0x30
[  226.688131]  [<ffffffff81149be6>] remove_vma+0x56/0xa0
[  226.688134]  [<ffffffff8114b063>] do_munmap+0x1f3/0x2f0
[  226.688137]  [<ffffffff8114c7e6>] sys_munmap+0x56/0x80
[  226.688139]  [<ffffffff81684a82>] system_call_fastpath+0x16/0x1b

This time it was apt-get and before it was another executable, this
dead lock happens after every start up for some process.
Thanks,
            - Madura A.
