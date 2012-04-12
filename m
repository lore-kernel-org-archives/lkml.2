Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2DLO0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:26:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab2DLO0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:26:37 -0400
Date: Thu, 12 Apr 2012 16:26:34 +0200
From: Jan Kara <jack@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, Shaohua Li <shli@fusionio.com>
Subject: Re: [RESEND][PATCH v2] block: remove plugging at buffered write
 time
Message-ID: <20120412142634.GA16559@quack.suse.cz>
References: <20120408010600.GA31377@localhost>
 <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
 <20120411161344.309f12ef.akpm@linux-foundation.org>
 <20120412013224.GA5859@localhost>
 <20120412022040.GA6800@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412022040.GA6800@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Fengguang,

On Thu 12-04-12 10:20:40, Wu Fengguang wrote:
> > > > > Note that plugging for O_SYNC writes is also removed. The user may pass
> > > > > arbitrary @size arguments, which may be much larger than the preferable
> > > > > I/O size, or may cross extent/device boundaries. Let the lower layers
> > > > > handle the plugging. Otherwise the plugging code here will turn the
> > > > > low level plugging into no-ops.
> > > > 
> > > > I assume you have some numbers to back this up, right?  Care to share
> > > > those?
> > > 
> > > Yes please.
> > > 
> > > We've broken this stuff a few times recently - we should review and
> > > test carefully.
> > 
> > Yes sure. Last time I posted the patch, I did some tests and found no
> > performance changes. Now for 3.3, the tests started days ago have not
> > finished now (partly because it is stalled for quite long time due to
> > unknown reason). The now-available numbers for bs=4k dd's look fine.
> > The pending tests are for bs=1M dd's and some random fio workloads.
> > 
> 
> The changes are basically small enough to be considered noises.
> But anyway here are some interpretations:
> 
> - application visible data write performance (write_bw) is almost the same
> - it slightly reduces the real IOs that hit disk (io_wkB_s, io_rkB_s)
> - disk utilization slightly increased
> - CPU time is slightly reduced
> 
  Well, two of the throughput numbers stand out (in both directions
actually) although they seem to be more extreme configurations so maybe it
is a noise. But maybe it would deserve further check:

> $ ./compare-io bay/*/*-{3.3.0,3.3.0-plug+}
>                    3.3.0               3.3.0-plug+
> ------------------------  ------------------------
...
>                     2.60        +7.1%         2.78  bay/thresh=1M/btrfs-10dd-1-3.3.0
>                     3.72       -12.5%         3.25  bay/thresh=1M/btrfs-1dd-1-3.3.0
...
  I looked at other iostat numbers as well, but seeing quite some changes
in both directions I'd say that those iostat numbers are too noisy to draw
serious conclusion from them.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
