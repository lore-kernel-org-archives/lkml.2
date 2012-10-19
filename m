Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030421Ab2JSPsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030220Ab2JSPsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:48:13 -0400
Date: Fri, 19 Oct 2012 11:00:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Robin Dong <robin.k.dong@gmail.com>, linux-kernel@vger.kernel.org,
        Robin Dong <sanbai@taobao.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH V3] block/throttle: Add IO throttled information in
 blkio.throttle
Message-ID: <20121019150011.GE27052@redhat.com>
References: <1349765625-4020-1-git-send-email-robin.k.dong@gmail.com>
 <20121016232706.GI16166@google.com>
 <20121017134945.GC31663@redhat.com>
 <20121018232404.GW13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018232404.GW13370@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 04:24:04PM -0700, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Wed, Oct 17, 2012 at 09:49:45AM -0400, Vivek Goyal wrote:
> > Can you explain a bit more. Whe do you mean by "total number queued". I
> > think throttle.io_queued will total number of bios queued in the cgroup
> > at the time of query.
> 
> Instead of exposing the number that blk-throttle currently has
> deferred, we can expose the number of bios that have been sent to
> blk-throttle and the number of bios which left blk-throttle, both
> monotically increasing and the difference indicating the number being
> deferred.

Ok, I see it now. So we currently already maintain the number of IOs
dispatched from blk-throttle  in throttle.io_serviced. Now you are 
suggesting that maintain another counter which keeps track of total
number IOs submitted to blk-throttle, say throttle.io_submitted? I think
using throttle.io_queued will be little confusing because in CFQ we
already use blkio.io_queued to represent number of IOs currently queued
and it is not monotonically increasing value.

> That way we can stick to the usual stats facility.

So how does this help? Because it is a monotonically increasing value
we can use per cpu stats without extra locking? Or somthing else?

Thanks
Vivek
