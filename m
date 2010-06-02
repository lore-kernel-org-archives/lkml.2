Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab0FBNFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:05:01 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56203 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936Ab0FBNFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:05:00 -0400
Date: Wed, 2 Jun 2010 15:04:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, Divyesh Shah <dpshah@google.com>
Subject: Re: blkiocg_update_io_add_stats(): INFO: trying to register
	non-static  key
Message-ID: <20100602130456.GP3564@kernel.dk>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins> <20100601064120.GA3407@elte.hu> <20100601064726.GG1660@kernel.dk> <20100601065500.GA7876@elte.hu> <20100602111653.GA25662@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602111653.GA25662@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02 2010, Ingo Molnar wrote:
> 
> btw., there's another warning triggered by the new blk-cgroups stats code:
> 
> sda:INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> Pid: 81, comm: async/2 Not tainted 2.6.35-rc1-tip-01073-gd2f7698-dirty #6765
> Call Trace:
>  [<ffffffff81065d6d>] register_lock_class+0x15f/0x365
>  [<ffffffff8105c426>] ? sched_clock_local+0x1d/0x83
>  [<ffffffff8105c557>] ? sched_clock_cpu+0xcb/0xd9
>  [<ffffffff81067184>] __lock_acquire+0x97/0x481
>  [<ffffffff810088d4>] ? native_sched_clock+0x37/0x6d
>  [<ffffffff81321b74>] ? blkiocg_update_io_add_stats+0x32/0x12e
>  [<ffffffff81067644>] lock_acquire+0xd6/0xfd
>  [<ffffffff81321b74>] ? blkiocg_update_io_add_stats+0x32/0x12e
>  [<ffffffff81850859>] _raw_spin_lock_irqsave+0x47/0x82
>  [<ffffffff81321b74>] ? blkiocg_update_io_add_stats+0x32/0x12e
>  [<ffffffff81321b74>] blkiocg_update_io_add_stats+0x32/0x12e

So that's blkg->stats_lock - help me out, what is lockdep complaining
about? The lock is initialized, what kind of lockdep annotation magic do
we need to sprinkle on it?

-- 
Jens Axboe

