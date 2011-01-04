Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab1ADIbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:31:39 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:21198 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab1ADIbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:31:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGdoIk15Ldpx/2dsb2JhbACkNnS7c4VKBJAq
Date: Tue, 4 Jan 2011 19:31:32 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110104083132.GA4485@amd>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104080323.GC4090@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 07:03:23PM +1100, Nick Piggin wrote:
> On Tue, Jan 04, 2011 at 01:57:37AM -0500, Christoph Hellwig wrote:
> > > Also giving filesystems the flexibility to do the data writeout can
> > > be more optimal by doing all writeout at once or ordering to suit their
> > > writeback patterns. Having range data could give some performance
> > > advantages writing back mappings or commit operations over network. I
> > > don't see it as a big complexity. It gives a chance to do range fsyncs
> > > and sync_file_range and such properly too.
> > 
> > We currently do all that just fine before calling into ->fsync.
> 
> What do you mean we do all that just fine? A filesystem can't schedule
> data submission and waiting optimally versus metadata, it can't do
> metadata operations or remote commits corresponding to data ranges, and
> it doesn't support nfs sync operations.

And actually I think it is much better to have sync_inode, which means
we'll be able to get rid of commit_metadata (which should be an inode
operation anyway, not an export operation which really should deal with
exporting filesystems to a non-vfs namespace, not nfsd hacks).

commit_metadata would just be sync_inode with a null range or no data
sync flag set.

