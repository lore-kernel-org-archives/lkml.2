Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0GAJgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:36:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab0GAJgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:36:09 -0400
Date: Thu, 1 Jul 2010 19:36:02 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-ID: <20100701093602.GJ22976@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030730.245992858@suse.de>
 <20100630072702.GF24712@dastard>
 <20100630120502.GB21358@laptop>
 <20100701023618.GQ24712@dastard>
 <20100701075426.GC22976@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701075426.GC22976@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:54:26PM +1000, Nick Piggin wrote:
> On Thu, Jul 01, 2010 at 12:36:18PM +1000, Dave Chinner wrote:
> If there is a
> difficulty with locking pops up in future, I'd prefer to look at it
> then.
> 
> I don't think any filesystems cared at all when I converted them.

What I mean by this is that _today_ no filesystems seemed to have
any problems with how I did it. I did touch quota and notify code,
which iterates inode sb lists, but it was pretty trivial. Not many
others are about inode locking details enough to care about any
of the locks in fs/inode.c.

And so instead of adding another lock now when I already have a
(IMO) nice and working code, I will prefer to wait until some fs
development runs into problem with locking.

There are several things that can be done. Using RCU for more of
the inode lists is a possibility, and can improve lock order problems
while actually reducing the amount of locking rather than adding
locks.

