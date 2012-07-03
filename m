Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2GCDtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 23:49:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:18886 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab2GCDtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 23:49:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172777695"
Date: Tue, 3 Jul 2012 11:49:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Prasad Koya <prasad.koya@gmail.com>
Cc: jack@suse.cz, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sync blocked for long time
Message-ID: <20120703034915.GA7872@localhost>
References: <CAGXD9OfLmSHzikhXxVi7f2wHBVO4det1KHReXc70YkEgYdQTLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXD9OfLmSHzikhXxVi7f2wHBVO4det1KHReXc70YkEgYdQTLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prasad,

On Mon, Jul 02, 2012 at 08:37:19PM -0700, Prasad Koya wrote:
> Hi
> 
> Sorry about writing to your personal address. I'm running into below panic
> but I couldn't find any patch for this in 2.6.32. I do see below discussion
> related to pretty much similar issue which doesn't appear to be resolved. I
> looked around quite a bit but I couldn't find any patches for this. Is this
> still unresolved? I have 2 USB sticks and I can get into this state by
> copying 2 large files (say 200-300M each) simultaneously (followed by sync)
> into both drives.

That is doing sync lots of data on slow device, with the sync time
being further enlarged by the active writers. I can imagine for the
sync to take very long time.

What's the filesystem btw?

> Appreciate any pointers.
> 
> thank you.
> 
> http://marc.info/?t=126596633700002&r=1&w=2
> 
> 
> <3>[  600.392088] INFO: task sync:2675 blocked for more than 120 seconds.
> <3>[  600.466884] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
...
> <4>[  600.560507]  [<ffffffff810a7dab>] sync_inodes_sb+0x1d/0xf1
> <4>[  600.560519]  [<ffffffff810abb3e>] __sync_filesystem+0x29/0x52
> <4>[  600.560536]  [<ffffffff810abc0f>] sync_filesystems+0xa8/0xfe
> <4>[  600.560556]  [<ffffffff810abcb5>] sys_sync+0x1c/0x2e
> <4>[  600.560570]  [<ffffffff810260c5>] cstar_dispatch+0x7/0x2b
> <0>[  600.560580] Kernel panic - not syncing: hung_task: blocked tasks

Please check /proc/sys/kernel/hung_task_panic . Normal users should
never set it to 1..

Thanks,
Fengguang
