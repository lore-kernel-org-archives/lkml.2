Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1FTWd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:33:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab1FTWd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:33:27 -0400
Date: Mon, 20 Jun 2011 18:33:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] cfq: Fix starvation of async writes in presence of heavy
 sync workload
Message-ID: <20110620223321.GA10523@redhat.com>
References: <20110620141631.GA4749@redhat.com>
 <BANLkTin9xgN0t4rn_Zf81TBdnLmJXPzNDT1fXtg3m64SnJVn5g@mail.gmail.com>
 <20110620164504.GC4749@redhat.com>
 <BANLkTik5+R3L5MQN9a4JVOL+Yt7y=72OsK0rDeAcNAJcaZKXsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik5+R3L5MQN9a4JVOL+Yt7y=72OsK0rDeAcNAJcaZKXsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 03:16:48PM -0700, Justin TerAvest wrote:

[..]
> How do we establish what's acceptable? My complaint is that it's not
> obvious what tradeoffs to make in the I/O scheduler.
> 

I think it should be driven with real workloads and some common
sense. Easily reproducible complete starvation of async requests
sounds bad enough that it needs fixing. 

> >
> >> This makes the preemption logic slightly harder to understand, and I'm
> >> concerned we'll keep making little adjustments like this to the
> >> scheduler.
> >
> > If you have other ideas for handling this, we can definitely give
> > it a try.
> 
> I haven't written out a case to prove it, but it seems like other
> preemption logic (like the cfq_rq_close() case) could also cause some
> requests to be starved indefinitely.

If we can easily reproduce this starvation may be that also needs
fixing.

> 
> I think if we want to make stronger guarantees about request
> starvation, we might have to rethink how preemption works.

What's your proposal? cpu scheduler like only class based preemption
is not going to work for the simple reason that writes come in big
sizes without any dependencies and reads can come in small sizes
one at a time because these are dependent reads.

So are you saying that write starvation is not a real problem or you
are suggesting that overall you are not happy with preemption logic
and want more changes in there.

Thanks
Vivek
