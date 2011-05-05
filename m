Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1EEQrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 12:47:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:17943 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab1EEQrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 12:47:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,321,1301900400"; 
   d="scan'208";a="688681809"
Date: Fri, 6 May 2011 00:47:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Chinner <david@fromorbit.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] writeback: refill b_io iff empty
Message-ID: <20110505164712.GA2548@localhost>
References: <20110420080336.441157866@intel.com>
 <20110420080918.560499032@intel.com>
 <20110504073931.GA22675@localhost>
 <20110505163708.GN5323@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505163708.GN5323@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 12:37:08AM +0800, Jan Kara wrote:
> On Wed 04-05-11 15:39:31, Wu Fengguang wrote:
> > To help understand the behavior change, I wrote the writeback_queue_io
> > trace event, and found very different patterns between
> > - vanilla kernel
> > - this patchset plus the sync livelock fixes
> > 
> > Basically the vanilla kernel each time pulls a random number of inodes
> > from b_dirty, while the patched kernel tends to pull a fixed number of
> > inodes (enqueue=1031) from b_dirty. The new behavior is very interesting...
>   This regularity is really strange. Did you have a chance to look more into
> it? I find it highly unlikely that there would be exactly 1031 dirty inodes
> in b_dirty list every time you call move_expired_inodes()...

Yeah that's the weird point. The other things I noticed are more
regular "flusher - dd - flusher - dd - ..." writeout patterns after
the patches.  In vanilla kernel it behaves more randomly and there are
many balance_dirty_pages() IOs from tar.

I'll try to collect more traces in ext4 tomorrow. Sorry it's too late
for me now.

Thanks,
Fengguang
