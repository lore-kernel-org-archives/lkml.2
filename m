Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0KJQ06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:26:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:57930 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384Ab0KJQ05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:26:57 -0500
Date: Wed, 10 Nov 2010 17:26:55 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Hellwig <hch@lst.de>,
        Jan Engelhardt <jengelh@medozas.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: stop background/kupdate works from
 livelocking other works
Message-ID: <20101110162655.GA4999@quack.suse.cz>
References: <20101110023500.404859581@intel.com>
 <20101110024223.847210776@intel.com>
 <20101110035516.GA12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110035516.GA12710@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-11-10 11:55:16, Wu Fengguang wrote:
> Jan, the below comment is also updated, please double check.
  Thanks! The comment looks OK.

> >  		/*
> > +		 * Background writeout and kupdate-style writeback may
> > +		 * run forever. Stop them if there is other work to do
> > +		 * so that e.g. sync can proceed. They'll be restarted
> > +		 * after the other works are all done.
> > +		 */
> > +		if ((work->for_background || work->for_kupdate) &&
> > +		    !list_empty(&wb->bdi->work_list))
> > +			break;
> > +
> > +		/*
> >  		 * For background writeout, stop when we are below the
> >  		 * background dirty threshold
> >  		 */

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
