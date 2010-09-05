Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0IEORh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 10:17:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:29007 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0IEORg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 10:17:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,321,1280732400"; 
   d="scan'208";a="321079465"
Date: Sun, 5 Sep 2010 22:17:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Rubin <mrubin@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 3/4] writeback: nr_dirtied and nr_cleaned in
 /proc/vmstat
Message-ID: <20100905141715.GA9024@localhost>
References: <1282963227-31867-1-git-send-email-mrubin@google.com>
 <1282963227-31867-4-git-send-email-mrubin@google.com>
 <20100828235029.GA7071@localhost>
 <AANLkTi=KjbfqzZsD6MOQG+4i7vHj6ZEh1_nF7DpwqeLV@mail.gmail.com>
 <20100831074825.GA19358@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831074825.GA19358@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 03:48:25PM +0800, Wu Fengguang wrote:
> > > The output format is quite different from /proc/vmstat.
> > > Do we really need to "Node X", ":" and "times" decorations?
> > 
> > Node X is based on the meminfo file but I agree it's redundant information.
> 
> Thanks. In the same directory you can find a different style example
> /sys/devices/system/node/node0/numastat :) If ever the file was named
> vmstat! In the other hand, shall we put the numbers there? I'm confused..

With wider use of NUMA, I'm expecting more interests to put
/proc/vmstat items into /sys/devices/system/node/node0/.

What shall we do then? There are several possible options:
- just put the /proc/vmstat items into nodeX/numastat
- create nodeX/vmstat and make numastat a symlink to vmstat
- create nodeX/vmstat and remove numastat in future

Any suggestions?

> > > And the "_PAGES" in NR_FILE_PAGES_DIRTIED looks redundant to
> > > the "_page" in node_page_state(). It's a bit long to be a pleasant
> > > name. NR_FILE_DIRTIED/NR_CLEANED looks nicer.
> > 
> > Yeah. Will fix.
> 
> Thanks. This is kind of nitpick, however here is another name by
> Jan Kara: BDI_WRITTEN. BDI_WRITTEN may not be a lot better than
> BDI_CLEANED, but here is a patch based on Jan's code. I'm cooking
> more patches that make use of this per-bdi counter to estimate the
> bdi's write bandwidth, and to further decide the optimal (large)
> writeback chunk size as well as to do IO-less balance_dirty_pages().
> 
> Basically BDI_WRITTEN and NR_CLEANED are accounting for the same
> thing in different dimensions. So it would be good if we can use
> the same naming scheme to avoid confusing users: either to use
> BDI_WRITTEN and NR_WRITTEN, or use BDI_CLEANED and NR_CLEANED.
> What's your opinion?

I tend to prefer *_WRITTEN now.
- *_WRITTEN reminds the users about IO, *_CLEANED is less so obvious.
- *_CLEANED seems to be paired with NR_DIRTIED, this could be
  misleading to the users. The fact is, dirty pages may either be
  written to disk, or dropped (by truncate).

Thanks,
Fengguang
