Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0DSOAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:00:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:36737 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab0DSOAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:00:44 -0400
Date: Tue, 20 Apr 2010 00:00:39 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100419140039.GQ5683@laptop>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
 <1271118255-21070-2-git-send-email-david@fromorbit.com>
 <20100418001514.GA26575@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100418001514.GA26575@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 08:15:14PM -0400, Christoph Hellwig wrote:
> Any chance we can still get this into 2.6.34?  It's really needed to fix
> a regression in XFS that would be hard to impossible to work around
> inside the fs.  While it touches quite a few places the changes are
> trivial and well understood.

Why do you even need this context argument?  Reclaim is not doing anything
smart about this, it would just call each call shrinker in turn.

Do you not have an easily traversable list of mountpoints? Can you just
make a list of them? It would be cheaper than putting a whole shrinker
structure into them anyway.

The main reason I would be against proliferation of dynamic shrinker
registration would be that it could change reclaim behaviour depending
on how they get ordered (in the cache the caches are semi-dependent,
like inode cache and dentry cache).

Unless there is a reason I missed, I would much prefer not to do this
like this.

