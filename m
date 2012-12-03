Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab2LCTHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:07:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab2LCTHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:07:18 -0500
Date: Mon, 3 Dec 2012 11:07:15 -0800
From: Zach Brown <zab@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
Message-ID: <20121203190715.GB1377@lenny.home.zabbo.net>
References: <x49boehtipu.fsf@segfault.boston.devel.redhat.com>
 <20121130221542.GM18574@lenny.home.zabbo.net>
 <x49zk1vnnju.fsf@segfault.boston.devel.redhat.com>
 <x49vccjnm0o.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49vccjnm0o.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 11:22:31AM -0500, Jeff Moyer wrote:
> Jeff Moyer <jmoyer@redhat.com> writes:
> 
> >>> +		bdi->flusher_cpumask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
> >>> +		if (!bdi->flusher_cpumask)
> >>> +			return -ENOMEM;
> >>
> >> The bare GFP_KERNEL raises an eyebrow.  Some bdi_init() callers like
> >> blk_alloc_queue_node() look like they'll want to pass in a gfp_t for the
> >> allocation.
> >
> > I'd be surprised if that was necessary, seeing how every single caller
> > of blk_alloc_queue_node passes in GFP_KERNEL.  I'll make the change,
> > though, there aren't too many callers of bdi_init out there.
> 
> No other callers of bdi_init want anything but GFP_KERNEL.  In the case
> of blk_alloc_queue_node, even *it* doesn't honor the gfp_t passed in!
> Have a look at blkcg_init_queue (called from blk_alloc_queue_node) to
> see what I mean.  Maybe that's a bug?

Heh, indeed.

> I've written the patch to modify bdi_init to take a gfp_t, but I'm
> actually not in favor of this change, so I'm not going to post it
> (unless, of course, you can provide a compelling argument).  :-)

No argument here,  it just jumped out at me in the code.  I didn't check
out the callers or history of why it was that way :).

- z
