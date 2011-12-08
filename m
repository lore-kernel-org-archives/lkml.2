Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1LHCya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 21:54:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:20528 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab1LHCy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 21:54:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83457624"
Date: Thu, 8 Dec 2011 10:44:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] writeback: fix dirtied pages accounting on
 sub-page writes
Message-ID: <20111208024425.GA7717@localhost>
References: <20111128135338.249672012@intel.com>
 <20111128140513.275099009@intel.com>
 <20111207105340.GF4622@quack.suse.cz>
 <20111207120818.GB6549@localhost>
 <20111207160753.GJ4622@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207160753.GJ4622@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 12:07:53AM +0800, Jan Kara wrote:
> On Wed 07-12-11 20:08:18, Wu Fengguang wrote:
> > On Wed, Dec 07, 2011 at 06:53:40PM +0800, Jan Kara wrote:
> > > On Mon 28-11-11 21:53:41, Wu Fengguang wrote:
> > > > When dd in 512bytes, generic_perform_write() calls
> > > > balance_dirty_pages_ratelimited() 8 times for the same page, but
> > > > obviously the page is only dirtied once.
> > >   Actually, for ppc where pages can be 64 KB the problem is even worse.
> > 
> > Ah yes.
> > 
> > > > Fix it by accounting tsk->nr_dirtied and bdp_ratelimits at page dirty time.
> > >   I was wondering about one more thing - couldn't we rather check in
> > > generic_perform_write() whether the page was dirty before calling
> > > ->write_end and call balance_dirty_pages_ratelimited() only if it wasn't?
> > 
> > Cough.. the very original version does that exactly, then you raised
> > some concern here:
> > 
> >         https://lkml.org/lkml/2011/4/13/554
> > 
> > The discussion goes on and eventually I get to the current version
> > that looks most acceptable in the three options.
>   Good point. I should have researched web (or my memory) more closely ;)
> Thanks for the pointer - it has reminded me why using PageDirty isn't quite
> perfect.
> 
> > >   For generic_perform_write() it doesn't really matter that much since we
> > > do things page-by-page anyway but other callers could be more efficient...
> > 
> > That's right.
>   You can add:
> Acked-by: Jan Kara <jack@suse.cz>

OK, thanks!

Fengguang
