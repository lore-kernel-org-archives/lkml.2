Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab1EMKOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:14:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:37048 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab1EMKOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:14:34 -0400
Date: Fri, 13 May 2011 11:14:29 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Message-ID: <20110513101429.GC3569@suse.de>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
 <1305127773-10570-4-git-send-email-mgorman@suse.de>
 <alpine.DEB.2.00.1105111314310.9346@chino.kir.corp.google.com>
 <20110511210907.GA17898@suse.de>
 <alpine.DEB.2.00.1105111456220.24003@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105111456220.24003@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 03:27:11PM -0700, David Rientjes wrote:
> On Wed, 11 May 2011, Mel Gorman wrote:
> 
> > I agree with you that there are situations where plenty of memory
> > means that that it'll perform much better. However, indications are
> > that it breaks down with high CPU usage when memory is low.  Worse,
> > once fragmentation becomes a problem, large amounts of UNMOVABLE and
> > RECLAIMABLE will make it progressively more expensive to find the
> > necessary pages. Perhaps with patches 1 and 2, this is not as much
> > of a problem but figures in the leader indicated that for a simple
> > workload with large amounts of files and data exceeding physical
> > memory that it was better off not to use high orders at all which
> > is a situation I'd expect to be encountered by more users than
> > performance-sensitive applications.
> > 
> > In other words, we're taking one hit or the other.
> > 
> 
> Seems like the ideal solution would then be to find how to best set the 
> default, and that can probably only be done with the size of the smallest 
> node since it has a higher liklihood of encountering a large amount of 
> unreclaimable slab when memory is low.
> 

Ideally yes, but glancing through this thread and thinking on it a bit
more, I'm going to drop this patch. As pointed out, SLUB with high
orders has been in use with distributions already so the breakage is
elsewhere. Patches 1 and 2 still make some sense but they're not the
root cause.

> <SNIP>

-- 
Mel Gorman
SUSE Labs
