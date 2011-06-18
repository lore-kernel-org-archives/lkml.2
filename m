Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab1FRR32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:29:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:30497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab1FRR3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:29:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,386,1304319600"; 
   d="scan'208";a="17831138"
Date: Sun, 19 Jun 2011 01:29:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: WARNING: at /home/ak/lsrc/git/linux-2.6/fs/fs-writeback.c:356
Message-ID: <20110618172922.GA4652@localhost>
References: <20110616000546.GA15121@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616000546.GA15121@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed, Jun 15, 2011 at 05:05:46PM -0700, Andi Kleen wrote:
> 
> Just got this shortly after booting a fresh Linus kernel on a 16 thread
> system. I had some patches on top, but they were completely unrelated.

I cannot reproduce this warning on v3.0-rc3 as well as linux-next.

This warning message appears after upgrading from an older linus tree
to the current linus tree?

There is only one commit since 2.6.39, which looks pretty unrelated
prototype change:

        git log v2.6.39..v3.0-rc3 fs/fs-writeback.c

        commit aa38572954ade52
        fs: pass exact type of data dirties to ->dirty_inode

Looking further back, there are some locking changes between .38 and
.39, however no one has reported problems with .39.

        git shortlog v2.6.38..v2.6.39 fs/fs-writeback.c

        Dave Chinner (4):
              fs: protect inode->i_state with inode->i_lock
              fs: move i_sb_list out from under inode_lock
              fs: move i_wb_list out from under inode_lock
              fs: pull inode->i_lock up out of writeback_single_inode

        Lucas De Marchi (1):
              Fix common misspellings

Thanks,
Fengguang

> 
> ------------[ cut here ]------------
> WARNING: at /home/ak/lsrc/git/linux-2.6/fs/fs-writeback.c:356 writeback_single_inode+0x65/0x1b7()
> Modules linked in:
> Pid: 3597, comm: flush-8:0 Not tainted 3.0.0-rc3-00061-g522a899 #164
> Call Trace:
>  [<ffffffff81039919>] warn_slowpath_common+0x85/0x9d
>  [<ffffffff8103994b>] warn_slowpath_null+0x1a/0x1c
>  [<ffffffff810ff887>] writeback_single_inode+0x65/0x1b7
>  [<ffffffff810ffbe5>] writeback_sb_inodes+0xba/0x134
>  [<ffffffff81100592>] writeback_inodes_wb+0x16f/0x181
>  [<ffffffff8110080f>] wb_writeback+0x26b/0x3a7
>  [<ffffffff81100a92>] wb_do_writeback+0x147/0x1a0
>  [<ffffffff81100b77>] bdi_writeback_thread+0x8c/0x20f
>  [<ffffffff81100aeb>] ? wb_do_writeback+0x1a0/0x1a0
>  [<ffffffff81100aeb>] ? wb_do_writeback+0x1a0/0x1a0
>  [<ffffffff81053f11>] kthread+0x82/0x8a
>  [<ffffffff815e78d4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81053e8f>] ? kthread_worker_fn+0x13a/0x13a
>  [<ffffffff815e78d0>] ? gs_change+0xb/0xb
> ---[ end trace fc0a60eb73c3e138 ]---
> 
> -Andi
> 
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
