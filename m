Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab0EYJr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:47:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:48893 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab0EYJrZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:47:25 -0400
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: piotr@hosowicz.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100525094347.GA7881@elte.hu>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100525094347.GA7881@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 11:47:14 +0200
Message-ID: <1274780834.5882.730.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 11:43 +0200, Ingo Molnar wrote:
> > Subject: sched_clock: Add local_clock()
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Tue May 25 10:48:51 CEST 2010
> > 
> > For people who otherwise get to write: cpu_clock(smp_processor_id()),
> > there is now: local_clock().
> 
> This doesnt fix the whole issue. cpu_clock() is local, while the measurements 
> done in the blk code are global ...
> 
> While the warning is fixed this way, the far more serious issue is still 
> there: time can go backwards if two points of time measurement are on 
> different CPUs and can mess up the statistics with negative values, etc...

cpu_clock() is synced on each tick, so the inter-cpu-drift should not
exceed 2 jiffies.

But yeah, if they want anything better, they'll have to start caring on
what cpu which timestamp got taken and use cpu_clock().
