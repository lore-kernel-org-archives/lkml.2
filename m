Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab1DLQzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:55:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab1DLQzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:55:00 -0400
Date: Tue, 12 Apr 2011 12:54:55 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "hch@infradead.org" <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110412165455.GB23764@infradead.org>
References: <20110411223623.4278fad1@notabene.brown>
 <4DA2F8AD.1060605@fusionio.com>
 <20110412011255.GA29236@infradead.org>
 <4DA40F0E.1070903@fusionio.com>
 <20110412122248.GC31057@dastard>
 <4DA4456F.3070301@fusionio.com>
 <20110412124134.GD31057@dastard>
 <4DA44C86.3090305@fusionio.com>
 <20110412164417.GA13890@infradead.org>
 <4DA482B1.5000005@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA482B1.5000005@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 06:49:53PM +0200, Jens Axboe wrote:
> I realize that, in fact it's already safe as long as you pass in 'true'
> for __blk_run_queue(). Before I had rewritten it to move the running
> out, so that makes the trick a little difficult. This afternoon I also
> tested it and saw no noticable difference, but I'll probably just do it
> anyway as it makes sense.

We still need the lock for __elv_add_request, so we'll need to keep the
logic anyway.  But splitting out the just queue to kblockd case from
__blk_run_queue and giving the latter a sane prototype still sounds
like a good idea to me.

Btw, now that we don't call the request_fn directly any more and thus
can't block, can the unplugging be moved into the preempt notifiers?
