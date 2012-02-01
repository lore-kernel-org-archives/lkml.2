Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab2BAHUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:20:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:28017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051Ab2BAHUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:20:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101856599"
Date: Wed, 1 Feb 2012 15:10:00 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>,
        Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
Message-ID: <20120201071000.GB29083@localhost>
References: <1327996780.21268.42.camel@sli10-conroe>
 <20120131220333.GD4378@redhat.com>
 <20120131141301.ba35ffe0.akpm@linux-foundation.org>
 <20120131222217.GE4378@redhat.com>
 <20120201033653.GA12092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201033653.GA12092@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 10:36:53PM -0500, Vivek Goyal wrote:
> On Tue, Jan 31, 2012 at 05:22:17PM -0500, Vivek Goyal wrote:
> [..]
> 
> > > 
> > > We've never really bothered making the /dev/sda[X] I/O very efficient
> > > for large I/O's under the (probably wrong) assumption that it isn't a
> > > very interesting case.  Regular files will (or should) use the mpage
> > > functions, via address_space_operations.readpages().  fs/blockdev.c
> > > doesn't even implement it.
> > > 
> > > > and by the time all the pages
> > > > are submitted and one big merged request is formed it wates lot of time.
> > > 
> > > But that was the case in eariler kernels too.  Why did it change?
> > 
> > Actually, I assumed that the case of reading /dev/sda[X] worked well in
> > earlier kernels. Sorry about that. Will build a 2.6.38 kernel tonight
> > and run the test case again to make sure we had same overhead and
> > relatively poor performance while reading /dev/sda[X].
> 
> Ok, I tried it with 2.6.38 kernel and results look more or less same.
> Throughput varied between 105MB to 145MB. Many a times it was close to
> 110MB and other times it was 145MB. Don't know what causes that spike
> sometimes.

The block device really has some aged performance bug. Which
interestingly only show up in some test environments...

> I still see that IO is being submitted one page at a time. The only
> real difference seems to be that queue unplug happening at random times
> and many a times we are submitting much smaller requests (40 sectors, 48
> sectors etc).

Would you share the blktrace data?

Thanks,
Fengguang
