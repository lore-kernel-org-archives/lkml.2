Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab2FZPxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:53:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704Ab2FZPxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:53:37 -0400
Date: Tue, 26 Jun 2012 11:53:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120626155332.GJ22557@redhat.com>
References: <CAKA=qzbycm0cjLyiuKaKkD8sxDm5DvX9WVqSxN2QVT2WZOzU0Q@mail.gmail.com>
 <CAKA=qza_s6zr+wZzfFTVPSzgPQAov=K63jf-SJOTDcrnDELY5w@mail.gmail.com>
 <CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
 <20120625133047.GA9394@redhat.com>
 <CAKA=qzbXm7LaDziH=cms1W5X+cwNNRkG0LNFfWKEppr2oht6_w@mail.gmail.com>
 <20120625211850.GC10916@redhat.com>
 <CAKA=qzaU=wKLrprgJ4z32tqqyO6W0+SBcaV=ArWAdKh_9c=Zew@mail.gmail.com>
 <CAKA=qzY+J-Ab8NC-+r1Dw_-giVzC=z8SnxJhSWHF-ud8j3yg6A@mail.gmail.com>
 <20120626125953.GA22557@redhat.com>
 <CAKA=qzZ_KhRbH6F4-TWvSAWiJyDsDrz4oUO5WppoMgWNEhyZmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzZ_KhRbH6F4-TWvSAWiJyDsDrz4oUO5WppoMgWNEhyZmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 10:18:04AM -0500, Josh Hunt wrote:
> On Tue, Jun 26, 2012 at 7:59 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Jun 25, 2012 at 11:01:48PM -0500, Josh Hunt wrote:
> >
> > [..]
> >> So this really seems like a problem with kblockd not kicking in. I've
> >> instrumented every path in select_queue and it's not getting hit after
> >> schedule dispatch. Everything seems to stall at that point until a new
> >> request comes in.
> >
> > Ok, that's cool. So now we need to find out why queued work is not being
> > scheduled.
> >
> > I think there are some workqueue related trace points. If you enable those
> > along with blktraces, that should give tejun some data to look at.
> >
> > Thanks
> > Vivek
> 
> Tejun
> 
> Do you have any suggestions on how to debug this?
> 
> I did "perf record -a -e workqueue:*" and grabbed some tracepoint
> data, but it's hard to correlate when these events are occurring in
> the blktrace logs. Will keep investigating.

If you capture blktrace logs through trace_pipe and not blktrace
tool, you will get both workqueue and block traces with time stamps and
then correlating these becomes easier. So just enable "blk" tracer, enable
tracing on that particular device and then enable certaion workqueue
related trace events and capture trace_pipe output.

thanks
Vivek
