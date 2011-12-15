Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab1LOBKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 20:10:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:12369 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab1LOBKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 20:10:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85854318"
Date: Thu, 15 Dec 2011 09:00:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Message-ID: <20111215010010.GA14805@localhost>
References: <20111214133400.GA18565@localhost>
 <20111214143014.GB18080@thunk.org>
 <1323910977.22361.423.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323910977.22361.423.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I found sometimes one disk hasn't any request inflight, but we can't
> send request to the disk, because the scsi host's resource (the queue
> depth) is used out, looks we send too many requests from other disks and
> leave some disks starved. The resource imbalance in scsi isn't a new
> problem, even 3.1 has such issue, so I'd think writeback introduces new
> imbalance between the 12 disks. In fact, if I limit disk's queue depth
> to 10, in this way the 12 disks will not impact each other in scsi
> layer, the performance regression fully disappears for both writeback
> and order mode.

I observe similar issue in MD. The default

        q->nr_requests = BLKDEV_MAX_RQ;

is too small for large arrays, and I end up doing

        echo 1280 > /sys/block/md0/queue/nr_requests

in my tests.

Thanks,
Fengguang
