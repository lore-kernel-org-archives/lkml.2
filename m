Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1IEKGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 06:06:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab1IEKGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 06:06:14 -0400
Date: Mon, 5 Sep 2011 12:06:12 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <jaxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: Cleanup clearing of BDI_pending bit in
 bdi_forker_thread()
Message-ID: <20110905100612.GB5466@quack.suse.cz>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
 <1315004059-9844-2-git-send-email-jack@suse.cz>
 <20110904030442.GA16361@localhost>
 <20110904041305.GA25981@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904041305.GA25981@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 04-09-11 12:13:05, Wu Fengguang wrote:
> On Sun, Sep 04, 2011 at 11:04:42AM +0800, Wu Fengguang wrote:
> > On Sat, Sep 03, 2011 at 06:54:18AM +0800, Jan Kara wrote:
> > > bdi_forker_thread() clears BDI_pending bit at the end of the main loop.
> > > However clearing of this bit must not be done in some cases which is handled by
> > > calling 'continue' from switch statement. That's kind of unusual construct and
> > > without a good reason so change the function into more intuitive code flow.
> > > 
> > > CC: Wu Fengguang <fengguang.wu@intel.com>
> > > CC: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > It's pure code refactor.
> > 
> > Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> But I do suspect it will slightly increase the code size.
> What do you think?
  I haven't checked, maybe it will if the compiler is not clever enough to
merge two occurences of the function which is going to be inlined. But the
overhead will be really small and the code is not really performance critical
so I think clarity has priority.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
