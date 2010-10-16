Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab0JPRVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 13:21:23 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:34802 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063Ab0JPRVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 13:21:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQEADd6uUx5LcB2gWdsb2JhbAChMBYBARYiIsAyhUkEj0w
Date: Sun, 17 Oct 2010 04:21:20 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101016172120.GE3240@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <20101008095658.GA19804@ZenIV.linux.org.uk>
 <20101008100346.GA27737@infradead.org>
 <20101016075721.GS19147@amd>
 <20101016162201.GF16861@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016162201.GF16861@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 12:22:01PM -0400, Christoph Hellwig wrote:
> On Sat, Oct 16, 2010 at 06:57:21PM +1100, Nick Piggin wrote:
> > My approach in my tree is a new function like Al suggests, which
> > simply doesn't assign the ino. That keeps compatibility backward.
> 
> There's really no point.

It is, the point is backwards compatibility and churn. It's like a
single function call and a load from cache in the inode creation
path -- a drop in the ocean. So it's not worth my time with the
churn.

>  The concept of creating a new inode has
> absolutely nothing to do with i_ino.  We'll just need i_ino before
> adding an inode to the hash.  The only reason it's been done by
> new_inode is historic coincidence - cleaning this mess up is a good
> thing independent of making the fake inode number generation scale
> better.  As you can see in my patch moving it out there's actually
> only very few filesystems that need it.

Easy to just have a new name, IMO. But I won't get hung up arguing
the point.

