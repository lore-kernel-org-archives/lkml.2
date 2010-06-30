Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0F3AUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:20:48 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:49093 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753389Ab0F3AUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:20:47 -0400
Date: Wed, 30 Jun 2010 10:20:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] xfs: minimize DMAPI footprint
Message-ID: <20100630002043.GB24712@dastard>
References: <1277762653.2040.554.camel@doink>
 <20100629075734.GA31118@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629075734.GA31118@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 03:57:34AM -0400, Christoph Hellwig wrote:
> > SGI has a product that uses the DMAPI support code that's
> > included in mainline XFS, along with some additional code
> > (the "never merged" stuff Christoph refers to) that we
> > maintain separately.  To our customers that need it, this
> > is an extremely important feature.
> 
> So why don't you bother to get HSM support upstream properly,
> or at least maintain it somewhere where you can get at it?
> What sourcxe tree do those important customers use it?
> 
> > What follows is a set of patches that I think accomplishes
> > these goals.  The net result of these changes is:
> 
> While this is a lot better than the old DMAPI supoort, it's still
> lots of dead code in the mainline tree, that won't ever be used
> there, as proper HSM suport if it ever was merged would sit at
> the VFS layer.

My question about the DMAPI hooks also still stands - if we leave
the hooks in mainline, how are we supposed to test that they are
still placed correctly for the out-of-tree patches to function
correctly? I can't see that we can actually do this, so I question
the value of even leaving minimal hooks in place....

> In addition to that the people who effectively maintain XFS for both
> the community and lots of paying customers have done a large amount
> of work ontop of the DMAPI removal of the last 1 1/2 month.  So I'd
> say rebase your changes over
> 
> 	http://git.kernel.org/?p=linux/kernel/git/dgc/xfsdev.git;a=shortlog;h=refs/heads/for-2.6.36
> 
> and keep them in a separate branch dmapi-dev branch where SGI can pull
> the code for it's customers from. This branch could also include the
> actual dmapi code and core kernel modifications, so that people that
> want dmapi support actually have chance to find a complete kernel tree
> for it.

This makes a lot of sense to me. I'd prefer an all-or-nothing
approach to supporting DMAPI (and any other out-of-tree enabling
functionality for that matter) and putting it all in separate
branch would give us both all and nothing. ;)

It would also help us test the DMAPI infrastructure without needing
a HSM as the xfsqa test suite does a pretty good job of testing it.
And, of course, we could also help clean it up if it is testable. As
such, I'd be quite happy to maintain a dmapi-dev branch in the above
repo if the eventual goal is to try to move the code towards being
more acceptible for mainline inclusion....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
