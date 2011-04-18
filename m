Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1DRT7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:59:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1DRT7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:59:34 -0400
Date: Mon, 18 Apr 2011 15:59:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, jaxboe@fusionio.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add blk_run_queue_async
Message-ID: <20110418195929.GA9650@infradead.org>
References: <20110418092647.GB3837@infradead.org>
 <BANLkTikOKji3_p+bqMO4zoSnXFunEdue0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikOKji3_p+bqMO4zoSnXFunEdue0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 03:55:04PM -0400, Mike Snitzer wrote:
> > +{
> > + ? ? ? if (likely(!blk_queue_stopped(q)))
> > + ? ? ? ? ? ? ? queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
> 
> I know Jens already queued this up 'for-linus' but why not use
> kblockd_schedule_work(q, &q->delay_work)?

I don't see what that would buy us.  If we'd absolutely want a wrapper
a blk_delay_queue(q, 0) in Jens' current tree would do it now that is
has been fixed up to use the kblockd workqueue.
