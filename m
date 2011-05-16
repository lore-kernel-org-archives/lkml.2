Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1EPImh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:42:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:42180 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab1EPImf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:42:35 -0400
Date: Mon, 16 May 2011 09:42:30 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Message-ID: <20110516084230.GC5279@suse.de>
References: <20110512154649.GB4559@redhat.com>
 <1305216023.2575.54.camel@mulgrave.site>
 <alpine.DEB.2.00.1105121121120.26013@router.home>
 <1305217843.2575.57.camel@mulgrave.site>
 <BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com>
 <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com>
 <alpine.DEB.2.00.1105121232110.28493@router.home>
 <20110512180018.GN11579@random.random>
 <20110513094958.GA3569@suse.de>
 <20110515163906.GB25981@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110515163906.GB25981@random.random>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 06:39:06PM +0200, Andrea Arcangeli wrote:
> On Fri, May 13, 2011 at 10:49:58AM +0100, Mel Gorman wrote:
> > On Thu, May 12, 2011 at 08:00:18PM +0200, Andrea Arcangeli wrote:
> > > <SNIP>
> > >
> > > BTW, it comes to mind in patch 2, SLUB should clear __GFP_REPEAT too
> > > (not only __GFP_NOFAIL). Clearing __GFP_WAIT may be worth it or not
> > > with COMPACTION=y, definitely good idea to clear __GFP_WAIT unless
> > > lumpy is restricted to __GFP_REPEAT|__GFP_NOFAIL.
> > 
> > This is in V2 (unreleased, testing in progress and was running
> > overnight). I noticed that clearing __GFP_REPEAT is required for
> > reclaim/compaction if direct reclaimers from SLUB are to return false in
> > should_continue_reclaim() and bail out from high-order allocation
> > properly. As it is, there is a possibility for slub high-order direct
> > reclaimers to loop in reclaim/compaction for a long time. This is
> > only important when CONFIG_COMPACTION=y.
> 
> Agreed. However I don't expect anyone to allocate from slub(/slab)
> with __GFP_REPEAT so it's probably only theoretical but more correct
> indeed ;).

Networking layer does specify __GFP_REPEAT.

-- 
Mel Gorman
SUSE Labs
