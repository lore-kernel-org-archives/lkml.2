Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0F2H5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:57:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42696 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab0F2H5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:57:35 -0400
Date: Tue, 29 Jun 2010 03:57:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] xfs: minimize DMAPI footprint
Message-ID: <20100629075734.GA31118@infradead.org>
References: <1277762653.2040.554.camel@doink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277762653.2040.554.camel@doink>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> SGI has a product that uses the DMAPI support code that's
> included in mainline XFS, along with some additional code
> (the "never merged" stuff Christoph refers to) that we
> maintain separately.  To our customers that need it, this
> is an extremely important feature.

So why don't you bother to get HSM support upstream properly,
or at least maintain it somewhere where you can get at it?
What sourcxe tree do those important customers use it?

> What follows is a set of patches that I think accomplishes
> these goals.  The net result of these changes is:

While this is a lot better than the old DMAPI supoort, it's still
lots of dead code in the mainline tree, that won't ever be used
there, as proper HSM suport if it ever was merged would sit at
the VFS layer.

In addition to that the people who effectively maintain XFS for both
the community and lots of paying customers have done a large amount
of work ontop of the DMAPI removal of the last 1 1/2 month.  So I'd
say rebase your changes over

	http://git.kernel.org/?p=linux/kernel/git/dgc/xfsdev.git;a=shortlog;h=refs/heads/for-2.6.36

and keep them in a separate branch dmapi-dev branch where SGI can pull
the code for it's customers from.  This branch could also include the
actual dmapi code and core kernel modifications, so that people that
want dmapi support actually have chance to find a complete kernel tree
for it.  I'd also hope you have fixed grave bugs like the oops on
unmount after multiple mount one I pointed out to SGI about two years
ago, but which still wasn't fixed inthe last dmapi enabled tree.

