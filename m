Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab0FOTRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:17:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0FOTRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:17:36 -0400
Date: Tue, 15 Jun 2010 15:17:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100615191716.GA6778@infradead.org>
References: <20100615141122.GA27893@infradead.org>
 <20100615142219.GE28052@random.random>
 <20100615144342.GA3339@infradead.org>
 <20100615150850.GF28052@random.random>
 <20100615152526.GA3468@infradead.org>
 <20100615154516.GG28052@random.random>
 <20100615162600.GA9910@infradead.org>
 <4C17AF2D.2060904@redhat.com>
 <20100615165423.GA16868@infradead.org>
 <4C17D0C5.9030203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C17D0C5.9030203@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 03:13:09PM -0400, Rik van Riel wrote:
> Why?   How about because you know the stack is not big enough
> to have the XFS call path on it twice? :)
> 
> Isn't the whole purpose of this patch series to prevent writepage
> from being called by the VM, when invoked from a deep callstack
> like xfs writepage?

It's not invoked from xfs writepage, but from xfs_file_aio_write via
generic_file_buffered_write.  Which isn't actually an all that deep
callstack, just en example of one that's alread bad enough to overflow
the stack.

> That sounds a lot like simply wanting to not have GFP_FS...

There's no point in sprinkling random GFP_NOFS flags.  It's not just
the filesystem code that uses a lot of stack.

