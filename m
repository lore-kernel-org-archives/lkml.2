Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2JMRHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 13:07:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40632 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2JMRHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 13:07:06 -0400
Date: Sat, 13 Oct 2012 18:07:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 3
Message-ID: <20121013170701.GT2616@ZenIV.linux.org.uk>
References: <20121013002003.GL2616@ZenIV.linux.org.uk>
 <5079164D.4030307@gmail.com>
 <20121013075128.GQ2616@ZenIV.linux.org.uk>
 <20121013154810.GA9678@infradead.org>
 <20121013160115.GS2616@ZenIV.linux.org.uk>
 <20121013160455.GA32420@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121013160455.GA32420@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 12:04:55PM -0400, Christoph Hellwig wrote:
> On Sat, Oct 13, 2012 at 05:01:15PM +0100, Al Viro wrote:
> > You know, I'm in the middle of dealing with one such TODO.  Yours, as it
> > were.  From six years ago.  kernel_thread() unexporting.  TODO comments
> > of any form are routinely shat upon and ignored, especially when shuffled
> > away into less read parts of the tree... ;-/
> > 
> > I'd rather see it done fs-by-fs.  Starting with something reasonably easy
> > to test - minixfs would do nicely.  Don't get me wrong - I'm all for
> > burying ->truncate(); what I'm worried about is that we'll end up burying
> > the warning about the reasons why vmtruncate() was a bad idea, leaving the
> > functionality exactly as it used to be...
> 
> As mentioned I agree with the concern in principle.  Let's start by
> taking Marco's patches for filesystems that use vmtruncate but don't 
> actually implement ->truncate.  There's a few I remember offhand, e.g.
> procfs and ufs right now.  Then we can do the actual work required ones
> piece by piece.

Umm... That would be what, procfs?  Frankly, I'm not sure that ATTR_SIZE for
procfs actually should not be silently ignored.  ->i_size there is completely
synthetic - it's not as if truncation would actually change the contents.

And ufs situation is quite different - there vmtruncate() is used only on the
->write_begin() side.  ->setattr() is already vmtruncate-free.  What's needed
there is an analog of e.g. ext2_write_failed().
