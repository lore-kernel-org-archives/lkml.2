Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab1JGUYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:24:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab1JGUYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:24:21 -0400
Date: Fri, 7 Oct 2011 21:24:17 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
        Josh Boyer <jwboyer@redhat.com>, aarcange@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Abort reclaim/compaction if compaction can
 proceed
Message-ID: <20111007202417.GD6418@suse.de>
References: <1318000643-27996-1-git-send-email-mgorman@suse.de>
 <1318000643-27996-3-git-send-email-mgorman@suse.de>
 <4E8F5BEA.3040502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4E8F5BEA.3040502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 04:07:06PM -0400, Rik van Riel wrote:
> On 10/07/2011 11:17 AM, Mel Gorman wrote:
> >If compaction can proceed, shrink_zones() stops doing any work but
> >the callers still shrink_slab(), raises the priority and potentially
> >sleeps.  This patch aborts direct reclaim/compaction entirely if
> >compaction can proceed.
> >
> >Signed-off-by: Mel Gorman<mgorman@suse.de>
> 
> This patch makes sense to me, but I have not tested it like
> the first one.
> 

Do if you can.

> Mel, have you tested this patch?

Yes.

> Did you see any changed
> behaviour vs. just the first patch?
> 

It's marginal and could be confirmation bias on my part. Basically,
there is noise when this path is being exercised but there were fewer
slabs scanned.  However, I don't know what the variances are and
whether the reduction was within the noise or not but it makes sense
that it would scan less.  If I profiled carefully, I might be able
to show that a few additional cycles are spent raising the priority
but it would be marginal.

While patch 1 is very clear, patch 2 depends on reviewers deciding it
"makes sense".

> Having said that, I'm pretty sure the patch is ok :)
> 

Care to ack?

-- 
Mel Gorman
SUSE Labs
