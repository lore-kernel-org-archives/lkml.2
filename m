Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1FJJOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:14:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab1FJJOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:14:32 -0400
Date: Fri, 10 Jun 2011 05:14:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
Message-ID: <20110610091427.GB4183@redhat.com>
References: <1307616577-6101-1-git-send-email-tm@tao.ma>
 <20110609141451.GD29913@redhat.com>
 <4DF0DD0F.8090407@tao.ma>
 <20110609153738.GF29913@redhat.com>
 <4DF0EA55.10209@tao.ma>
 <20110609182706.GG29913@redhat.com>
 <4DF1B035.7080009@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF1B035.7080009@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:48:37PM +0800, Tao Ma wrote:

[..]
> >> btw, reverting the patch doesn't work. I can still get the livelock.

What test exactly you are running. I am primarily interested in whether
you still get the hung task timeout warning where a writer is waiting on
get_request_wait() for more than 120 secods or not.

Livelock might be a different problem and for which Christoph provided
a patch for XFS.

> > 
> > Can you give following patch a try and see if it helps. On my system this
> > does allow CFQ to dispatch some writes once in a while.
> Sorry, this patch doesn't work in my test.

Can you give me backtrace of say 15 seconds each with and without patch.
I think now we must be dispatching some writes, that's a different thing
that writer still sleeps more than 120 seconds because there are  way
too many readers.

May be we need to look into show workload tree scheduling takes place and
tweak that logic a bit.

Looking at backtraces should help.

On my system with XFS filesystem I ran 32 readers and 16 buffered writers
with fio for 180 seconds. Without the patch I was getting hung task
timeout warning and with the patch I stopped getting that. I also ran
the blktrace and saw that roughly in 4 seconds we got to dispatch a write.
Which is much better than complete write starving.

So basically blktrace will help here.

Thanks
Vivek
