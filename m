Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3ABP1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:27:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3ABP1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:27:36 -0500
Date: Wed, 2 Jan 2013 10:27:27 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: schedule_timeout: wrong timeout value fffffffffffffff0
Message-ID: <20130102152727.GA25940@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happened to a box I left running fuzz tests over the holidays.


schedule_timeout: wrong timeout value fffffffffffffff0
Pid: 6606, comm: trinity-child1 Not tainted 3.8.0-rc1+ #43
Call Trace:
 [<ffffffff81698415>] schedule_timeout+0x305/0x340
 [<ffffffff8169ae82>] ? preempt_schedule+0x42/0x60
 [<ffffffff8169cb65>] ? _raw_spin_unlock_irqrestore+0x75/0x80
 [<ffffffff810dc461>] audit_log_start+0x311/0x470
 [<ffffffff8106c62c>] ? __rcu_read_unlock+0x5c/0xa0
 [<ffffffff81086120>] ? try_to_wake_up+0x320/0x320
 [<ffffffff810e0d0b>] audit_log_exit+0x4b/0xfb0
 [<ffffffff81156e1b>] ? vm_mmap_pgoff+0x8b/0xb0
 [<ffffffff810b2342>] ? get_lock_stats+0x22/0x70
 [<ffffffff810b27ae>] ? put_lock_stats.isra.23+0xe/0x40
 [<ffffffff810b2ecb>] ? lock_release_holdtime.part.24+0xcb/0x130
 [<ffffffff81075f93>] ? up_write+0x23/0x40
 [<ffffffff81156e1b>] ? vm_mmap_pgoff+0x8b/0xb0
 [<ffffffff816a4afc>] ? sysret_signal+0x5/0x47
 [<ffffffff810e3d3f>] __audit_syscall_exit+0x25f/0x2c0
 [<ffffffff816a4bad>] sysret_audit+0x17/0x21

