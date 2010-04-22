Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0DVQ5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:57:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:53115 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab0DVQ5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:57:15 -0400
Date: Fri, 23 Apr 2010 02:57:11 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100422165711.GA5683@laptop>
References: <1271118255-21070-2-git-send-email-david@fromorbit.com>
 <20100418001514.GA26575@infradead.org>
 <20100419140039.GQ5683@laptop>
 <20100420004149.GA14744@dastard>
 <20100420083840.GR5683@laptop>
 <20100420103216.GK15130@dastard>
 <20100421084004.GS5683@laptop>
 <20100422163211.GA2478@infradead.org>
 <20100422163801.GZ5683@laptop>
 <20100422164247.GA15882@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422164247.GA15882@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 12:42:47PM -0400, Christoph Hellwig wrote:
> On Fri, Apr 23, 2010 at 02:38:01AM +1000, Nick Piggin wrote:
> > I don't understand, it should be implemented like just all the other
> > shrinkers AFAIKS. Like the dcache one that has to shrink multiple
> > superblocks. There is absolutely no requirement for this API change
> > to implement it in XFS.
> 
> The dcache shrinker is an example for a complete mess.

I don't know. It's not really caused by not registering multiple
shrinkers. It seems to be caused more by the locking, which is not
going away when you have multiple shrinkers.

The XFS patch seems to be pinning the mount structure when it is
registered, so it would have no such locking/refcounting problems
using a private list AFAIKS.


> > But the shrinker list *is* a global list. The downside of it in the way
> > it was done in the XFS patch is that 1) it is much larger than a simple
> > list head, and 2) not usable by anything other then the shrinker.
> 
> It is an existing global list just made more useful.  Whenever a driver
> has muliple instances of pool that need shrinking this comes in useful,
> it's not related to filesystems at all. 

I would say less useful, because shrinker structure cannot be used
by anything but the shrinker, wheras a private list can be used by
anything, including the applicable shrinker.

