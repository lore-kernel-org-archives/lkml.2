Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1AGTIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:08:10 -0500
Received: from THUNK.ORG ([69.25.196.29]:51688 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab1AGTII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:08:08 -0500
Date: Fri, 7 Jan 2011 14:08:05 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 5/8] fs: ext2 inode sync fix
Message-ID: <20110107190805.GH21922@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Nick Piggin <npiggin@kernel.dk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.436300300@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218015117.436300300@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 12:46:39PM +1100, Nick Piggin wrote:
> There is a big fuckup with inode metadata writeback (I suspect in a lot
> of filesystems, but I've only dared to look at a couple as yet).
> 
> ext2 relies on ->write_inode being called from sync_inode_metadata in
> fsync in order to sync the inode. However I_DIRTY_SYNC gets cleared
> after a call to this guy, and it doesn't actually write back and wait
> on the inode block unless it is called for sync. This means that write_inode
> from background writeback can kill the inode dirty bits without the data
> getting to disk. Fsync will subsequently miss it.
> 
> The fix is for ->write_inode to dirty the buffers/cache, and then ->fsync to
> write back the dirty data. In the full filesystem sync case, buffercache
> writeback in the generic code will write back the dirty data. Other
> filesystems could use ->sync_fs for this.
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>

What are your plans for this patch?  Is this something you were
planning on pushing during the merge window, or should file system
maintainers try to fix up their code, since I gather this particular
change is independent of the previous patches in this patchset.  Is
that correct?

						- Ted
