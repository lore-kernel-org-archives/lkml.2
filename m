Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1DBLrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 07:47:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1DBLrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 07:47:17 -0400
Message-ID: <4D970CB6.3070604@redhat.com>
Date: Sat, 02 Apr 2011 19:47:02 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
CC: mingo@elte.hu
Subject: BUG: sleeping function called from invalid context at kernel/mutex.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

     I've got following warnings when I'm trying to resume from suspend, so
sparse_lock is not safe enough as a mutex for the suspend resume case, can
we simply convert sparse_lock back to spinlock?

BUG: sleeping function called from invalid context at kernel/mutex.c:278
in_atomic(): 1, irqs_disabled(): 1, pid: 2345, name: bash
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<          (null)>]           (null)
hardirqs last disabled at (0): [<ffffffff81068391>] 
copy_process+0x4d1/0x1070
softirqs last  enabled at (0): [<ffffffff81068391>] 
copy_process+0x4d1/0x1070
softirqs last disabled at (0): [<          (null)>]           (null)
Pid: 2345, comm: bash Tainted: G          I 2.6.39-rc1+ #59
Call Trace:
  [<ffffffff81052d77>] __might_sleep+0x107/0x140
  [<ffffffff816a57df>] mutex_lock_nested+0x2f/0x50
  [<ffffffff810e191a>] irq_reserve_irqs+0x4a/0xa0
  [<ffffffff810e18a8>] ? __irq_put_desc_unlock+0x28/0x50
  [<ffffffff810e4e78>] irq_set_chip+0x58/0x70
  [<ffffffff810e4fc0>] ? handle_level_irq+0xe0/0xe0
  [<ffffffff810e4eb6>] irq_set_chip_and_handler_name+0x26/0x50
  [<ffffffff8102fbb0>] arch_setup_hpet_msi+0xa0/0xf0
  [<ffffffff8103613c>] hpet_setup_msi_irq+0x1c/0x40
  [<ffffffff81036ad3>] hpet_set_mode+0x1a3/0x1f0
  [<ffffffff81036b34>] hpet_msi_set_mode+0x14/0x20
  [<ffffffff810a03aa>] clockevents_set_mode+0x2a/0x70
  [<ffffffff810a0693>] tick_resume+0x53/0xa0
  [<ffffffff810a0cbd>] tick_notify+0x1cd/0x1e0
  [<ffffffff810a00a8>] ? clockevents_notify+0x28/0x140
  [<ffffffff816ab1f4>] notifier_call_chain+0x94/0xd0
  [<ffffffff810970c6>] raw_notifier_call_chain+0x16/0x20
  [<ffffffff810a00bd>] clockevents_notify+0x3d/0x140
  [<ffffffff8109c000>] timekeeping_resume+0x190/0x1d0
  [<ffffffff813c5fd5>] syscore_resume+0x45/0xf0
  [<ffffffff810bb977>] suspend_enter+0xe7/0x120
  [<ffffffff810bba7e>] suspend_devices_and_enter+0x8e/0x2c0
  [<ffffffff810bbd86>] enter_state+0xd6/0x130
  [<ffffffff810baf99>] state_store+0x99/0x100
  [<ffffffff812c82b7>] kobj_attr_store+0x17/0x20
  [<ffffffff811fc6f3>] sysfs_write_file+0xa3/0x100
  [<ffffffff81187310>] vfs_write+0xd0/0x1a0
  [<ffffffff811874e4>] sys_write+0x54/0xa0
  [<ffffffff816af382>] system_call_fastpath+0x16/0x1b

Thanks
Xiaotian
