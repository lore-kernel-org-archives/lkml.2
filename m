Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1HBLoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:44:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:47569 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab1HBLob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:44:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,306,1309762800"; 
   d="scan'208";a="34221798"
Date: Tue, 2 Aug 2011 19:44:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110802114428.GA6014@localhost>
References: <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
 <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
 <20110801020951.GA12870@dastard>
 <20110801112330.GA27190@infradead.org>
 <20110801165242.GA18802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801165242.GA18802@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 12:52:42AM +0800, Christoph Hellwig wrote:
> wb_check_background_flush is indeed what we're hitting.

That means s_umount is NOT held by another queued writeback work.

> See the trace output using a patch inspired by Curt's below:
> 
> # tracer: nop
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>            <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
>            <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
>            <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush

What's that bdi 7:0? And sb_dev=0:0, nr_pages=9223372036854775807=0x7fffffffffffffff.

All are indicating some special bdi/inode.

Thanks,
Fengguang
