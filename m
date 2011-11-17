Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab1KQJXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:23:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:29262 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab1KQJXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:23:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,525,1315206000"; 
   d="scan'208";a="76110299"
Message-ID: <4EC4D248.5070704@linux.intel.com>
Date: Thu, 17 Nov 2011 17:22:16 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH v2] pstore: pass allocated memory region back to caller
References: <20111116211329.GA8328@www.outflux.net>
In-Reply-To: <20111116211329.GA8328@www.outflux.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/11/17 5:13, Kees Cook 写道:
> The buf_lock cannot be held while populating the inodes, so make the backend
> pass forward an allocated and filled buffer instead. This solves the following
> backtrace. The effect is that "buf" is only ever used to notify the backends
> that something was written to it, and shouldn't be used in the read path.
>
> To replace the buf_lock during the read path, isolate the open/read/close
> loop with a separate mutex to maintain serialized access to the backend.
>
> [   59.691019] BUG: sleeping function called from invalid context at .../mm/slub.c:847
> [   59.691019] in_atomic(): 0, irqs_disabled(): 1, pid: 1819, name: mount
> [   59.691019] Pid: 1819, comm: mount Not tainted 3.0.8 #1
> [   59.691019] Call Trace:
> [   59.691019]  [<810252d5>] __might_sleep+0xc3/0xca
> [   59.691019]  [<810a26e6>] kmem_cache_alloc+0x32/0xf3
> [   59.691019]  [<810b53ac>] ? __d_lookup_rcu+0x6f/0xf4
> [   59.691019]  [<810b68b1>] alloc_inode+0x2a/0x64
> [   59.691019]  [<810b6903>] new_inode+0x18/0x43
> [   59.691019]  [<81142447>] pstore_get_inode.isra.1+0x11/0x98
> [   59.691019]  [<81142623>] pstore_mkfile+0xae/0x26f
> [   59.691019]  [<810a2a66>] ? kmem_cache_free+0x19/0xb1
> [   59.691019]  [<8116c821>] ? ida_get_new_above+0x140/0x158
> [   59.691019]  [<811708ea>] ? __init_rwsem+0x1e/0x2c
> [   59.691019]  [<810b67e8>] ? inode_init_always+0x111/0x1b0
> [   59.691019]  [<8102127e>] ? should_resched+0xd/0x27
> [   59.691019]  [<8137977f>] ? _cond_resched+0xd/0x21
> [   59.691019]  [<81142abf>] pstore_get_records+0x52/0xa7
> [   59.691019]  [<8114254b>] pstore_fill_super+0x7d/0x91
> [   59.691019]  [<810a7ff5>] mount_single+0x46/0x82
> [   59.691019]  [<8114231a>] pstore_mount+0x15/0x17
> [   59.691019]  [<811424ce>] ? pstore_get_inode.isra.1+0x98/0x98
> [   59.691019]  [<810a8199>] mount_fs+0x5a/0x12d
> [   59.691019]  [<810b9174>] ? alloc_vfsmnt+0xa4/0x14a
> [   59.691019]  [<810b9474>] vfs_kern_mount+0x4f/0x7d
> [   59.691019]  [<810b9d7e>] do_kern_mount+0x34/0xb2
> [   59.691019]  [<810bb15f>] do_mount+0x5fc/0x64a
> [   59.691019]  [<810912fb>] ? strndup_user+0x2e/0x3f
> [   59.691019]  [<810bb3cb>] sys_mount+0x66/0x99
> [   59.691019]  [<8137b537>] sysenter_do_call+0x12/0x26
>

Hi, Kees

Would you please tell me how do you construct such a scenario to
get above call trace?

Thx a lot!

