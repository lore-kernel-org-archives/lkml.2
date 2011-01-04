Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1ADJNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:13:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1ADJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:13:50 -0500
Date: Tue, 4 Jan 2011 04:13:48 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
        joel.becker@oracle.com, swhiteho@redhat.com
Subject: Re: [patch 7/8] fs: fix or note I_DIRTY handling bugs in filesystems
Message-ID: <20110104091347.GA2760@infradead.org>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.652706340@kernel.dk>
 <20101229150108.GA13358@infradead.org>
 <20110104060452.GC3402@amd>
 <20110104063944.GA1910@infradead.org>
 <20110104075248.GB4090@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104075248.GB4090@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 06:52:48PM +1100, Nick Piggin wrote:
> Right if you want a helper to get the correct mask of bits required
> that's fine and I agree, but locking is a different issue too: if
> filesystems are trying to keep private state in sync with vfs state,
> then they _need_ to do it properly with the proper locking. I think
> your hfsplus implementation had a bug or two in this area didn't it?
> (although I ended up getting side tracked with all these bugs half
> way through looking at that).

It's not locking, but ordering that was the issue.  It's an issue caused
by the VFS interfaces, but not really related to the area you work
on currently.  If ->dirty_inode told us what was dirtied it would be
a lot simpler.  Alternatively we should just stop requiring filesystems
to participate in the I_DIRTY_SYNC/DATASYNC protocol.  In general it's
much easier for the filesystem to keep that state by itself in proper
granularity.  But I lost the fight to have the timestamp updates go
through proper methods instead of just writing into the VFS inode and
marking the inode dirty long ago, so we'll have to live with it.
