Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab1FAWc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:32:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab1FAWc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:32:27 -0400
Date: Wed, 1 Jun 2011 15:31:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/18] writeback fixes and cleanups for 2.6.40 (v3)
Message-Id: <20110601153142.0bf83332.akpm@linux-foundation.org>
In-Reply-To: <20110524032859.GA17429@localhost>
References: <20110519214530.939830917@intel.com>
	<20110523090739.GA27894@infradead.org>
	<20110523092838.GA25829@localhost>
	<20110524032859.GA17429@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011 11:28:59 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Mon, May 23, 2011 at 05:28:38PM +0800, Wu Fengguang wrote:
> > On Mon, May 23, 2011 at 05:07:39PM +0800, Christoph Hellwig wrote:
> > > Wu, Andrew,
> > > 
> > > what's the plan for these for 2.6.40?  We'll need to make some progress
> > > in this area, and even if we can't get everything it we should make sure
> > > to at least include the updated versions of those in -mm.  But even
> > > some of the later ones are pretty low risk.

I've been waiting for this work to stabilize a bit more.

> > Yes, except for patch 14 which does not include external behavior
> > changes besides the good full write chunk size for large files, the
> > patches not in -mm are pretty trivial ones.
> > 
> > Aside from my simple tests, Alex also helped going through the LKP
> > tests with the patchset and find no writeback regressions.
> 
> I'll rearrange the series and move patch 14 to the end, so that the
> patches come in order
> 
> - 10 (updated) patches in -mm
> - 6 more trivial patches that is safe to go upstream after -rc1 
> - the current patch 14 and patch 16 (that depends on 14)

I didn't merge the writeback patches for -rc1 due to uncertainty about
their readiness.  Here's what I'm sitting on:


writeback-pass-writeback_control-down-to-move_expired_inodes.patch
writeback-introduce-writeback_controlinodes_cleaned.patch
writeback-try-more-writeback-as-long-as-something-was-written.patch
writeback-the-kupdate-expire-timestamp-should-be-a-moving-target.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-refill-b_io-iff-empty.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
writeback-elevate-queue_io-into-wb_writeback.patch
writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage.patch
writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock.patch
writeback-avoid-extra-sync-work-at-enqueue-time.patch

Are these all up-todate and considered ready to go?


I have a couple of notes I made:

#writeback-try-more-writeback-as-long-as-something-was-written.patch: sync livelocks

IOW, someone reported livelocks with sync, or speculated that it might
cause them.

#writeback-sync-expired-inodes-first-in-background-writeback.patch: TBU??

"to be updated".

I haven't gone back through the email trail to work out why I added
these notes and whether the identified issues were resolved.

