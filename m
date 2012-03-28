Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab2C1Wkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:40:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:36984 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758638Ab2C1Wkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:40:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124520410"
Date: Thu, 29 Mar 2012 06:35:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Suresh Jayaraman <sjayaraman@suse.com>,
        Andrea Righi <andrea@betterlinux.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] buffered write IO controller in balance_dirty_pages()
Message-ID: <20120328223542.GA11065@localhost>
References: <20120328121308.568545879@intel.com>
 <20120328211017.GF3376@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328211017.GF3376@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Wed, Mar 28, 2012 at 05:10:18PM -0400, Vivek Goyal wrote:
> On Wed, Mar 28, 2012 at 08:13:08PM +0800, Fengguang Wu wrote:
> > 
> > Here is one possible solution to "buffered write IO controller", based on Linux
> > v3.3
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git  buffered-write-io-controller
> > 
> > Features:
> > - support blkio.weight
> 
> So this does proportional write bandwidth division on bdi for buffered
> writes?

Right. That is done in patch 3, costing only 3 lines in balance_dirty_pages().

> > - support blkio.throttle.buffered_write_bps
> 
> This is absolute limit systemwide or per bdi?

It's per-blkcg absolute limit. It can be extended to per-blkcg-per-bdi
limits w/o changing the basic algorithms. We only need to change interface and
vectorize the variables:
        struct percpu_counter nr_dirtied;
        unsigned long bw_time_stamp;
        unsigned long dirtied_stamp;
        unsigned long dirty_ratelimit;
        unsigned long long buffered_write_bps;
and add a "bdi" parameter to relevant functions.

> [..]
> > The test results included in the last patch look pretty good in despite of the
> > simple implementation.
> > 
> >  [PATCH 1/6] blk-cgroup: move blk-cgroup.h in include/linux/blk-cgroup.h
> >  [PATCH 2/6] blk-cgroup: account dirtied pages
> >  [PATCH 3/6] blk-cgroup: buffered write IO controller - bandwidth weight
> >  [PATCH 4/6] blk-cgroup: buffered write IO controller - bandwidth limit
> >  [PATCH 5/6] blk-cgroup: buffered write IO controller - bandwidth limit interface
> >  [PATCH 6/6] blk-cgroup: buffered write IO controller - debug trace
> > 
> 
> Hi Fengguang,
> 
> Only patch 0 and patch 4 have shown up in my mail box. Same seems to be
> the case for lkml. I am wondering what happened to rest of the patches.

Sorry I shut down my laptop before all emails are sent out.

> Will understand the patches better once I have the full set.

OK, thanks!

Fengguang
