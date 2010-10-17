Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab0JQCQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:16:18 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:33384 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757223Ab0JQCQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:16:17 -0400
Date: Sun, 17 Oct 2010 13:16:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19] fs: Convert nr_inodes and nr_unused to per-cpu
 counters
Message-ID: <20101017021613.GH32255@dastard>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-4-git-send-email-david@fromorbit.com>
 <1287217776.2799.69.camel@edumazet-laptop>
 <20101016100441.GP4681@dastard>
 <1287224852.2799.130.camel@edumazet-laptop>
 <1287250008.1998.123.camel@laptop>
 <20101017010944.GD29677@dastard>
 <20101017011204.GA2207@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017011204.GA2207@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 09:12:04PM -0400, Christoph Hellwig wrote:
> On Sun, Oct 17, 2010 at 12:09:44PM +1100, Dave Chinner wrote:
> > > fwiw, for_each_*_cpu() takes longer than a single jiffy tick on those
> > > machines.
> > 
> > Yes, agreed. I'm not sure we need exact summation for these counters,
> > but I haven't wanted to bring inaccuracies into the code at this
> > point in time. I need to investigate the effect of using the
> > approximate summation values in all the cases they are used.
> 
> Use of the dirty inodes numbers in the writeback code is something
> that does not make much sense.  It was added as an undocumented
> workaround somewhere in the old writeback code, and spread to even
> more sites over time.  I'm pretty sure we don't actually need it,
> but I'm not quite sure what we actually need.

IIRC, it was needed so that we trigger writeback on purely dirty
inodes. i.e. inodes that have no dirty pages and so wbc->nr_to_write
could be changed and not have background writeback abort because
either nr_to_write was zero or wbc->nr_to_write did not change...

A hack, yes, and one that definitely needs to be revisited outside
the scope of this patch set.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
