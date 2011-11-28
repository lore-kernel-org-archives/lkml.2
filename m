Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1K1Nv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:51:57 -0500
Received: from mga14.intel.com ([143.182.124.37]:52623 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1K1Nv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:51:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="79781885"
Date: Mon, 28 Nov 2011 21:51:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: fix dirtied pages accounting on
 sub-page writes
Message-ID: <20111128135149.GA24975@localhost>
References: <20111121130342.211953629@intel.com>
 <20111121131215.905222115@intel.com>
 <20111122001127.GG4017@quack.suse.cz>
 <20111122092110.GB12864@localhost>
 <20111122122157.GB8058@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122122157.GB8058@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

On Tue, Nov 22, 2011 at 01:21:57PM +0100, Jan Kara wrote:
> On Tue 22-11-11 17:21:11, Wu Fengguang wrote:
> > On Tue, Nov 22, 2011 at 08:11:27AM +0800, Jan Kara wrote:
> > > On Mon 21-11-11 21:03:45, Wu Fengguang wrote:
> > > > When dd in 512bytes, generic_perform_write() calls
> > > > balance_dirty_pages_ratelimited() 8 times for the same page, but
> > > > obviously the page is only dirtied once.
> > > > 
> > > > Fix it by accounting nr_dirtied at page dirty time.
> > >   Well, but after this change, the interface balance_dirty_ratelimited_nr()
> > > is strange because the argument is only used for per-CPU ratelimiting and
> > > not for per-task ratelimiting...
> > 
> > Yeah I was vaguely aware of this... and still choose to ignore this
> > since the patchset looked already forbiddingly large at the time ;)
> > 
> > > So if you do this switch then I'd also
> > > switch bdp_ratelimits to get consistent results and a clean interface and
> > > completely kill balance_dirty_pages_ratelimited_nr().
> > 
> > Following your suggestions to change ratelimiting as well :)
> > 
> > I'll do the interface change with a standalone patch.
>   OK.

It looks worthwhile to consider a better scheme to reduce calls into
balance_dirty_pages_ratelimited_nr() before doing the interface
change. Currently that function is called on every page in
generic_perform_write().

I have no clear idea for now, so would like to delay the interface
change (after this patch).

Thanks,
Fengguang
