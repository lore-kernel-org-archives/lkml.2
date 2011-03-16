Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1CPNHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:07:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1CPNHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:07:39 -0400
Date: Wed, 16 Mar 2011 09:07:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS - the first pile
Message-ID: <20110316130728.GB30866@infradead.org>
References: <20110315213248.GL22723@ZenIV.linux.org.uk>
 <20110316061917.GA30195@dastard>
 <20110316065103.GP22723@ZenIV.linux.org.uk>
 <20110316072123.GR22723@ZenIV.linux.org.uk>
 <B0CB85F7-23A7-45EA-848E-8B2701545371@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B0CB85F7-23A7-45EA-848E-8B2701545371@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 07:46:40AM -0400, Theodore Tso wrote:
> 
> On Mar 16, 2011, at 3:21 AM, Al Viro wrote:
> 
> > BTW, you want to update 005 in there - we are back to correct "maximum
> > is 40 symlinks total, 8 levels on nesting" for all syscalls.  Add the
> > 41st symlink to your chain in testcase ;-)
> 
> Unless there's a way to read out these limits, I'm not sure it's a good idea
> to add a test like that to xfstests --- it's too fragile since at some point
> we might change what those limits might be.
> 
> Also, xfstests is primarily intended to be a file system level stress tester
> testing for correctness, and issues of whether we blow up on the 40th, 
> 41st, or 42nd symlink seems more like an ABI issue --- and even there I'm
> not sure the ABI specification should be quite that detailed over what's
> allowed and not allowed.

That's not what it tests anyway.  It tests that we get ELOOP at some
point, and do not blow the stack.  Which is someting that older Linux
code used to do.
