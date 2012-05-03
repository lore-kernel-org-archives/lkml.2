Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2ECOIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:08:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:1828 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab2ECOIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:08:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148931606"
Date: Thu, 3 May 2012 22:08:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@fusionio.com>
Subject: Re: [PATCH] btrfs: lower metadata writeback threshold on low dirty
 threshold
Message-ID: <20120503140827.GA24981@localhost>
References: <20120408010600.GA31377@localhost>
 <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
 <20120411161344.309f12ef.akpm@linux-foundation.org>
 <20120412013224.GA5859@localhost>
 <20120412022040.GA6800@localhost>
 <20120412142634.GA16559@quack.suse.cz>
 <20120413014026.GA9027@localhost>
 <20120503034311.GA14081@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503034311.GA14081@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 11:43:11AM +0800, Fengguang Wu wrote:
> This helps write performance when setting the dirty threshold to tiny numbers.
> 
>      3.4.0-rc2         3.4.0-rc2-btrfs4+
>   ------------  ------------------------
>          96.92        -0.4%        96.54  bay/thresh=1000M/btrfs-100dd-1-3.4.0-rc2
>          98.47        +0.0%        98.50  bay/thresh=1000M/btrfs-10dd-1-3.4.0-rc2
>          99.38        -0.3%        99.06  bay/thresh=1000M/btrfs-1dd-1-3.4.0-rc2
>          98.04        -0.0%        98.02  bay/thresh=100M/btrfs-100dd-1-3.4.0-rc2
>          98.68        +0.3%        98.98  bay/thresh=100M/btrfs-10dd-1-3.4.0-rc2
>          99.34        -0.0%        99.31  bay/thresh=100M/btrfs-1dd-1-3.4.0-rc2
>   ==>    88.98        +9.6%        97.53  bay/thresh=10M/btrfs-10dd-1-3.4.0-rc2
>   ==>    86.99       +13.1%        98.39  bay/thresh=10M/btrfs-1dd-1-3.4.0-rc2
>   ==>     2.75     +2442.4%        69.88  bay/thresh=1M/btrfs-10dd-1-3.4.0-rc2
>   ==>     3.31     +2634.1%        90.54  bay/thresh=1M/btrfs-1dd-1-3.4.0-rc2

Well, further tests show that it behaves very unstable:

       3.4.0-rc2-btrfs4+         3.4.0-rc2-btrfs5+  
------------------------  ------------------------  
                   69.88       +16.4%        81.31  bay/thresh=1M/btrfs-10dd-1-3.4.0-rc2-btrfs4+
                   71.09        +1.4%        72.05  bay/thresh=1M/btrfs-10dd-2-3.4.0-rc2-btrfs4+
                   72.60        -1.7%        71.38  bay/thresh=1M/btrfs-10dd-3-3.4.0-rc2-btrfs4+
                   90.54        -0.9%        89.74  bay/thresh=1M/btrfs-1dd-1-3.4.0-rc2-btrfs4+
                   89.17       -90.2%     ==> 8.71  bay/thresh=1M/btrfs-1dd-2-3.4.0-rc2-btrfs4+
               ==> 14.96      +495.3%        89.06  bay/thresh=1M/btrfs-1dd-3-3.4.0-rc2-btrfs4+
                  408.23        +1.0%       412.26  TOTAL write_bw

Where the -btrfs5 kernel has one more patch to remove the write plug.

Thanks,
Fengguang
