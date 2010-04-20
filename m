Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0DTKch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:32:37 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:53233 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754355Ab0DTKcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:32:35 -0400
Date: Tue, 20 Apr 2010 20:32:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100420103216.GK15130@dastard>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
 <1271118255-21070-2-git-send-email-david@fromorbit.com>
 <20100418001514.GA26575@infradead.org>
 <20100419140039.GQ5683@laptop>
 <20100420004149.GA14744@dastard>
 <20100420083840.GR5683@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420083840.GR5683@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 06:38:40PM +1000, Nick Piggin wrote:
> On Tue, Apr 20, 2010 at 10:41:49AM +1000, Dave Chinner wrote:
> > And if this is enough of a problem to disallow context based cache
> > shrinkers, then lets fix the interface so that we encode the
> > dependencies explicitly in the registration interface rather than
> > doing it implicitly.
> > 
> > IOWs, I don't think this is a valid reason for not allowing a
> > context to be passed with a shrinker because it is easily fixed.
> 
> Well yeah you could do all that maybe. I think it would definitely be
> required if we were to do context shrinkers like this. But AFAIKS there
> is simply no need at all. Definitely it is not preventing XFS from
> following more like the existing shrinker implementations.

So you're basically saying that we shouldn't improve the shrinker
interface because you don't think that anyone should be doing
anything different to what is already there.

If a change of interface means that we end up with shorter call
chains, less global state, more flexibilty, better batching and IO
patterns, less duplication of code and algorithms and it doesn't
cause any regressions, then where's the problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
