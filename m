Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2AKLNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:13:09 -0500
Received: from mout4.freenet.de ([195.4.92.94]:55707 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2AKLNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:13:07 -0500
From: Karsten Wiese <fzuuzf@googlemail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
Date: Wed, 11 Jan 2012 12:10:31 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.35.14-106.fc14.x86_64; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
In-Reply-To: <1324525237.5916.114.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111210.31965.fzuuzf@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 22 Dezember 2011 schrieb Steven Rostedt:
> 
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0.14-rt31 stable release.


Filed as:
https://bugzilla.redhat.com/show_bug.cgi?id=773266

Happens while shutting down from KDE on VMWare.

[ INFO: possible recursive locking detected ]
3.0.14-1.rt31.1.fc16.ccrma.x86_64.rt #1
---------------------------------------------
krunner/2402 is trying to acquire lock:
 (l3_key){+.+...}, at: [<ffffffff81133172>] ____cache_alloc+0xab/0x212
but task is already holding lock:
 (l3_key){+.+...}, at: [<ffffffff811325ae>] __cache_free+0x145/0x1e8
other info that might help us debug this:
 Possible unsafe locking scenario:
       CPU0
       ----
  lock(l3_key);
  lock(l3_key);
 *** DEADLOCK ***
 May be due to missing lock nesting notation
2 locks held by krunner/2402:
 #0:  (&per_cpu(slab_lock, __cpu).lock){+.+...}, at: [<ffffffff81131468>]
__local_lock_irq+0x26/0x79
 #1:  (l3_key){+.+...}, at: [<ffffffff811325ae>] __cache_free+0x145/0x1e8
stack backtrace:
Pid: 2402, comm: krunner Not tainted 3.0.14-1.rt31.1.fc16.ccrma.x86_64.rt #1
Call Trace:
 [<ffffffff8108e8fe>] __lock_acquire+0x917/0xcf7
 [<ffffffff814f20bd>] ? _raw_spin_unlock+0x41/0x4e
 [<ffffffff814f0d54>] ? rt_spin_lock_slowlock+0x96/0x288
 [<ffffffff8108bd5b>] ? look_up_lock_class+0x5f/0xc3
 [<ffffffff81133172>] ? ____cache_alloc+0xab/0x212
 [<ffffffff8108f1d4>] lock_acquire+0xf3/0x13e
 [<ffffffff81133172>] ? ____cache_alloc+0xab/0x212
 [<ffffffff814f157b>] rt_spin_lock+0x4f/0x56
 [<ffffffff81133172>] ? ____cache_alloc+0xab/0x212
 [<ffffffff8108e4d7>] ? __lock_acquire+0x4f0/0xcf7
 [<ffffffff81133172>] ____cache_alloc+0xab/0x212
 [<ffffffff81134351>] kmem_cache_alloc+0xbf/0x1b4
 [<ffffffff812576db>] __debug_object_init+0x61/0x2e1
 [<ffffffff8125796f>] debug_object_init+0x14/0x16
 [<ffffffff8107725c>] rcuhead_fixup_activate+0x29/0xbb
 [<ffffffff8125740e>] debug_object_fixup+0x1c/0x28
 [<ffffffff81257a57>] debug_object_activate+0xcd/0xda
 [<ffffffff81132868>] ? drain_freelist+0xfd/0xfd
 [<ffffffff810c86d9>] __call_rcu+0x4f/0x197
 [<ffffffff810c8836>] call_rcu+0x15/0x17
 [<ffffffff811321cb>] slab_destroy+0x3a/0x64
 [<ffffffff811322a8>] free_block+0xb3/0xea
 [<ffffffff81132603>] __cache_free+0x19a/0x1e8
 [<ffffffff81132110>] kmem_cache_free+0x84/0x105
 [<ffffffff8111d445>] anon_vma_free+0x48/0x4d
 [<ffffffff8111e467>] __put_anon_vma+0x38/0x3d
 [<ffffffff8111e492>] put_anon_vma+0x26/0x2b
 [<ffffffff8111e5b3>] unlink_anon_vmas+0xb9/0xed
 [<ffffffff81113c4e>] free_pgtables+0x6c/0xcb
 [<ffffffff8111a4e8>] exit_mmap+0xc7/0x100
 [<ffffffff81058516>] mmput+0x60/0xdd
 [<ffffffff8105eaab>] exit_mm+0x147/0x154
 [<ffffffff8105ed2f>] do_exit+0x277/0x876
 [<ffffffff8108f5de>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff814f1f9c>] ? _raw_spin_unlock_irqrestore+0x65/0x73
 [<ffffffff8105f5ed>] do_group_exit+0x92/0xc0
 [<ffffffff8105f632>] sys_exit_group+0x17/0x17
 [<ffffffff814f7f42>] system_call_fastpath+0x16/0x1b
