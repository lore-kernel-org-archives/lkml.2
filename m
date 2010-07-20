Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab0GTWpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:45:49 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:36313 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933011Ab0GTWpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:45:47 -0400
Date: Wed, 21 Jul 2010 08:45:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: OOPS at boot time
Message-ID: <20100720224525.GO32635@dastard>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
 <20100720033656.0ce6356f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720033656.0ce6356f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 03:36:56AM -0700, Andrew Morton wrote:
> On Tue, 20 Jul 2010 16:41:45 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Al,
> > 
> > All of my PowerPC boot tests are getting this after getting to user mode
> > (sometimes several times):
> > 
> > ------------[ cut here ]------------
> > kernel BUG at fs/inode.c:1244!
> > Oops: Exception in kernel mode, sig: 5 [#1]
> > SMP NR_CPUS=128 NUMA pSeries
> > last sysfs file: /sys/kernel/uevent_seqnum
> > Modules linked in: ehea xt_tcpudp iptable_filter ip_tables nfnetlink nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT x_tables dm_mirror dm_region_hash dm_log dm_zero dm_snapshot parport_pc parport dm_multipath autofs4
> > NIP: c000000000168074 LR: c000000000168064 CTR: 0000000000000000
> > REGS: c0000000063d39f0 TRAP: 0700   Not tainted  (2.6.35-rc5-autokern1)
> > MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 22008422  XER: 20000001
> > TASK = c000000003a25840[4995] 'rm' THREAD: c0000000063d0000 CPU: 2
> > GPR00: 0000000000000001 c0000000063d3c70 c000000000bfdea0 c0000000015f2090 
> > GPR04: 0000000000000003 0000000000000001 c0000000063d3bd0 c000000000c5a388 
> > GPR08: 80c0000000000000 0000000000000006 6000000000000000 8000000000000000 
> > GPR12: c0000000056c0598 c0000000074d6400 0000000003100000 0000000000779b68 
> > GPR16: 00000000007782f0 0000000010018875 00000000ff9c74b8 0000000000000000 
> > GPR20: 0000000000000000 0000000000000000 0000000010010000 0000000010010000 
> > GPR24: 0000000000000001 00000000fffba994 0000000000000002 000000001001a038 
> > GPR28: c000000006617800 c000000000aefd40 c000000000b586b8 c0000000056c0748 
> > NIP [c000000000168074] .iput+0x288/0x2d0
> > LR [c000000000168064] .iput+0x278/0x2d0
> > Call Trace:
> > [c0000000063d3c70] [c000000000168064] .iput+0x278/0x2d0 (unreliable)
> > [c0000000063d3d00] [c00000000015e964] .do_unlinkat+0x124/0x1b8
> > [c0000000063d3e30] [c000000000008554] syscall_exit+0x0/0x40
> > Instruction dump:
> > 38000000 f81f0008 f81f0000 e87e8090 48457d8d 60000000 7fe3fb78 4bfff339 
> > e81f03b0 68000060 3120ffff 7c090110 <0b000000> 38210090 7fe3fb78 e8010010 
> > ---[ end trace 9ace9d3884bc0aac ]---
> > Trace/breakpoint trap
> > ------------[ cut here ]------------
> > 
> > This is:
> > 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
> > in iput_final().
> > 
> > That BUG_ON was added by commit c0ae81f2 ("Make ->drop_inode() just
> > return whether inode needs to be dropped").
> > 
> > Has anyone seen this or something similar?
> 
> I get it all the time.  See the thread "Subject: Re: linux-next: Tree for
> July 7".

Yet nobody else seems to be able to reproduce it. Given that powerPC
is good at triggering reace conditions, maybe there is one that
only you are unlucky eough to trigger.

Rather than just commenting out the BUG_ON() and ignoring the
problem, can you print out the inode state (and enough information
to identify the filesystem the inode belongs to) before triggering
the BUG_ON() so we can get some idea of how this is triggering?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
