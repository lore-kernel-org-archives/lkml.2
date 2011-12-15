Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab1LOGXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:23:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:63002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab1LOGXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:23:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86761844"
Date: Thu, 15 Dec 2011 13:02:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: NeilBrown <neilb@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>, "Ted Ts'o" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Message-ID: <20111215050233.GA8959@localhost>
References: <20111214133400.GA18565@localhost>
 <20111214143014.GB18080@thunk.org>
 <1323910977.22361.423.camel@sli10-conroe>
 <20111215010010.GA14805@localhost>
 <20111215122759.7ce0b7b5@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215122759.7ce0b7b5@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 09:27:59AM +0800, NeilBrown wrote:
> On Thu, 15 Dec 2011 09:00:10 +0800 Wu Fengguang <fengguang.wu@intel.com>
> wrote:
> 
> > > I found sometimes one disk hasn't any request inflight, but we can't
> > > send request to the disk, because the scsi host's resource (the queue
> > > depth) is used out, looks we send too many requests from other disks and
> > > leave some disks starved. The resource imbalance in scsi isn't a new
> > > problem, even 3.1 has such issue, so I'd think writeback introduces new
> > > imbalance between the 12 disks. In fact, if I limit disk's queue depth
> > > to 10, in this way the 12 disks will not impact each other in scsi
> > > layer, the performance regression fully disappears for both writeback
> > > and order mode.
> > 
> > I observe similar issue in MD. The default
> > 
> >         q->nr_requests = BLKDEV_MAX_RQ;
> > 
> > is too small for large arrays, and I end up doing
> > 
> >         echo 1280 > /sys/block/md0/queue/nr_requests
> > 
> > in my tests.
> 
> And you find this makes a difference?
> 
> That is very surprising because md devices don't use requests (and really use
> the 'queue' at all) and definitely don't make use of nr_requests.

Yes it is: /sys/block/md0/queue/nr_requests cannot be modified at all...

Sorry for the noise!

Fengguang
