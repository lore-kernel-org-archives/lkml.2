Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2AOWY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 17:24:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab2AOWY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 17:24:26 -0500
Date: Sun, 15 Jan 2012 17:24:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com
Subject: Re: [RFC 0/3]block: An IOPS based ioscheduler
Message-ID: <20120115222420.GA3174@redhat.com>
References: <20120104065337.230911609@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104065337.230911609@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 02:53:37PM +0800, Shaohua Li wrote:
> An IOPS based I/O scheduler
> 
> Flash based storage has some different characteristics against rotate disk.
> 1. no I/O seek.
> 2. read and write I/O cost usually is much different.
> 3. Time which a request takes depends on request size.
> 4. High throughput and IOPS, low latency.
> 
> CFQ iosched does well for rotate disk, for example fair dispatching, idle
> for sequential read. It also has optimization for flash based storage (for
> item 1 above), but overall it's not designed for flash based storage. It's
> a slice based algorithm. Since flash based storage request cost is very
> low, and drive has big queue_depth is quite popular now which makes
> dispatching cost even lower, CFQ's slice accounting (jiffy based)
> doesn't work well. CFQ doesn't consider above item 2 & 3.
> 
> FIOPS (Fair IOPS) ioscheduler is trying to fix the gaps. It's IOPS based, so
> only targets for drive without I/O seek. It's quite similar like CFQ, but
> the dispatch decision is made according to IOPS instead of slice.

Hi Shaohua,

What problem are you trying to fix. If you just want to do provide
fairness in terms of IOPS instead of time, then I think existing code
should be easily modifiable instead of writing a new IO scheduler
altogether. It is just like switching the mode either based on tunable
or based on disk type. 

If slice_idle is zero, we already have some code to effectively do 
accounting in terms of IOPS. This is primarily for group level. We should
be able to extend it to queue level.

These are implementation details. I think what I am not able to understand
that what is the problem and what are you going to gain by doing
accounting in terms of IOPS.

Also, for flash based storage, isn't noop or deadline a good choice of
scheduler. Why do we want to come up with something which is CFQ like.
For this fast device any idling will kill the performance and if you
don't idle, then I think practically most of the workload will almost
become round robin kind of serving.

Thanks
Vivek
