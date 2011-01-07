Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1AGTGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:06:36 -0500
Received: from THUNK.ORG ([69.25.196.29]:51673 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab1AGTGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:06:34 -0500
Date: Fri, 7 Jan 2011 14:06:31 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110107190631.GG21922@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Nick Piggin <npiggin@kernel.dk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218015117.759480620@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 12:46:42PM +1100, Nick Piggin wrote:
> --- linux-2.6.orig/Documentation/filesystems/porting	2010-12-18 00:32:44.000000000 +1100
> +++ linux-2.6/Documentation/filesystems/porting	2010-12-18 03:51:40.000000000 +1100
> +--
> +[mandatory]
> +	Inode writeback and syncing has undergone an overhaul.
> +write_inode_now doesn't sync (unless ->write_inode *always* syncs)
> +

Could you perhaps give a bit more detail in the documentation about
what sync_inode() is supposed to do?  I gather that it is supposed to
(based on the flags), do the specified combination of (a) do writeback
for the pages corresponding to the specified range (if INODE_SYNC_DATA
is given), (b) write out the inode if necessary depending on
INODE_SYNC_DATA_METADATA (for fdatasync) and INODE_SYNC_DATA (for
fsync).

When sync_inode() returns, what is guaranteed is that the appropriate
buffer_heads are dirtied (for both the metadata and the data if the
file system is still using the buffer cache for data I/O) and/or the
data has been pushed to the block I/O system, but the sync_inode()
method does not wait force the dirtied buffers out to disk, and it
does not wait for any initiated I/O to complete (either at the block
I/O layer or guaranteeing that the data has hit the platters by
issuing a barrier request).

Do I have that right?  If so, could we please add that to the
documentation, just so it's clear?  Thanks!!

						- Ted
