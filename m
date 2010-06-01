Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0FAHxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:53:47 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50083 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab0FAHxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:53:46 -0400
Date: Tue, 1 Jun 2010 09:53:45 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, Divyesh Shah <dpshah@google.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
	icedove-bin/5449
Message-ID: <20100601075345.GP1660@kernel.dk>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins> <20100601064120.GA3407@elte.hu> <20100601064726.GG1660@kernel.dk> <20100601065500.GA7876@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601065500.GA7876@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01 2010, Ingo Molnar wrote:
> 
> * Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On Tue, Jun 01 2010, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Mon, 2010-05-24 at 05:03 +0200, Piotr Hosowicz wrote:
> > > > > [  720.313607] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
> > > > > [  720.313612] caller is native_sched_clock+0x3c/0x68
> > > > > [  720.313616] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
> > > > > [  720.313618] Call Trace:
> > > > > [  720.313624]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
> > > > > [  720.313629]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
> > > > > [  720.313634]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
> > > > > [  720.313637]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
> > > > > [  720.313641]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
> > > > > [  720.313646]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d 
> > > > 
> > > > This comes from wreckage in the blk tree..
> > > > 
> > > > ---
> > > > commit 9195291e5f05e01d67f9a09c756b8aca8f009089
> > > > Author: Divyesh Shah <dpshah@google.com>
> > > > Date:   Thu Apr 1 15:01:41 2010 -0700
> > > > 
> > > >     blkio: Increment the blkio cgroup stats for real now
> > > 
> > > Jens, this regression is still in .35-rc1 and triggers in about 25% of all 
> > > -tip boot tests.
> > > 
> > > The above commit is using sched_clock() in an unsafe way - please fix it or 
> > > revert it.
> > > 
> > > The local_clock() changes PeterZ is working on are still WIP, it's not sure 
> > > we'll have it before .36.
> > 
> > OK, I guess we'll have to solve this differently for .35 - I'll cook up 
> > something simple, if need be revert the change.
> 
> I suspect you can put get_cpu/put_cpu around it and use cpu_clock(). The 
> cross-CPU effects will still be there and there might be weird stats.

It'll shut it up at least, which is the primary concern at this point.

-- 
Jens Axboe

