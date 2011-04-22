Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab1DVQKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:10:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab1DVQKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:10:21 -0400
Date: Fri, 22 Apr 2011 12:10:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "hch@infradead.org" <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110422161016.GC8255@redhat.com>
References: <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110418081922.1651474a@notabene.brown>
 <4DABDC60.2090009@fusionio.com>
 <20110418172551.55629fc6@notabene.brown>
 <4DABF1EA.3070301@fusionio.com>
 <20110418183343.036f412e@notabene.brown>
 <20110418212306.GA21154@infradead.org>
 <20110422153908.GA4430@infradead.org>
 <20110422160110.GB8255@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422160110.GB8255@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 12:01:10PM -0400, Vivek Goyal wrote:
> On Fri, Apr 22, 2011 at 11:39:08AM -0400, hch@infradead.org wrote:
> > On Mon, Apr 18, 2011 at 05:23:06PM -0400, hch@infradead.org wrote:
> > > > NeilBrown (6):
> > > >       md: use new plugging interface for RAID IO.
> > > >       md/dm - remove remains of plug_fn callback.
> > > >       md - remove old plugging code.
> > > >       md: provide generic support for handling unplug callbacks.
> > > >       md: incorporate new plugging into raid5.
> > > >       md: fix up raid1/raid10 unplugging.
> > > 
> > > Looking over more of the unplugging left over, is there a reason to
> > > keep the unplug_work bits in CFQ?  They seem to rather counter the
> > > current scheme (and it is the last user of kblockd outside of
> > > blk-core.c)
> > 
> > Jens, Vivkek:
> > 
> > can you take a look at if cfq_schedule_dispatch is still needed in
> > new unplugging world order?  It's the only kblockd user outside the
> > block core that's still left, and it seems rather odd to me at least.
> 
> I guess cfq_schedule_dispatch() will still be required. One use case is
> that CFQ might not dispatch requests to driver even if it has one (idling on
> cfqq) and once the timer fires, it still need to be able to kick the queue
> and dispatch requests.
> 
> To me this sounds independent of plugging logic. Or am I missing something.

I guess you question probably was that do we still need cfqd->unplug_work
and cfq_kick_queue() and can these be replaced by delay_work mechanism.
I think would think that we should be able to. Will wirte a patch and
test it.

Thanks
Vivek
