Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1DRUVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab1DRUV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:21:29 -0400
Date: Mon, 18 Apr 2011 16:20:53 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: jaxboe@fusionio.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: block: add blk_run_queue_async
Message-ID: <20110418202053.GA29394@redhat.com>
References: <20110418092647.GB3837@infradead.org>
 <BANLkTikOKji3_p+bqMO4zoSnXFunEdue0g@mail.gmail.com>
 <20110418195929.GA9650@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418195929.GA9650@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18 2011 at  3:59pm -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Apr 18, 2011 at 03:55:04PM -0400, Mike Snitzer wrote:
> > > +{
> > > + ? ? ? if (likely(!blk_queue_stopped(q)))
> > > + ? ? ? ? ? ? ? queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
> > 
> > I know Jens already queued this up 'for-linus' but why not use
> > kblockd_schedule_work(q, &q->delay_work)?
> 
> I don't see what that would buy us.  If we'd absolutely want a wrapper
> a blk_delay_queue(q, 0) in Jens' current tree would do it now that is
> has been fixed up to use the kblockd workqueue.

Right, I missed 4521cc4 block: blk_delay_queue() should use kblockd
workqueue.  So why not use blk_delay_queue()?

I agree with Jens that it doesn't much matter but I also cannot see it
being a bad thing.. I'd prefer it ;)

*shrug*
