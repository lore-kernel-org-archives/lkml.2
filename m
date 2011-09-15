Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934524Ab1IOTax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934429Ab1IOTaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:30:52 -0400
Date: Thu, 15 Sep 2011 15:30:18 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Rudolf Marek <r.marek@assembler.cz>
Subject: coretemp breaks lockdep. (MAX_LOCKDEP_ENTRIES too low!)
Message-ID: <20110915193018.GA10256@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Rudolf Marek <r.marek@assembler.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just had a user report this against rc6..

# while true; do rmmod coretemp; modprobe coretemp; done


[15811.924167] BUG: MAX_LOCKDEP_ENTRIES too low!
[15811.924171] turning off the locking correctness validator.
[15811.924175] Pid: 10598, comm: modprobe Not tainted 3.1.0-rc6+ #5
[15811.924178] Call Trace:
[15811.924187]  [<ffffffff81081205>] ? up+0x39/0x3e
[15811.924193]  [<ffffffff8108e556>] add_lock_to_list.constprop.22+0x45/0xa7
[15811.924198]  [<ffffffff81090c05>] __lock_acquire+0xb7f/0xd0c
[15811.924204]  [<ffffffff81091594>] ? mark_held_locks+0x6d/0x95
[15811.924210]  [<ffffffff814e27d5>] ? __slab_alloc+0x41c/0x43d
[15811.924216]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
[15811.924221]  [<ffffffff81091295>] lock_acquire+0xf3/0x13e
[15811.924225]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
[15811.924230]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
[15811.924236]  [<ffffffff814e96a3>] _raw_spin_lock+0x40/0x73
[15811.924241]  [<ffffffff812701d0>] ? kobject_add_internal+0x9b/0x18c
[15811.924245]  [<ffffffff8127012e>] ? kobject_get+0x18/0x1f
[15811.924250]  [<ffffffff812701d0>] kobject_add_internal+0x9b/0x18c
[15811.924255]  [<ffffffff812705fa>] kobject_add+0x91/0xa2
[15811.924260]  [<ffffffff814c5afd>] ? klist_init+0x33/0x46
[15811.924265]  [<ffffffff81337bc3>] device_add+0xd5/0x576
[15811.924271]  [<ffffffff81336ac3>] ? dev_set_name+0x41/0x43
[15811.924277]  [<ffffffff8133b8f1>] platform_device_add+0x111/0x15b
[15811.924283]  [<ffffffffa0606cbd>] get_core_online+0x9b/0x143 [coretemp]
[15811.924290]  [<ffffffffa0050000>] ? 0xffffffffa004ffff
[15811.924296]  [<ffffffffa005004b>] coretemp_init+0x4b/0x1000 [coretemp]
[15811.924302]  [<ffffffffa0050000>] ? 0xffffffffa004ffff
[15811.924308]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[15811.924313]  [<ffffffffa0050000>] ? 0xffffffffa004ffff
[15811.924319]  [<ffffffff8109cacf>] sys_init_module+0x114/0x267
[15811.924324]  [<ffffffff814f0202>] system_call_fastpath+0x16/0x1b

