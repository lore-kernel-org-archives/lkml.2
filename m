Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2JMQBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:01:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40502 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2JMQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:01:19 -0400
Date: Sat, 13 Oct 2012 17:01:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 3
Message-ID: <20121013160115.GS2616@ZenIV.linux.org.uk>
References: <20121013002003.GL2616@ZenIV.linux.org.uk>
 <5079164D.4030307@gmail.com>
 <20121013075128.GQ2616@ZenIV.linux.org.uk>
 <20121013154810.GA9678@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121013154810.GA9678@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 11:48:10AM -0400, Christoph Hellwig wrote:
> On Sat, Oct 13, 2012 at 08:51:28AM +0100, Al Viro wrote:
> > It's somewhat pointless on its own...  If you were doing something with
> > the callers afterwards - sure, it would be make sense, but as it is...
> 
> I'd really like to see ->truncate and vmtruncate done, so from that side
> I'm absolutely in favour of this series.  What I'm a bit concerned about
> is that it just does the trivial 1:1 conversion and not actually
> converts the sequence of operations to the proper form, which was one
> of the two big reasons of moving away from ->truncate to start with.
> 
> I'd love to see the full conversion, but without adequate test coverage
> for all the fringe filesystems that might be a bit too much to expect
> from Marco.
> 
> I think just doing the easy conversions he did, and putting a TODO
> comment explaining how it should be taken further at each of the sites
> would be valueable on its own.

You know, I'm in the middle of dealing with one such TODO.  Yours, as it
were.  From six years ago.  kernel_thread() unexporting.  TODO comments
of any form are routinely shat upon and ignored, especially when shuffled
away into less read parts of the tree... ;-/

I'd rather see it done fs-by-fs.  Starting with something reasonably easy
to test - minixfs would do nicely.  Don't get me wrong - I'm all for
burying ->truncate(); what I'm worried about is that we'll end up burying
the warning about the reasons why vmtruncate() was a bad idea, leaving the
functionality exactly as it used to be...
